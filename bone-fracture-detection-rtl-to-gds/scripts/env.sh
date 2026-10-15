#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

if [[ -z "${PDK_ROOT:-}" ]]; then
  PDK_ROOT="$(find "$HOME/.ciel/ciel/sky130/versions" -type d -name sky130A -print -quit 2>/dev/null || true)"
fi
# Also accept the parent versions directory used by some local scripts.
if [[ -n "${PDK_ROOT:-}" && -d "$PDK_ROOT/sky130A/libs.ref" ]]; then
  PDK_ROOT="$PDK_ROOT/sky130A"
fi
if [[ -z "${PDK_ROOT:-}" || ! -d "$PDK_ROOT/libs.ref" ]]; then
  echo "ERROR: SKY130 PDK not found. Set PDK_ROOT to the full sky130A directory." >&2
  echo 'Example: export PDK_ROOT="$HOME/.ciel/ciel/sky130/versions/<version>/sky130A"' >&2
  exit 1
fi
export PDK_ROOT

required_files=(
  "09_place_and_route/route_output.v"
  "02_chip_io/chip_io_wrapper.v"
  "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
  "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
  "$PDK_ROOT/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef"
  "$PDK_ROOT/libs.ref/sky130_sram_macros/lef/sky130_sram_1kbyte_1rw1r_8x1024_8.lef"
  "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
  "$PDK_ROOT/libs.ref/sky130_fd_io/lib/sky130_ef_io__gpiov2_pad_wrapped_tt_tt_025C_1v80_3v30.lib"
  "$PDK_ROOT/libs.ref/sky130_sram_macros/lib/sky130_sram_1kbyte_1rw1r_8x1024_8_TT_1p8V_25C.lib"
  "$PDK_ROOT/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"
  "$PDK_ROOT/libs.ref/sky130_fd_io/gds/sky130_fd_io.gds"
  "$PDK_ROOT/libs.ref/sky130_fd_io/gds/sky130_ef_io.gds"
  "$PDK_ROOT/libs.ref/sky130_fd_io/gds/sky130_ef_io__gpiov2_pad_wrapped.gds"
  "$PDK_ROOT/libs.ref/sky130_sram_macros/gds/sky130_sram_1kbyte_1rw1r_8x1024_8.gds"
  "12_chip_physical/config/sky130_layermap.txt"
)
for f in "${required_files[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "ERROR: Missing required file: $f" >&2
    exit 1
  fi
done

mkdir -p 12_chip_physical/results 12_chip_physical/reports

