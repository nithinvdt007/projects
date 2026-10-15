# Physical verification

This repository snapshot does not include a verified Magic DRC / Netgen LVS
flow or a completed DRC / LVS result. Stage 12 currently contains only a
global-route preview; detailed routing timed out and power connectivity failed.

Before calling the design physically verified:

1. Resolve the core-flow routing issue noted in the [flow status](../docs/FLOW_STATUS.md).
2. Complete detailed routing for the chip-I/O integration and resolve its power-connectivity failures.
3. Review final detailed-route DRC output.
4. Run and review foundry-appropriate physical DRC and LVS checks against the completed layout and netlist.

The chip-I/O GDS in the [project gallery](../OUTPUT%20PICTURES/README.md) is a global-route preview, not a detailed-routed layout or signoff release.


A separate post-I/O-pad chip GDS is included under [`12_chip_physical`](../12_chip_physical/README.md). It is a useful integration artifact, but it does not establish full-chip foundry DRC/LVS or pad electrical signoff. The reported QoR and its evidence limits are recorded in [`crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md).
