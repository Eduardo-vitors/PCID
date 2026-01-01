onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group INPUTS -label START /FSM_Control_TB/start
add wave -noupdate -expand -group INPUTS -label CLK /FSM_Control_TB/clk
add wave -noupdate -expand -group INPUTS -label RST_IN /FSM_Control_TB/rst_in
add wave -noupdate -expand -group OUTPUTS -label READY /FSM_Control_TB/ready
add wave -noupdate -expand -group OUTPUTS -label ACT_MAC /FSM_Control_TB/act_mac
add wave -noupdate -expand -group OUTPUTS -label RD_EN /FSM_Control_TB/rd_en
add wave -noupdate -expand -group OUTPUTS -label RST_OUT /FSM_Control_TB/rst_out
add wave -noupdate -expand -group OUTPUTS -label U -radix unsigned /FSM_Control_TB/u
add wave -noupdate -expand -group OUTPUTS -label V -radix unsigned /FSM_Control_TB/v
add wave -noupdate -expand -group OUTPUTS -label ADDRESS -radix unsigned /FSM_Control_TB/address
add wave -noupdate -expand -group OUTPUTS -label X -radix unsigned /FSM_Control_TB/x
add wave -noupdate -expand -group OUTPUTS -label Y -radix unsigned /FSM_Control_TB/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 us}

run -all