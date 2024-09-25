transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/sync_oscillator/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/sync_oscillator/rtl/sync_oscillator.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/sync_oscillator/testbendch {H:/my_workshop/learn_fpga/Exercises/TEST/sync_oscillator/testbendch/sync_oscillator_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  sync_oscillator_tb

add wave *
view structure
view signals
run -all
