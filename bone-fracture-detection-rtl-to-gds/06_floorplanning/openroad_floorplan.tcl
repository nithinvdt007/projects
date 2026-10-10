# Floorplan, I/O pins, well taps, constant tie cells, and a simple SKY130 PDN.
set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir ..]]
set synth_dir [file join $project_root 04_synthesis]
set pdk_root $::env(PDK_ROOT)
set netlist [file join $synth_dir synth_output.v]
set sdc [file join $synth_dir constraints.sdc]
set lib [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lib sky130_fd_sc_hd__tt_025C_1v80.lib]
set tech_lef_src [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd techlef sky130_fd_sc_hd.tlef]
set cell_lef [file join $pdk_root sky130A libs.ref sky130_fd_sc_hd lef sky130_fd_sc_hd.lef]
foreach f [list $netlist $sdc $lib $tech_lef_src $cell_lef] {
    if {![file exists $f]} { puts stderr "Missing required input: $f"; exit 1 }
}
set tech_lef [file join /tmp bone_sky130_tech.tlef]
file copy -force $tech_lef_src $tech_lef
read_liberty $lib
read_lef $tech_lef
read_lef $cell_lef
read_verilog $netlist
link_design top_level_final_decision
read_sdc $sdc
initialize_floorplan -site unithd -die_area "0 0 400 400" -core_area "20 20 380 380"
insert_tiecells -prefix TIE_ZERO_ sky130_fd_sc_hd__conb_1/LO
insert_tiecells -prefix TIE_ONE_ sky130_fd_sc_hd__conb_1/HI
make_tracks
place_pins -hor_layers met3 -ver_layers met2
add_global_connection -net VPWR -pin_pattern "^VPB$" -power
add_global_connection -net VGND -pin_pattern "^VNB$" -ground
tapcell -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 -endcap_master sky130_fd_sc_hd__decap_4 -distance 14
add_global_connection -net VPWR -pin_pattern "^VPWR$" -power
add_global_connection -net VGND -pin_pattern "^VGND$" -ground
set_voltage_domain -name Core -power VPWR -ground VGND
define_pdn_grid -name Core -voltage_domains Core
add_pdn_stripe -grid Core -layer met1 -width 0.48 -followpins
add_pdn_ring -grid Core -layers {met4 met5} -widths {1.6 1.6} -spacings {1.6 1.6} -core_offsets 2
add_pdn_stripe -grid Core -layer met4 -width 1.6 -pitch 90 -offset 20 -extend_to_core_ring
add_pdn_stripe -grid Core -layer met5 -width 1.6 -pitch 90 -offset 20 -extend_to_core_ring
add_pdn_connect -grid Core -layers {met1 met4}
add_pdn_connect -grid Core -layers {met4 met5}
pdngen
write_def [file join $script_dir floorplan.def]
write_db [file join $script_dir floorplan.odb]
puts "Floorplanning complete: floorplan.def and floorplan.odb"
exit
