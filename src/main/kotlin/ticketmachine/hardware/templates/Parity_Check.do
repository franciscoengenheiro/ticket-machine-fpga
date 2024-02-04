onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Cornflower Blue} /parity_check_tb/UUT/SCLK
add wave -noupdate -color {Dark Orchid} /parity_check_tb/UUT/INIT
add wave -noupdate -color Gold /parity_check_tb/UUT/ERR
add wave -noupdate /parity_check_tb/UUT/DATA
add wave -noupdate /parity_check_tb/UUT/Q_LINK
add wave -noupdate /parity_check_tb/UUT/D_LINK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
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
WaveRestoreZoom {0 ps} {403083 ps}
