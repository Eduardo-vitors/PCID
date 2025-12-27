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

