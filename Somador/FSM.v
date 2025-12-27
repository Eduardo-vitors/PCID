module FSM (clk, reset, address, rden, wren, load, clear, transf, ready);

    input        clk, reset;
    output reg [4:0] address;
    output reg       rden, wren;
    output reg       load, clear, transf;
    output reg       ready;

    reg [4:0] block_base;     // 0, 8, 16, 24
    reg [2:0] index_in_block; // 0..6 (7 leituras)

    wire last_index  = (index_in_block == 3'd6);
    wire last_block  = (block_base == 5'd24);

    localparam ST_RESET_CLEAR   = 4'd0;
    localparam ST_SET_READ_ADDR = 4'd1;
    localparam ST_RDEN_ON       = 4'd2;
    localparam ST_WAIT_1        = 4'd3;
    localparam ST_WAIT_2        = 4'd4;
    localparam ST_WAIT_3        = 4'd5;
    localparam ST_CAPTURE       = 4'd6;
    localparam ST_ADD           = 4'd7;
    localparam ST_WRITE_PREP    = 4'd8;
    localparam ST_WREN_ON       = 4'd9;
    localparam ST_WREN_OFF      = 4'd10;
    localparam ST_NEXT_BLOCK    = 4'd11;
    localparam ST_READY_PULSE   = 4'd12;

    reg [3:0] state;

    // -------------------------------------------------------
    // FSM com RESET ASSÍNCRONO (resolve X quando clk_top=0)
    // -------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            address        <= 5'd0;
            rden           <= 1'b0;
            wren           <= 1'b0;

            load           <= 1'b0;
            transf         <= 1'b0;
            ready          <= 1'b0;

            clear          <= 1'b0;  // clear ativo em 0 => zera acumulador

            block_base     <= 5'd0;
            index_in_block <= 3'd0;
            state          <= ST_RESET_CLEAR;

        end else begin
            // Pulsos padrão (1 ciclo)
            load   <= 1'b0;
            transf <= 1'b0;
            ready  <= 1'b0;

            case (state)

                ST_RESET_CLEAR: begin
                    clear <= 1'b1;  // libera acumulador (não zera)
                    rden  <= 1'b0;
                    wren  <= 1'b0;
                    state <= ST_SET_READ_ADDR;
                end

                ST_SET_READ_ADDR: begin
                    address <= block_base + index_in_block;
                    state   <= ST_RDEN_ON;
                end

                ST_RDEN_ON: begin
                    rden  <= 1'b1;
                    state <= ST_WAIT_1;
                end

                ST_WAIT_1: state <= ST_WAIT_2;
                ST_WAIT_2: state <= ST_WAIT_3;
                ST_WAIT_3: state <= ST_CAPTURE;

                ST_CAPTURE: begin
                    load  <= 1'b1;
                    rden  <= 1'b0;
                    state <= ST_ADD;
                end

                ST_ADD: begin
                    transf <= 1'b1;

                    if (last_index) begin
                        state <= ST_WRITE_PREP;
                    end else begin
                        index_in_block <= index_in_block + 3'd1;
                        state <= ST_SET_READ_ADDR;
                    end
                end

                ST_WRITE_PREP: begin
                    address <= block_base + 5'd7;
                    state   <= ST_WREN_ON;
                end

                ST_WREN_ON: begin
                    wren  <= 1'b1;
                    state <= ST_WREN_OFF;
                end

                ST_WREN_OFF: begin
                    wren  <= 1'b0;
                    state <= ST_NEXT_BLOCK;
                end

                ST_NEXT_BLOCK: begin
                    clear          <= 1'b0;  // pulso de clear baixo (zera acumulador)
                    index_in_block <= 3'd0;

                    if (last_block) begin
                        state <= ST_READY_PULSE;
                    end else begin
                        block_base <= block_base + 5'd8;
                        state <= ST_RESET_CLEAR;
                    end
                end

                ST_READY_PULSE: begin
                    ready <= 1'b1;
                    block_base     <= 5'd0;
                    index_in_block <= 3'd0;
                    state <= ST_RESET_CLEAR;
                end

                default: state <= ST_RESET_CLEAR;

            endcase
        end
    end

endmodule
