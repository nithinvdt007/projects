# Crucible Stage Status

Status based on the project run notes available when this file was prepared.

| Stage | Recorded status |
|---|---|
| RTL lint | Completed with nonfatal warnings |
| Yosys synthesis | Completed |
| Floorplanning | Completed |
| Placement | Completed |
| Clock-tree synthesis | Output database/DEF reported |
| Detailed routing | Earlier attempt reported TritonRoute error: ground-class net `u_scharr/zero_` was not routable as a signal net |
| GDS stream-out / physical verification | Do not claim signoff success from the available status alone |

The screenshots linked in the parent project document the visual outputs. A final clean route should be supported by the actual detailed-route log, DRC report, and physical-verification results.
