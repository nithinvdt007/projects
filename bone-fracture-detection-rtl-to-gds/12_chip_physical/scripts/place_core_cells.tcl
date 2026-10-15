source 12_chip_physical/scripts/common.tcl


read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"
read_liberty "$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty "$PDK/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"
read_db 12_chip_physical/results/chip_pads_placed.odb

# Globally connect standard-cell supply and bulk pins before routability analysis.
add_global_connection -net vccd -inst_pattern {.*} -pin_pattern {^VPWR$} -power
add_global_connection -net vccd -inst_pattern {.*} -pin_pattern {^VPB$} -power
add_global_connection -net vssd -inst_pattern {.*} -pin_pattern {^VGND$} -ground
add_global_connection -net vssd -inst_pattern {.*} -pin_pattern {^VNB$} -ground
global_connect

# SKY130 SRAM macro supply pins (OpenRAM macro).
add_global_connection -net vccd -inst_pattern {.*u_macro.*} -pin_pattern {^vccd1$} -power
add_global_connection -net vssd -inst_pattern {.*u_macro.*} -pin_pattern {^vssd1$} -ground
global_connect


# Select SRAM-hierarchy standard cells through OpenSTA objects.
# This avoids failures caused by escaped slashes in instance names.
set sram_insts [get_cells -hierarchical -regexp {.*u_sram.*} -filter {is_macro == false}]
set sram_count [llength $sram_insts]
puts "SRAM standard-cell instances selected for padding: $sram_count"

if {$sram_count == 0} {
    error "No SRAM standard cells matched; stopping without placement."
}

set_placement_padding -instances $sram_insts -left 1 -right 1

# Spread placement to reduce local congestion.
global_placement -density 0.35 -skip_io -pad_left 1 -pad_right 1
make_tracks
make_tracks
make_tracks
make_tracks
make_tracks
make_tracks
# PIN RAILS AT DISTINCT LOCATIONS
place_pin -pin_name vddio   -layer met3 -location {100 0}   -force_to_die_boundary
place_pin -pin_name vddio_q -layer met3 -location {250 0}   -force_to_die_boundary
place_pin -pin_name vdda    -layer met3 -location {400 0}   -force_to_die_boundary
place_pin -pin_name vccd    -layer met3 -location {550 0}   -force_to_die_boundary
place_pin -pin_name vcchib  -layer met3 -location {950 0}   -force_to_die_boundary
place_pin -pin_name vswitch -layer met3 -location {1100 0}  -force_to_die_boundary
place_pin -pin_name vssio   -layer met3 -location {1250 0}  -force_to_die_boundary
place_pin -pin_name vssio_q -layer met3 -location {1400 0}  -force_to_die_boundary
place_pin -pin_name vssd    -layer met3 -location {100 1500} -force_to_die_boundary
place_pin -pin_name vssa    -layer met3 -location {300 1500} -force_to_die_boundary

place_pins -hor_layers met3 -ver_layers met2 -corner_avoidance 25
global_placement -density 0.35 -pad_left 1 -pad_right 1 -routability_driven

# Legalize using the SRAM padding constraints.
detailed_placement
check_placement -verbose

write_db 12_chip_physical/results/chip_cells_placed.odb
write_def 12_chip_physical/results/chip_cells_placed.def
puts "SRAM-SPACED CELL PLACEMENT COMPLETED"


