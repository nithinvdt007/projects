source 12_chip_physical/scripts/common.tcl



read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"

read_liberty "$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty "$PDK/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"
read_liberty "$PDK/libs.ref/sky130_fd_io/lib/sky130_ef_io__gpiov2_pad_tt_tt_025C_1v80_3v30.lib"

read_db 12_chip_physical/results/chip_pdn.odb

# Verify current SRAM hierarchy dynamically.
set block [ord::get_db_block]
set matches {}
foreach inst [$block getInsts] {
    if {[[$inst getMaster] getName] eq "sky130_sram_1kbyte_1rw1r_8x1024_8"} {
        lappend matches $inst
    }
}
if {[llength $matches] != 1} {
    error "Expected one SRAM macro; found [llength $matches]"
}
puts "CONFIRMED SRAM: [[lindex $matches 0] getName]"

# Verify the actual wrapper clock net.
set clock_dbnet [$block findNet clk_i]
if {$clock_dbnet eq "NULL"} {
    error "Clock net clk_i not found in chip_pdn.odb"
}
set clock_net_name [$clock_dbnet getName]
puts "CONFIRMED CTS ROOT NET: $clock_net_name"

if {[llength [get_ports {pad_clk}]] != 1} {
    error "Top-level pad_clk port not found"
}
create_clock -name core_clk -period 20 [get_ports {pad_clk}]

set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
estimate_parasitics -placement

clock_tree_synthesis \
    -clk_nets [list $clock_net_name] \
    -root_buf sky130_fd_sc_hd__clkbuf_2 \
    -buf_list {sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4}

repair_clock_nets
detailed_placement
set_propagated_clock [all_clocks]
estimate_parasitics -placement
report_cts

# Keep the old chip_cts files unchanged for now.
write_db 12_chip_physical/results/chip_cts_hierarchy_fixed.odb
write_def 12_chip_physical/results/chip_cts_hierarchy_fixed.def
puts "HIERARCHY-AWARE CHIP CTS COMPLETED"


