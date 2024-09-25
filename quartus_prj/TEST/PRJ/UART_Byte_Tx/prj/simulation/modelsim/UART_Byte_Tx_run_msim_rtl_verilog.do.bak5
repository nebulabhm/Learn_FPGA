transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/key_stable/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/key_stable/rtl/key_stable.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/Div_cnt.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/DR_LUT.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/bps_cnt.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/MUX2.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/Data_reg.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/MUX10.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/UART_Byte_Tx.v}
vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/rtl/UART_Tx_top.v}
vlib hex_data
vmap hex_data hex_data
vlog -vlog01compat -work hex_data +incdir+h:/my_workshop/learn_fpga/exercises/test/prj/uart_byte_tx/prj/db/ip/hex_data {h:/my_workshop/learn_fpga/exercises/test/prj/uart_byte_tx/prj/db/ip/hex_data/hex_data.v}
vlog -vlog01compat -work hex_data +incdir+h:/my_workshop/learn_fpga/exercises/test/prj/uart_byte_tx/prj/db/ip/hex_data/submodules {h:/my_workshop/learn_fpga/exercises/test/prj/uart_byte_tx/prj/db/ip/hex_data/submodules/altsource_probe_top.v}

vlog -vlog01compat -work work +incdir+H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/prj/../testbench {H:/my_workshop/learn_fpga/Exercises/TEST/PRJ/UART_Byte_Tx/prj/../testbench/UART_Byte_Tx_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L hex_data -voptargs="+acc"  UART_Byte_Tx_tb

add wave *
view structure
view signals
run -all
