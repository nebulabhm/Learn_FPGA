transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/rom_ip/prj/ip {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/rom_ip/prj/ip/rom.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/rom_ip/prj/../testbench {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/rom_ip/prj/../testbench/rom_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  rom_tb

add wave *
view structure
view signals
run -all
