module Acumulador (clk, in, load, clear, transf, out);

    input        clk, load, transf, clear;
    input  [15:0] in;
    output reg [15:0] out;

    // Nome mais claro: buffer do dado lido da memória
    reg [15:0] data_buffer;

    // LOAD: captura o dado vindo da memória
    // Usar negedge ajuda a evitar corrida com a FSM (que normalmente muda sinais no posedge)
    always @(negedge clk or negedge clear) begin
        if (clear == 0) begin
            data_buffer <= 16'd0;
        end else if (load == 1) begin
            data_buffer <= in;
        end
    end

    // TRANSF: soma o dado capturado no acumulador
    // CLEAR (ativo em 0) zera a soma
    always @(negedge clk or negedge clear) begin
        if (clear == 0) begin
            out <= 16'd0;
        end else if (transf == 1) begin
            out <= out + data_buffer;
        end
    end

endmodule
