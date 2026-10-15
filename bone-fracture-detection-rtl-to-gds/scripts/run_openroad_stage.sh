#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source scripts/env.sh
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 path/to/openroad_stage.tcl" >&2
  exit 2
fi
unset CRUCIBLE_ENV || true
./scripts/tool.sh openroad -exit "$1"

