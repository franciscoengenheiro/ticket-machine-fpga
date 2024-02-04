onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_scan_tb/MCLK_tb
add wave -noupdate /key_scan_tb/RESET_tb
add wave -noupdate -color Gray60 /key_scan_tb/Kpress_tb
add wave -noupdate -color {Medium Slate Blue} /key_scan_tb/Kscan_tb
add wave -noupdate -color Gold /key_scan_tb/Lin_tb
add wave -noupdate -color Magenta /key_scan_tb/Col_tb
add wave -noupdate -color Cyan /key_scan_tb/K_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47859 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
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
WaveRestoreZoom {23710 ps} {71160 ps}
