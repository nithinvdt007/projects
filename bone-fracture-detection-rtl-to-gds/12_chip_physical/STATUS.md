# Completed chip-I/O run status

**Result:** detailed-routed chip-I/O layout and final GDS  
**Run:** seed 43; 303 s detailed-route runtime  
**Platform:** Ubuntu / Igny `spi` environment  
**PDK / corner:** SKY130A; TT, 25 °C, 1.80 V  
**Clock target:** 20 ns

## Completed stages

- RTL lint and synthesis.
- Core floorplanning and placement with the SRAM macro.
- Clock-tree synthesis, core routing, and timing analysis.
- Chip-level I/O wrapper and pad integration.
- Chip floorplanning, pad placement, power-grid generation, and clock-tree handling.
- Chip-level global routing and **completed detailed routing**.
- Final GDS stream-out to `chip_final_ring.gds`.

## Final QoR

- Reported area: 238,732 µm²; utilization: 24%; die: 1500 × 1500 µm.
- Setup / hold worst slack: 6.406 ns / 0.404 ns; TNS: 0.000 ns.
- Total power: 2.680 mW (macro 98.9%, combinational logic 1.1%).
- Detailed route: zero reported OpenROAD route DRC violations; approximately 128,821 µm wire length and 21,216 vias.

See the [QoR table](../crucible-results/QOR_CHIP_IO.md). The final GDS and seed-43 route DRC report are checked in under `results/` and `reports/`; the single final chip screenshot is under [`OUTPUT PICTURES/CHIP_IO/`](../OUTPUT%20PICTURES/CHIP_IO/).

The reported zero is the detailed-route DRC result. It does not by itself state that independent foundry DRC or LVS signoff was run. Earlier preview-run logs and inspection reports remain archived in [`audit/`](audit/) and [`reports/`](reports/); they describe a separate preliminary run, not this completed result.
