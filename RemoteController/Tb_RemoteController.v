`timescale 1ns / 1ps

module tb_RemoteController_ManualCheck;

    reg Clock_RX_38k; 
    reg Clock_TX_38k; 
    reg Reset_In;
    reg Serial;

    // wire [31:0] dados_brutos; // <-- REMOVIDO: Não precisamos desse fio aqui fora
    wire [7:0] Tecla;
    wire Ready;

    // Geração do Clock do Transmissor (Levemente diferente para simular drift real)
    initial begin
        Clock_TX_38k = 0;
        forever #13157 Clock_TX_38k = ~Clock_TX_38k;
    end

    // Geração do Clock do Receptor (FPGA)
    initial begin
        Clock_RX_38k = 0;
        #5000; 
        forever #13000 Clock_RX_38k = ~Clock_RX_38k; 
    end

    // Instanciação do Módulo (Sem a porta de dados_brutos)
    RemoteController uut (
        .Clock(Clock_RX_38k), 
        .Reset_In(Reset_In),
        .Serial(Serial),
        // .dados_brutos(dados_brutos), // <-- REMOVIDO DA LISTA DE PORTAS
        .Tecla(Tecla),
        .Ready(Ready)
    );

    // Task para enviar bits sincronizados com o clock do transmissor
    task enviar_bit;
        input valor_bit;
        begin
            @(negedge Clock_TX_38k);
            Serial = valor_bit;
            @(posedge Clock_TX_38k);
        end
    endtask

    // Task para montar o protocolo NEC completo
    task enviar_pacote_customizado;
        input [15:0] custom_code;      
        input [7:0]  key_code;         
        input [7:0]  inv_key_manual;   
        
        integer i;
        begin
            $display("\n--- ENVIANDO PACOTE MANUAL ---");
            $display("Custom: %h | Key: %h | Check: %h", custom_code, key_code, inv_key_manual);

            // Start Bit (simulado simples aqui como 0)
            enviar_bit(0);

            // Envia Custom Code (16 bits)
            for (i = 15; i >= 0; i = i - 1) enviar_bit(custom_code[i]);
            
            // Envia Key Code (8 bits)
            for (i = 7; i >= 0; i = i - 1) enviar_bit(key_code[i]);
            
            // Envia Key Code Invertido (Check - 8 bits)
            for (i = 7; i >= 0; i = i - 1) enviar_bit(inv_key_manual[i]);
            
            $display("-> Enviando Endpoint...");
            enviar_bit(1); 

            @(negedge Clock_TX_38k);
            Serial = 1; // Idle state
        end
    endtask

    // Bloco Principal de Teste
    initial begin
        Reset_In = 1; 
        Serial = 1;
        
        #100000; 
        Reset_In = 0; 
        #20000;
        
        @(negedge Clock_TX_38k);
        
        // Envia um comando (Ex: Tecla C = 10, Check = EF)
        enviar_pacote_customizado(16'h0000, 8'h10, 8'hEF); 

        $display("Pacote enviado. Aguardando reacao do hardware...");

        fork : verif
            begin
                // Aguarda o sinal de pronto do módulo
                @(posedge Ready);
                #100;
                $display("\n>>> READY DETECTADO! <<<");
                
                // --- ACESSO HIERÁRQUICO AQUI (uut.dados_brutos) ---
                $display("Dados Hex: %h (Tecla: %h)", uut.dados_brutos, uut.dados_brutos[15:8]);
                
                // Verifica integridade acessando sinais internos
                if (uut.dados_brutos[15:8] == ~uut.dados_brutos[7:0]) begin
                    $display("INTEGRIDADE: OK (Checksum valido).");
                    
                    $write("IDENTIFICACAO: ");
                    // Decodificação baseada no byte de comando (Bits 15:8 do registrador interno)
                    case (uut.dados_brutos[15:8])
                        8'h0F: $display("Tecla A");
                        8'h13: $display("Tecla B");
                        8'h10: $display("Tecla C"); 
                        8'h12: $display("Power (Liga/Desliga)");

                        8'h01: $display("Numero 1");
                        8'h02: $display("Numero 2");
                        8'h03: $display("Numero 3");
                        8'h1A: $display("Seta Cima");

                        8'h04: $display("Numero 4");
                        8'h05: $display("Numero 5");
                        8'h06: $display("Numero 6");
                        8'h1E: $display("Seta Baixo");

                        8'h07: $display("Numero 7");
                        8'h08: $display("Numero 8");
                        8'h09: $display("Numero 9");
                        8'h1B: $display("Triangulo Cima / Vol+");

                        8'h11: $display("Menu / Lista");
                        8'h00: $display("Numero 0");
                        8'h17: $display("Voltar / Return");
                        8'h1F: $display("Triangulo Baixo / Vol-");

                        8'h16: $display("Play / Pause");
                        8'h14: $display("Seta Esquerda");
                        8'h18: $display("Seta Direita");
                        8'h0C: $display("Mute");

                        default: $display("NAO RECONHECE A TECLA (Codigo %h desconhecido)", uut.dados_brutos[15:8]);
                    endcase

                end else begin
                    $display("VEREDITO: ERRO GRAVE! Checksum errado aceito!"); 
                end
                
                disable verif; // Mata o processo de timeout
            end

            begin
                // Timeout de segurança
                #600000; 
                $display("\n>>> TIMEOUT (Ready nao subiu) <<<");
                disable verif; // Mata o processo de verificação
            end
        join 

        $stop; 
    end
endmodule