# Bone Fracture Detection RTL-to-GDSII

An educational RTL-to-physical-design project for a rule-based bone-image decision pipeline, targeting SKY130A. It includes the core Verilog flow and a separate chip-I/O global-route preview around the SRAM-backed SPI core.

> This is a learning project, not a clinically validated diagnostic tool or a tapeout-ready design.

## Design and core flow

The core top is `top_level_final_decision` in [`01_rtl/bone_fracture_top_combined.v`](01_rtl/bone_fracture_top_combined.v). The design processes a 3 × 3 pixel neighborhood, derives directional and edge features, accumulates rule scores, and produces a frame-level decision.

The numbered directories document the core flow from lint through physical-verification setup. See the [core flow guide](docs/RTL_TO_GDSII_FLOW.md), [toolchain setup](docs/IGNY_SETUP.md), and [core flow status](docs/FLOW_STATUS.md). The core-only routing history is separate from the chip-I/O preview below.

## Chip-I/O global-route preview

Stage 12 integrates a six-pad `chip_io_wrapper` around the routed SRAM-backed SPI core and runs floorplanning, pad and cell placement, PDN, CTS, pre-route repair, and global routing with direct OpenROAD from a LibreLane devshell. See [`12_chip_physical/README.md`](12_chip_physical/README.md). From the repository root, run `make -f Makefile.chip-io global-route`.

| Metric | Corrected preview run |
|---|---:|
| Die / core area | 1500 × 1500 µm / 997,820.739 µm² |
| Post-placement total instance area | 256,681.178 µm² (25.72% of core by calculation) |
| Global route | 3015 nets; 184,740 µm estimated wirelength; 47,399 estimated vias; zero global-route overflow |
| GDS output | Global-route preview, 21,828,588 bytes uncompressed |
| Detailed route | **Incomplete:** timed out at ~110 s, 40% progress, 5,330 intermediate violations |
| Power connectivity | **Failed:** `vccd` check failed; eight I/O rails have no physical special wires |
| Post-route timing / power | Not supplied |

This GDS is only a global-route preview. Routing guides are not completed detailed signal wires. Zero global-route overflow is not zero detailed-route DRC. Full detailed routing, power continuity, foundry DRC, and LVS remain unfinished. The raw logs and GDS inspection reports are retained in [`12_chip_physical/audit/`](12_chip_physical/audit/) and [`12_chip_physical/reports/`](12_chip_physical/reports/); see the [run status](12_chip_physical/STATUS.md) and [QoR details](crucible-results/QOR_CHIP_IO.md).

## Gallery

See the [project gallery](OUTPUT%20PICTURES/README.md) for core-flow screenshots and the corrected chip-I/O preview.

## License

No project license has been provided. Review the terms for the RTL authors, tools, and third-party PDK content before redistribution.

