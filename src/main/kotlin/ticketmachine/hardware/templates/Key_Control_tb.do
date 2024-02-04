onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_control_tb/UUT/MCLK
add wave -noupdate /key_control_tb/UUT/RESET
add wave -noupdate -color Cyan /key_control_tb/UUT/Kack
add wave -noupdate /key_control_tb/UUT/Kpress
add wave -noupdate -color Coral /key_control_tb/UUT/Kval
add wave -noupdate -color {Dark Orchid} /key_control_tb/UUT/Kscan
add wave -noupdate /key_control_tb/UUT/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19052 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
WaveRestoreZoom {0 ps} {27562 ps}
