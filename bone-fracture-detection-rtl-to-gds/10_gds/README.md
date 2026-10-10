# GDS streamout

The original working archive included a GDS snapshot and a SKY130 LEF/DEF layer map, but binary artifacts were not transferred through the connected GitHub text-file upload action. The streamout target therefore needs the PDK layer map at `10_gds/lefdef_layer_map.txt` and a completed `09_place_and_route/route.def`.

Use `klayout-stream` only after routing completes successfully. Do not treat a supplied old GDS snapshot as proof of successful current routing or physical signoff.
