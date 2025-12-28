## Generated SDC file "FSM_Control3.sdc"

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

## DATE    "Sun Dec 28 17:09:01 2025"

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

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {clk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rst_in}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {start}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {act_mac}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {address[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rd_en}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {ready}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rst_out}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {u[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {u[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {u[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {v[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {v[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {v[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {x[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {x[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {x[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {y[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {y[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {y[2]}]


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

