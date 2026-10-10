# Igny / Crucible installation and setup

These instructions are for the Ignytion **Crucible Core** `igny` CLI used by this project. Crucible is a beta toolchain; verify commands available in your installed release with `igny --help` and the official [CLI guide](https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/).

## 1. Windows: install WSL2 with Ubuntu

Open PowerShell as Administrator and run:

```powershell
wsl --install -d Ubuntu
```

Restart if requested, launch Ubuntu, and use your normal Linux user. Native Linux users can skip this section.

## 2. Install host prerequisites

In Ubuntu/Linux:

```bash
sudo apt update
sudo apt install -y curl git g++ python3
```

`g++` is needed by Verilator's generated C++ build. It is a host dependency, not an Igny-managed EDA tool.

## 3. Install Ignytion Crucible Core

Run the official beta installer as your normal Linux user:

```bash
curl -fsSL https://get-beta.ignytion.io/v2/install.sh | bash
```

Then check the CLI and installed subcommands:

```bash
igny --help
igny env --help
igny tool --help
```

Official docs: https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/

## 4. Enter and select the project environment

From the repository directory:

```bash
igny init
```

If the CLI complains that environment `base` does not exist because `CRUCIBLE_ENV=base` is set, run:

```bash
unset CRUCIBLE_ENV
igny env use bone --workspace
```

Exact commands vary by beta CLI version; check `igny env --help` if a command is not recognized. The workspace path and banner's environment label are separate concepts.

## 5. Sync and install required tools

```bash
igny workspace sync
igny tool install make
igny tool install yosys
igny tool list
```

The archived tool list did not include `make` and `yosys`, even though the flow invokes them. Install them after syncing. Do not assume an environment-lock subcommand exists in every beta release.

The expected EDA tools include Verilator, OpenROAD, Magic, Netgen, `klayout-stream`, Ciel, and Yosys. Availability depends on the registry/platform.

## 6. SKY130A PDK

The flow expects `$PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/`. The scripts try to discover the PDK under `~/.ciel`. If necessary, set the parent directory containing `sky130A/`:

```bash
export PDK_ROOT="$HOME/.ciel/ciel/sky130/versions/<installed-version>"
```

Replace the placeholder with the actual installed version directory. Do not copy PDK libraries into this repository.

## 7. Quick check

```bash
pwd
igny tool list
igny run make lint
```

Stop on the first failed stage; later-stage databases may otherwise be stale.
