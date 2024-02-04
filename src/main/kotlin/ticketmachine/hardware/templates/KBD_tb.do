onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /kbd_tb/UUT/MCLK
add wave -noupdate /kbd_tb/UUT/RESET
add wave -noupdate -color {Violet Red} /kbd_tb/UUT/TXclk
add wave -noupdate -color Gold /kbd_tb/UUT/TXD
add wave -noupdate /kbd_tb/UUT/LIN
add wave -noupdate -color Violet /kbd_tb/UUT/U1/U1/Kpress
add wave -noupdate /kbd_tb/UUT/COL
add wave -noupdate -color Cyan /kbd_tb/UUT/DAC_LINK
add wave -noupdate -color {Medium Blue} /kbd_tb/UUT/KVAL_LINK
add wave -noupdate /kbd_tb/UUT/K_LINK
add wave -noupdate -color Coral /kbd_tb/UUT/U2/M3/A
add wave -noupdate -color {Dark Orchid} /kbd_tb/UUT/U2/M3/S
add wave -noupdate -color {Violet Red} /kbd_tb/UUT/U1/U2/currentState
add wave -noupdate -color {Cadet Blue} /kbd_tb/UUT/U2/M0/currentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6875 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 235
configure wave -valuecolwidth 120
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
WaveRestoreZoom {0 ps} {44653 ps}
