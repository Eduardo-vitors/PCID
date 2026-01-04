transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/ENGG56/MPEG {C:/ENGG56/MPEG/FSM_Control.v}

vlog -vlog01compat -work work +incdir+C:/ENGG56/MPEG {C:/ENGG56/MPEG/tb_FSM_Control.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  FSM_Control_TB

do C:/ENGG56/MPEG/simulation/modelsim/wave.do
