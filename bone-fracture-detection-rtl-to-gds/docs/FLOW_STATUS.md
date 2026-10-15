# Notes from the project run

The table below separates files included here from results observed in the
original workspace. It should help set expectations when you browse the
project or try the flow yourself.

| Stage | Included in this repository | What the supplied run tells us |
|---|---|---|
| RTL lint | A screenshot; no machine-readable lint report | Verilator completed with non-blocking filename and unused-`p22` warnings. |
| Synthesis | Screenshots; no generated netlist or statistics file | Yosys synthesis was performed in the supplied workspace. Regenerate the netlist before relying on it. |
| Floorplan | A screenshot; no DEF / ODB database | Floorplanning was performed in the supplied workspace. |
| Placement | A screenshot; no placement database | Detailed placement completed in the supplied workspace. |
| Clock-tree synthesis | A screenshot; no CTS database | A CTS result was present in the supplied workspace. |
| Timing | A written TT / SS summary and a screenshot; no raw timing reports | The recorded estimates use placement-based parasitics at 27 ns; they are not post-route signoff. |
| Routing | A screenshot; no routed database or machine-readable error log | A later run was reported to stop at TritonRoute `DRT-0305` on a constant tie net. Rerun and review routing. |
| Core-flow GDSII | No core-only GDS binary | The original core-only flow has no archived GDS. A chip-level global-route preview is included under stage 12; it is not a detailed-route GDS. |
| Physical verification | No verified DRC / LVS result | Physical signoff has not been established. |

## Where the flow stands

Lint, synthesis, floorplanning, placement, and clock-tree synthesis were
reported in the original workspace. The timing summary is placement-based.
The later routing attempt stopped at TritonRoute `DRT-0305`, so post-route
timing and physical verification still need attention.

## Next steps

1. Rebuild from the RTL using the configured tools and record the exact tool
   versions and commands.
2. Resolve the routing error and regenerate the routed database.
3. Review the routing DRC report and run foundry-appropriate DRC and LVS.
4. Re-run timing analysis with post-route parasitics.
5. Archive the resulting machine-readable reports alongside any screenshots.

The screenshots are here to show the work and tell the story of the run.
Rebuilding the flow and checking the final reports is the way to confirm a
result. See the [RTL-to-GDSII flow guide](RTL_TO_GDSII_FLOW.md) for stage
details and the [setup guide](IGNY_SETUP.md) to get started.


## Current chip-I/O run

Stage 12 now documents the corrected direct OpenROAD global-route preview. Global routing completed for 3,015 nets with 184,740 µm estimated wirelength, 47,399 estimated vias, and zero global-route overflow. Detailed routing timed out at about 110 seconds (40% progress, 5,330 intermediate violations); the vccd connectivity check failed, and eight I/O rails have no physical special wires. This run has no post-route STA, power estimate, completed detailed-route GDS, full-layout DRC, or LVS result. Its GDS is only a global-route preview. See [chip-I/O status](CHIP_IO_STATUS.md), the [stage 12 guide](../12_chip_physical/README.md), and the [current-run QoR note](../crucible-results/QOR_CHIP_IO.md).
