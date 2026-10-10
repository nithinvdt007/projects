# Following the RTL-to-GDSII flow

This project is arranged around the steps an RTL design typically takes on
its way to a GDSII layout. The scripts use Verilator, Yosys, OpenROAD / OpenSTA,
and the SKY130A standard-cell library through Ignytion Crucible.

The stage notes below describe the **supplied workspace snapshot**. They do
not mean that a fresh checkout has completed every step or passed signoff.
For the current evidence in one place, see [Flow status](FLOW_STATUS.md).

## The journey, stage by stage

### 00–03 · Check and exercise the RTL

- **00 — Lint:** Verilator reported non-blocking filename and unused-`p22`
  warnings in the supplied run.
- **01 — RTL:** The Verilog design lives in
  [`01_rtl/bone_fracture_top_combined.v`](../01_rtl/bone_fracture_top_combined.v).
- **02 — Simulation:** A validated bone-image simulation testbench is not
  included, so simulation results are not claimed.
- **03 — Functional verification:** A bone-specific verification suite is
  not included in this repository snapshot.

### 04–05 · Synthesize and prepare for test

- **04 — Synthesis:** Yosys mapped the design to SKY130 cells in the supplied
  workspace. Regenerate the output before relying on an archived netlist.
- **05 — DFT:** Scan insertion and design-for-test checks are not implemented.

### 06–09 · Build the physical implementation

- **06 — Floorplanning:** Floorplan DEF / ODB outputs exist in the supplied
  workspace.
- **07 — Placement:** Detailed placement completed in the supplied workspace.
- **08 — Timing analysis:** Archived TT / SS reports show placement-based
  estimates at a 27 ns clock target. They are not post-route timing signoff.
- **09 — Clock tree and routing:** A later routing attempt stopped with
  TritonRoute error `DRT-0305` on a constant tie net. Resolve and rerun the
  route before relying on downstream results.

### 10–11 · Stream out and verify

- **10 — GDSII:** A screenshot of a GDS view is included in the
  [image gallery](../OUTPUT%20PICTURES/README.md); the GDS binary is not
  included in this repository snapshot.
- **11 — Physical verification:** The supplied materials do not establish
  DRC / LVS signoff. Independently run and review foundry-appropriate checks.

The numbered directories in the original workspace describe the intended
flow. Not every stage has a corresponding implementation or validated result
in this repository snapshot.

## Set up the tools

Follow [the Ubuntu / WSL2 setup guide](IGNY_SETUP.md) first. The physical
design stages also need SKY130A available through `PDK_ROOT`; do not copy the
PDK libraries into this repository.

## Run the configured stages

From the project root, run one command at a time and stop if anything fails:

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

The root [`Makefile`](../Makefile) provides these stage targets and an `all`
target. An `all` run is not a substitute for checking individual stage
results: in particular, do not treat downstream output as verified if the
routing step fails. GDS streamout needs a completed route and the SKY130
LEF/DEF layer map described in [`10_gds/README.md`](../10_gds/README.md).

## Reading the timing snapshot

The archived TT and SS timing summary records 0.00 ns WNS and 0.00 ns TNS
with a 27 ns clock target (about 37 MHz). These figures use
**placement-based parasitics**. They do not demonstrate post-route timing
closure. See the
[timing summary](reports/post-placement-sta.md).

## Before calling it signoff

First resolve `DRT-0305` and regenerate the route. Then review the routing DRC
report, run the appropriate physical DRC and LVS checks, and analyze timing
with post-route parasitics. Screenshots and archived reports are helpful
context, but they are not a substitute for those checks.
