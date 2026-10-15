# SKY130 chip-I/O integration — completed detailed route

This stage wraps the SRAM-backed SPI core in `chip_io_wrapper`, adds the SKY130 I/O pads and power grid, and completes chip-level detailed routing and GDS stream-out.

## Final result

| Metric | Result |
|---|---:|
| Die | 1500 × 1500 µm |
| Reported area / utilization | 238,732 µm² / 24% |
| Timing corner / clock target | TT, 25 °C, 1.80 V / 20 ns |
| Setup / hold worst slack | 6.406 ns / 0.404 ns |
| TNS | 0.000 ns |
| Total power | 2.680 mW |
| Detailed-route DRC | 0 reported violations |
| Routed wire length / vias | ~128,821 µm / 21,216 |
| Detailed-route seed / runtime | 43 / 303 s |
| Final GDS | `chip_final_ring.gds`, 14.5 MB |

The final screenshot is in [`OUTPUT PICTURES/CHIP_IO/`](../OUTPUT%20PICTURES/CHIP_IO/). The compressed final GDS and seed-43 DRC report are in [`results/`](results/) and [`reports/`](reports/).

## Implementation sequence

1. Floorplan the 1500 × 1500 µm chip around the routed core and SRAM.
2. Place the GPIO pads and legalize core cells.
3. Build the power distribution network and clock tree.
4. Run global routing, then complete detailed routing with seed 43.
5. Stream out and inspect the final GDS.

The completed-run values are summarized in [`crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md). The [status page](STATUS.md) lists the delivered artifacts and the verification scope.

## Re-run

Use Ubuntu/WSL with the Igny `spi` environment and the SKY130A PDK configured:

```bash
igny env use spi
make -f Makefile.chip-io global-route
make -f Makefile.chip-io detailed-route
make -f Makefile.chip-io gds
```

The checked-in final GDS is the saved seed-43 result. The QoR summary records its run metrics; a new run may differ if the tool versions, PDK revision, constraints, or routing seed change.
