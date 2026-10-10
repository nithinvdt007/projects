# Global and detailed placement from the saved floorplan database.
set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set pdk_root $::env(PDK_ROOT)
set db [file join $project_root 06_floorplanning floorplan.odb]
set sdc [file join $project_root 04_synthesis constraints.sdc]
set lib [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lib sky130_fd_sc_hd__tt_025C_1v80.lib]
foreach f [list $db $sdc $lib] { if {![file exists $f]} { puts stderr "Missing required input: $f"; exit 1 } }
read_liberty $lib
read_db $db
read_sdc $sdc
global_placement -density 0.65
detailed_placement
check_placement -verbose
write_def [file join $script_dir placement.def]
write_db [file join $script_dir placement.odb]
puts "Placement complete."
exit
