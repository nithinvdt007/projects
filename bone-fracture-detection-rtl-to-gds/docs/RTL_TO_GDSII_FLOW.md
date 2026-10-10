# From RTL to GDSII

Here’s how the project is intended to move from Verilog source to a chip
layout. The scripts use Verilator, Yosys, OpenROAD / OpenSTA, and the SKY130A
standard-cell library through Ignytion Crucible.

The stage notes reflect the original project run. For a quick summary of what
is included here and what remains, see [Flow notes](FLOW_STATUS.md).

## The stages

### 00–03 · Explore the RTL

- **00 — Lint:** Verilator checked the source; the captured run showed
  filename and unused-`p22` warnings.
- **01 — RTL:** The Verilog design lives in
  [`01_rtl/bone_fracture_top_combined.v`](../01_rtl/bone_fracture_top_combined.v).
- **02 — Simulation:** A bone-image testbench is not included.
- **03 — Verification:** A design-specific functional test suite is not
  included.

### 04–05 · Turn RTL into cells

- **04 — Synthesis:** Yosys maps the design to SKY130 cells. A synthesis run
  was recorded in the original workspace.
- **05 — DFT:** Scan insertion and design-for-test checks are not part of the
  current flow.

### 06–09 · Shape and connect the design

- **06 — Floorplanning:** Set up the core area, rows, and I/O locations.
- **07 — Placement:** Arrange and legalize the standard cells.
- **08 — Timing:** The archived TT / SS summary uses placement-based
  estimates at a 27 ns clock target.
- **09 — Clock tree and routing:** Build the clock tree and connect the
  design. A later route attempt stopped with TritonRoute error `DRT-0305` on
  a constant tie net; the route still needs to be resolved and rerun.

### 10–11 · Create and check the layout

- **10 — GDSII:** Stream out the routed layout. The
  [image gallery](../OUTPUT%20PICTURES/README.md) includes a layout screenshot;
  it is not a GDSII file.
- **11 — Physical verification:** Run and review physical DRC and LVS checks.
  Completed signoff results are not included here.

The numbered folders make it easy to find each stage’s scripts and notes.

## Set up the tools

Follow [the Ubuntu / WSL2 setup guide](IGNY_SETUP.md) first. The physical
design stages also need SKY130A available through `PDK_ROOT`; do not copy the
PDK libraries into this repository.

## Run the stages

From the project root, run the stages in order:

```bash
igny run make lint
igny run make synth
igny run make floorplan
igny run make place
igny run make cts
igny run make route
igny run make sta
igny run make gds
```

These targets are also collected in the root [`Makefile`](../Makefile). Check
each stage’s output as you go; later steps depend on earlier ones. GDS
streamout needs a completed route and the SKY130 LEF/DEF layer map described
in [`10_gds/README.md`](../10_gds/README.md).

## Making sense of the timing numbers

The archived TT and SS summary records 0.00 ns WNS and 0.00 ns TNS with a
27 ns clock target (about 37 MHz). These are placement-based estimates, not
post-route timing results. See the [timing summary](reports/post-placement-sta.md).

## After routing

Resolve `DRT-0305`, regenerate the route, and review the resulting reports.
Then run physical DRC and LVS, and check timing with post-route parasitics.
