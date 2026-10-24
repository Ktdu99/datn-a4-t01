#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

SEED_VALUE="${SEED:-1}"
CYCLES="${RANDOM_CYCLES:-300}"

if ! [[ "$SEED_VALUE" =~ ^[0-9]+$ &&
        "$CYCLES" =~ ^[0-9]+$ ]]; then
    echo "ERROR: SEED and RANDOM_CYCLES must be integers"
    exit 1
fi

if (( CYCLES < 1 )); then
    echo "ERROR: RANDOM_CYCLES must be positive"
    exit 1
fi

for tool in iverilog vvp; do
    command -v "$tool" >/dev/null
done

echo "========================================"
echo " FIFO A/B - FUNCTIONAL VERIFICATION DEMO"
echo "========================================"
echo "SEED=$SEED_VALUE"
echo "RANDOM_CYCLES=$CYCLES"

# Isolated workspace: do not overwrite project evidence.
RUN_DIR="$(mktemp -d "${TMPDIR:-/tmp}/fifo-demo-XXXXXXXX")"

mkdir -p \
    "$RUN_DIR/scripts" \
    "$RUN_DIR/rtl" \
    "$RUN_DIR/tb" \
    "$RUN_DIR/sim/logs" \
    "$RUN_DIR/sim/waveforms" \
    "$RUN_DIR/build/sim"

cp "$ROOT/scripts/run_sim_a.sh" "$RUN_DIR/scripts/"
cp "$ROOT/scripts/run_sim_b.sh" "$RUN_DIR/scripts/"

cp "$ROOT/rtl/sync_fifo_count.v" "$RUN_DIR/rtl/"
cp "$ROOT/rtl/sync_fifo_pointer.v" "$RUN_DIR/rtl/"

cp "$ROOT/tb/tb_sync_fifo_count.sv" "$RUN_DIR/tb/"
cp "$ROOT/tb/tb_sync_fifo_pointer.sv" "$RUN_DIR/tb/"

echo
echo "OUTPUT_DIR=$RUN_DIR"

echo
echo "===== DEMO A: COUNT-BASED FIFO ====="

if SEED="$SEED_VALUE" RANDOM_CYCLES="$CYCLES" \
    bash "$RUN_DIR/scripts/run_sim_a.sh"; then
    echo "DEMO_A_PASS"
else
    echo "DEMO_A_FAIL"
    echo "OUTPUT_DIR=$RUN_DIR"
    exit 1
fi

echo
echo "===== DEMO B: EXTENDED-POINTER FIFO ====="

if SEED="$SEED_VALUE" RANDOM_CYCLES="$CYCLES" \
    bash "$RUN_DIR/scripts/run_sim_b.sh"; then
    echo "DEMO_B_PASS"
else
    echo "DEMO_B_FAIL"
    echo "OUTPUT_DIR=$RUN_DIR"
    exit 1
fi

echo
echo "===== VERIFY LOG FILES ====="

for name in \
    sync_fifo_count \
    sync_fifo_pointer
do
    LOG="$RUN_DIR/sim/logs/${name}_seed_${SEED_VALUE}.log"

    test -s "$LOG"
    grep -q "ALL TESTS PASSED" "$LOG"
    grep -Eq 'Errors[[:space:]]*:[[:space:]]*0' "$LOG"
done

echo "DEMO_LOG_VALIDATION_PASS"

echo
echo "===== GENERATED WAVEFORMS ====="
find "$RUN_DIR/sim/waveforms" -maxdepth 1 \
    -type f -name '*.vcd' -print

echo
echo "===== SUMMARY ====="
echo "FIFO A : PASS"
echo "FIFO B : PASS"
echo "SEED   : $SEED_VALUE"
echo "CYCLES : $CYCLES"
echo "OUTPUT : $RUN_DIR"
echo "FIFO_AB_DEMO_PASS"
