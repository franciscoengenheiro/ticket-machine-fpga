onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /serial_control_tb/UUT/MCLK
add wave -noupdate /serial_control_tb/UUT/RESET
add wave -noupdate -color {Sky Blue} /serial_control_tb/UUT/nSS
add wave -noupdate /serial_control_tb/UUT/dFlag
add wave -noupdate /serial_control_tb/UUT/pFlag
add wave -noupdate -color Orange /serial_control_tb/UUT/RXerror
add wave -noupdate -color {Blue Violet} /serial_control_tb/UUT/accept
add wave -noupdate -color Magenta /serial_control_tb/UUT/init
add wave -noupdate -color {Steel Blue} /serial_control_tb/UUT/wr
add wave -noupdate -color Thistle /serial_control_tb/UUT/DXval
add wave -noupdate -color {Violet Red} /serial_control_tb/UUT/busy
add wave -noupdate -color Cyan /serial_control_tb/UUT/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43109 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
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
WaveRestoreZoom {11866 ps} {51732 ps}
