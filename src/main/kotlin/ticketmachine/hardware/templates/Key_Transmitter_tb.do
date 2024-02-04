onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_transmitter_tb/UUT/MCLK
add wave -noupdate /key_transmitter_tb/UUT/RESET
add wave -noupdate -color {Violet Red} /key_transmitter_tb/UUT/DAV
add wave -noupdate -color Gold /key_transmitter_tb/UUT/TXclk
add wave -noupdate -color Cyan /key_transmitter_tb/UUT/D
add wave -noupdate /key_transmitter_tb/UUT/Q_LINK
add wave -noupdate /key_transmitter_tb/UUT/RCLK_LINK
add wave -noupdate -color {Green Yellow} /key_transmitter_tb/UUT/DAC
add wave -noupdate -color Coral /key_transmitter_tb/UUT/TXD
add wave -noupdate /key_transmitter_tb/UUT/M0/TXD_INIT
add wave -noupdate -color Magenta /key_transmitter_tb/UUT/S_LINK
add wave -noupdate /key_transmitter_tb/UUT/M_LINK
add wave -noupdate -color {Blue Violet} /key_transmitter_tb/UUT/M0/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5517 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 278
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
WaveRestoreZoom {177859 ps} {253797 ps}
