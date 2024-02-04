onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_transmitter_control_tb/UUT/MCLK
add wave -noupdate /key_transmitter_control_tb/UUT/RESET
add wave -noupdate -color Gold /key_transmitter_control_tb/UUT/DAV
add wave -noupdate /key_transmitter_control_tb/UUT/Cflag
add wave -noupdate -color {Slate Blue} /key_transmitter_control_tb/UUT/ENR
add wave -noupdate -color Pink /key_transmitter_control_tb/UUT/RESET_C
add wave -noupdate -color {Dark Orchid} /key_transmitter_control_tb/UUT/ENC
add wave -noupdate -color Magenta /key_transmitter_control_tb/UUT/TXD_INIT
add wave -noupdate -color Gold /key_transmitter_control_tb/UUT/DAC
add wave -noupdate /key_transmitter_control_tb/UUT/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15135 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 296
configure wave -valuecolwidth 168
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
WaveRestoreZoom {0 ps} {30322 ps}
