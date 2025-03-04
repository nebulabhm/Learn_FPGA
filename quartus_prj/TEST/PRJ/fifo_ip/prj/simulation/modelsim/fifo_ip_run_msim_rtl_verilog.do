transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/fifo_ip/prj/ip {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/fifo_ip/prj/ip/dpram.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/fifo_ip/prj/../testbench {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/fifo_ip/prj/../testbench/fifo_ip_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  fifo_ip_tb

add wave *
view structure
view signals
run -all
