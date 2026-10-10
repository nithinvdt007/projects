# Bone Fracture Detection — RTL-to-GDS with SKY130A

A Verilog implementation of a rule-based bone-fracture decision pipeline, adapted for an open-source-style RTL-to-GDS flow using Ignytion Crucible, Yosys, Verilator, OpenROAD/OpenSTA, and the SKY130A standard-cell PDK.

> **Research prototype only.** This repository is not a medical device and is not validated for clinical diagnosis.

## Architecture

Top module: `top_level_final_decision` in `01_rtl/bone_fracture_top_combined.v`.

1. **Pixel memory and windowing:** SRAM-style Verilog memory plus line buffers create the 3×3 pixel neighbourhood.
2. **Directional gradients:** horizontal/vertical Scharr gradients plus two diagonal measures.
3. **Binary masks:** configurable weak/strong gradient classification.
4. **Rule scoring:** cluster, corner, chaos, and brightness counters.
5. **Final decision:** programmable thresholds feed a voting block that produces the frame-level diagnosis and `output_valid`.

## Install Igny / Crucible

This flow was developed in Ubuntu under WSL2. Use your normal Linux username, not `root`, unless you intentionally want the installation stored under `/root`.

In Windows PowerShell (Administrator), install WSL2 and Ubuntu if needed:

```powershell
wsl --install -d Ubuntu
```

Restart if requested, launch Ubuntu, then install host prerequisites:

```bash
sudo apt update
sudo apt install -y curl git g++ python3
```

Install the Ignytion Crucible Core beta CLI using the official installer:

```bash
curl -fsSL https://get-beta.ignytion.io/v2/install.sh | bash
```

Official CLI guide: https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/

Verify the commands available in your installed beta version:

```bash
igny --help
igny env --help
igny tool --help
```

### Enter and configure the workspace

From the repository root in Ubuntu/WSL:

```bash
igny init
```

If a command reports that environment `base` does not exist because `CRUCIBLE_ENV=base` is set, correct the current shell and select the project environment:

```bash
unset CRUCIBLE_ENV
igny env use bone --workspace
igny workspace sync
```

In the tested setup, `workspace sync` removed tools that were installed but absent from `crucible.lock`. Re-bind the required tools after syncing:

```bash
igny tool install make
igny tool install yosys
igny tool list
```

Verilator requires host `g++` to compile its generated C++ code; this is a system package, not an Igny-managed EDA tool. The physical-design scripts discover SKY130A beneath `~/.ciel`. If needed, set `PDK_ROOT` to the directory containing the `sky130A/` folder.

## Run the flow

Run each step from the workspace root and stop if a stage fails. The project does not include a dedicated validated bone-image testbench, so simulation is not claimed here.

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

## Captured status and limitations

- Verilator lint completed with non-blocking filename and unused-`p22` warnings.
- Yosys produced a mapped SKY130 netlist and area statistics.
- Floorplanning and detailed placement completed in the supplied workspace.
- The archived timing summary reports post-placement STA with a 27 ns clock target (about 37 MHz), placement-estimated parasitics, and WNS/TNS of 0 ns at TT and SS. These values **are not post-route timing signoff**.
- Routing attempts in the supplied session stopped at TritonRoute error `DRT-0305` on constant nets (`one_` / `u_scharr/zero_`). Do not claim routed DRC/LVS signoff unless the route is regenerated and DRC/LVS are independently reviewed.

Generated OpenROAD databases, netlists, and final GDS files are intentionally not treated as validated release outputs in this source repository. Generate them using the flow above and review their logs before publishing them as signoff artifacts.

## Repository layout

```text
01_rtl/                  Bone-detection RTL
04_synthesis/             Yosys synthesis and SDC generation
06_floorplanning/         OpenROAD floorplan / tapcells / PDN
07_placement/              Global and detailed placement
08_sta/                    OpenSTA scripts and archived timing snapshots
09_place_and_route/        CTS and routing scripts
10_gds/                    GDS streamout script and layer map
11_physical_verification/ Physical-verification scripts and status
docs/                      Igny setup guide and flow notes
```

## Licensing

No project license was supplied. Until the authors choose one, all rights remain with the applicable copyright holders. Check third-party and PDK terms before redistribution.
