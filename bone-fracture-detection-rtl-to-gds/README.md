<div align="center">

# Bone Fracture Detection

### An experimental Verilog design and RTL-to-GDSII learning project

**RTL · SKY130A · Yosys · OpenROAD · OpenSTA**

<img src="OUTPUT%20PICTURES/GDS.jpg" alt="Screenshot of the supplied GDS layout view" width="760">

*A screenshot from the supplied project run. It is a visual preview—not physical signoff.*

</div>

> [!IMPORTANT]
> **Research prototype only.** This project is not a medical device and has not
> been validated for clinical use. It must not be used to make healthcare
> decisions.

## Welcome

This repository brings together a rule-based bone-fracture decision design
written in Verilog and an experimental RTL-to-GDSII flow built around
open-source EDA tools. It is intended as a learning and engineering project:
explore the RTL, follow the implementation stages, and see which results
are—and are not—supported by the supplied run.

The design's top module is `top_level_final_decision`, in
[`01_rtl/bone_fracture_top_combined.v`](01_rtl/bone_fracture_top_combined.v).
It accepts pixel-memory writes and programmable score thresholds, then
produces a frame-level decision, a validity signal, and debug outputs.

## At a glance

| | |
|---|---|
| **Hardware description** | Verilog |
| **Target library** | SKY130A standard-cell library |
| **Flow tools** | Verilator, Yosys, OpenROAD / OpenSTA, Ignytion Crucible |
| **Design scope** | Pixel windowing, gradient-based features, rule scores, and a final vote |
| **Current evidence** | RTL, flow scripts, archived timing notes, and nine stage screenshots |
| **Not established** | Clean end-to-end rebuild, post-route timing closure, DRC/LVS signoff |

## How the design is organized

The RTL builds a 3 × 3 pixel neighborhood, calculates directional gradient
features, classifies edge masks, and accumulates cluster, corner, chaos, and
brightness scores. A vote block compares the accumulated scores with the
provided thresholds and produces the frame-level result.

This is a description of the supplied RTL—not a claim that the algorithm has
been validated on medical images.

## Take a look around

- [RTL-to-GDSII flow guide](docs/RTL_TO_GDSII_FLOW.md) — what each numbered
  stage does and how to try the configured flow.
- [Toolchain setup](docs/IGNY_SETUP.md) — Ubuntu / WSL2, Ignytion Crucible,
  and SKY130A setup notes.
- [Captured flow status](docs/FLOW_STATUS.md) — a concise record of the
  supplied run and its limitations.
- [Screenshot gallery](OUTPUT%20PICTURES/README.md) — lint through GDS-view
  images, with context for what they do and do not show.
- [Post-placement timing summary](docs/reports/post-placement-sta.md) —
  archived TT / SS results and their scope.

## Try the first check

The flow was developed for Ubuntu / WSL2. Once the tools are installed and the
workspace is configured, run the lint stage from this project directory:

```bash
igny run make lint
```

If that succeeds, the [flow guide](docs/RTL_TO_GDSII_FLOW.md) lists the
remaining configured stages. Run them one by one and stop if a stage fails:
the archived routing attempt hit a TritonRoute error, so later results should
not be assumed to be current or reproducible.

## What the supplied results tell us

The archived run notes record lint, synthesis, floorplanning, placement, and
placement-based timing results. They are useful project history, but they
come from a supplied workspace—not a demonstrated clean checkout.

In particular, the 27 ns timing snapshot uses placement-based parasitics; it
does not prove post-route timing closure. A later routing attempt reported
TritonRoute error `DRT-0305` on a constant tie net. The GDS image in the
gallery is only a screenshot; no GDS binary is included here. DRC/LVS signoff
has not been established. More detail is in [the flow status](docs/FLOW_STATUS.md).

## License and attribution

No project license was supplied. Until the relevant authors or rights holders
choose one, all rights remain with them. Check the licensing terms for any
third-party material and PDK assets before redistributing the project.
