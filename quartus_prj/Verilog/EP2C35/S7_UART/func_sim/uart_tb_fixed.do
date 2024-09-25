onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /UART_tb/clk16x
add wave -noupdate -format Logic /UART_tb/rst
add wave -noupdate -color Gold -format Logic /UART_tb/sdo
add wave -noupdate -format Literal -radix ascii /UART_tb/din
add wave -noupdate -format Logic /UART_tb/wrn
add wave -noupdate -color Magenta -format Logic /UART_tb/rxd
add wave -noupdate -format Logic /UART_tb/data_ready
add wave -noupdate -format Logic /UART_tb/rdn
add wave -noupdate -format Literal -radix ascii /UART_tb/dout
add wave -noupdate -color Magenta -format Logic /UART_tb/FPGA/txd
add wave -noupdate -format Literal -radix hexadecimal /UART_tb/FPGA/din
add wave -noupdate -format Logic /UART_tb/FPGA/wrn
add wave -noupdate -color Gold -format Logic /UART_tb/FPGA/rxd
add wave -noupdate -format Logic /UART_tb/FPGA/data_ready
add wave -noupdate -format Logic /UART_tb/FPGA/rdn
add wave -noupdate -format Literal -radix ascii /UART_tb/FPGA/dout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300 ps} 0}
WaveRestoreZoom {4196800 ps} {31070400 ps}
configure wave -namecolwidth 209
configure wave -valuecolwidth 41
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
