# Shared SKY130 paths for the chip-I/O flow.
# Set PDK_ROOT to the full sky130A directory, or let the script discover it under ~/.ciel.
if {![info exists ::env(PDK_ROOT)] || $::env(PDK_ROOT) eq ""} {
    set candidates [glob -nocomplain "$::env(HOME)/.ciel/ciel/sky130/versions/*/sky130A"]
    if {[llength $candidates] == 0} {
        error "SKY130 PDK not found. Set PDK_ROOT to the full sky130A directory."
    }
    set ::env(PDK_ROOT) [lindex $candidates 0]
}
set PDK $::env(PDK_ROOT)
if {![file exists "$PDK/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"]} {
    error "PDK_ROOT must point to sky130A; not found: $PDK/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
}

set TECH_LEF "$PDK/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
set SC_LEF   "$PDK/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
set IO_LEF   "$PDK/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
set SRAM_LEF "$PDK/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"
set SC_LIB   "$PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
set SRAM_LIB "$PDK/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"
set IO_LIB   "$PDK/libs.ref/sky130_fd_io/lib/sky130_ef_io__gpiov2_pad_wrapped_tt_tt_025C_1v80_3v30.lib"

proc load_chip_lefs {} {
    global TECH_LEF SC_LEF IO_LEF SRAM_LEF
    read_lef $TECH_LEF
    read_lef $SC_LEF
    read_lef $IO_LEF
    read_lef $SRAM_LEF
}
proc load_chip_libs {} {
    global SC_LIB SRAM_LIB IO_LIB
    read_liberty $SC_LIB
    read_liberty $SRAM_LIB
    read_liberty $IO_LIB
}

