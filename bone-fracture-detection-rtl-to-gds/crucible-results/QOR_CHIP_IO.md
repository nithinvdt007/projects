# Chip I/O QoR and run comparison

Both data sets are for the SRAM-backed `chip_io_wrapper` after integrating the GPIO pads and supply ports. They are separate runs and their completion points differ. The earlier run used Igny/OpenROAD and was reported as detailed-routed; the alternate run used direct OpenROAD from a LibreLane devshell and stopped before detailed routing completed.

## Side-by-side results

| Metric | Earlier Igny run (user-reported) | Alternate direct OpenROAD run (logs in supplied ZIP) |
|---|---|---|
| Toolchain | Igny `spi` environment; OpenROAD 26Q3-771 | LibreLane devshell 3.0.16; OpenROAD `dcf3613`; SKY130A CIEL revision `8afc8346…` |
| Die / core | 1500 × 1500 µm die; 24% utilization reported | 1500 × 1500 µm die; core area 997,820.739 µm² |
| Area / utilization | 238,732 µm²; 24% reported | Post-placement total instance area 256,681.178 µm², or 25.72% of the logged core area by calculation. OpenROAD also reports 7.474% standard-cell-only utilization; the definitions/endpoints differ, so treat the area comparison as indicative. |
| Timing | Worst slack max/min +6.406 / +0.404 ns; TNS 0 reported | No post-route STA result supplied for this run |
| Power | 2.680 mW reported (macro 98.9%, combinational 1.1%) | No power estimate supplied; power-connectivity check failed on `vccd`, and the eight listed I/O rails have zero special-wire counts |
| Routing | Detailed routing and zero DRC reported; ~128,821 µm wire, 21,216 vias, 303 s reported | Global route completed: 184,740 µm estimated wirelength, 47,399 estimated vias, zero global-route overflow. Detailed route timed out at 110 s, reaching 40% with 5,330 intermediate violations; no final detailed-route DRC count exists. These routing measures are not directly comparable. |
| GDS | `chip_final_ring.gds`, 14.5 MB uncompressed, reported as final | `chip_global_route_preview.gds`, 21,828,588 bytes. This is a global-route preview without completed detailed signal wires, not a final routed GDS. |
| Physical verification | Zero detailed-route DRC reported, but the archived seed-43 DRC report is empty; foundry DRC/LVS not established | Full-layout DRC and LVS not run; signal-route completeness not proven; power connectivity failed |

## How to interpret the comparison

The earlier summary describes a claimed completed route, but its screenshot reports different detailed-route values (79,146 µm, 21,077 vias, 1,463.20 s) and its archived DRC report is zero bytes. Its QoR remains labeled reported rather than independently verified.

The alternate run is better supported by saved logs, but it is **not a completed detailed-route result**. Its 184,740 µm wirelength and 47,399 vias are global-route estimates; do not compare them to detailed-route wire/via counts as if they were final. The global-route preview opens and identifies top cell `chip_io_wrapper`, includes six GPIO pads and one SRAM, and the geometry-XOR check reports zero difference for the pad and SRAM source polygons. That geometry check does not establish signal routing, electrical power continuity, DRC, or LVS. The preview bounding box extends slightly beyond the nominal die due to source-cell geometry, and one empty source-PDK example cell is retained and disclosed in the audit.

The alternate ZIP's `STATUS.md`, `audit/floorplan.log`, `audit/placement.log`, `audit/global-route.log`, `audit/detailed-route-timeout.log`, `audit/power-connectivity-summary.log`, `12_chip_physical/reports/gds-preview-inspection.json`, and `12_chip_physical/reports/geometry-xor.json` were used to extract these figures. The full ZIP and generated preview are not copied into this repository by this documentation-only comparison.

## Earlier Igny run metrics

**Design:** `chip_io_wrapper` / `chip_final_ring`, after integration of the GPIO pads, supply ports, and SRAM-backed core  
**Corner and constraint:** TT, 25 °C, 1.80 V, 20 ns

The user-reported earlier summary was: area 238,732 µm²; 24% utilization; +6.406 ns max slack / +0.404 ns min slack; TNS 0; 2.680 mW total power; zero detailed-route DRC; approximately 128,821 µm wire; 21,216 vias; 303 s at seed 43; and a 14.5 MB `chip_final_ring.gds`.

The final GDS is included as `12_chip_physical/results/chip_final_ring.gds.gz` (14,520,504 bytes uncompressed). The KLayout screenshot shows the `chip_io_wrapper` top cell. The DRC, timing, and power caveats above still apply. No full-chip foundry DRC, LVS, pad electrical check, or fabrication signoff is claimed for either run.

