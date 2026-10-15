# Shared SKY130A paths for the chip-level integration scripts.
# Set PDK_ROOT to the full sky130A directory, or discover a CIEL install.
if {![info exists ::env(PDK_ROOT)] || $::env(PDK_ROOT) eq ""} {
    set candidates [glob -nocomplain "$::env(HOME)/.ciel/ciel/sky130/versions/*/sky130A"]
    if {[llength $candidates] == 0} {
        error "SKY130A PDK not found. Set PDK_ROOT to the full sky130A directory."
    }
    set ::env(PDK_ROOT) [lindex $candidates 0]
}
set PDK $::env(PDK_ROOT)
set pdk $PDK
set TECH_LEF "$PDK/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef"

