# What the supplied run shows

This page records the evidence that came with the project. It is a snapshot
of a supplied workspace—not a report of a clean, end-to-end rebuild from this
repository.

| Stage | Included in this repository | What the supplied run tells us |
|---|---|---|
| RTL lint | A screenshot; no machine-readable lint report | Verilator completed with non-blocking filename and unused-`p22` warnings. |
| Synthesis | Screenshots; no generated netlist or statistics file | Yosys synthesis was performed in the supplied workspace. Regenerate the netlist before relying on it. |
| Floorplan | A screenshot; no DEF / ODB database | Floorplanning was performed in the supplied workspace. |
| Placement | A screenshot; no placement database | Detailed placement completed in the supplied workspace. |
| Clock-tree synthesis | A screenshot; no CTS database | A CTS result was present in the supplied workspace. |
| Timing | A written TT / SS summary and a screenshot; no raw timing reports | The recorded estimates use placement-based parasitics at 27 ns; they are not post-route signoff. |
| Routing | A screenshot; no routed database or machine-readable error log | A later run was reported to stop at TritonRoute `DRT-0305` on a constant tie net. Rerun and review routing. |
| GDSII | A screenshot of a layout view; no GDS binary | The image is a visual record only, not a physical-design deliverable. |
| Physical verification | No verified DRC / LVS result | Physical signoff has not been established. |

## What to do next

1. Rebuild from the RTL using the configured tools and record the exact tool
   versions and commands.
2. Resolve the routing error and regenerate the routed database.
3. Review the routing DRC report and run foundry-appropriate DRC and LVS.
4. Re-run timing analysis with post-route parasitics.
5. Archive the resulting machine-readable reports alongside any screenshots.

Until then, treat the screenshots and archived outputs as useful project
context—not proof of reproducibility, timing closure, or physical signoff.

See the [RTL-to-GDSII flow guide](RTL_TO_GDSII_FLOW.md) for stage details and
the [setup guide](IGNY_SETUP.md) for the tool environment.
