<div align="center">

# Bone Fracture Detection

### From Verilog RTL to a SKY130A physical-design flow

**Verilog** &nbsp;·&nbsp; **Yosys** &nbsp;·&nbsp; **OpenROAD** &nbsp;·&nbsp; **SKY130A**

<img src="OUTPUT%20PICTURES/GDS.jpg" alt="Layout view from a project run" width="760">

*One of the layout views captured during the project.*

</div>

> **A note on the project:** This is an experimental hardware and learning
> project, not a clinically validated diagnostic tool.

## The project

This repository explores how a rule-based bone-image decision pipeline can
be expressed in Verilog and taken through an RTL-to-GDSII flow. It brings
together the hardware design, implementation scripts, setup notes, and
screenshots from the project.

The top-level module is `top_level_final_decision`, in
[`01_rtl/bone_fracture_top_combined.v`](01_rtl/bone_fracture_top_combined.v).
It accepts pixel-memory writes and programmable score thresholds, then
produces a frame-level decision, a validity signal, and debug outputs.

## Inside the design

Pixels are arranged into a 3 × 3 neighborhood. The RTL derives directional
gradient and edge features, accumulates cluster, corner, chaos, and brightness
scores, then combines those scores in a final vote.

```text
Pixel data → 3 × 3 window → edge features → rule scores → final vote
```

## Project at a glance

| | |
|---|---|
| **Language** | Verilog |
| **Target** | SKY130A standard-cell library |
| **Tools** | Verilator · Yosys · OpenROAD / OpenSTA · Ignytion Crucible |
| **In this repo** | Core RTL flow, stage 12 chip I/O integration, GDSII, screenshots, and reported QoR |
| **Still to do** | Clean-room reproduction, complete raw reports, and full-chip physical verification |

## Explore

| Start here | What you’ll find |
|---|---|
| [RTL-to-GDSII flow](docs/RTL_TO_GDSII_FLOW.md) | A tour of the stages and commands to run them. |
| [Toolchain setup](docs/IGNY_SETUP.md) | Ubuntu / WSL2, Ignytion Crucible, and SKY130A setup. |
| [Flow notes](docs/FLOW_STATUS.md) | What is present in the repository and what the original core run showed. |
| [Post-I/O chip integration](docs/CHIP_IO_STATUS.md) | Stage 12 scripts, chip GDS, screenshots, QoR, and verification limits. |
| [Image gallery](OUTPUT%20PICTURES/README.md) | Screenshots from lint through the layout view. |
| [Timing snapshot](docs/reports/post-placement-sta.md) | The archived TT / SS placement-based timing summary. |

## Give it a try

The flow was developed in Ubuntu / WSL2. Once the tools are installed and the
workspace is configured, start with lint:

```bash
igny run make lint
```

Then follow the [flow guide](docs/RTL_TO_GDSII_FLOW.md), running each stage in
order and checking its output before continuing.

## A note on the results

The screenshots and timing summary record the supplied core-flow run. That
core-only run later encountered TritonRoute error `DRT-0305`. This repository
also includes a separate post-I/O-pad integration run with the
`chip_io_wrapper` top and `chip_final_ring.gds`; its QoR summary is reported
with evidence caveats, and full-chip foundry DRC/LVS is not included. See the
[chip I/O status](docs/CHIP_IO_STATUS.md), [chip stage guide](12_chip_physical/README.md),
and [QoR summary](crucible-results/QOR_CHIP_IO.md).

## License

No project license has been provided. Please check with the relevant authors
before redistributing the RTL, and review the terms for any third-party tools
or PDK material you use.
