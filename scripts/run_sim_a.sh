#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.."
    pwd
)"

SEED_VALUE="${SEED:-20260924}"
RANDOM_CYCLE_COUNT="${RANDOM_CYCLES:-10000}"

mkdir -p "$PROJECT_ROOT/build/sim"
mkdir -p "$PROJECT_ROOT/sim/logs"
mkdir -p "$PROJECT_ROOT/sim/waveforms"

echo "Compiling Architecture A..."

iverilog -g2012 \
    -s tb_sync_fifo_count \
    -Ptb_sync_fifo_count.RANDOM_CYCLES="$RANDOM_CYCLE_COUNT" \
    -o "$PROJECT_ROOT/build/sim/tb_sync_fifo_count" \
    "$PROJECT_ROOT/rtl/sync_fifo_count.v" \
    "$PROJECT_ROOT/tb/tb_sync_fifo_count.sv"

echo "Running Architecture A verification..."

cd "$PROJECT_ROOT"

vvp build/sim/tb_sync_fifo_count \
    +SEED="$SEED_VALUE" \
    2>&1 | tee \
    "sim/logs/sync_fifo_count_seed_${SEED_VALUE}.log"

grep -q "Errors                 : 0" \
    "sim/logs/sync_fifo_count_seed_${SEED_VALUE}.log"

grep -q "ALL TESTS PASSED" \
    "sim/logs/sync_fifo_count_seed_${SEED_VALUE}.log"

echo "ARCHITECTURE A REGRESSION PASSED"
