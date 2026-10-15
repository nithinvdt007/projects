#!/usr/bin/env bash
set -euo pipefail
if [[ -n "${LIBRELANE_DEVSHELL:-}" ]]; then
 exec "$LIBRELANE_DEVSHELL" "$@"
elif command -v "${1:-}" >/dev/null 2>&1; then
 exec "$@"
elif command -v igny >/dev/null 2>&1; then
 exec igny run "$@"
else
 echo "Required tool $1 is unavailable. Set LIBRELANE_DEVSHELL or add compatible tools to PATH." >&2;exit 127
fi

