module TOP (clk, reset, ready, address, rden, wren, datain, dataout);

    input        clk, reset;
    // datain  = dado que VEM da memória (q)
    // dataout = dado que VAI para a memória (data)
    input  [15:0] datain;
    output [15:0] dataout;

    output [4:0]  address;
    output        rden, wren, ready;

    // Sinais de controle do acumulador (gerados pela FSM)
    wire capture_data;   // (load) captura o valor da memória
    wire clear_acc_n;    // (clear) limpa acumulador (ativo em 0)
    wire add_enable;     // (transf) soma o valor capturado no acumulador

    // Instância do Acumulador
    Acumulador acc(
        clk,
        datain,          // in: dado vindo da memória
        capture_data,    // load: captura dado em buffer
        clear_acc_n,     // clear: limpa acumulador (ativo em 0)
        add_enable,      // transf: soma no acumulador
        dataout          // out: valor acumulado para escrever na memória
    );

    // Instância da FSM
    FSM fsm(
        clk,
        reset,
        address,
        rden,
        wren,
        capture_data,    // load
        clear_acc_n,     // clear (ativo em 0)
        add_enable,      // transf
        ready
    );

endmodule

