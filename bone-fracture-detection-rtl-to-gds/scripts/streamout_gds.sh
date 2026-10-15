#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source scripts/env.sh
exec ./scripts/tool.sh python3 scripts/streamout.py "${1:-}"

