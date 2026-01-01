## Generated SDC file "RemoteController.out.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

## DATE    "Mon Dec 29 16:00:02 2025"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 53 -divide_by 68901 -master_clock {CLOCK_50} [get_pins {inst|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {CLOCK_50}]
set_input_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {IRDA_RXD}]
set_input_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {KEY[0]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDG[1]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[0]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[1]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[2]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[3]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[4]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[5]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[6]}]
set_output_delay -add_delay  -clock [get_clocks {inst|altpll_component|auto_generated|pll1|clk[0]}]  2.600 [get_ports {LEDR[7]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

