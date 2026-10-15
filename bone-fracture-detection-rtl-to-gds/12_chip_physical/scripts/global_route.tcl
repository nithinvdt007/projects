source 12_chip_physical/scripts/common.tcl
load_chip_lefs
load_chip_libs

read_db 12_chip_physical/results/chip_route_ready.odb

# Verify SRAM macro by master type, not escaped hierarchy path.
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
set chip_sram [lindex $matches 0]
puts "CONFIRMED SRAM: [$chip_sram getName]"

foreach pin {vccd1 vssd1} {
    set found 0
    foreach iterm [$chip_sram getITerms] {
        if {[[$iterm getMTerm] getName] eq $pin} {
            puts "CONFIRMED SRAM power pin exists: $pin"
            set found 1
            break
        }
    }
    if {!$found} {
        error "SRAM power pin $pin missing"
    }
}


# Remove earlier top-level pin shapes for signals carried by integrated pad cells.
set block [ord::get_db_block]
foreach name {pad_clk pad_reset pad_spi_sclk pad_spi_cs_n pad_spi_mosi pad_spi_miso} {
    set bterm [$block findBTerm $name]
    if {$bterm != "NULL"} {
        foreach bpin [$bterm getBPins] {
            odb::dbBPin_destroy $bpin
        }
    }
}


# Standard-cell supply connections.
add_global_connection -net vccd -pin_pattern {^VPWR$} -power
add_global_connection -net vccd -pin_pattern {^VPB$}
add_global_connection -net vssd -pin_pattern {^VGND$} -ground
add_global_connection -net vssd -pin_pattern {^VNB$}

# GPIO pad power and ground nets.
add_global_connection -net vddio   -inst_pattern {^u_pad_.*$} -pin_pattern {^VDDIO$}   -power
add_global_connection -net vddio_q -inst_pattern {^u_pad_.*$} -pin_pattern {^VDDIO_Q$} -power
add_global_connection -net vdda    -inst_pattern {^u_pad_.*$} -pin_pattern {^VDDA$}    -power
add_global_connection -net vccd    -inst_pattern {^u_pad_.*$} -pin_pattern {^VCCD$}    -power
add_global_connection -net vcchib  -inst_pattern {^u_pad_.*$} -pin_pattern {^VCCHIB$}  -power
add_global_connection -net vswitch -inst_pattern {^u_pad_.*$} -pin_pattern {^VSWITCH$} -power

add_global_connection -net vssio   -inst_pattern {^u_pad_.*$} -pin_pattern {^VSSIO$}   -ground
add_global_connection -net vssio_q -inst_pattern {^u_pad_.*$} -pin_pattern {^VSSIO_Q$} -ground
add_global_connection -net vssd    -inst_pattern {^u_pad_.*$} -pin_pattern {^VSSD$}    -ground
add_global_connection -net vssa    -inst_pattern {^u_pad_.*$} -pin_pattern {^VSSA$}    -ground

global_connect

# SKY130 SRAM macro supply pins (OpenRAM macro).
add_global_connection -net vccd -inst_pattern {.*u_macro.*} -pin_pattern {^vccd1$} -power
add_global_connection -net vssd -inst_pattern {.*u_macro.*} -pin_pattern {^vssd1$} -ground
global_connect

# Physical tie cells for constant nets.
global_connect
place_io_terminals u_pad_*/PAD
detailed_placement
create_clock -name core_clk -period 20 [get_ports {pad_clk}]
set_propagated_clock [all_clocks]

set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5
set_routing_layers -signal met3-met5 -clock met3-met5
estimate_parasitics -placement

pin_access
global_route \
  -guide_file 12_chip_physical/results/chip_route.guide \
  -congestion_iterations 50 \
  -verbose

estimate_parasitics -global_routing

write_db 12_chip_physical/results/chip_global_route.odb
write_def 12_chip_physical/results/chip_global_route.def

puts "CHIP GLOBAL ROUTING COMPLETED"

