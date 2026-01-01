`define periodo 20
`timescale 1ns/1ns

module FSM_Control_TB;

  reg start, clk, rst_in;
  wire ready, act_mac, rd_en, rst_out;
  wire [2:0] u, v, x, y;
  wire [5:0] address;

  // ------------------------------------------------------------
  // DUT
  // ------------------------------------------------------------
  FSM_Control dut(
    .start(start),
    .clk(clk),
    .rst_in(rst_in),
    .ready(ready),
    .u(u), .v(v), .x(x), .y(y),
    .act_mac(act_mac),
    .rd_en(rd_en),
    .address(address),
    .rst_out(rst_out)
  );

  // ------------------------------------------------------------
  // Clock
  // ------------------------------------------------------------
  initial clk = 1'b0;
  always #(`periodo/2) clk = ~clk;

  // ------------------------------------------------------------
  // LOG EM ARQUIVO
  // ------------------------------------------------------------
  integer fd;
  initial begin
    fd = $fopen("fsm_log.txt","w");
    if (fd == 0) begin
      $display("FALHA: Nao foi possivel criar fsm_log.txt");
      $stop;
    end
    $fwrite(fd, "=== LOG FSM_CONTROL ===\n");
  end

  // ------------------------------------------------------------
  // Controle de falha/sucesso
  // ------------------------------------------------------------
  reg start_pulse;
  reg fail_flag;
  initial begin
    start_pulse = 0;
    fail_flag   = 0;
  end

  task fail;
    input [8*200:1] msg;
    begin
      fail_flag = 1'b1;
      $fwrite(fd, "[%0t] FALHA: %s\n", $time, msg);
      $display("FALHA: %s", msg);
      $fclose(fd);
      $stop;
    end
  endtask

  // ------------------------------------------------------------
  // Reset + Start (pulso)
  // ------------------------------------------------------------
  initial begin
    start  = 0;
    rst_in = 0;      // reset ativo em 0

    #(2*`periodo);
    rst_in = 1;

    #(`periodo);
    start = 1;
    #(`periodo);
    start = 0;
    start_pulse = 1;

    $fwrite(fd, "[%0t] START aplicado\n", $time);
  end

  // ============================================================
  // LOG DETALHADO (NO ARQUIVO)
  // ============================================================
  reg [2:0] u_d, v_d, x_d, y_d;
  reg [5:0] addr_d;

  always @(posedge clk) begin
    if (!rst_in) begin
      u_d <= u; v_d <= v; x_d <= x; y_d <= y; addr_d <= address;
    end else if (start_pulse) begin
      if (u!=u_d || v!=v_d || x!=x_d || y!=y_d) begin
        $fwrite(fd, "[%0t] IDX u=%0d v=%0d x=%0d y=%0d\n", $time, u, v, x, y);
      end
      if (address != addr_d) begin
        $fwrite(fd, "[%0t] ADDR addr=%0d (u=%0d v=%0d)\n", $time, address, u, v);
      end
      u_d <= u; v_d <= v; x_d <= x; y_d <= y; addr_d <= address;
    end
  end

  always @(posedge rd_en)
    if (start_pulse)
      $fwrite(fd, "[%0t] RD  addr=%0d (u=%0d v=%0d)\n", $time, address, u, v);

  always @(posedge act_mac)
    if (start_pulse)
      $fwrite(fd, "[%0t] MAC acumula (x=%0d y=%0d)\n", $time, x, y);

  // ============================================================
  // CHECK 1: rd_en é pulso de 1 ciclo
  // ============================================================
  reg rd_en_d1;
  always @(posedge clk) begin
    if (!rst_in) rd_en_d1 <= 1'b0;
    else begin
      rd_en_d1 <= rd_en;
      if (start_pulse && rd_en && rd_en_d1) begin
        fail("rd_en ficou alto por mais de 1 ciclo");
      end
    end
  end

  // ============================================================
  // CHECK 2: act_mac deve ocorrer 2 ciclos após rd_en
  // (RD_PULSE -> WAIT_MEM -> ACCUM)
  // ============================================================
  reg [1:0] pipe_rd;
  always @(posedge clk) begin
    if (!rst_in) pipe_rd <= 2'b00;
    else begin
      pipe_rd <= {pipe_rd[0], rd_en};

      if (start_pulse) begin
        if (pipe_rd[1] && !act_mac)
          fail("Esperava act_mac=1 dois ciclos apos rd_en, mas act_mac=0");

        if (!pipe_rd[1] && act_mac)
          fail("act_mac=1 fora do timing (sem rd_en 2 ciclos antes)");
      end
    end
  end

  // ============================================================
  // CHECK 3: no pulso rd_en, address deve ser {u,v}
  // ============================================================
  always @(posedge clk) begin
    if (start_pulse && rd_en) begin
      if (address !== {u,v}) begin
        $fwrite(fd, "Detalhe: address=%0d esperado=%0d u=%0d v=%0d\n",
                address, {u,v}, u, v);
        fail("address != {u,v} no pulso de rd_en");
      end
    end
  end

  // ============================================================
  // CHECK 4/5: excursão u,v e salto x/y quando u,v zeram
  // ============================================================
  reg [2:0] u_prev, v_prev, x_prev, y_prev;

  always @(posedge clk) begin
    if (!rst_in) begin
      u_prev <= 0; v_prev <= 0; x_prev <= 0; y_prev <= 0;
    end else if (start_pulse) begin

      if (u!=u_prev || v!=v_prev || x!=x_prev || y!=y_prev) begin

        if (u_prev==3'd7 && v_prev==3'd7) begin
          if (!(u==3'd0 && v==3'd0))
            fail("Esperava u=v=0 apos (u=v=7)");

          if (x_prev < 3'd7) begin
            if (!(x == x_prev + 3'd1 && y == y_prev))
              fail("Esperava x++ apos finalizar u,v");
          end else begin
            if (!(x == 3'd0 && y == y_prev + 3'd1))
              fail("Esperava x=0 e y++ apos x=7 e finalizar u,v");
          end

        end else begin
          if (v_prev < 3'd7) begin
            if (!(v == v_prev + 3'd1 && u == u_prev && x == x_prev && y == y_prev))
              fail("Esperava v++ (u,x,y constantes)");
          end else begin
            if (!(v == 3'd0 && u == u_prev + 3'd1 && x == x_prev && y == y_prev))
              fail("Esperava v=0 e u++ (x,y constantes)");
          end
        end
      end

      u_prev <= u; v_prev <= v; x_prev <= x; y_prev <= y;
    end
  end

  // ============================================================
  // CHECK 6: ready deve ocorrer depois que passou por x=y=u=v=7
  // ============================================================
  reg viu_done_all;
  always @(posedge clk) begin
    if (!rst_in) viu_done_all <= 1'b0;
    else if (start_pulse) begin
      if (x==3'd7 && y==3'd7 && u==3'd7 && v==3'd7)
        viu_done_all <= 1'b1;
    end
  end

  // ============================================================
  // FINAL: terminal só sucesso/falha
  // ============================================================
  always @(posedge ready) begin
    if (start_pulse) begin
      if (!viu_done_all) begin
        fail("ready subiu sem ter passado por (x=y=u=v=7)");
      end else begin
        $fwrite(fd, "[%0t] SUCESSO: ready=1 e passou por done_all\n", $time);
        $fclose(fd);
        $display("Simulacao finalizou com sucesso");
        #100 $stop;
      end
    end
  end

endmodule
