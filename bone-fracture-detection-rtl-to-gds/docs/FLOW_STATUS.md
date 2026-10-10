# Captured flow status

| Stage | Snapshot evidence | Notes |
|---|---|---|
| RTL lint | Verilator completed | Non-blocking filename and unused `p22` warnings were seen. |
| Synthesis | Yosys netlist and statistics were produced | PDK libraries should be discovered through `PDK_ROOT`, not committed. |
| Floorplanning | DEF / ODB generated in the supplied workspace | Constant tie-cell insertion is part of the flow. |
| Placement | Detailed placement converged in the supplied workspace | A later placement run reported zero remaining violations after padding adjustment. |
| CTS | CTS ODB / DEF exist in the supplied workspace archive | Clock tree inserted. |
| STA snapshot | TT/SS summary reports captured | Post-placement estimates only; not post-route signoff. |
| Routing / GDS | A GDS snapshot was supplied | A subsequent route rerun hit TritonRoute `DRT-0305` on a constant net. Rerun route and review DRC/LVS before claiming signoff. |

These statuses describe supplied workspace snapshots, not a claim that a clean checkout has been rebuilt end to end.
