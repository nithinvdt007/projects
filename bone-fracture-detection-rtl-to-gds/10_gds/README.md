# GDSII streamout

The streamout stage converts a successfully routed design into a GDSII
layout. It requires both:

- a completed `09_place_and_route/route.def`; and
- the SKY130 LEF/DEF layer map at `10_gds/lefdef_layer_map.txt`.

The layer map and routed DEF are not included in this repository snapshot.
Run `klayout-stream` only after regenerating a successful route and providing
the required PDK layer map. The
[GDS gallery image](../OUTPUT%20PICTURES/README.md) is a screenshot—not a GDS
file, and not evidence of current routing or physical signoff.
