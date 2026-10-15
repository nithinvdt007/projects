# Project gallery

## Core-only flow screenshots

These screenshots document the earlier RTL-to-GDS core flow. They show the core **without the SRAM macro and without chip-level I/O pad integration**.

| Lint | Synthesis | Synthesis statistics |
|---|---|---|
| [<img src="LINT.jpg" alt="Core-only Verilator lint output" width="240">](LINT.jpg) | [<img src="SYNTH1.jpg" alt="Core-only synthesis output" width="240">](SYNTH1.jpg) | [<img src="SYNTH2.jpg" alt="Core-only synthesis statistics and netlist output" width="240">](SYNTH2.jpg) |

| Core-only floorplan | Core-only placement | Core-only clock-tree synthesis |
|---|---|---|
| [<img src="FLOORPLAN.jpg" alt="Core-only floorplan view, without SRAM macro" width="240">](FLOORPLAN.jpg) | [<img src="PLACEMENT.jpg" alt="Core-only placement view, without SRAM macro" width="240">](PLACEMENT.jpg) | [<img src="CLOCKTREESYNTHESIS.jpg" alt="Core-only clock-tree synthesis output, without SRAM macro" width="240">](CLOCKTREESYNTHESIS.jpg) |

| Core-only route-stage view | Core-only timing analysis | Core-only GDS screenshot |
|---|---|---|
| [<img src="POSTROUTECTS.jpg" alt="Core-only post-CTS and route-stage output, without SRAM macro" width="240">](POSTROUTECTS.jpg) | [<img src="STA.jpg" alt="Core-only static timing analysis, without SRAM macro" width="240">](STA.jpg) | [<img src="GDS.jpg" alt="Core-only GDS layout screenshot, without SRAM macro" width="240">](GDS.jpg) |

## Post-I/O chip preview

The corrected post-I/O run is a separate SRAM-backed chip-wrapper design. The supplied archive contains one GDS preview image plus machine-readable reports and logs; it does not contain separate post-I/O floorplan, placement, CTS, STA, or detailed-route screenshots. The image below is a **global-route preview**, not a completed detailed-route GDS or signoff result.

[<img src="CHIP_IO/preview.png" alt="Post-I/O SRAM-backed chip global-route GDS preview" width="720">](CHIP_IO/preview.png)

See the [stage 12 run status](../12_chip_physical/STATUS.md), [QoR summary](../crucible-results/QOR_CHIP_IO.md), and [archived reports and logs](../12_chip_physical/).
