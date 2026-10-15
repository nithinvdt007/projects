# Chip I/O integration status

The repository now includes a **post-I/O-pad integration** result for the SRAM-backed `chip_io_wrapper` top: six GPIO signal pads and supply ports around the core, with floorplan, placement, PDN, CTS, timing repair, routing, and `chip_final_ring.gds` outputs represented by the archived scripts, GDS, QoR note, and screenshots.

This is a new chip-top run and should be read separately from the original core-only RTL-to-GDS flow summarized in [`FLOW_STATUS.md`](FLOW_STATUS.md). The core-only run's reported TritonRoute issue remains part of that history; it does not describe the later chip-level artifact.

The post-I/O-integration QoR is a supplied summary, not an independently reproduced report. The route-log screenshot shows different wire length, via count, and runtime from that summary, and the submitted seed-43 DRC report is zero bytes. The GDS opens in KLayout, but the repository does not include complete machine-readable timing and power reports or full foundry DRC/LVS results. See [`../crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md) and [`../12_chip_physical/README.md`](../12_chip_physical/README.md).

