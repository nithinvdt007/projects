# RTL-to-GDSII Stage Screenshots

The following images are visual records supplied with the project. They show
selected tool windows and layout views; they are not independent verification
evidence or proof of a clean rebuild.

## 00 — Lint

![Verilator lint output](LINT.jpg)

## 04 — Synthesis

![Synthesis output](SYNTH1.jpg)

![Synthesis statistics and netlist output](SYNTH2.jpg)

## 06 — Floorplanning

![Floorplan view](FLOORPLAN.jpg)

## 07 — Placement

![Placement view](PLACEMENT.jpg)

## 09 — Clock-tree synthesis and routing

![Clock-tree synthesis](CLOCKTREESYNTHESIS.jpg)

![Post-CTS and route-stage output](POSTROUTECTS.jpg)

## 08 — Static timing analysis

![Static timing analysis](STA.jpg)

## 10 — GDS view

![GDS layout view](GDS.jpg)

The archived route attempt also reported TritonRoute error `DRT-0305` on a
constant tie net. Resolve the routing issue and independently review DRC/LVS
before claiming physical signoff; see the
[flow status](../docs/FLOW_STATUS.md).
