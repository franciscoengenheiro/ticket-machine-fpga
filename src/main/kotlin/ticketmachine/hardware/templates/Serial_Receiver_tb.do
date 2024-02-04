onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serial_receiver_tb/UUT/MCLK
add wave -noupdate -color {Medium Slate Blue} /serial_receiver_tb/UUT/SDX
add wave -noupdate -color Gold /serial_receiver_tb/UUT/SCLK
add wave -noupdate -color {Dark Orchid} /serial_receiver_tb/UUT/SS
add wave -noupdate /serial_receiver_tb/UUT/accept
add wave -noupdate /serial_receiver_tb/UUT/RESET
add wave -noupdate /serial_receiver_tb/UUT/D
add wave -noupdate /serial_receiver_tb/UUT/DXval
add wave -noupdate /serial_receiver_tb/UUT/busy
add wave -noupdate /serial_receiver_tb/UUT/COUNTER_LINK
add wave -noupdate /serial_receiver_tb/UUT/dFlag_LINK
add wave -noupdate /serial_receiver_tb/UUT/pFlag_LINK
add wave -noupdate /serial_receiver_tb/UUT/INIT_LINK
add wave -noupdate -color Magenta /serial_receiver_tb/UUT/ERR_LINK
add wave -noupdate /serial_receiver_tb/UUT/WR_LINK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5939 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
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
WaveRestoreZoom {0 ps} {48471 ps}
