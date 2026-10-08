








#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
run_tag="${1:-SYNTH_A_50MHZ}"

run_dir="$repo_root/openlane/sync_fifo_count/runs/$run_tag"
out_dir="$repo_root/results/synthesis_a/$run_tag"

netlist="$run_dir/results/synthesis/sync_fifo_count.synthesis.v"
if [[ ! -s "$netlist" ]]; then
    netlist="$run_dir/results/synthesis/sync_fifo_count.v"
fi

sdf_file="$run_dir/results/synthesis/sync_fifo_count.sdf"
synth_log="$run_dir/logs/synthesis/1-synthesis.log"
sta_log="$run_dir/logs/synthesis/2-sta.log"

for required in \
    "$netlist" \
    "$run_dir/config.tcl" \
    "$synth_log" \
    "$sta_log"
do
    if [[ ! -s "$required" ]]; then
        printf '[FAIL] Thiếu file: %s\n' "$required" >&2
        exit 1
    fi
done

mkdir -p "$out_dir/reports"
mkdir -p "$out_dir/logs"

cp "$repo_root/openlane/sync_fifo_count/config.json" \
   "$out_dir/config.json"

cp "$run_dir/config.tcl" \
   "$out_dir/resolved_config.tcl"

cp "$netlist" \
   "$out_dir/sync_fifo_count.synthesis.v"

if [[ -s "$sdf_file" ]]; then
    cp "$sdf_file" \
       "$out_dir/sync_fifo_count.sdf"
fi

find "$run_dir/reports/synthesis" \
    -maxdepth 1 -type f \
    -exec cp -t "$out_dir/reports" {} +

# Đổi đuôi .log thành .txt để Git lưu được log gốc.
cp "$synth_log" \
   "$out_dir/logs/1-synthesis.full.txt"

cp "$sta_log" \
   "$out_dir/logs/2-sta.full.txt"

for stem in 1-synthesis 2-sta; do
    for suffix in errors warnings; do
        source_file="$run_dir/logs/synthesis/$stem.$suffix"

        if [[ -f "$source_file" ]]; then
            cp "$source_file" "$out_dir/logs/"
        fi
    done
done

area_report="$out_dir/reports/1-synthesis.AREA_0.stat.rpt"

if [[ ! -s "$area_report" ]]; then
    echo "[FAIL] Không tìm thấy báo cáo area cuối." >&2
    exit 1
fi

liberty="$(
    sed -n \
        's/^set ::env(LIB_SYNTH) "\(.*\)"$/\1/p' \
        "$run_dir/config.tcl" |
    head -n 1
)"

if [[ -z "$liberty" || ! -s "$liberty" ]]; then
    echo "[FAIL] Không xác định được LIB_SYNTH." >&2
    exit 1
fi

# Kiểm tra lại netlist với đầy đủ thông tin hướng chân Liberty.
if ! yosys \
    -l "$out_dir/reports/netlist_check.txt" \
    -p "
read_liberty -lib -ignore_miss_dir \"$liberty\"
read_verilog \"$out_dir/sync_fifo_count.synthesis.v\"
hierarchy -check -top sync_fifo_count
check -assert
stat
" >/dev/null
then
    echo "[FAIL] Netlist hậu tổng hợp không đạt kiểm tra Yosys." >&2
    exit 1
fi

if ! grep -q 'sky130_fd_sc_hd__' \
    "$out_dir/sync_fifo_count.synthesis.v"
then
    echo "[FAIL] Netlist chưa map sang SKY130 standard cells." >&2
    exit 1
fi

# Phân loại lỗi thực và thông báo ABC không gây dừng flow.
known_abc_message='ABC: Error: The network is combinational.'
unexpected_file="$out_dir/logs/unexpected_errors.txt"

: > "$unexpected_file"

for error_file in "$out_dir"/logs/*.errors; do
    [[ -e "$error_file" ]] || continue

    awk -v known="$known_abc_message" '
        NF && $0 != known {
            print FILENAME ":" $0
        }
    ' "$error_file" >> "$unexpected_file"
done

grep -HEin '\[(ERROR|FATAL)\]' \
    "$out_dir/logs/1-synthesis.full.txt" \
    "$out_dir/logs/2-sta.full.txt" \
    >> "$unexpected_file" || true

if [[ -s "$unexpected_file" ]]; then
    echo "[FAIL] Phát hiện lỗi chưa được phân loại:" >&2
    cat "$unexpected_file" >&2
    exit 1
fi

printf 'none\n' > "$unexpected_file"

cells_line="$(
    grep -E '^[[:space:]]*Number of cells:' \
        "$area_report" |
    tail -n 1 || true
)"

area_line="$(
    grep -E '^[[:space:]]*Chip area for module' \
        "$area_report" |
    tail -n 1 || true
)"

timing_lines="$(
    grep -E \
        '^[[:space:]]*(wns|tns)[[:space:]]|report_worst_slack|^[[:space:]]*worst slack' \
        "$out_dir/logs/2-sta.full.txt" || true
)"

if [[ -z "$cells_line" || -z "$area_line" ]]; then
    echo "[FAIL] Không trích xuất được cell count hoặc area." >&2
    exit 1
fi

if [[ -z "$timing_lines" ]]; then
    echo "[FAIL] Không trích xuất được kết quả timing." >&2
    exit 1
fi

{
    printf 'run_tag=%s\n' "$run_tag"
    printf 'rtl_commit=%s\n' \
        "$(git -C "$repo_root" rev-parse HEAD)"
    printf 'architecture=A_count_based\n'
    printf 'data_width=8\n'
    printf 'depth=16\n'
    printf 'clock_period_ns=20.0\n'
    printf 'target_frequency_mhz=50.0\n'
    printf 'pdk=sky130A\n'
    printf 'std_cell_library=sky130_fd_sc_hd\n'
    printf 'synth_strategy=AREA_0\n'
    printf 'postmap_netlist_check=PASS\n'
    printf 'unexpected_errors=0\n'

    printf '\n=== FINAL AREA AND CELL COUNT ===\n'
    printf '%s\n' "$cells_line"
    printf '%s\n' "$area_line"

    printf '\n=== TIMING ===\n'
    printf '%s\n' "$timing_lines"
} | tee "$out_dir/key_metrics.txt"

{
    printf 'OpenLane synthesis warning assessment\n'
    printf '=====================================\n'
    printf 'undriven_output_warning=FALSE_POSITIVE\n'
    printf 'postmap_full_liberty_check=PASS\n'
    printf 'postmap_yosys_problems=0\n'
    printf 'abc_combinational_retime_message=KNOWN_NON_FATAL\n'
    printf 'sta_database_not_saved=EXPECTED_FOR_SYNTHESIS_ONLY_RUN\n'
    printf 'reference_issue=https://github.com/The-OpenROAD-Project/OpenLane/issues/2098\n'
    printf 'reference_fix=https://github.com/The-OpenROAD-Project/OpenLane/pull/2099\n'
} > "$out_dir/warning_assessment.txt"

echo
echo "[PASS] Đã thu thập và kiểm tra bằng chứng Chặng 5:"
echo "$out_dir"
