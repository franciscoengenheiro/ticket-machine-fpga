onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ios_tb/UUT/MCLK
add wave -noupdate /ios_tb/UUT/RESET_IOS
add wave -noupdate -color {Dark Orchid} /ios_tb/UUT/SS
add wave -noupdate -color {Violet Red} /ios_tb/UUT/SCLK
add wave -noupdate -color Gold /ios_tb/UUT/SDX
add wave -noupdate /ios_tb/UUT/Fsh
add wave -noupdate /ios_tb/UUT/Dout
add wave -noupdate /ios_tb/UUT/busy
add wave -noupdate /ios_tb/UUT/Wrl
add wave -noupdate /ios_tb/UUT/Wrt
add wave -noupdate /ios_tb/UUT/DXval_LINK
add wave -noupdate /ios_tb/UUT/done_LINK
add wave -noupdate /ios_tb/UUT/D_LINK
add wave -noupdate /ios_tb/UUT/SLR/M3/currentState
add wave -noupdate /ios_tb/UUT/DPTR/currentState
add wave -noupdate /ios_tb/UUT/SLR/M2/INIT
add wave -noupdate -color Gold /ios_tb/UUT/SLR/M2/ERR
add wave -noupdate /ios_tb/UUT/SLR/M2/Q_LINK
add wave -noupdate /ios_tb/UUT/SLR/M2/D_LINK
add wave -noupdate /ios_tb/UUT/SLR/M1/O
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 337
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
WaveRestoreZoom {1596 ps} {37394 ps}
