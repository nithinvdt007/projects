source 12_chip_physical/scripts/common.tcl
load_chip_lefs
load_chip_libs

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

