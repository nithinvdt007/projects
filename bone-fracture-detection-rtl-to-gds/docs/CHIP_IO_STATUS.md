# Chip-I/O detailed-route result

The current saved result is the completed SRAM-backed `chip_io_wrapper` run. It proceeds through chip-level floorplanning, pad placement, power-grid generation, clock handling, global routing, **detailed routing**, and GDS stream-out.

- Final detailed-route seed: 43; runtime: 303 s.
- Detailed-route DRC: zero reported violations.
- Final GDS: `chip_final_ring.gds` (14.5 MB before compression).
- Die: 1500 × 1500 µm; reported area: 238,732 µm²; utilization: 24%.
- Timing: TT 25 °C, 1.80 V, 20 ns target; setup / hold worst slack 6.406 / 0.404 ns; TNS 0.000 ns.
- Power: 2.680 mW total; SRAM macro 98.9%, combinational logic 1.1%.

See the [stage README](../12_chip_physical/README.md), [run status](../12_chip_physical/STATUS.md), and [full QoR table](../crucible-results/QOR_CHIP_IO.md). The final compressed GDS and seed-43 route DRC report are checked in under `12_chip_physical/`.

The earlier global-route-only preview run is not the current result. The zero DRC figure refers to the detailed-route report; it does not imply that separate foundry DRC and LVS signoff checks were run.
