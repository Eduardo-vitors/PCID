/* TESTBENCH DO TOP (clone RAM + display + stop) */

`timescale 1ns/1ns
`define periodo 20
`define meioperiodo (`periodo/2)

module TOP_TB;

    // -----------------------------
    // Clock/Reset
    // -----------------------------
    reg clk, reset;

    // -----------------------------
    // TOP <-> RAM
    // -----------------------------
    wire [15:0] datain;
    wire [15:0] dataout;

    wire [4:0]  address_top;
    wire        rden_top, wren, ready;

    // -----------------------------
    // Modo clone
    // -----------------------------
    reg         clone_mode;
    reg         rden_tb;
    reg  [4:0]  cont_mem_read;
    reg         ativa_clk_top;

    // sinais reais que vão pra RAM
    wire [4:0] address_mem;
    wire       rden_mem;
    wire       clk_top;

    assign clk_top = (ativa_clk_top) ? clk : 1'b0;

    // MUX correto (sem OR com X)
    assign address_mem = (clone_mode) ? cont_mem_read : address_top;
    assign rden_mem    = (clone_mode) ? rden_tb       : rden_top;

    // -----------------------------
    // Espelho debug
    // -----------------------------
    reg [15:0] r_mem [0:31];

    // -----------------------------
    // DUT
    // -----------------------------
    TOP top_teste(
        .clk(clk_top),
        .reset(reset),
        .ready(ready),
        .address(address_top),
        .rden(rden_top),
        .wren(wren),
        .datain(datain),
        .dataout(dataout)
    );

    // RAM (nome: memoria)
    memoria ram(
        .address(address_mem),
        .clock(clk),
        .data(dataout),
        .rden(rden_mem),
        .wren(wren),
        .q(datain)
    );

    // -----------------------------
    // Clock base
    // -----------------------------
    always #`meioperiodo clk = ~clk;

    // -----------------------------
    // Log de escrita
    // -----------------------------
    always @(posedge wren) begin
        r_mem[address_mem] = dataout;
        $display("T=%0t | [WRITE] addr=%0d | dataout=0x%04h (%0d)", $time, address_mem, dataout, dataout);
    end

    // -----------------------------
    // Display do TOP (cada clk_top)
    // -----------------------------
    always @(posedge clk_top) begin
        $display("T=%0t | [TOP] addr_top=%0d | rden=%b wren=%b | datain=0x%04h dataout=0x%04h | ready=%b",
                 $time, address_top, rden_top, wren, datain, dataout, ready);
    end

    // -----------------------------
    // Timeout anti-loop infinito
    // -----------------------------
    integer ciclos;
    localparam integer MAX_CICLOS = 20000;

    always @(posedge clk) begin
        ciclos <= ciclos + 1;
        if (ciclos > MAX_CICLOS) begin
            $display("** TIMEOUT ** T=%0t | Estourou MAX_CICLOS=%0d. Parando com $stop.", $time, MAX_CICLOS);
            $stop;
        end
    end

    // -----------------------------
    // Sequência principal
    // -----------------------------
    initial begin
        clk = 0;
        ciclos = 0;

        ativa_clk_top  = 1'b0;  // TOP parado
        clone_mode     = 1'b1;  // clonar primeiro
        rden_tb        = 1'b0;
        cont_mem_read  = 5'd0;

        // RESET ativo (importante!)
        reset = 1'b1;

        $display("============================================================");
        $display("INICIO DA SIMULACAO - TOP");
        $display("Periodo=%0dns | MeioPeriodo=%0dns", `periodo, `meioperiodo);
        $display("============================================================");

        // espera alguns clocks com reset ativo
        #(4*`periodo);

        $display("T=%0t | [CLONE] TOP pausado (clk_top=0). Clonando RAM...", $time);

        // clona 32 posições (RAM tem saida registrada, então damos 1 ciclo pra sair)
        repeat(32) begin
            rden_tb = 1'b1;
            #`periodo;          // 1 ciclo com rden=1
            rden_tb = 1'b0;
            #`periodo;          // folga

            // captura
            r_mem[cont_mem_read] = datain;

            $display("T=%0t | [CLONE] RAM[%0d] = 0x%04h (%0d)",
                     $time, cont_mem_read, datain, datain);

            cont_mem_read = cont_mem_read + 1;
        end

        $display("T=%0t | [CLONE] Memoria RAM Clonada.", $time);
        // se você quiser parar AQUI também:
        // $stop;

        // agora roda o TOP
        clone_mode    = 1'b0;
        ativa_clk_top = 1'b1;

        // libera reset
        reset = 1'b0;
        $display("T=%0t | Reset liberado (reset=0). Iniciando TOP.", $time);

        // espera terminar
        wait (ready == 1'b1);
        $display("T=%0t | READY=1 (fim). Simulacao OK. Parando com $stop.", $time);

        #200;
        $stop;
    end

endmodule
