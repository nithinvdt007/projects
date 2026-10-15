source 12_chip_physical/scripts/common.tcl



read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"

read_liberty "$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty "$PDK/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"
read_liberty "$PDK/libs.ref/sky130_fd_io/lib/sky130_ef_io__gpiov2_pad_tt_tt_025C_1v80_3v30.lib"

read_db 12_chip_physical/results/chip_cts_hierarchy_fixed.odb

# Find SRAM by master type, not by escaped hierarchy.
set block [ord::get_db_block]
set found 0
foreach inst [$block getInsts] {
    if {[[$inst getMaster] getName] eq "sky130_sram_1kbyte_1rw1r_8x1024_8"} {
        puts "CONFIRMED SRAM INSTANCE: [$inst getName]"
        set found 1
    }
}
if {!$found} {
    error "SRAM macro missing from chip_cts_hierarchy_fixed.odb"
}

if {[llength [get_ports {pad_clk}]] != 1} {
    error "Top-level pad_clk port missing"
}
puts "CONFIRMED CLOCK PORT: pad_clk"

create_clock -name core_clk -period 20 [get_ports {pad_clk}]
set_propagated_clock [all_clocks]
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
estimate_parasitics -placement

repair_timing -skip_gate_cloning
detailed_placement
estimate_parasitics -placement

report_worst_slack -min -digits 3
report_worst_slack -max -digits 3
report_tns -digits 3

write_db 12_chip_physical/results/chip_timing_repaired_clean.odb
write_def 12_chip_physical/results/chip_timing_repaired_clean.def

puts "CLEAN CHIP TIMING REPAIR COMPLETED"


