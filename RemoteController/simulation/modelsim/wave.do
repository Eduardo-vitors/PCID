onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group REMOTE_CONTROLLER -label DADOS /tb_RemoteController_ManualCheck/uut/dados_brutos
add wave -noupdate -expand -group REMOTE_CONTROLLER -label Reset_SYNC /tb_RemoteController_ManualCheck/Reset_In
add wave -noupdate -expand -group REMOTE_CONTROLLER -label SERIAL /tb_RemoteController_ManualCheck/Serial
add wave -noupdate -expand -group REMOTE_CONTROLLER -label TECLA -radix hexadecimal /tb_RemoteController_ManualCheck/Tecla
add wave -noupdate -expand -group REMOTE_CONTROLLER -label READY /tb_RemoteController_ManualCheck/Ready
add wave -noupdate -expand -group CLOCK -label CLOCK_RX /tb_RemoteController_ManualCheck/Clock_RX_38k
add wave -noupdate -expand -group CLOCK -label CLOCK_TX /tb_RemoteController_ManualCheck/Clock_TX_38k
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
WaveRestoreZoom {0 ps} {1165605 ns}

run -all