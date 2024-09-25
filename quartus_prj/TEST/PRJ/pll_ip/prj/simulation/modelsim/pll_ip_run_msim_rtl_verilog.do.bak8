transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/rtl/counter.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/ip {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/ip/pll_ip.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/rtl/counter_pll_top.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/db {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/db/pll_ip_altpll.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/../testbench {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/pll_ip/prj/../testbench/counter_pll_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  counter_pll_tb

add wave *
view structure
view signals
run -all
