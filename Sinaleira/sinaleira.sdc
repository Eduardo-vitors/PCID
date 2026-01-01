# Projeto combinacional: não possui clock físico.
# Um clock virtual é usado apenas para permitir a análise de timing pelo TimeQuest.
# Os delays de entrada e saída definem o tempo máximo permitido para a lógica combinacional.

create_clock -name virtual_clk -period 20.000

set_input_delay  2.000 -clock virtual_clk [all_inputs]
set_output_delay 2.000 -clock virtual_clk [all_outputs]