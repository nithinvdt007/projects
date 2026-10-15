# Physical verification

This repository snapshot does not include a verified Magic DRC / Netgen LVS
flow or a completed DRC / LVS result.

Before calling the design physically verified:

1. Resolve the routed-design issue noted in the
   [flow status](../docs/FLOW_STATUS.md) and regenerate the route.
2. Review the routing DRC report.
3. Run and review foundry-appropriate physical DRC and LVS checks against the
   regenerated layout and netlist.

The GDS view in the [project gallery](../OUTPUT%20PICTURES/README.md) is an
illustrative screenshot, not a signoff release.


A separate post-I/O-pad chip GDS is included under [`12_chip_physical`](../12_chip_physical/README.md). It is a useful integration artifact, but it does not establish full-chip foundry DRC/LVS or pad electrical signoff. The reported QoR and its evidence limits are recorded in [`crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md).
