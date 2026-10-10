# Bone Fracture Detection — RTL-to-GDS with SKY130A

A Verilog implementation of a rule-based bone-fracture decision pipeline, organized for an open-source-style RTL-to-GDS flow using Ignytion Crucible, Yosys, Verilator, OpenROAD/OpenSTA, and the SKY130A standard-cell PDK.

> **Research prototype only.** This repository is not a medical device and is not validated for clinical diagnosis.

## Architecture

Top module: `top_level_final_decision` in `01_rtl/bone_fracture_top_combined.v`.

1. **Pixel memory and windowing:** SRAM-style Verilog memory plus line buffers create a 3×3 pixel neighbourhood.
2. **Directional gradients:** horizontal/vertical Scharr gradients plus two diagonal measures.
3. **Binary masks:** configurable weak/strong gradient classification.
4. **Rule scoring:** cluster, corner, chaos, and brightness counters.
5. **Final decision:** programmable thresholds feed a voting block that outputs the frame-level diagnosis and `output_valid`.

## Install Igny / Crucible

This flow was developed in Ubuntu under WSL2. Use your normal Linux username, not `root`, unless you intentionally want the installation stored under `/root`.

In Windows PowerShell (Administrator), install WSL2 and Ubuntu if needed:

```powershell
wsl --install -d Ubuntu
```

In Ubuntu, install host prerequisites:

```bash
sudo apt update
sudo apt install -y curl git g++ python3
```

Install the Ignytion Crucible Core beta CLI using the official installer:

```bash
curl -fsSL https://get-beta.ignytion.io/v2/install.sh | bash
```

Full guide: [docs/IGNY_SETUP.md](docs/IGNY_SETUP.md). Official CLI guide: https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/

### Prepare the workspace

From the repository root in Ubuntu/WSL:

```bash
igny init
```

If the CLI reports that environment `base` does not exist because `CRUCIBLE_ENV=base` is set:

```bash
unset CRUCIBLE_ENV
igny env use bone --workspace
igny workspace sync
igny tool install make
igny tool install yosys
igny tool list
```

The archived environment omitted `make` and `yosys` from its lock file even though the flow uses them. Reinstall/bind them after syncing. `g++` is a host dependency for Verilator. The physical-design scripts look for SKY130A under `~/.ciel`; if needed, set `PDK_ROOT` to the parent directory containing `sky130A/`.

## Run stages

Run each stage from the workspace root and stop on the first failure. No dedicated validated bone-image testbench is included, so simulation is not claimed.

```bash
igny run make lint
igny run make synth
igny run make -C 06_floorplanning floorplan
igny run make -C 07_placement place
igny run make -C 08_sta corners
igny run make -C 09_place_and_route cts
igny run make -C 09_place_and_route route
igny run make -C 08_sta corners
igny run make -C 10_gds gds
```

## Captured flow status and limitations

- Verilator lint completed with non-blocking filename and unused-`p22` warnings.
- Yosys produced a mapped SKY130 netlist and statistics in the supplied workspace.
- Floorplanning and detailed placement completed in the supplied workspace.
- Archived timing reports showed post-placement STA at a 27 ns clock target (~37 MHz), with WNS/TNS of 0 ns at TT and SS. These are placement-based estimates, **not post-route timing signoff**. See [docs/reports/post-placement-sta.md](docs/reports/post-placement-sta.md).
- A later route attempt stopped at TritonRoute error `DRT-0305` on a constant tie net (`one_` / `u_scharr/zero_`). Do not claim routed DRC/LVS signoff unless routing is regenerated and DRC/LVS are independently reviewed. See [docs/FLOW_STATUS.md](docs/FLOW_STATUS.md).

The current GitHub folder contains the RTL, flow scripts, setup documentation, and status notes. Binary outputs (GDS, screenshots, and the PDF paper) were not transferred by the available text-file GitHub upload action; they are not linked here as if they were committed. The GDS snapshot in the original local archive should be treated as an unverified supplied artifact, not signoff.

## Licensing

No project license was supplied. Until the authors choose one, all rights remain with the applicable copyright holders. Check third-party and PDK terms before redistribution.
