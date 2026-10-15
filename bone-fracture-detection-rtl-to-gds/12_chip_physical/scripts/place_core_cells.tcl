source 12_chip_physical/scripts/common.tcl
load_chip_lefs
load_chip_libs

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
# Match OpenSTA objects rather than passing escaped OpenDB names back to STA.
set sram_insts {}
foreach inst [get_cells -hierarchical *] {
    if {[string match "*u_sram*" [get_full_name $inst]] && [get_property $inst ref_name] ne "sky130_sram_1kbyte_1rw1r_8x1024_8"} {
        lappend sram_insts $inst
    }
}
puts "SRAM hierarchy standard-cell instances selected for padding: [llength $sram_insts]"
if {[llength $sram_insts]} { set_placement_padding -instances $sram_insts -left 1 -right 1 }

# Spread placement to reduce local congestion.
global_placement -density 0.35 -skip_io -pad_left 1 -pad_right 1
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

