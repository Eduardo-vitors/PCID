transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/ENGG56/Somador {C:/ENGG56/Somador/TOP.v}
vlog -vlog01compat -work work +incdir+C:/ENGG56/Somador {C:/ENGG56/Somador/Acumulador.v}
vlog -vlog01compat -work work +incdir+C:/ENGG56/Somador {C:/ENGG56/Somador/FSM.v}
vcom -93 -work work {C:/ENGG56/Somador/memoria.vhd}

vlog -vlog01compat -work work +incdir+C:/ENGG56/Somador {C:/ENGG56/Somador/tb_TOP.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TOP_TB

do C:/ENGG56/Somador/simulation/modelsim/wave.do
