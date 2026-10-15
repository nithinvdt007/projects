source 12_chip_physical/scripts/common.tcl
load_chip_lefs

read_db 12_chip_physical/results/chip_global_route.odb

# Verify the SRAM macro in the routed database.
set block [ord::get_db_block]
set sram_count 0
foreach inst [$block getInsts] {
  if {[[$inst getMaster] getName] eq "sky130_sram_1kbyte_1rw1r_8x1024_8"} {
    incr sram_count
    puts "CONFIRMED SRAM macro: [$inst getName]"
  }
}
if {$sram_count != 1} {
  error "Expected exactly one SRAM macro; found $sram_count"
}
read_guides 12_chip_physical/results/chip_route.guide
set_routing_layers -signal met3-met5 -clock met3-met5

detailed_route \
  -drc_report_iter_step 1 \
  -droute_end_iter 26 \
  -output_drc 12_chip_physical/reports/chip_detailed_route_drc.rpt \
  -output_maze 12_chip_physical/reports/chip_detailed_route_maze.log \
  -verbose 1

write_db 12_chip_physical/results/chip_detailed_route.odb
write_def 12_chip_physical/results/chip_detailed_route.def

puts "DETAILED ROUTING COMPLETED"

