# Getting the toolchain ready

The project flow uses the Ignytion Crucible Core `igny` CLI. These notes
reflect the beta toolchain used when the project was prepared; CLI commands
and available tools may change between releases. When a command differs,
check `igny --help` and the [official Crucible CLI guide](https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/).

## 1. Use Ubuntu or WSL2

The flow was developed in Ubuntu under WSL2. On Windows, open PowerShell as
Administrator and install Ubuntu if you do not already have it:

```powershell
wsl --install -d Ubuntu
```

Restart if Windows asks you to, then open Ubuntu and use your regular Linux
account. Native Linux users can skip this step.

## 2. Install host prerequisites

In Ubuntu, install the basic host packages:

```bash
sudo apt update
sudo apt install -y curl git g++ python3
```

`g++` is needed for Verilator's generated C++ build. It is a host dependency,
not an Igny-managed EDA tool.

## 3. Install Ignytion Crucible Core

Run the official beta installer as your normal Linux user:

```bash
curl -fsSL https://get-beta.ignytion.io/v2/install.sh | bash
```

Then confirm the CLI is available and check the commands supported by your
installed version:

```bash
igny --help
igny env --help
igny tool --help
```

See the [official CLI guide](https://docs.ignytion.io/crucible-cli/latest/CRUCIBLE_CLI_USER_GUIDE/)
for current installation and usage information.

## 4. Initialize the project workspace

From this project directory in Ubuntu / WSL2:

```bash
igny init
```

If the CLI complains that the `base` environment is missing and you have
`CRUCIBLE_ENV=base` set, unset it and select the project's `bone` environment:

```bash
unset CRUCIBLE_ENV
igny env use bone --workspace
```

The exact environment commands can vary by beta release. If a command is not
recognized, check `igny env --help`.

## 5. Sync and check the tools

```bash
igny workspace sync
igny tool install make
igny tool install yosys
igny tool list
```

The archived tool list did not include `make` and `yosys`, even though the
flow invokes them, so they may need to be installed after syncing. The other
expected tools include Verilator, OpenROAD, OpenSTA, Magic, Netgen,
`klayout-stream`, and Ciel; availability depends on the registry and platform.

## 6. Make SKY130A available

The flow expects the PDK to contain
`sky130A/libs.ref/sky130_fd_sc_hd/`. Its scripts try to find SKY130A under
`~/.ciel`. If the automatic lookup does not work, point `PDK_ROOT` to the
parent directory that contains `sky130A`:

```bash
export PDK_ROOT="$HOME/.ciel/ciel/sky130/versions/<installed-version>"
```

Replace `<installed-version>` with the directory on your system. Do not copy
PDK libraries into this repository.

## 7. Run a quick check

From the project root:

```bash
pwd
igny tool list
igny run make lint
```

If lint fails, resolve that before moving on. Later physical-design stages
depend on earlier outputs, which may otherwise be missing or stale. See the
[flow guide](RTL_TO_GDSII_FLOW.md) for the stage commands and
[current flow status](FLOW_STATUS.md) for known limitations.
