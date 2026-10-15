# Direct OpenROAD chip I/O run status

**Result class:** corrected global-route preview, not final detailed route  
**Run date:** 2026-10-15  
**Toolchain:** LibreLane devshell 3.0.16; OpenROAD `dcf36133`; Magic 8.3.623; Netgen 1.5.316; KLayout 0.30.7  
**PDK:** SKY130A CIEL revision `8afc8346a57fe1ab7934ba5a6056ea8b43078e71`

## Completed

- Floorplan, six GPIO pad placement, core placement/legalization, core PDN, CTS (three inserted clock buffers), pre-route preparation, and global routing.
- Global routing completed for 3,015 nets with 184,740 µm estimated wirelength and 47,399 estimated vias. Final global-route congestion overflow was zero.
- Global-route GDS preview was streamed out and read back. It identifies top cell `chip_io_wrapper`, six GPIO pads, and one SRAM. The pad and SRAM source-geometry XOR checks each report zero polygon differences.

## Incomplete or failed

- Detailed routing timed out about 110 seconds into the initial iteration. It reached 40% and reported 5,330 intermediate violations. These are not a final DRC count; there is no completed detailed-route DEF/GDS.
- Power connectivity failed on `vccd`. The eight I/O rails `vddio`, `vddio_q`, `vdda`, `vcchib`, `vswitch`, `vssio`, `vssio_q`, and `vssa` have no physical special wires in the supplied connectivity summary.
- Full-layout foundry DRC and LVS were not run. Signal-route completeness is not proven.
- No post-route STA or power estimate is supplied.
- The global-route preview is placement, macro geometry, and PDN. Routing guides are not detailed metal wires.
- The preview GDS bounding box is `(0,-1.17)–(1500,1500.57) µm`, slightly beyond the nominal die because of source-cell geometry. One empty example cell, `sky130_fd_pr__gendlring__example_559591418081`, is retained from the source PDK.

## Placement context

- Nominal die: 1500 × 1500 µm.
- Logged core area: 997,820.739 µm².
- Floorplan effective utilization: 34.1% before placement.
- Post-placement total instance area: 256,681.178 µm²; this is 25.72% of the logged core area by calculation. The OpenROAD standard-cell-only utilization field is 7.474% because it excludes fixed macro area.
- SRAM was track-snapped from the requested `(300,300) µm` to `(300.910,300.030) µm`; no shrink was requested.

See the saved stage logs in [`audit/`](audit/), the GDS inspection reports in [`reports/`](reports/), and the metric summary in [`../crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md).

