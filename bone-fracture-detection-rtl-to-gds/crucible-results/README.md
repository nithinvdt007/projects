# Crucible RTL-to-GDS Results

This folder records the Crucible-based SKY130A implementation results for the bone-fracture-detection RTL project.

## Run summary

- **Flow:** Verilog RTL → Yosys synthesis → OpenROAD physical design
- **PDK:** SKY130A, sky130_fd_sc_hd standard-cell library
- **Top module:** `top_level_final_decision`
- **Environment:** Ignytion Crucible `bone`

## Reported QoR snapshot

See [QOR_SUMMARY.md](QOR_SUMMARY.md) for the metrics captured from the Crucible run.

## Stage evidence

Screenshots already tracked in the project are linked here:

- [Lint](../OUTPUT%20PICTURES/LINT.jpg)
- [Synthesis overview 1](../OUTPUT%20PICTURES/SYNTH1.jpg)
- [Synthesis overview 2](../OUTPUT%20PICTURES/SYNTH2.jpg)
- [Floorplan](../OUTPUT%20PICTURES/FLOORPLAN.jpg)
- [Placement](../OUTPUT%20PICTURES/PLACEMENT.jpg)
- [STA](../OUTPUT%20PICTURES/STA.jpg)
- [Clock-tree synthesis](../OUTPUT%20PICTURES/CLOCKTREESYNTHESIS.jpg)
- [Post-route CTS view](../OUTPUT%20PICTURES/POSTROUTECTS.jpg)
- [GDS/layout screenshot](../OUTPUT%20PICTURES/GDS.jpg)

## Status and caveats

The QoR numbers below are a captured report snapshot, not a fresh rerun. The earlier Crucible routing attempt reported a TritonRoute error for the ground-class net `u_scharr/zero_`; therefore do not treat the route or GDS stages as clean signoff unless the detailed-route DRC report and final physical verification confirm it.

This is an educational/experimental hardware project and is not a clinically validated diagnostic tool.
