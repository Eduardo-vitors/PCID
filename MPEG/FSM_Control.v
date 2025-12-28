module FSM_Control (
    input  wire       start,
    input  wire       clk,
    input  wire       rst_in,     // reset ativo em 0 (igual seu TB)

    output reg        ready,
    output reg [2:0]  u,
    output reg [2:0]  v,
    output reg [2:0]  x,
    output reg [2:0]  y,
    output reg        act_mac,
    output reg        rd_en,
    output reg [5:0]  address,
    output reg        rst_out
);

    // -----------------------------
    // Estados do diagrama
    // -----------------------------
    localparam IDLE     = 4'd0;
    localparam INIT     = 4'd1;
    localparam SET_ADDR = 4'd2;
    localparam RD_PULSE = 4'd3;
    localparam WAIT_MEM = 4'd4;
    localparam ACCUM    = 4'd5;
    localparam GAP      = 4'd6;
    localparam NEXT     = 4'd7;
    localparam DONE     = 4'd8;

    reg [3:0] state, next_state;

    wire done_all = (x==3'd7 && y==3'd7 && u==3'd7 && v==3'd7);

    // -----------------------------
    // State register
    // -----------------------------
    always @(posedge clk or negedge rst_in) begin
        if (!rst_in) state <= IDLE;
        else         state <= next_state;
    end

    // -----------------------------
    // Next-state logic (igual ao diagrama)
    // -----------------------------
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:     next_state = (start) ? INIT : IDLE;
            INIT:     next_state = SET_ADDR;
            SET_ADDR: next_state = RD_PULSE;
            RD_PULSE: next_state = WAIT_MEM;
            WAIT_MEM: next_state = ACCUM;
            ACCUM:    next_state = GAP;
            GAP:      next_state = NEXT;
            NEXT:     next_state = (done_all) ? DONE : SET_ADDR;
            DONE:     next_state = IDLE;
            default:  next_state = IDLE;
        endcase
    end

    // -----------------------------
    // Outputs (Moore) — batem com o diagrama
    // -----------------------------
    always @(*) begin
        // defaults
        rd_en   = 1'b0;
        act_mac = 1'b0;
        ready   = 1'b0;
        rst_out = 1'b1;

        // rst_out opcional: baixo em INIT para "zerar datapath"
        if (state == INIT) rst_out = 1'b0;

        // RD_PULSE: rd_en=1 por 1 ciclo
        if (state == RD_PULSE) rd_en = 1'b1;

        // ACCUM: acumula dado (MAC ativo)
        if (state == ACCUM) begin
            act_mac = 1'b1;
        end

        // DONE: ready=1
        if (state == DONE) ready = 1'b1;
    end

    // -----------------------------
    // Registers: x,y,u,v,address
    // -----------------------------
    always @(posedge clk or negedge rst_in) begin
        if (!rst_in) begin
            x <= 3'd0; y <= 3'd0; u <= 3'd0; v <= 3'd0;
            address <= 6'd0;
        end else begin
            case (state)

                INIT: begin
                    x <= 3'd0; y <= 3'd0; u <= 3'd0; v <= 3'd0;
                    address <= 6'd0;
                end

                // SET_ADDR: address = {u,v}
                SET_ADDR: begin
                    address <= {u, v};
                end

                // NEXT: incrementa índices (igual texto do seu NEXT no diagrama)
                NEXT: begin
                    // Se ainda não terminou u,v: incrementa v e depois u
                    if (!(u==3'd7 && v==3'd7)) begin
                        if (v < 3'd7) begin
                            v <= v + 3'd1;
                        end else begin
                            v <= 3'd0;
                            u <= u + 3'd1;
                        end
                    end else begin
                        // terminou u,v para esse (x,y): zera u,v e incrementa x,y
                        u <= 3'd0;
                        v <= 3'd0;

                        if (x < 3'd7) begin
                            x <= x + 3'd1;
                        end else begin
                            x <= 3'd0;
                            if (y < 3'd7) y <= y + 3'd1;
                            else          y <= 3'd0; // ao final, DONE vai ocorrer antes disso importar
                        end
                    end
                end

                default: begin
                    // mantém
                end

            endcase
        end
    end

endmodule
