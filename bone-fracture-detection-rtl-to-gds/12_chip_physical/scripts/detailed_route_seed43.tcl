source 12_chip_physical/scripts/common.tcl


read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"

read_db 12_chip_physical/results/chip_global_route_hierarchy_fixed.odb
read_guides 12_chip_physical/results/chip_route.guide

set_routing_layers -signal met1-met5 -clock met1-met5

detailed_route \
    -drc_report_iter_step 1 \
    -droute_end_iter 8 \
    -or_seed 43 \
    -or_k 2 \
    -output_drc 12_chip_physical/reports/chip_route_drc_seed43.rpt \
    -output_maze 12_chip_physical/reports/chip_route_maze_seed43.log \
    -verbose 1

write_db 12_chip_physical/results/chip_detailed_route_seed43.odb
write_def 12_chip_physical/results/chip_detailed_route_seed43.def

puts "SEED 43 DETAILED ROUTING COMPLETED"


