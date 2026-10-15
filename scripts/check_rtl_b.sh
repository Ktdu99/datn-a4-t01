#!/usr/bin/env bash

set -euo pipefail

repo_root="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.."
    pwd
)"

rtl_file="$repo_root/rtl/sync_fifo_pointer.v"
build_dir="$repo_root/build/rtl_b"
result_dir="$repo_root/results/rtl_b"

iverilog_report="$result_dir/iverilog_check.txt"
yosys_report="$result_dir/yosys_check.txt"
summary_file="$result_dir/check_summary.txt"

mkdir -p "$build_dir"
mkdir -p "$result_dir"

for tool in iverilog yosys sha256sum; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[FAIL] Không tìm thấy công cụ: $tool"
        exit 1
    fi
done

if [[ ! -s "$rtl_file" ]]; then
    echo "[FAIL] Không tìm thấy RTL: $rtl_file"
    exit 1
fi

echo "[INFO] Kiểm tra biên dịch RTL B..."

if iverilog \
    -g2012 \
    -Wall \
    -s sync_fifo_pointer \
    -o "$build_dir/sync_fifo_pointer.out" \
    "$rtl_file" \
    >"$iverilog_report" 2>&1
then
    iverilog_status="PASS"
else
    cat "$iverilog_report"
    echo "[FAIL] Icarus Verilog không biên dịch được RTL B."
    exit 1
fi

echo "[INFO] Kiểm tra cấu trúc bằng Yosys..."

yosys \
    -l "$yosys_report" \
    -p "
        read_verilog -sv $rtl_file
        hierarchy -check -top sync_fifo_pointer
        proc
        memory
        opt
        check
        stat
    "

if grep -q \
    "Found and reported 0 problems" \
    "$yosys_report"
then
    yosys_status="PASS"
else
    echo "[FAIL] Yosys chưa xác nhận 0 problems."
    exit 1
fi

rtl_sha256="$(
    sha256sum "$rtl_file" |
    awk '{print $1}'
)"

{
    printf 'architecture=B_extended_pointer\n'
    printf 'top_module=sync_fifo_pointer\n'
    printf 'data_width=8\n'
    printf 'depth=16\n'
    printf 'address_pointer_width=4\n'
    printf 'extended_pointer_width=5\n'
    printf 'occupancy_counter=NOT_USED\n'
    printf 'iverilog_elaboration=%s\n' \
        "$iverilog_status"
    printf 'yosys_structural_check=%s\n' \
        "$yosys_status"
    printf 'rtl_sha256=%s\n' \
        "$rtl_sha256"
} >"$summary_file"

echo
cat "$summary_file"

echo
echo "[PASS] CHẶNG 7 RTL B STRUCTURAL CHECK"
