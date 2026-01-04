`timescale 1ns/1ps

module tb_Acumulador;

    // -------------------------
    // Sinais do testbench
    // -------------------------
    reg         clk;
    reg         load;
    reg         transf;
    reg         clear;
    reg  [15:0] in;
    wire [15:0] out;

    // -------------------------
    // Instância do DUT
    // -------------------------
    Acumulador dut (
        .clk(clk),
        .in(in),
        .load(load),
        .clear(clear),
        .transf(transf),
        .out(out)
    );

    // -------------------------
    // Geração do clock (10 ns)
    // -------------------------
    always #5 clk = ~clk;

    // -------------------------
    // Monitor contínuo
    // -------------------------
    initial begin
        $monitor(
            "T=%0t | clk=%b clear=%b load=%b transf=%b in=%d out=%d",
            $time, clk, clear, load, transf, in, out
        );
    end

    // -------------------------
    // Sequência de estímulos
    // -------------------------
    initial begin
        // Inicialização
        clk    = 0;
        load   = 0;
        transf = 0;
        clear  = 0;
        in     = 16'd0;

        $display("--------------------------------------------------");
        $display("INICIO DA SIMULACAO");
        $display("Reset ativo (clear = 0)");
        $display("--------------------------------------------------");

        #12;
        clear = 1;
        $display("T=%0t | Reset liberado (clear = 1)", $time);

        // ==================================================
        // TESTE 1
        // ==================================================
        @(negedge clk);
        in   = 16'd10;
        load = 1;
        $display("T=%0t | LOAD: capturando valor %d", $time, in);

        @(negedge clk);
        load = 0;

        @(negedge clk);
        transf = 1;
        $display("T=%0t | TRANSF: somando data_buffer ao acumulador", $time);

        @(negedge clk);
        transf = 0;
        $display("T=%0t | RESULTADO ESPERADO: out = 10 | out atual = %d", $time, out);

        // ==================================================
        // TESTE 2
        // ==================================================
        @(negedge clk);
        in   = 16'd5;
        load = 1;
        $display("T=%0t | LOAD: capturando valor %d", $time, in);

        @(negedge clk);
        load = 0;

        @(negedge clk);
        transf = 1;
        $display("T=%0t | TRANSF: acumulando valor", $time);

        @(negedge clk);
        transf = 0;
        $display("T=%0t | RESULTADO ESPERADO: out = 15 | out atual = %d", $time, out);

        // ==================================================
        // TESTE 3
        // ==================================================
        @(negedge clk);
        in   = 16'd20;
        load = 1;
        $display("T=%0t | LOAD: capturando valor %d", $time, in);

        @(negedge clk);
        load = 0;

        @(negedge clk);
        transf = 1;
        $display("T=%0t | TRANSF: acumulando valor", $time);

        @(negedge clk);
        transf = 0;
        $display("T=%0t | RESULTADO ESPERADO: out = 35 | out atual = %d", $time, out);

        // ==================================================
        // CLEAR DURANTE OPERACAO
        // ==================================================
        @(negedge clk);
        clear = 0;
        $display("T=%0t | CLEAR ATIVO: zerando acumulador", $time);

        @(negedge clk);
        clear = 1;
        $display("T=%0t | CLEAR LIBERADO | out = %d (esperado 0)", $time, out);

        // ==================================================
        // TESTE FINAL
        // ==================================================
        @(negedge clk);
        in   = 16'd7;
        load = 1;
        $display("T=%0t | LOAD: capturando valor %d", $time, in);

        @(negedge clk);
        load = 0;

        @(negedge clk);
        transf = 1;
        $display("T=%0t | TRANSF: acumulando valor", $time);

        @(negedge clk);
        transf = 0;
        $display("T=%0t | RESULTADO FINAL ESPERADO: out = 7 | out atual = %d", $time, out);

        // ==================================================
        // FIM
        // ==================================================
        #20;
        $display("--------------------------------------------------");
        $display("FIM DA SIMULACAO");
        $display("--------------------------------------------------");
        $stop;
    end

endmodule
