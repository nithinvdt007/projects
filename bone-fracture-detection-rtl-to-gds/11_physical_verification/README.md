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
