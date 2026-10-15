
source 12_chip_physical/scripts/common.tcl
load_chip_lefs
load_chip_libs

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

# Save the chip-level CTS checkpoint.
write_db 12_chip_physical/results/chip_cts.odb
write_def 12_chip_physical/results/chip_cts.def
puts "CHIP CTS COMPLETED"

