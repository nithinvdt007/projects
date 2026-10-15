# Project gallery

A few snapshots from the project run, from lint through layout. Select an image to see it full size.

| Lint | Synthesis | Synthesis statistics |
|---|---|---|
| [<img src="LINT.jpg" alt="Verilator lint output" width="240">](LINT.jpg) | [<img src="SYNTH1.jpg" alt="Synthesis output" width="240">](SYNTH1.jpg) | [<img src="SYNTH2.jpg" alt="Synthesis statistics and netlist output" width="240">](SYNTH2.jpg) |

| Core floorplan | Core placement | Core clock-tree synthesis |
|---|---|---|
| [<img src="FLOORPLAN.jpg" alt="Core floorplan view" width="240">](FLOORPLAN.jpg) | [<img src="PLACEMENT.jpg" alt="Core placement view" width="240">](PLACEMENT.jpg) | [<img src="CLOCKTREESYNTHESIS.jpg" alt="Core clock-tree synthesis output" width="240">](CLOCKTREESYNTHESIS.jpg) |

| Core route-stage view | Core timing analysis | Core layout screenshot |
|---|---|---|
| [<img src="POSTROUTECTS.jpg" alt="Core post-CTS and route-stage output" width="240">](POSTROUTECTS.jpg) | [<img src="STA.jpg" alt="Core static timing analysis" width="240">](STA.jpg) | [<img src="GDS.jpg" alt="Core GDS layout screenshot" width="240">](GDS.jpg) |

## Post-I/O-pad chip integration

These additional captures document the pad-integrated `chip_io_wrapper` flow. The floorplan image is the core floorplanning log used as context; placement, CTS, detailed route, STA, and the final KLayout view are from the SRAM-backed chip integration run.

| Floorplanning context | SRAM placement | CTS with SRAM |
|---|---|---|
| [<img src="CHIP_IO/core_floorplan.jpg" alt="Core floorplan context" width="240">](CHIP_IO/core_floorplan.jpg) | [<img src="CHIP_IO/placement_with_sram.jpg" alt="Placement with SRAM" width="240">](CHIP_IO/placement_with_sram.jpg) | [<img src="CHIP_IO/cts_with_sram.jpg" alt="Clock tree synthesis with SRAM" width="240">](CHIP_IO/cts_with_sram.jpg) |

| Detailed-route log | STA with SRAM | Final chip GDS in KLayout |
|---|---|---|
| [<img src="CHIP_IO/detailed_route_log.jpg" alt="Detailed routing log with SRAM" width="240">](CHIP_IO/detailed_route_log.jpg) | [<img src="CHIP_IO/sta_with_sram.jpg" alt="Timing report with SRAM" width="240">](CHIP_IO/sta_with_sram.jpg) | [<img src="CHIP_IO/chip_final_ring_klayout.png" alt="Post-I/O-integration chip GDS in KLayout" width="240">](CHIP_IO/chip_final_ring_klayout.png) |

The final chip stream and its reported QoR are documented separately in [`12_chip_physical/README.md`](../12_chip_physical/README.md) and [`crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md). The reported metrics are not a full foundry DRC/LVS signoff. See [the flow notes](../docs/FLOW_STATUS.md) for the distinction between the original core-only route attempt and this post-I/O-integration result.

