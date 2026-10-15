source 12_chip_physical/scripts/common.tcl


read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"
read_liberty "$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty "$PDK/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"

read_verilog 09_place_and_route/route_output.v
read_verilog 02_chip_io/chip_io_wrapper.v
link_design chip_io_wrapper

initialize_floorplan \
  -die_area {0 0 1500 1500} \
  -core_area {250 250 1250 1250} \
  -site unithd

# Create routing tracks before SRAM macro placement.
make_tracks

# Place the hard SRAM macro inside the core before standard-cell placement.
# Location is in microns; adjust only if the floorplan dimensions change.
place_macro -macro_name {u_core/u_core\/u_sram\/u_macro} -location {300 300} -orientation R0

insert_tiecells -prefix TIEHI_ sky130_fd_sc_hd__conb_1/HI
insert_tiecells -prefix TIELO_ sky130_fd_sc_hd__conb_1/LO

write_db 12_chip_physical/results/chip_floorplan.odb
write_def 12_chip_physical/results/chip_floorplan.def

puts "CHIP FLOORPLAN CREATED"


