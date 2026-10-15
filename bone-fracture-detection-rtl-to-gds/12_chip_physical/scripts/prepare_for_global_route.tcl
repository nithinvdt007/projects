
source 12_chip_physical/scripts/common.tcl
load_chip_lefs
load_chip_libs

read_db 12_chip_physical/results/chip_cts.odb

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
    error "SRAM macro missing from chip_cts.odb"
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


write_db 12_chip_physical/results/chip_route_ready.odb
write_def 12_chip_physical/results/chip_route_ready.def

puts "PRE-ROUTE PLACEMENT REPAIR COMPLETED (not signoff STA)"

