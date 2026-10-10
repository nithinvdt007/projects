# RTL-to-GDSII Flow

This guide describes the numbered project stages, their purpose, and what the
current repository snapshot does—and does not—demonstrate. The flow uses
Verilator, Yosys, OpenROAD/OpenSTA, and the SKY130A standard-cell PDK through
Ignytion Crucible.

> **Status caveat:** The notes below describe archived workspace outputs and
> screenshots. They are not a claim that a clean checkout has completed every
> stage successfully or achieved physical signoff.

## Stage map

| Stage | Purpose | Tool / artifact | Snapshot status |
|---|---|---|---|
| `00_lint` | Check the RTL for syntax and lint diagnostics. | Verilator | Completed with non-blocking filename and unused-`p22` warnings. |
| `01_rtl` | Hold the synthesizable bone-fracture decision design. | Verilog; top module `top_level_final_decision` | Source is in the repository. |
| `02_sim` | Exercise RTL behavior in simulation. | Icarus Verilog / VVP | No validated bone-image testbench is included; simulation results are not claimed. |
| `03_verification` | Run design-specific functional verification. | Testbench / verification environment | No bone-specific verification suite is included in this snapshot. |
| `04_synthesis` | Elaborate, optimize, and map the RTL to SKY130 standard cells. | Yosys; mapped netlist and statistics | Synthesis outputs exist in the supplied workspace; reproduce from a clean checkout before relying on them. |
| `05_dft` | Insert and verify scan/test structures. | DFT tooling | Not implemented. |
| `06_floorplanning` | Initialize the core, rows, tracks, taps, and I/O placement. | OpenROAD; DEF/ODB | Floorplan outputs exist in the supplied workspace. |
| `07_placement` | Place standard cells and legalize the placement. | OpenROAD; DEF/ODB | Detailed placement completed in the supplied workspace. |
| `08_sta` | Analyze timing at the configured library corners. | OpenSTA/OpenROAD; TT and SS reports | Archived reports are placement-based estimates at a 27 ns clock target, not post-route timing signoff. |
| `09_place_and_route` | Build the clock tree and perform global/detailed routing. | OpenROAD; CTS and route outputs | A route rerun encountered TritonRoute `DRT-0305` on a constant tie net. Resolve and rerun before treating route results as current. |
| `10_gds` | Stream out the routed layout to GDSII. | KLayout streamout and SKY130 layer map | A GDS-view screenshot is included; the GDS binary is not included in this repository snapshot. |
| `11_physical_verification` | Check physical rule compliance and layout/netlist equivalence. | Magic DRC and Netgen LVS | DRC/LVS signoff is not established by the supplied materials. |

The directory names intentionally preserve the `00`–`11` stage numbering.
Stages without a validated bone-design implementation are called out above
rather than represented as completed flow steps.

## Run the implemented stages

Use Ubuntu or WSL2 with the Ignytion Crucible environment and SKY130A PDK set
up as described in [the setup guide](IGNY_SETUP.md). Run commands from the
project root and stop if a stage fails:

```bash
igny run make lint
igny run make synth
igny run make -C 06_floorplanning floorplan
igny run make -C 07_placement place
igny run make -C 08_sta corners
igny run make -C 09_place_and_route cts
igny run make -C 09_place_and_route route
igny run make -C 08_sta corners
igny run make -C 10_gds gds
```

These commands describe the configured flow; they are not a guarantee that the
current RTL and tool environment will complete every stage. In particular,
the archived routing issue must be resolved before relying on downstream
streamout or physical-verification results.

## Screenshot evidence

The [stage image gallery](../OUTPUT%20PICTURES/README.md) contains the supplied
lint, synthesis, floorplan, placement, CTS, route-stage, STA, and GDS-view
screenshots. They are illustrative snapshots, not substitutes for machine
readable reports or independent signoff.

## Timing snapshot

The archived TT and SS reports show 0.00 ns WNS and 0.00 ns TNS at a 27 ns
clock target (about 37 MHz). The reports use placement-based parasitics; this
does **not** establish post-route timing closure. See
[the captured STA summary](reports/post-placement-sta.md).

## Physical signoff

The supplied materials do not establish successful routed DRC/LVS signoff.
Review the routing DRC report, regenerate routing after resolving
`DRT-0305`, and run foundry-appropriate DRC and LVS before describing the
design as physically verified.
