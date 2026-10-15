source 12_chip_physical/scripts/common.tcl
load_chip_lefs

read_db 12_chip_physical/results/chip_floorplan.odb

# West edge
place_inst -name u_pad_clk   -location {0 300}    -orientation R90  -status LOCKED
place_inst -name u_pad_reset -location {0 540}    -orientation R90  -status LOCKED

# North edge
place_inst -name u_pad_sclk  -location {400 1289} -orientation R0   -status LOCKED
place_inst -name u_pad_cs    -location {700 1289} -orientation R0   -status LOCKED

# East and south edges
place_inst -name u_pad_miso  -location {1289 650} -orientation R270 -status LOCKED
place_inst -name u_pad_mosi  -location {700 0}    -orientation R180 -status LOCKED

write_db 12_chip_physical/results/chip_pads_placed.odb
write_def 12_chip_physical/results/chip_pads_placed.def

puts "GPIO PAD PLACEMENT COMPLETED"

