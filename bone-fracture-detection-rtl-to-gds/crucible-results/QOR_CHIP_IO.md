# Chip-I/O integration QoR

Final values for the **SRAM-backed, I/O-pad-integrated chip after detailed routing**. This replaces the earlier global-route-only preview snapshot.

**Run conditions:** SKY130A, TT 25 °C, 1.80 V, 20 ns clock target; detailed-route seed 43.

| Metric | Final result |
|---|---:|
| Die size | 1500 × 1500 µm |
| Reported area | 238,732 µm² |
| Utilization | 24% |
| Setup worst slack | 6.406 ns |
| Hold worst slack | 0.404 ns |
| TNS | 0.000 ns |
| Total power | 2.680 mW |
| Power breakdown | SRAM macro 98.9%; combinational logic 1.1% |
| Detailed-route DRC | 0 reported violations |
| Routed wire length | ~128,821 µm |
| Vias | 21,216 |
| Detailed-route runtime | 303 s |
| Final layout | `chip_final_ring.gds` (14.5 MB) |

The seed-43 detailed-route DRC report is archived at [`12_chip_physical/reports/chip_route_drc_seed43.rpt`](../12_chip_physical/reports/chip_route_drc_seed43.rpt). The final layout is stored as [`chip_final_ring.gds.gz`](../12_chip_physical/results/chip_final_ring.gds.gz); a KLayout screenshot is in [the gallery](../OUTPUT%20PICTURES/README.md).

These figures describe the final integrated run and should not be mixed with the earlier core-only QoR snapshot in [`QOR_SUMMARY.md`](QOR_SUMMARY.md). Zero detailed-route DRC violations are not a claim of independent foundry DRC/LVS signoff.
