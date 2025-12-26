module FSM (clk, reset, address, rden, wren, load, clear, transf, ready);

    input        clk, reset;
    output reg [4:0] address;
    output reg       rden, wren;
    output reg       load, clear, transf;
    output reg       ready;

    // -------------------------------------------------------
    // Variáveis internas com nomes claros
    // -------------------------------------------------------
    reg [4:0] block_base;     // 0, 8, 16, 24
    reg [2:0] index_in_block; // 0..6 (7 leituras)

    wire last_index  = (index_in_block == 3'd6);
    wire last_block  = (block_base == 5'd24);

    // -------------------------------------------------------
    // Estados (nomes fáceis)
    // -------------------------------------------------------
    localparam ST_RESET_CLEAR   = 4'd0;
    localparam ST_SET_READ_ADDR = 4'd1;
    localparam ST_RDEN_ON       = 4'd2;
    localparam ST_WAIT_1        = 4'd3;
    localparam ST_WAIT_2        = 4'd4;
    localparam ST_WAIT_3        = 4'd5;
    localparam ST_CAPTURE       = 4'd6;  // load=1 (captura dado)
    localparam ST_ADD           = 4'd7;  // transf=1 (soma no acumulador)
    localparam ST_WRITE_PREP    = 4'd8;
    localparam ST_WREN_ON       = 4'd9;
    localparam ST_WREN_OFF      = 4'd10;
    localparam ST_NEXT_BLOCK    = 4'd11;
    localparam ST_READY_PULSE   = 4'd12;

    reg [3:0] state;

    // -------------------------------------------------------
    // Máquina de estados
    // -------------------------------------------------------
    always @(posedge clk) begin
        // Pulsos padrão (1 ciclo)
        load   <= 1'b0;
        transf <= 1'b0;
        ready  <= 1'b0;

        if (reset) begin
            // reset: coloca sistema em condição inicial
            address        <= 5'd0;
            rden           <= 1'b0;
            wren           <= 1'b0;

            // clear ativo em 0 (limpa acumulador)
            clear          <= 1'b0;

            block_base     <= 5'd0;
            index_in_block <= 3'd0;
            state          <= ST_RESET_CLEAR;

        end else begin
            case (state)

                // Libera acumulador para operar (clear=1) e inicia ciclo do bloco ATUAL
                // (Correção: NÃO zerar block_base aqui, senão nunca avança para 8,16,24)
                ST_RESET_CLEAR: begin
                    clear <= 1'b1;  // libera acumulador para operar
                    rden  <= 1'b0;
                    wren  <= 1'b0;
                    state <= ST_SET_READ_ADDR;
                end

                // Define endereço para leitura: base + índice
                ST_SET_READ_ADDR: begin
                    address <= block_base + index_in_block;
                    state   <= ST_RDEN_ON;
                end

                // Liga RDEN (TB exige ficar ativo tempo suficiente)
                ST_RDEN_ON: begin
                    rden  <= 1'b1;
                    state <= ST_WAIT_1;
                end

                // 3 waits + RDEN_ON = 4 clocks com RDEN ativo (passa no TB)
                ST_WAIT_1: state <= ST_WAIT_2;
                ST_WAIT_2: state <= ST_WAIT_3;
                ST_WAIT_3: state <= ST_CAPTURE;

                // Captura o dado da memória no buffer do acumulador
                ST_CAPTURE: begin
                    load  <= 1'b1;  // captura no acumulador (negedge)
                    rden  <= 1'b0;  // pode desligar RDEN depois do tempo mínimo
                    state <= ST_ADD;
                end

                // Soma o valor capturado no acumulador
                ST_ADD: begin
                    transf <= 1'b1;

                    if (last_index) begin
                        // terminou 7 leituras -> vai escrever no base+7
                        state <= ST_WRITE_PREP;
                    end else begin
                        // próxima leitura
                        index_in_block <= index_in_block + 3'd1;
                        state <= ST_SET_READ_ADDR;
                    end
                end

                // Prepara endereço de escrita (base+7)
                ST_WRITE_PREP: begin
                    address <= block_base + 5'd7;
                    state   <= ST_WREN_ON;
                end

                // Liga WREN por 1 ciclo (TB também verifica estabilidade de address durante WREN)
                ST_WREN_ON: begin
                    wren  <= 1'b1;
                    state <= ST_WREN_OFF;
                end

                // Desliga WREN
                ST_WREN_OFF: begin
                    wren  <= 1'b0;
                    state <= ST_NEXT_BLOCK;
                end

                // Próximo bloco ou final
                ST_NEXT_BLOCK: begin
                    // limpa acumulador entre blocos (pulso de clear=0 por 1 ciclo)
                    clear          <= 1'b0;
                    index_in_block <= 3'd0;

                    if (last_block) begin
                        state <= ST_READY_PULSE;
                    end else begin
                        block_base <= block_base + 5'd8;
                        state <= ST_RESET_CLEAR; // volta para liberar clear=1 depois
                    end
                end

                // Ready por 1 ciclo e reinicia tudo
                ST_READY_PULSE: begin
                    ready <= 1'b1;
                    block_base     <= 5'd0;
                    index_in_block <= 3'd0;
                    state <= ST_RESET_CLEAR;
                end

                default: begin
                    state <= ST_RESET_CLEAR;
                end

            endcase
        end
    end

endmodule
