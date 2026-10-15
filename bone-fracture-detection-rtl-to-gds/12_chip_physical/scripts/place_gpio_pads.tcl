source 12_chip_physical/scripts/common.tcl


read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"
read_db 12_chip_physical/results/chip_floorplan.odb

# Corners 200x204
place_inst -name u_corner_sw -location {0 0} -orientation R0 -status LOCKED
place_inst -name u_corner_se -location {1300 0} -orientation R270 -status LOCKED
place_inst -name u_corner_nw -location {0 1296} -orientation R90 -status LOCKED
place_inst -name u_corner_ne -location {1300 1296} -orientation R180 -status LOCKED

# West edge signals
place_inst -name u_pad_clk   -location {0 300}    -orientation R90  -status LOCKED
place_inst -name u_pad_reset -location {0 540}    -orientation R90  -status LOCKED

# North edge signals
place_inst -name u_pad_sclk  -location {400 1289} -orientation R0   -status LOCKED
place_inst -name u_pad_cs    -location {700 1289} -orientation R0   -status LOCKED

# East and south edges signals
place_inst -name u_pad_miso  -location {1289 650} -orientation R270 -status LOCKED
place_inst -name u_pad_mosi  -location {700 0}    -orientation R180 -status LOCKED

place_inst -name u_pwr_vddio_0 -location {0 700} -orientation R90 -status LOCKED
place_inst -name u_pwr_vssd_1 -location {0 800} -orientation R90 -status LOCKED
place_inst -name u_pwr_vddio_2 -location {0 950} -orientation R90 -status LOCKED
place_inst -name u_pwr_vssio_3 -location {0 1050} -orientation R90 -status LOCKED
place_inst -name u_pwr_vddio_4 -location {250 1289} -orientation R0 -status LOCKED
place_inst -name u_pwr_vssio_5 -location {550 1289} -orientation R0 -status LOCKED
place_inst -name u_pwr_vddio_6 -location {850 1289} -orientation R0 -status LOCKED
place_inst -name u_pwr_vssio_7 -location {1000 1289} -orientation R0 -status LOCKED
place_inst -name u_pwr_vdda_8 -location {1150 1289} -orientation R0 -status LOCKED
place_inst -name u_pwr_vccd_9 -location {1289 300} -orientation R270 -status LOCKED
place_inst -name u_pwr_vssd_10 -location {1289 450} -orientation R270 -status LOCKED
place_inst -name u_pwr_vddio_11 -location {1289 850} -orientation R270 -status LOCKED
place_inst -name u_pwr_vssio_12 -location {1289 1000} -orientation R270 -status LOCKED
place_inst -name u_pwr_vddio_13 -location {300 0} -orientation R180 -status LOCKED
place_inst -name u_pwr_vssio_14 -location {450 0} -orientation R180 -status LOCKED
place_inst -name u_pwr_vssa_15 -location {900 0} -orientation R180 -status LOCKED
place_inst -name u_pwr_vdda_16 -location {1050 0} -orientation R180 -status LOCKED
place_inst -name u_pwr_vccd_17 -location {1200 0} -orientation R180 -status LOCKED

write_db 12_chip_physical/results/chip_pads_placed.odb
write_def 12_chip_physical/results/chip_pads_placed.def

puts "GPIO+CORNER PLACEMENT COMPLETED"


