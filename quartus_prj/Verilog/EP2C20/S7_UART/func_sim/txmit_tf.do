onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench_tx/clk16x
add wave -noupdate -format Logic /testbench_tx/rst
add wave -noupdate -format Literal /testbench_tx/din
add wave -noupdate -color Gold -format Logic /testbench_tx/wrn
add wave -noupdate -format Logic /testbench_tx/tbre
add wave -noupdate -format Logic /testbench_tx/tsre
add wave -noupdate -format Logic /testbench_tx/sdo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5014 ns} 0}
WaveRestoreZoom {0 ns} {4030 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 59
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
