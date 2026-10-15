# Post-I/O global-route preview status

The current chip-I/O result is a direct OpenROAD run from the LibreLane devshell and stops after global routing. It is not a detailed-route result.

- Global route: 3,015 nets, 184,740 µm estimated wirelength, 47,399 estimated vias, and zero global-route congestion overflow.
- Detailed route: timed out after approximately 110 seconds at 40%, with 5,330 intermediate violations. No final detailed-route DRC count or detailed-route GDS exists.
- Power: `vccd` connectivity check failed. The rails `vddio`, `vddio_q`, `vdda`, `vcchib`, `vswitch`, `vssio`, `vssio_q`, and `vssa` have no physical special wires.
- Timing, power estimation, foundry DRC, and LVS: not supplied or not run.
- The GDS is a global-route preview with placement, pad/SRAM geometry, and PDN; it does not contain fully routed signal wires.

See the [stage README](../12_chip_physical/README.md), [run status](../12_chip_physical/STATUS.md), and [QoR summary](../crucible-results/QOR_CHIP_IO.md). This page contains no metrics from the earlier chip-I/O run.

