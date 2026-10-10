# Generate SDC constraints for bone fracture detection.
if {![info exists ::env(PDK_ROOT)] || $::env(PDK_ROOT) eq ""} {
    puts stderr "PDK_ROOT is not set. Install the SKY130A PDK with Ciel or export PDK_ROOT."
    exit 1
}
set lib_ss [file join $::env(PDK_ROOT) sky130A libs.ref sky130_fd_sc_hd lib sky130_fd_sc_hd__ss_100C_1v60.lib]
if {![file exists $lib_ss]} { puts stderr "Missing SKY130 liberty: $lib_ss"; exit 1 }
yosys read_verilog 04_synthesis/synth_output.v
yosys read_liberty -lib $lib_ss
yosys hierarchy -check -top top_level_final_decision
set top top_level_final_decision
set clock_port clk
set clock_period_ns 27
set io_delay_ns 2
yosys tee -q -o 04_synthesis/_in.txt select -list $top/i:*
yosys tee -q -o 04_synthesis/_out.txt select -list $top/o:*
proc read_portnames {path top} {
    set fp [open $path r]
    set raw [read $fp]
    close $fp
    file delete $path
    set names {}
    foreach line [split $raw "\n"] {
        set line [string trim $line]
        if {$line eq ""} { continue }
        if {[string first "$top/" $line] != 0} { continue }
        lappend names [string range $line [string length "$top/"] end]
    }
    return $names
}
set input_ports [read_portnames 04_synthesis/_in.txt $top]
set output_ports [read_portnames 04_synthesis/_out.txt $top]
set input_ports [lsearch -all -inline -not -exact $input_ports $clock_port]
set out [open 04_synthesis/constraints.sdc w]
puts $out "# Timing constraints for $top"
puts $out "create_clock -name $clock_port -period $clock_period_ns \[get_ports $clock_port\]"
puts $out "set_input_delay -clock $clock_port $io_delay_ns \[get_ports {$input_ports}\]"
puts $out "set_output_delay -clock $clock_port $io_delay_ns \[get_ports {$output_ports}\]"
close $out
puts "Generated SDC: clock=$clock_port, period=${clock_period_ns}ns"
