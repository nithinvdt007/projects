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

The [gallery](OUTPUT%20PICTURES/README.md) labels the earlier core-flow screenshots separately; those images show the core without the SRAM macro. The final chip-I/O run is represented by its single GDS screenshot and the saved QoR/report files. The full GDS is available as [`chip_final_ring.gds.gz`](12_chip_physical/results/chip_final_ring.gds.gz).

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
