onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dispatcher_control_tb/UUT/MCLK
add wave -noupdate -color {Dark Orchid} /dispatcher_control_tb/UUT/Fsh
add wave -noupdate -color Cyan /dispatcher_control_tb/UUT/Dval
add wave -noupdate /dispatcher_control_tb/UUT/RESET
add wave -noupdate -color Orange /dispatcher_control_tb/UUT/cFlag
add wave -noupdate /dispatcher_control_tb/UUT/Din
add wave -noupdate -color {Cornflower Blue} /dispatcher_control_tb/UUT/Wrt
add wave -noupdate -color Gold /dispatcher_control_tb/UUT/Wrl
add wave -noupdate -color Cyan /dispatcher_control_tb/UUT/done
add wave -noupdate -color Magenta /dispatcher_control_tb/UUT/resetC
add wave -noupdate /dispatcher_control_tb/UUT/Dout
add wave -noupdate /dispatcher_control_tb/UUT/currentState
add wave -noupdate /dispatcher_control_tb/UUT/Tnl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 264
configure wave -valuecolwidth 141
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
WaveRestoreZoom {0 ps} {49300 ps}
