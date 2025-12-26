# Clock virtual (não precisa existir como porta)
create_clock -name vclk -period 10.0

# Atrasos genéricos relativos ao clock virtual
set_input_delay  1.0 -clock vclk [get_ports {A B C D}]
set_output_delay 1.0 -clock vclk [get_ports {NS LO}]
