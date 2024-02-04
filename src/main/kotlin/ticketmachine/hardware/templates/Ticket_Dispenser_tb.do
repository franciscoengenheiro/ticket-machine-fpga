onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Violet Red} /ticket_dispenser_tb/UUT/Prt
add wave -noupdate /ticket_dispenser_tb/UUT/CollectTicket
add wave -noupdate -color {Slate Blue} /ticket_dispenser_tb/UUT/Dout
add wave -noupdate /ticket_dispenser_tb/UUT/Fn
add wave -noupdate -color Coral /ticket_dispenser_tb/UUT/HEX0
add wave -noupdate /ticket_dispenser_tb/UUT/HEX1
add wave -noupdate -color {Medium Slate Blue} /ticket_dispenser_tb/UUT/HEX2
add wave -noupdate /ticket_dispenser_tb/UUT/HEX3
add wave -noupdate -color Cyan /ticket_dispenser_tb/UUT/HEX4
add wave -noupdate /ticket_dispenser_tb/UUT/HEX5
add wave -noupdate /ticket_dispenser_tb/UUT/RT
add wave -noupdate -color Coral /ticket_dispenser_tb/UUT/RTtoBDC
add wave -noupdate -color {Medium Slate Blue} /ticket_dispenser_tb/UUT/O
add wave -noupdate -color Cyan /ticket_dispenser_tb/UUT/D
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17992 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
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
WaveRestoreZoom {0 ps} {120715 ps}
