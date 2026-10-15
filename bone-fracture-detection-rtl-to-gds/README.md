# Bone Fracture Detection ASIC — RTL to GDSII on SKY130A

This project takes a bone-fracture decision design from Verilog through synthesis and physical design, then integrates the routed core with an SRAM macro and chip I/O pads. The completed chip-I/O run includes detailed routing and final GDS stream-out.

<p align="center">
  <img src="OUTPUT%20PICTURES/CHIP_IO/chip_final_ring.png" alt="Final detailed-routed SKY130 chip layout with I/O pads and SRAM" width="760">
</p>
<p align="center"><em>Final layout: <code>chip_io_wrapper</code> with the SRAM-backed core, I/O pads, and routed metal.</em></p>

> Educational implementation for physical-design practice. The project is not a clinically validated diagnostic device.

## Design

| Item | Value |
|---|---|
| Core | Bone-fracture decision RTL with SPI interface |
| Chip top | `chip_io_wrapper` |
| Memory | One SKY130 SRAM macro (`sky130_sram_1kbyte_1rw1r_8x1024_8`) |
| I/O | Integrated SKY130 pad cells |
| Process | SKY130A |
| Die | 1500 × 1500 µm |
| Timing corner | TT, 25 °C, 1.80 V |
| Clock target | 20 ns |

## Final chip-I/O results

The values below describe the **post-I/O-pad, SRAM-integrated, detailed-routed** result. They are not the earlier core-only screenshots.

| Metric | Final result |
|---|---:|
| Reported area | 238,732 µm² |
| Utilization | 24% |
| Die size | 1500 × 1500 µm |
| Setup / hold worst slack | 6.406 ns / 0.404 ns |
| TNS | 0.000 ns |
| Total power | 2.680 mW |
| Power split | SRAM macro 98.9%; combinational logic 1.1% |
| Detailed-route DRC | 0 reported violations |
| Routed wire length | ~128,821 µm |
| Vias | 21,216 |
| Detailed-route run | Seed 43; 303 s |
| Final GDS | `chip_final_ring.gds` (14.5 MB; compressed copy in the repository) |

The detailed-route DRC count is the OpenROAD route report for seed 43. This README does not claim foundry-level DRC or LVS signoff. See the [chip-I/O QoR report](crucible-results/QOR_CHIP_IO.md) and [run status](12_chip_physical/STATUS.md) for scope and artifact details.

## Chip-I/O QoR comparison

The ZIP contains a separate non-Crucible OpenROAD run of the same `chip_io_wrapper` design with a SKY130 SRAM macro and six GPIO pads. It completed floorplanning, placement, CTS, PDN generation, and global routing, then stopped during detailed routing. The figures below compare that preview run with the completed Crucible chip-I/O result.

| Metric | Non-Crucible OpenROAD preview | Crucible completed run |
|---|---:|---:|
| Top / integration | `chip_io_wrapper`, SRAM macro, 6 GPIO pads | `chip_io_wrapper`, SRAM macro, I/O pads |
| SKY130A die | 1500 × 1500 µm | 1500 × 1500 µm |
| Core area | 997,820.739 µm² | — |
| Floorplan instance area / reported area | 339,972.924 µm² (floorplan total instances) | 238,732 µm² (reported final area) |
| Utilization | 34.1% (floorplan) | 24% (reported final) |
| Global-route wire length | 184,740 µm (estimate) | ~128,821 µm (detailed routed) |
| Vias | 47,399 (global-route estimate) | 21,216 (detailed routed) |
| Detailed routing | Timed out at 40% during the first optimization iteration, after 110 s | Completed, seed 43; 303 s |
| Route DRC | No final detailed-route result | 0 reported detailed-route violations |
| Timing and power | No final reports in this ZIP | Setup/hold worst slack 6.406/0.404 ns; TNS 0.000 ns; total power 2.680 mW |

The two runs share the 1500 µm die and chip top, but their endpoint metrics are not directly equivalent: the preview’s area/utilization are floorplan values, and its wire/via totals are global-route estimates. The Crucible values are from the completed detailed-route result. The non-Crucible archive also records a failed `vccd` power-connectivity check, so that preview is useful for comparison and debug, not as the completed chip result.

Source for the non-Crucible column: the supplied `bone_chip_io_corrected_preview_20261015-8214b388fb2e337a82e8ffdceebafe99 (1).zip`, especially `audit/floorplan.log`, `audit/global-route.log`, `audit/detailed-route-timeout.log`, and `STATUS.md`. See [Crucible chip-I/O QoR](crucible-results/QOR_CHIP_IO.md) for the completed-run report.

## Flow

| Stage | Work |
|---|---|
| Lint and RTL checks | Check the Verilog before implementation |
| Synthesis | Map the design to SKY130 standard cells |
| Core floorplan and placement | Define the core, place cells and SRAM, legalize |
| Clock-tree synthesis | Build and repair the clock tree |
| Core routing and timing | Route the core and review timing |
| Chip-I/O integration | Add the wrapper, pads, power grid, and chip-level floorplan |
| Chip-level detailed routing | Route the integrated design; final run used seed 43 |
| GDS stream-out | Produce `chip_final_ring.gds` |

Use the numbered stage directories for the scripts and inputs. The root [Makefile](Makefile) runs the core flow; [`Makefile.chip-io`](Makefile.chip-io) and [`12_chip_physical/`](12_chip_physical/) hold the chip-I/O flow.

## Results and screenshots

Paper-reported simulation outcomes are documented separately in [PAPER_SIMULATION_RESULTS.md](crucible-results/PAPER_SIMULATION_RESULTS.md); they are non-Crucible research-paper results and are kept distinct from implementation QoR. The [gallery](OUTPUT%20PICTURES/README.md) contains the supplied core RTL-to-GDS screenshots with the SRAM macro, captured before I/O pad integration. The completed post-I/O result is shown separately with its final GDS screenshot and saved QoR/report files. The full GDS is available as [`chip_final_ring.gds.gz`](12_chip_physical/results/chip_final_ring.gds.gz).

To open the GDS in KLayout on Ubuntu/WSL:

```bash
gzip -dc 12_chip_physical/results/chip_final_ring.gds.gz > /tmp/chip_final_ring.gds
klayout /tmp/chip_final_ring.gds
```

## Run environment

The completed run was made in the Ubuntu Igny `spi` environment with SKY130A. The supplied `FINAL DONE.zip` contains the detailed-route DEF, seed-43 DRC report, final GDS, and STA snapshots. This repository now includes the final compressed GDS, the route DRC report, and the QoR summary. Earlier preview-run logs and geometry reports are retained under [`12_chip_physical/audit/`](12_chip_physical/audit/) as historical evidence; they do not describe the final run.

## Project map

| Path | Contents |
|---|---|
| `01_rtl/` | Core RTL |
| `02_chip_io/` | Chip-I/O wrapper |
| `04_synthesis/` | Synthesis scripts and constraints |
| `06_floorplanning/`, `07_placement/` | Core floorplan and placement |
| `08_sta/`, `09_place_and_route/` | Timing, CTS, and core routing |
| `10_gds/` | GDS stream-out |
| `12_chip_physical/` | Chip-I/O implementation and final GDS |
| `crucible-results/` | QoR summaries |
| `OUTPUT PICTURES/` | Core-flow and final chip screenshots |

## License

No repository-wide license has been provided. Review the RTL, tool, and third-party PDK terms before redistribution.
