#!/bin/bash

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

start_cluster "${1:-eventual}" "${2:-0}"
