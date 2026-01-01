onerror {resume}
quietly WaveActivateNextPane {} 0

# -----------------------------
# Funções de cada testbench
# -----------------------------
proc load_waves_acumulador {} {
    delete wave *
    quietly WaveActivateNextPane {} 0

    add wave -noupdate -expand -group INPUTS -label CLK    /tb_Acumulador/clk
    add wave -noupdate -expand -group INPUTS -label LOAD   /tb_Acumulador/load
    add wave -noupdate -expand -group INPUTS -label TRANSF /tb_Acumulador/transf
    add wave -noupdate -expand -group INPUTS -label CLEAR  /tb_Acumulador/clear
    add wave -noupdate -expand -group INPUTS -label IN -radix unsigned /tb_Acumulador/in
    add wave -noupdate -expand -group OUTPUT -label OUT /tb_Acumulador/out

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
    WaveRestoreZoom {0 ps} {220500 ps}
}

proc load_waves_fsm_tb {} {
    delete wave *
    quietly WaveActivateNextPane {} 0

    add wave -noupdate -expand -group INPUTS  -label CLK   /FSM_TB/clk
    add wave -noupdate -expand -group INPUTS  -label RESET /FSM_TB/reset

    add wave -noupdate -expand -group OUTPUTS -label ADDRESS /FSM_TB/address
    add wave -noupdate -expand -group OUTPUTS -label RDEN    /FSM_TB/rden
    add wave -noupdate -expand -group OUTPUTS -label WREN    /FSM_TB/wren
    add wave -noupdate -expand -group OUTPUTS -label LOAD    /FSM_TB/load
    add wave -noupdate -expand -group OUTPUTS -label TRANSF  /FSM_TB/transf
    add wave -noupdate -expand -group OUTPUTS -label CLEAR   /FSM_TB/clear
    add wave -noupdate -expand -group OUTPUTS -label READY   /FSM_TB/ready

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
    WaveRestoreZoom {214336 ps} {9113069 ps}
}

proc load_waves_top {} {
    # Proteção: se não existir TOP_TB, sai sem tentar adicionar nada
    if {[catch {examine /TOP_TB/clk}]} {
        puts ">> load_waves_top: /TOP_TB não existe nesta simulação."
        return
    }

    delete wave *
    quietly WaveActivateNextPane {} 0

    add wave -noupdate -group {TESTEBENCH TOP} -expand -group MEMORIA -label R_MEM -radix unsigned \
        -childformat {{{/TOP_TB/r_mem[0]} -radix unsigned} {{/TOP_TB/r_mem[1]} -radix unsigned} {{/TOP_TB/r_mem[2]} -radix unsigned} {{/TOP_TB/r_mem[3]} -radix unsigned} \
                     {{/TOP_TB/r_mem[4]} -radix unsigned} {{/TOP_TB/r_mem[5]} -radix unsigned} {{/TOP_TB/r_mem[6]} -radix unsigned} {{/TOP_TB/r_mem[7]} -radix unsigned} \
                     {{/TOP_TB/r_mem[8]} -radix unsigned} {{/TOP_TB/r_mem[9]} -radix unsigned} {{/TOP_TB/r_mem[10]} -radix unsigned} {{/TOP_TB/r_mem[11]} -radix unsigned} \
                     {{/TOP_TB/r_mem[12]} -radix unsigned} {{/TOP_TB/r_mem[13]} -radix unsigned} {{/TOP_TB/r_mem[14]} -radix unsigned} {{/TOP_TB/r_mem[15]} -radix unsigned} \
                     {{/TOP_TB/r_mem[16]} -radix unsigned} {{/TOP_TB/r_mem[17]} -radix unsigned} {{/TOP_TB/r_mem[18]} -radix unsigned} {{/TOP_TB/r_mem[19]} -radix unsigned} \
                     {{/TOP_TB/r_mem[20]} -radix unsigned} {{/TOP_TB/r_mem[21]} -radix unsigned} {{/TOP_TB/r_mem[22]} -radix unsigned} {{/TOP_TB/r_mem[23]} -radix unsigned} \
                     {{/TOP_TB/r_mem[24]} -radix unsigned} {{/TOP_TB/r_mem[25]} -radix unsigned} {{/TOP_TB/r_mem[26]} -radix unsigned} {{/TOP_TB/r_mem[27]} -radix unsigned} \
                     {{/TOP_TB/r_mem[28]} -radix unsigned} {{/TOP_TB/r_mem[29]} -radix unsigned} {{/TOP_TB/r_mem[30]} -radix unsigned} {{/TOP_TB/r_mem[31]} -radix unsigned}} \
        -expand -subitemconfig {{/TOP_TB/r_mem[0]} {-radix unsigned} {/TOP_TB/r_mem[1]} {-radix unsigned} {/TOP_TB/r_mem[2]} {-radix unsigned} {/TOP_TB/r_mem[3]} {-radix unsigned} \
                               {/TOP_TB/r_mem[4]} {-radix unsigned} {/TOP_TB/r_mem[5]} {-radix unsigned} {/TOP_TB/r_mem[6]} {-radix unsigned} {/TOP_TB/r_mem[7]} {-radix unsigned} \
                               {/TOP_TB/r_mem[8]} {-radix unsigned} {/TOP_TB/r_mem[9]} {-radix unsigned} {/TOP_TB/r_mem[10]} {-radix unsigned} {/TOP_TB/r_mem[11]} {-radix unsigned} \
                               {/TOP_TB/r_mem[12]} {-radix unsigned} {/TOP_TB/r_mem[13]} {-radix unsigned} {/TOP_TB/r_mem[14]} {-radix unsigned} {/TOP_TB/r_mem[15]} {-radix unsigned} \
                               {/TOP_TB/r_mem[16]} {-radix unsigned} {/TOP_TB/r_mem[17]} {-radix unsigned} {/TOP_TB/r_mem[18]} {-radix unsigned} {/TOP_TB/r_mem[19]} {-radix unsigned} \
                               {/TOP_TB/r_mem[20]} {-radix unsigned} {/TOP_TB/r_mem[21]} {-radix unsigned} {/TOP_TB/r_mem[22]} {-radix unsigned} {/TOP_TB/r_mem[23]} {-radix unsigned} \
                               {/TOP_TB/r_mem[24]} {-radix unsigned} {/TOP_TB/r_mem[25]} {-radix unsigned} {/TOP_TB/r_mem[26]} {-radix unsigned} {/TOP_TB/r_mem[27]} {-radix unsigned} \
                               {/TOP_TB/r_mem[28]} {-radix unsigned} {/TOP_TB/r_mem[29]} {-radix unsigned} {/TOP_TB/r_mem[30]} {-radix unsigned} {/TOP_TB/r_mem[31]} {-radix unsigned}} \
        /TOP_TB/r_mem

    add wave -noupdate -group {TESTEBENCH TOP} -expand -group {TESTEBENCH TOP} -label CLK /TOP_TB/clk
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group {TESTEBENCH TOP} -label RESET /TOP_TB/reset

    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label DATA_IN -radix unsigned /TOP_TB/datain
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label DATA_OUT -radix unsigned /TOP_TB/dataout
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label ADDRESS_TOP -radix unsigned /TOP_TB/address_top
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label RDEN_TOP /TOP_TB/rden_top
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label WREN /TOP_TB/wren
    add wave -noupdate -group {TESTEBENCH TOP} -expand -group TOP -label READY /TOP_TB/ready

    add wave -noupdate -group ACUMULADOR -expand -group INPUTS -label CLK    /TOP_TB/top_teste/acc/clk
    add wave -noupdate -group ACUMULADOR -expand -group INPUTS -label LOAD   /TOP_TB/top_teste/acc/load
    add wave -noupdate -group ACUMULADOR -expand -group INPUTS -label TRANSF /TOP_TB/top_teste/acc/transf
    add wave -noupdate -group ACUMULADOR -expand -group INPUTS -label CLEAR  /TOP_TB/top_teste/acc/clear
    add wave -noupdate -group ACUMULADOR -expand -group INPUTS -label IN -radix unsigned /TOP_TB/top_teste/acc/in
    add wave -noupdate -group ACUMULADOR -expand -group OUTPUT -label OUT /TOP_TB/top_teste/acc/out

    add wave -noupdate -group FSM -label CLK /TOP_TB/top_teste/fsm/clk
    add wave -noupdate -group FSM -label RESET /TOP_TB/top_teste/fsm/reset
    add wave -noupdate -group FSM -expand -group OUTPUTS -label ADDRESS /TOP_TB/top_teste/fsm/address
    add wave -noupdate -group FSM -expand -group OUTPUTS -label RDEN /TOP_TB/top_teste/fsm/rden
    add wave -noupdate -group FSM -expand -group OUTPUTS -label WREN /TOP_TB/top_teste/fsm/wren
    add wave -noupdate -group FSM -expand -group OUTPUTS -label LOAD /TOP_TB/top_teste/fsm/load
    add wave -noupdate -group FSM -expand -group OUTPUTS -label CLEAR /TOP_TB/top_teste/fsm/clear
    add wave -noupdate -group FSM -expand -group OUTPUTS -label TRANSF /TOP_TB/top_teste/fsm/transf
    add wave -noupdate -group FSM -expand -group OUTPUTS -label READY /TOP_TB/top_teste/fsm/ready

    TreeUpdate [SetDefaultTree]
    WaveRestoreCursors {{Cursor 1} {0 ns} 0} {{Cursor 2} {29 ns} 0}
    quietly wave cursor active 2

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
    WaveRestoreZoom {0 ns} {788 ns}
}

# -----------------------------
# Detecção automática do TB (tb_Acumulador / FSM_TB / TOP_TB)
# -----------------------------
set is_acc 0
set is_fsm 0
set is_top 0

if {[catch {examine /tb_Acumulador/clk} msg] == 0} {
    set is_acc 1
}

if {[catch {examine /FSM_TB/clk} msg] == 0} {
    set is_fsm 1
}

if {[catch {examine /TOP_TB/clk} msg] == 0} {
    set is_top 1
}

if {$is_acc} {
    puts ">> wave_auto.do: detectado tb_Acumulador"
    load_waves_acumulador
} elseif {$is_fsm} {
    puts ">> wave_auto.do: detectado FSM_TB"
    load_waves_fsm_tb
} elseif {$is_top} {
    puts ">> wave_auto.do: detectado TOP_TB"
    load_waves_top
} else {
    puts ">> wave_auto.do: nenhum TB reconhecido. Confira o nome do testbench no topo (dir /)."
}

# -----------------------------
# Forçar expansão total no Wave (ModelSim Intel 2020.1)
# -----------------------------
TreeUpdate [SetDefaultTree]
WaveExpandAll
update
# -----------------------------
# Executa a simulação
# -----------------------------
run -all
