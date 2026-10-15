# SKY130 chip I/O global-route preview

This stage integrates the routed SPI core netlist with a six-pad `chip_io_wrapper` and runs the design through global routing. It is **not** a completed detailed-route or tapeout flow.

## Run from the repository root

Requires Linux/WSL, the SKY130A PDK, OpenROAD, and Python KLayout. The validated alternate tool setup used a LibreLane devshell; this package can also use a compatible OpenROAD on `PATH`.

```bash
export LIBRELANE_DEVSHELL=/path/to/librelane-devshell-x86_64.AppImage
export PDK_ROOT="$HOME/.ciel/ciel/sky130/versions/<revision>/sky130A"
make -f Makefile.chip-io global-route
make -f Makefile.chip-io gds-preview
```

The environment checker verifies the PDK LEFs, Liberty files, source GDS files, wrapper/netlist inputs, and layer map. `PDK_ROOT` must point to the full `sky130A` directory. See the toolchain setup notes in [`docs/IGNY_SETUP.md`](../docs/IGNY_SETUP.md) only if using the existing Igny environment.

Main stages:

1. Floorplan the 1500 × 1500 µm die with a 1000 × 1000 µm nominal core and SRAM macro.
2. Place six GPIO signal pads and assign pad locations.
3. Place/legalize core cells and top-level supply pins.
4. Generate the core PDN.
5. Build the clock tree.
6. Perform pre-route timing/placement repair.
7. Run global routing and write a route guide.
8. Optionally try detailed routing with `make -f Makefile.chip-io detailed-route`.

The included `12_chip_physical/results/chip_global_route_preview.gds.gz` is generated from the global-route DEF. Global routing creates guides; this stream does **not** contain completed detailed signal wires. It is useful for viewing placement, macro/pad geometry, and the power grid only. Decompress it before opening in KLayout:

```bash
gzip -dk 12_chip_physical/results/chip_global_route_preview.gds.gz
klayout 12_chip_physical/results/chip_global_route_preview.gds
```

## Latest saved run status

The direct OpenROAD run completed global routing for 3015 nets with 184,740 µm estimated wirelength, 47,399 estimated vias, and zero global-route overflow. It did not complete detailed routing: the run timed out after 110 seconds at 40%, with 5,330 intermediate violations. The `vccd` power-connectivity check failed, and eight I/O rails have no physical special wires. No post-route STA, power estimate, full-layout DRC, or LVS result is supplied. See [`STATUS.md`](STATUS.md) and [`../crucible-results/QOR_CHIP_IO.md`](../crucible-results/QOR_CHIP_IO.md).

## Sources and generated outputs

- Inputs: [`02_chip_io/chip_io_wrapper.v`](../02_chip_io/chip_io_wrapper.v), [`09_place_and_route/route_output.v`](../09_place_and_route/route_output.v), and an installed SKY130A PDK.
- Scripts: [`scripts/`](scripts/) and [`../scripts/`](../scripts/) (runner/stream-out helpers).
- Execution logs and preview geometry checks: [`audit/`](audit/) and [`reports/`](reports/).
- Generated ODB, DEF, route guides, detailed-route reports, and temporary GDS outputs go under `results/` and `reports/` and are ignored by Git, except the explicitly archived compressed preview GDS and audit artifacts.

The preview bounding box slightly exceeds the nominal die because of source-cell geometry. One empty example cell from the source PDK is retained. Neither observation is a signoff check. Review third-party PDK licenses before redistributing generated layout.

