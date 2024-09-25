onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /UART_tb/tbre
add wave -noupdate -format Logic /UART_tb/tsre
add wave -noupdate -format Logic /UART_tb/sdo
add wave -noupdate -format Logic /UART_tb/rxd
add wave -noupdate -format Literal /UART_tb/din
add wave -noupdate -format Logic /UART_tb/rst
add wave -noupdate -format Logic /UART_tb/clk16x
add wave -noupdate -format Logic /UART_tb/wrn
add wave -noupdate -format Logic /UART_tb/rdn
add wave -noupdate -format Literal /UART_tb/dout
add wave -noupdate -format Logic /UART_tb/data_ready
add wave -noupdate -format Logic /UART_tb/framing_error
add wave -noupdate -format Logic /UART_tb/parity_error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
update
WaveRestoreZoom {0 ps} {224965700 ps}
