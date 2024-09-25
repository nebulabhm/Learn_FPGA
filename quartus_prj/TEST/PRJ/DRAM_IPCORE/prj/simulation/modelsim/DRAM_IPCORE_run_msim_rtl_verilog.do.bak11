transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/exercise/DRAM_IPCORE/prj/ip {H:/my_workshop/learn_fpga/exercise/DRAM_IPCORE/prj/ip/dpram.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/exercise/DRAM_IPCORE/prj/../testbench {H:/my_workshop/learn_fpga/exercise/DRAM_IPCORE/prj/../testbench/dpram_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  dpram_tb

add wave *
view structure
view signals
run -all
