set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set pdk_root $::env(PDK_ROOT)
set placement_db [file join $project_root 07_placement placement.odb]
set sdc [file join $project_root 04_synthesis constraints.sdc]
set lib [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lib sky130_fd_sc_hd__tt_025C_1v80.lib]
set tech_lef [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd techlef sky130_fd_sc_hd.tlef]
set cell_lef [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lef sky130_fd_sc_hd.lef]
foreach f [list $placement_db $sdc $lib $tech_lef $cell_lef] { if {![file exists $f]} { puts stderr "Missing required input: $f"; exit 1 } }
read_liberty $lib
read_lef $tech_lef
read_lef $cell_lef
read_db $placement_db
read_sdc $sdc
clock_tree_synthesis -buf_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4}
repair_timing
write_def [file join $script_dir cts.def]
write_db [file join $script_dir cts.odb]
puts "CTS complete."
exit
