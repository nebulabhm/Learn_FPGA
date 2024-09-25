transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {e:/intelfpga/18.0/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/rtl/DAC_test.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/rtl/dac_tlv5618.v}
vlib issp_dac_tlv5618
vmap issp_dac_tlv5618 issp_dac_tlv5618
vlog -vlog01compat -work issp_dac_tlv5618 +incdir+h:/my_workshop/learn_fpga/exercises/test/prj/dac_tlv5618/prj/db/ip/issp_dac_tlv5618 {h:/my_workshop/learn_fpga/exercises/test/prj/dac_tlv5618/prj/db/ip/issp_dac_tlv5618/issp_dac_tlv5618.v}
vlog -vlog01compat -work issp_dac_tlv5618 +incdir+h:/my_workshop/learn_fpga/exercises/test/prj/dac_tlv5618/prj/db/ip/issp_dac_tlv5618/submodules {h:/my_workshop/learn_fpga/exercises/test/prj/dac_tlv5618/prj/db/ip/issp_dac_tlv5618/submodules/altsource_probe_top.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/prj/../testbench {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/dac_tlv5618/prj/../testbench/dac_tlv5618_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L issp_dac_tlv5618 -voptargs="+acc"  dac_tlv5618_tb

add wave *
view structure
view signals
run -all
