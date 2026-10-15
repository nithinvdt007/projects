# Project gallery

Core-flow screenshots are retained here to document the original RTL-to-GDS learning stages.

| Lint | Synthesis | Synthesis statistics |
|---|---|---|
| [<img src="LINT.jpg" alt="Verilator lint output" width="240">](LINT.jpg) | [<img src="SYNTH1.jpg" alt="Synthesis output" width="240">](SYNTH1.jpg) | [<img src="SYNTH2.jpg" alt="Synthesis statistics and netlist output" width="240">](SYNTH2.jpg) |

| Core floorplan | Core placement | Core clock-tree synthesis |
|---|---|---|
| [<img src="FLOORPLAN.jpg" alt="Core floorplan view" width="240">](FLOORPLAN.jpg) | [<img src="PLACEMENT.jpg" alt="Core placement view" width="240">](PLACEMENT.jpg) | [<img src="CLOCKTREESYNTHESIS.jpg" alt="Core clock-tree synthesis output" width="240">](CLOCKTREESYNTHESIS.jpg) |

| Core route-stage view | Core timing analysis | Core GDS screenshot |
|---|---|---|
| [<img src="POSTROUTECTS.jpg" alt="Core post-CTS and route-stage output" width="240">](POSTROUTECTS.jpg) | [<img src="STA.jpg" alt="Core static timing analysis" width="240">](STA.jpg) | [<img src="GDS.jpg" alt="Core GDS layout screenshot" width="240">](GDS.jpg) |

## Corrected chip-I/O preview

This is the global-route preview from the direct OpenROAD run. It is not a detailed-routed chip GDS and does not establish DRC/LVS signoff.

[<img src="CHIP_IO/preview.png" alt="Corrected chip-I/O global-route GDS preview" width="720">](CHIP_IO/preview.png)

See the [stage 12 run status](../12_chip_physical/STATUS.md) and [QoR summary](../crucible-results/QOR_CHIP_IO.md). The earlier chip-I/O result images have been removed from this gallery.

