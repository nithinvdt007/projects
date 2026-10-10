set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set pdk_root $::env(PDK_ROOT)
set cts_db [file join $script_dir cts.odb]
set sdc [file join $project_root 04_synthesis constraints.sdc]
set lib [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lib sky130_fd_sc_hd__tt_025C_1v80.lib]
set tech_lef [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd techlef sky130_fd_sc_hd.tlef]
set cell_lef [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lef sky130_fd_sc_hd.lef]
foreach f [list $cts_db $sdc $lib $tech_lef $cell_lef] { if {![file exists $f]} { puts stderr "Missing required input: $f"; exit 1 } }
read_liberty $lib
read_lef $tech_lef
read_lef $cell_lef
read_db $cts_db
read_sdc $sdc
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
global_route -guide_file [file join $script_dir route.guide]
detailed_route -output_drc [file join $script_dir route_drc.rpt] -output_maze [file join $script_dir route_maze.log]
write_def [file join $script_dir route.def]
write_db [file join $script_dir route.odb]
write_spef [file join $script_dir route.spef]
write_verilog [file join $script_dir route_output.v]
puts "Routing complete."
exit
