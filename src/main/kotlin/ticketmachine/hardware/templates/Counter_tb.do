onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Lime Green} /counter_tb/UUT/CLR
add wave -noupdate -color {Dark Orchid} /counter_tb/UUT/SCLK
add wave -noupdate -color Cyan /counter_tb/UUT/EN
add wave -noupdate /counter_tb/UUT/O
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39922 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
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
WaveRestoreZoom {362662 ps} {507228 ps}
