source 12_chip_physical/scripts/common.tcl


read_lef $TECH_LEF
read_lef "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
read_lef "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
read_lef "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"

read_db 12_chip_physical/results/chip_cells_placed.odb

# Confirm the SRAM macro in the current chip-level hierarchy.
set block [ord::get_db_block]
set sram_found 0
foreach inst [$block getInsts] {
    set inst_name [$inst getName]
    set master_name [[$inst getMaster] getName]
    if {[string match "*u_macro" $inst_name] &&
        $master_name eq "sky130_sram_1kbyte_1rw1r_8x1024_8"} {
        puts "CONFIRMED SRAM macro: $inst_name ($master_name)"
        set sram_found 1
    }
}
if {!$sram_found} {
    error "Expected SRAM macro was not found in chip_cells_placed.odb"
}
puts "CONFIRMED chip-level database and SRAM hierarchy."


# Connect standard-cell power and ground pins to the supply nets.
add_global_connection -net vccd -inst_pattern {.*} -pin_pattern {^VPWR$} -power
add_global_connection -net vccd -inst_pattern {.*} -pin_pattern {^VPB$}
add_global_connection -net vssd -inst_pattern {.*} -pin_pattern {^VGND$} -ground
add_global_connection -net vssd -inst_pattern {.*} -pin_pattern {^VNB$}
global_connect

# SKY130 SRAM macro supply pins (OpenRAM macro).
add_global_connection -net vccd -inst_pattern {.*u_macro$} -pin_pattern {^vccd1$} -power
add_global_connection -net vssd -inst_pattern {.*u_macro$} -pin_pattern {^vssd1$} -ground
global_connect

# Define the core voltage domain.
set_voltage_domain -name CORE -power vccd -ground vssd

# SKY130 standard-cell power grid.
define_pdn_grid -name grid -voltage_domains CORE -pins {met5}
define_pdn_grid -name macro -macro -default -voltage_domains CORE -halo {10 0.8 10 1.5}

add_pdn_stripe -grid grid -layer met1 -width 0.48 -pitch 5.44 -offset 0 -followpins
add_pdn_stripe -grid grid -layer met4 -width 1.60 -pitch 27.14 -offset 13.57
add_pdn_stripe -grid grid -layer met5 -width 1.60 -pitch 27.20 -offset 13.60

add_pdn_connect -grid grid -layers {met1 met4}
add_pdn_connect -grid grid -layers {met4 met5}
add_pdn_connect -grid macro -layers {met4 met5}

pdngen

write_db 12_chip_physical/results/chip_pdn.odb
write_def 12_chip_physical/results/chip_pdn.def

puts "CORE PDN GENERATION COMPLETED"


