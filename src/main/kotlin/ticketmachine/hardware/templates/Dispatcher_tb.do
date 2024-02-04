onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dispatcher_tb/UUT/MCLK
add wave -noupdate -color {Violet Red} /dispatcher_tb/UUT/Fsh
add wave -noupdate -color Coral /dispatcher_tb/UUT/Dval
add wave -noupdate /dispatcher_tb/UUT/RESET
add wave -noupdate /dispatcher_tb/UUT/Din
add wave -noupdate -color {Dark Orchid} /dispatcher_tb/UUT/Wrt
add wave -noupdate -color {Cornflower Blue} /dispatcher_tb/UUT/Wrl
add wave -noupdate /dispatcher_tb/UUT/done
add wave -noupdate -color Gold /dispatcher_tb/UUT/cFlag_LINK
add wave -noupdate /dispatcher_tb/UUT/resetC_LINK
add wave -noupdate /dispatcher_tb/UUT/Dout
add wave -noupdate /dispatcher_tb/UUT/COUNTER_LINK
add wave -noupdate /dispatcher_tb/UUT/M0/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {56588 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 283
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {57330 ps}
