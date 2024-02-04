onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_decode_tb/U1/MCLK
add wave -noupdate /key_decode_tb/U1/RESET
add wave -noupdate /key_decode_tb/U1/LIN
add wave -noupdate /key_decode_tb/U1/COL
add wave -noupdate -color {Medium Spring Green} /key_decode_tb/U1/K
add wave -noupdate -color Goldenrod /key_decode_tb/U1/KSCAN_LINK
add wave -noupdate -color Cyan /key_decode_tb/U1/U2/Kpress
add wave -noupdate -color {Slate Blue} /key_decode_tb/U1/U2/Kval
add wave -noupdate -color Gold /key_decode_tb/U1/KACK
add wave -noupdate /key_decode_tb/U1/U2/currentState
add wave -noupdate -color Magenta /key_decode_tb/U1/U1/O_LINK
add wave -noupdate /key_decode_tb/U1/U1/Y_LINK
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37894 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 283
configure wave -valuecolwidth 154
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
WaveRestoreZoom {0 ps} {32415 ps}
