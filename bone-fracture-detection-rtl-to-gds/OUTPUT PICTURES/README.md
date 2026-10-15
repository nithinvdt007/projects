# Project gallery

## Core-flow screenshots

These earlier screenshots document the core RTL-to-GDS flow **without the SRAM macro and without chip-level I/O pads**. They are not images of the completed chip-I/O run.

| Lint | Synthesis | Synthesis statistics |
|---|---|---|
| [<img src="LINT.jpg" alt="Core-only Verilator lint output" width="240">](LINT.jpg) | [<img src="SYNTH1.jpg" alt="Core-only synthesis output" width="240">](SYNTH1.jpg) | [<img src="SYNTH2.jpg" alt="Core-only synthesis statistics" width="240">](SYNTH2.jpg) |

| Core-only floorplan | Core-only placement | Core-only clock-tree synthesis |
|---|---|---|
| [<img src="FLOORPLAN.jpg" alt="Core-only floorplan without SRAM" width="240">](FLOORPLAN.jpg) | [<img src="PLACEMENT.jpg" alt="Core-only placement without SRAM" width="240">](PLACEMENT.jpg) | [<img src="CLOCKTREESYNTHESIS.jpg" alt="Core-only clock-tree synthesis without SRAM" width="240">](CLOCKTREESYNTHESIS.jpg) |

| Core-only route-stage view | Core-only timing analysis | Core-only GDS screenshot |
|---|---|---|
| [<img src="POSTROUTECTS.jpg" alt="Core-only post-CTS and route-stage output" width="240">](POSTROUTECTS.jpg) | [<img src="STA.jpg" alt="Core-only static timing analysis" width="240">](STA.jpg) | [<img src="GDS.jpg" alt="Core-only GDS without SRAM" width="240">](GDS.jpg) |

## Completed chip-I/O layout

This is the single supplied screenshot of the final SRAM-integrated, I/O-padded chip after detailed routing. It corresponds to `chip_final_ring.gds`; the [QoR summary](../crucible-results/QOR_CHIP_IO.md) and [run status](../12_chip_physical/STATUS.md) describe the reports.

[<img src="CHIP_IO/chip_final_ring.png" alt="Final detailed-routed chip GDS with SRAM and I/O pads" width="760">](CHIP_IO/chip_final_ring.png)
