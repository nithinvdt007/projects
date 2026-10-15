# Project gallery

## Core RTL-to-GDS with SRAM macro (before chip-I/O integration)

These screenshots are from the completed core physical-design flow with the SRAM macro placed in the core. They show the design **before** chip-level I/O pad integration. The final pad-integrated chip is shown separately below.

| Lint | Synthesis | Synthesis statistics |
|---|---|---|
| [<img src="LINT.jpg" alt="Core RTL lint output" width="240">](LINT.jpg) | [<img src="SYNTH1.jpg" alt="Core RTL synthesis output" width="240">](SYNTH1.jpg) | [<img src="SYNTH2.jpg" alt="Core RTL synthesis statistics" width="240">](SYNTH2.jpg) |

| Core floorplan with SRAM | Placement with SRAM | CTS with SRAM macro |
|---|---|---|
| [<img src="FLOORPLAN.jpg" alt="Core floorplan with SRAM macro, before I/O pads" width="240">](FLOORPLAN.jpg) | [<img src="PLACEMENT.jpg" alt="Core placement with SRAM macro, before I/O pads" width="240">](PLACEMENT.jpg) | [<img src="CLOCKTREESYNTHESIS.jpg" alt="Clock tree with SRAM macro, before I/O pads" width="240">](CLOCKTREESYNTHESIS.jpg) |

| Core routing with SRAM | Core STA with SRAM | Final chip-I/O GDS |
|---|---|---|
| [<img src="POSTROUTECTS.jpg" alt="Core detailed routing with SRAM macro, before I/O pads" width="240">](POSTROUTECTS.jpg) | [<img src="STA.jpg" alt="Core static timing report with SRAM macro, before I/O pads" width="240">](STA.jpg) | [<img src="GDS.jpg" alt="Final chip GDS after I/O pad integration" width="240">](GDS.jpg) |

## Completed chip-I/O layout

This is the single supplied screenshot of the final SRAM-integrated chip after I/O pad integration and detailed routing. It corresponds to `chip_final_ring.gds`; the [QoR summary](../crucible-results/QOR_CHIP_IO.md) and [run status](../12_chip_physical/STATUS.md) describe the final reports. The earlier global-route preview remains historical evidence and is not the final result.

[<img src="CHIP_IO/chip_final_ring.png" alt="Final detailed-routed chip GDS with SRAM and I/O pads" width="760">](CHIP_IO/chip_final_ring.png)
