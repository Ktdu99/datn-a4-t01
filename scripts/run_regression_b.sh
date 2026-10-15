#!/usr/bin/env bash

set -euo pipefail

repo_root="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.."
    pwd
)"

random_cycles="${RANDOM_CYCLES:-10000}"

result_dir="$repo_root/results/verification_b"
summary_file="$result_dir/regression_summary.txt"
diff_file="$result_dir/testbench_diff.txt"
baseline_file="$result_dir/seed_20260924.txt"

tb_a="$repo_root/tb/tb_sync_fifo_count.sv"
tb_b="$repo_root/tb/tb_sync_fifo_pointer.sv"

seeds=(
    1
    2
    3
    4
    5
    20260924
)

mkdir -p "$result_dir"

normalized_tb="$(mktemp)"

cleanup() {
    rm -f "$normalized_tb"
}

trap cleanup EXIT

sed \
    -e 's/tb_sync_fifo_pointer/tb_sync_fifo_count/g' \
    -e 's/sync_fifo_pointer/sync_fifo_count/g' \
    -e 's/ARCHITECTURE B/ARCHITECTURE A/g' \
    -e 's/phương án B/phương án A/g' \
    "$tb_b" >"$normalized_tb"

if cmp -s "$tb_a" "$normalized_tb"; then
    testbench_reuse="PASS"
else
    echo "[FAIL] Testbench B khác A ngoài nhận dạng DUT."
    diff -u "$tb_a" "$normalized_tb" || true
    exit 1
fi

diff -u \
    --label "Architecture_A_testbench" \
    --label "Architecture_B_testbench" \
    "$tb_a" \
    "$tb_b" \
    >"$diff_file" || true

rtl_sha256="$(
    sha256sum "$repo_root/rtl/sync_fifo_pointer.v" |
    awk '{print $1}'
)"

{
    printf 'FIFO Architecture B Regression\n'
    printf '====================================\n'
    printf 'architecture=B_extended_pointer\n'
    printf 'top_module=sync_fifo_pointer\n'
    printf 'data_width=8\n'
    printf 'depth=16\n'
    printf 'random_cycles_per_seed=%s\n' \
        "$random_cycles"
    printf 'golden_model=reference_memory_scoreboard\n'
    printf 'testbench_reuse_check=%s\n' \
        "$testbench_reuse"
    printf 'rtl_sha256=%s\n' \
        "$rtl_sha256"
    printf '\n'
    printf '%-12s %-12s %-12s %-10s %-8s\n' \
        'seed' 'cycles' 'checks' 'errors' 'result'
} >"$summary_file"

for seed_value in "${seeds[@]}"; do
    echo
    echo "===== RUN SEED $seed_value ====="

    SEED="$seed_value" \
    RANDOM_CYCLES="$random_cycles" \
        "$repo_root/scripts/run_sim_b.sh"

    log_file="$repo_root/sim/logs/sync_fifo_pointer_seed_${seed_value}.log"

    if ! grep -q "ALL TESTS PASSED" "$log_file"; then
        echo "[FAIL] Seed $seed_value không PASS."
        exit 1
    fi

    cycles="$(
        sed -n \
            's/^Cycles[[:space:]]*:[[:space:]]*//p' \
            "$log_file" |
        tail -1
    )"

    checks="$(
        sed -n \
            's/^Checks[[:space:]]*:[[:space:]]*//p' \
            "$log_file" |
        tail -1
    )"

    errors="$(
        sed -n \
            's/^Errors[[:space:]]*:[[:space:]]*//p' \
            "$log_file" |
        tail -1
    )"

    if [[ "$errors" != "0" ]]; then
        echo "[FAIL] Seed $seed_value có $errors lỗi."
        exit 1
    fi

    printf '%-12s %-12s %-12s %-10s %-8s\n' \
        "$seed_value" \
        "$cycles" \
        "$checks" \
        "$errors" \
        "PASS" \
        >>"$summary_file"
done

cp \
    "$repo_root/sim/logs/sync_fifo_pointer_seed_20260924.log" \
    "$baseline_file"

{
    printf '\noverall_result=PASS\n'
    printf 'seed_count=%s\n' "${#seeds[@]}"
} >>"$summary_file"

echo
cat "$summary_file"

echo
echo "[PASS] ARCHITECTURE B MULTI-SEED REGRESSION"
