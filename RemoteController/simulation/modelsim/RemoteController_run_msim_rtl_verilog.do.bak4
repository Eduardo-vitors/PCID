transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/ENGG56/RemoteController {C:/ENGG56/RemoteController/RemoteController.v}
vlog -vlog01compat -work work +incdir+C:/ENGG56/RemoteController {C:/ENGG56/RemoteController/PLL.v}
vlog -vlog01compat -work work +incdir+C:/ENGG56/RemoteController/db {C:/ENGG56/RemoteController/db/pll_altpll.v}

vlog -vlog01compat -work work +incdir+C:/ENGG56/RemoteController {C:/ENGG56/RemoteController/Tb_RemoteController.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_RemoteController_ManualCheck

do C:/ENGG56/RemoteController/simulation/modelsim/wave.do
