# Bone fracture detection RTL synthesis - SKY130 HD
if {![info exists ::env(PDK_ROOT)] || $::env(PDK_ROOT) eq ""} {
    puts stderr "PDK_ROOT is not set. Install the SKY130A PDK with Ciel or export PDK_ROOT."
    exit 1
}
set lib_dir [file join $::env(PDK_ROOT) sky130A libs.ref sky130_fd_sc_hd lib]
set liberty_ss [file join $lib_dir sky130_fd_sc_hd__ss_100C_1v60.lib]
set liberty_tt [file join $lib_dir sky130_fd_sc_hd__tt_025C_1v80.lib]
foreach path [list $liberty_ss $liberty_tt] {
    if {![file exists $path]} { puts stderr "Missing SKY130 liberty: $path"; exit 1 }
}
read_verilog -I 01_rtl 01_rtl/bone_fracture_top_combined.v
hierarchy -check -top top_level_final_decision
proc
opt
fsm
opt
memory
opt
synth -top top_level_final_decision
dfflibmap -liberty $liberty_ss
abc -liberty $liberty_ss -D 10000
clean
hilomap -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
stat -liberty $liberty_tt
write_verilog -noattr 04_synthesis/synth_output.v
