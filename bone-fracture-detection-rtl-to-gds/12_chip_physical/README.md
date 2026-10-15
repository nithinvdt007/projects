# Chip-level I/O integration and physical design

This is **stage 12**, following the core RTL-to-GDS flow. It wraps the SRAM-backed SPI core with SKY130 I/O pads and carries the chip-level design through floorplanning, pad placement, core placement, PDN generation, CTS, timing repair, global routing, and detailed routing. This post-I/O-integration run is separate from the core-only flow and does not close the core flow's existing physical-verification tasks.

## Delivered files

- `02_chip_io/chip_io_wrapper.v`: `chip_io_wrapper` top module with six signal pads and supply ports.
- `09_place_and_route/route_output.v`: routed core netlist used by the wrapper flow.
- `12_chip_physical/scripts/`: PDK-portable copies of the integration sequence and inspection utilities.
- `12_chip_physical/results/chip_final_ring.gds.gz`: compressed final GDSII; expands to 14,520,504 bytes.
- `12_chip_physical/results/chip_detailed_route_seed43.def.gz`: compressed detailed-route DEF checkpoint.
- `config/lefdef_layer_map.txt`: layer map used for stream-out.
- `OUTPUT PICTURES/CHIP_IO/`: floorplanning context, placement, CTS, route-log, STA, and KLayout screenshots.

The PDK and licensed library files are not included. The GDS merges geometry from the SKY130 PDK and SRAM macro; check their license terms before redistributing the binary.

## Inspect the GDS

From Ubuntu or WSL in the repository root:

```bash
gzip -dk 12_chip_physical/results/chip_final_ring.gds.gz
klayout 12_chip_physical/results/chip_final_ring.gds
```

The supplied KLayout capture shows top cell `chip_io_wrapper`. Opening the stream is a visual check, not a DRC/LVS signoff certificate.

## Run sequence

The scripts expect a compatible SKY130A PDK and OpenROAD/Igny toolchain, with the project root as the current directory. Point `PDK_ROOT` to the full `sky130A` directory; otherwise the helper looks under `$HOME/.ciel/ciel/sky130/versions/*/sky130A`.

```bash
unset CRUCIBLE_ENV
igny env use spi
export PDK_ROOT="$HOME/.ciel/ciel/sky130/versions/<installed-revision>/sky130A"
mkdir -p 12_chip_physical/results 12_chip_physical/reports
```

Run one script at a time with OpenROAD from the active Igny environment. The intended sequence is:

1. `12_chip_physical/scripts/floorplan_chip.tcl`
2. `12_chip_physical/scripts/place_gpio_pads.tcl`
3. `12_chip_physical/scripts/place_core_cells.tcl`
4. `12_chip_physical/scripts/create_pdn.tcl`
5. `12_chip_physical/scripts/run_cts_hierarchy_fixed.tcl`
6. `12_chip_physical/scripts/repair_timing_clean.tcl`
7. `12_chip_physical/scripts/global_route_hierarchy_fixed.tcl`
8. `12_chip_physical/scripts/detailed_route_seed43.tcl`

Each script reads the previous step's ODB checkpoint and writes a new one under `12_chip_physical/results/`. Preserve intermediate outputs when resuming and inspect each script's exact `read_db` and `write_db` paths. These archived scripts have the original machine-specific PDK paths removed; the repo does not claim a clean-room run of this exact sequence.

## QoR and verification caveats

See [`../crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md) for the reported post-I/O-integration QoR and the discrepancy in the captured route log. The supplied route DRC report was empty, so the reported zero detailed-router violations cannot be independently confirmed from that report. No full foundry-rule DRC/LVS signoff is included.


