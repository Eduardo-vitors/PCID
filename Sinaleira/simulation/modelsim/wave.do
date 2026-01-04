onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group INPUTS -label A /tb_sinaleira/A
add wave -noupdate -expand -group INPUTS -label B /tb_sinaleira/B
add wave -noupdate -expand -group INPUTS -label C /tb_sinaleira/C
add wave -noupdate -expand -group INPUTS -label D /tb_sinaleira/D
add wave -noupdate -expand -group OUTPUTS -label NS /tb_sinaleira/NS
add wave -noupdate -expand -group OUTPUTS -label LO /tb_sinaleira/LO
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158951 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {158530 ps} {160078 ps}

run -all