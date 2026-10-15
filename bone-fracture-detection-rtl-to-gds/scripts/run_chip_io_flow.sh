#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source scripts/env.sh

run_stage() {
  echo
  echo "============================================================"
  echo "Running: $1"
  echo "============================================================"
  unset CRUCIBLE_ENV || true
  ./scripts/tool.sh openroad -exit "$1"
}

run_stage 12_chip_physical/scripts/floorplan_chip.tcl
run_stage 12_chip_physical/scripts/place_gpio_pads.tcl
run_stage 12_chip_physical/scripts/place_core_cells.tcl
run_stage 12_chip_physical/scripts/create_pdn.tcl
run_stage 12_chip_physical/scripts/run_cts.tcl
run_stage 12_chip_physical/scripts/prepare_for_global_route.tcl
run_stage 12_chip_physical/scripts/global_route.tcl

echo
echo "GLOBAL-ROUTE FLOW COMPLETED."
echo "Global-route DB : 12_chip_physical/results/chip_global_route.odb"
echo "Global-route DEF: 12_chip_physical/results/chip_global_route.def"
echo "Route guide     : 12_chip_physical/results/chip_route.guide"
echo "Use 'make gds-preview' for a preview GDS, or 'make detailed-route' then 'make gds' for detailed-route GDS."

