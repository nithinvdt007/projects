# Chip I/O integration QoR (reported)

**Design:** `chip_io_wrapper` / `chip_final_ring`, after integration of the GPIO pads, supply ports, and SRAM-backed core  
**Corner and constraint:** TT, 25 °C, 1.80 V, 20 ns  
**Provenance:** user-supplied post-integration run summary and screenshots in `OUTPUT PICTURES/CHIP_IO/`; raw machine-readable reports are incomplete.

| Metric | Reported result |
|---|---:|
| Cell area | 238,732 µm² |
| Utilization | 24% (1000 × 1000 µm core in a 1500 × 1500 µm die) |
| Worst slack, max/min | +6.406 ns / +0.404 ns |
| TNS | 0.000 ns |
| Total power | 2.680 mW (macro 98.9%, combinational 1.1%) |
| Detailed-route DRC | 0 reported |
| Routed wire length | approximately 128,821 µm |
| Via count | 21,216 |
| Runtime | 303 s (seed 43) |
| Stream-out | `chip_final_ring.gds`, 14.5 MB uncompressed |

## Evidence and limits

The GDSII is included as `12_chip_physical/results/chip_final_ring.gds.gz`; its uncompressed size is 14,520,504 bytes. The KLayout screenshot shows the `chip_io_wrapper` top cell. The other images are captured post-I/O-integration flow logs/views and do not substitute for archived reports.

The detailed-route screenshot in `OUTPUT PICTURES/CHIP_IO/detailed_route_log.jpg` contains a different run summary: 79,146 µm wire length, 21,077 vias, and 1,463.20 s runtime. The included `chip_route_drc_seed43.rpt` from the submitted snapshot is zero bytes. Therefore, the supplied summary's wire/via/time figures and zero-DRC claim are recorded as **reported**, not independently reproduced or verified. Do not treat them as chip signoff.

The screenshots also include a separate STA output with different slack values; no complete raw timing report is supplied to reconcile it with the summary above. The power breakdown has no attached machine-readable report. No full-chip foundry DRC, LVS, pad electrical check, or fabrication signoff is claimed.

