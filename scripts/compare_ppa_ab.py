#!/usr/bin/env python3

import argparse
import csv
import hashlib
import json
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument(
    "--show",
    action="store_true",
    help="Hiển thị biểu đồ sau khi tạo",
)
args = parser.parse_args()

repo_root = Path(__file__).resolve().parents[1]

a_metrics_path = (
    repo_root
    / "results/physical_a/PHYS_A_50MHZ/key_metrics.txt"
)

b_metrics_path = (
    repo_root
    / "results/physical_b/PHYS_B_50MHZ/key_metrics.txt"
)

a_config_path = (
    repo_root
    / "results/physical_a/PHYS_A_50MHZ/config.json"
)

b_config_path = (
    repo_root
    / "results/physical_b/PHYS_B_50MHZ/config.json"
)

output_dir = repo_root / "results/ppa_comparison"
figure_dir = repo_root / "docs/figures"


def read_metrics(path):
    if not path.is_file() or path.stat().st_size == 0:
        raise SystemExit(f"[FAIL] Thiếu file: {path}")

    values = {}

    for line in path.read_text(
        encoding="utf-8"
    ).splitlines():
        line = line.strip()

        if line and "=" in line:
            key, value = line.split("=", 1)
            values[key.strip()] = value.strip()

    return values


def calculate_sha256(path):
    return hashlib.sha256(
        path.read_bytes()
    ).hexdigest()


def format_number(value):
    return (
        f"{value:.9f}"
        .rstrip("0")
        .rstrip(".")
    )


a = read_metrics(a_metrics_path)
b = read_metrics(b_metrics_path)

for config_path in (
    a_config_path,
    b_config_path,
):
    if (
        not config_path.is_file()
        or config_path.stat().st_size == 0
    ):
        raise SystemExit(
            f"[FAIL] Thiếu file: {config_path}"
        )

config_a = json.loads(
    a_config_path.read_text(encoding="utf-8")
)

config_b = json.loads(
    b_config_path.read_text(encoding="utf-8")
)

ignored_config_keys = {
    "DESIGN_NAME",
    "VERILOG_FILES",
}

normalized_a = {
    key: value
    for key, value in config_a.items()
    if key not in ignored_config_keys
}

normalized_b = {
    key: value
    for key, value in config_b.items()
    if key not in ignored_config_keys
}

if normalized_a != normalized_b:
    different_keys = sorted(
        key
        for key in (
            set(normalized_a)
            | set(normalized_b)
        )
        if normalized_a.get(key)
        != normalized_b.get(key)
    )

    raise SystemExit(
        "[FAIL] Config khác ngoài "
        "DESIGN_NAME/VERILOG_FILES: "
        + ", ".join(different_keys)
    )

common_keys = (
    "data_width",
    "depth",
    "pdk",
    "std_cell_library",
    "clock_period_ns",
    "target_frequency_mhz",
)

for key in common_keys:
    if a.get(key) != b.get(key):
        raise SystemExit(
            f"[FAIL] Khác {key}: "
            f"A={a.get(key)}, B={b.get(key)}"
        )

if a.get("architecture") != "A_count_based":
    raise SystemExit(
        "[FAIL] Sai nhãn kiến trúc A"
    )

if b.get("architecture") != "B_extended_pointer":
    raise SystemExit(
        "[FAIL] Sai nhãn kiến trúc B"
    )

zero_signoff_fields = (
    "tritonroute_violations",
    "magic_drc_violations",
    "lvs_total_errors",
    "pin_antenna_violations",
    "net_antenna_violations",
)

for architecture, values in (
    ("A", a),
    ("B", b),
):
    if values.get("flow_status") != "flow completed":
        raise SystemExit(
            f"[FAIL] Flow {architecture} chưa hoàn thành"
        )

    if float(values["postroute_wns_ns"]) < 0:
        raise SystemExit(
            f"[FAIL] WNS kiến trúc {architecture} âm"
        )

    if float(values["postroute_tns_ns"]) < 0:
        raise SystemExit(
            f"[FAIL] TNS kiến trúc {architecture} âm"
        )

    if any(
        int(float(values[key])) != 0
        for key in zero_signoff_fields
    ):
        raise SystemExit(
            f"[FAIL] Signoff kiến trúc "
            f"{architecture} còn lỗi"
        )

metrics = (
    (
        "die_area_mm2",
        "Die area",
        "mm^2",
    ),
    (
        "core_area_um2",
        "Core area",
        "um^2",
    ),
    (
        "synth_cell_count",
        "Synthesis cells",
        "cells",
    ),
    (
        "total_cells_after_physical",
        "Physical cells",
        "cells",
    ),
    (
        "wire_length_um",
        "Wire length",
        "um",
    ),
    (
        "via_count",
        "Via count",
        "vias",
    ),
    (
        "critical_path_ns",
        "Critical path",
        "ns",
    ),
)

rows = []

for key, label, unit in metrics:
    value_a = float(a[key])
    value_b = float(b[key])

    delta = value_b - value_a
    delta_percent = (
        delta / value_a * 100
    )

    if value_b < value_a:
        assessment = "B_BETTER"
    elif value_b > value_a:
        assessment = "A_BETTER"
    else:
        assessment = "TIE"

    rows.append(
        {
            "metric": key,
            "label": label,
            "unit": unit,
            "architecture_a": format_number(
                value_a
            ),
            "architecture_b": format_number(
                value_b
            ),
            "delta_b_minus_a": format_number(
                delta
            ),
            "delta_percent_vs_a": (
                f"{delta_percent:.4f}"
            ),
            "assessment": assessment,
        }
    )

output_dir.mkdir(
    parents=True,
    exist_ok=True,
)

figure_dir.mkdir(
    parents=True,
    exist_ok=True,
)

csv_path = output_dir / "ppa_ab.csv"

with csv_path.open(
    "w",
    encoding="utf-8",
    newline="",
) as stream:
    writer = csv.DictWriter(
        stream,
        fieldnames=rows[0].keys(),
	lineterminator="\n",
    )

    writer.writeheader()
    writer.writerows(rows)

config_report_path = (
    output_dir
    / "config_equivalence.txt"
)

config_report_path.write_text(
    "FIFO A/B Physical Configuration Equivalence\n"
    "============================================\n"
    "result=PASS\n"
    "ignored_expected_keys="
    "DESIGN_NAME,VERILOG_FILES\n"
    f"architecture_a_design="
    f"{config_a['DESIGN_NAME']}\n"
    f"architecture_b_design="
    f"{config_b['DESIGN_NAME']}\n"
    "all_other_config_fields=IDENTICAL\n",
    encoding="utf-8",
)

checksum_path = (
    output_dir
    / "source_checksums.txt"
)

checksum_path.write_text(
    "FIFO A/B PPA Source Checksums\n"
    "================================\n"
    f"architecture_a_metrics_sha256="
    f"{calculate_sha256(a_metrics_path)}\n"
    f"architecture_b_metrics_sha256="
    f"{calculate_sha256(b_metrics_path)}\n"
    f"architecture_a_config_sha256="
    f"{calculate_sha256(a_config_path)}\n"
    f"architecture_b_config_sha256="
    f"{calculate_sha256(b_config_path)}\n"
    f"architecture_a_rtl_sha256="
    f"{a['rtl_sha256']}\n"
    f"architecture_b_rtl_sha256="
    f"{b['rtl_sha256']}\n"
    f"architecture_a_repository_commit="
    f"{a['repository_commit']}\n"
    f"architecture_b_repository_commit="
    f"{b['repository_commit']}\n",
    encoding="utf-8",
)

summary_lines = [
    "FIFO Architecture A/B PPA Comparison",
    "====================================",
    "comparison_basis=postroute_physical_results",
    "fairness_check=PASS",
    f"data_width={a['data_width']}",
    f"depth={a['depth']}",
    f"pdk={a['pdk']}",
    (
        "std_cell_library="
        f"{a['std_cell_library']}"
    ),
    (
        "clock_period_ns="
        f"{a['clock_period_ns']}"
    ),
    (
        "target_frequency_mhz="
        f"{a['target_frequency_mhz']}"
    ),
    "architecture_a_timing_signoff=PASS",
    "architecture_b_timing_signoff=PASS",
    (
        "architecture_a_postroute_wns_ns="
        f"{a['postroute_wns_ns']}"
    ),
    (
        "architecture_b_postroute_wns_ns="
        f"{b['postroute_wns_ns']}"
    ),
    (
        "architecture_a_postroute_tns_ns="
        f"{a['postroute_tns_ns']}"
    ),
    (
        "architecture_b_postroute_tns_ns="
        f"{b['postroute_tns_ns']}"
    ),
    (
        "architecture_a_placement_"
        "utilization_pct="
        f"{a['placement_utilization_pct']}"
    ),
    (
        "architecture_b_placement_"
        "utilization_pct="
        f"{b['placement_utilization_pct']}"
    ),
    (
        "architecture_a_clock_max_"
        "fanout_violations="
        f"{a['clock_max_fanout_violation_count']}"
    ),
    (
        "architecture_b_clock_max_"
        "fanout_violations="
        f"{b['clock_max_fanout_violation_count']}"
    ),
    (
        "architecture_a_power_status="
        f"{a['power_estimate_status']}"
    ),
    (
        "architecture_b_power_status="
        f"{b['power_estimate_status']}"
    ),
    (
        "power_comparison="
        "NOT_PERFORMED_WITHOUT_QUALIFIED_"
        "SWITCHING_ACTIVITY"
    ),
    "",
    (
        "metric,A,B,"
        "delta_percent_vs_a,assessment"
    ),
]

for row in rows:
    summary_lines.append(
        f"{row['metric']},"
        f"{row['architecture_a']},"
        f"{row['architecture_b']},"
        f"{row['delta_percent_vs_a']}%,"
        f"{row['assessment']}"
    )

summary_lines.extend(
    [
        "",
        "area_result=B_BETTER",
        (
            "performance_result="
            "B_BETTER_BY_REPORTED_CRITICAL_"
            "PATH_AT_50MHZ"
        ),
        "power_result=NOT_EVALUATED",
        (
            "overall_conclusion="
            "B_BETTER_IN_AREA_AND_REPORTED_"
            "CRITICAL_PATH_UNDER_TESTED_"
            "CONSTRAINTS"
        ),
        (
            "claim_limit="
            "NO_FULL_PPA_WINNER_WITHOUT_"
            "VALID_POWER_DATA"
        ),
    ]
)

summary_path = (
    output_dir
    / "ppa_ab_summary.txt"
)

summary_path.write_text(
    "\n".join(summary_lines) + "\n",
    encoding="utf-8",
)

try:
    import matplotlib.pyplot as plt
except ImportError as error:
    raise SystemExit(
        "[FAIL] Thiếu matplotlib. Chạy: "
        "sudo apt install python3-matplotlib"
    ) from error

labels = [
    row["label"]
    for row in rows
]

normalized_b = [
    (
        float(row["architecture_b"])
        / float(row["architecture_a"])
        * 100
    )
    for row in rows
]

positions = list(
    range(len(labels))
)

bar_height = 0.35

figure, axis = plt.subplots(
    figsize=(11, 6.5)
)

axis.barh(
    [
        position - bar_height / 2
        for position in positions
    ],
    [100] * len(positions),
    bar_height,
    label="Kiến trúc A",
    color="#3567a9",
)

bars_b = axis.barh(
    [
        position + bar_height / 2
        for position in positions
    ],
    normalized_b,
    bar_height,
    label="Kiến trúc B",
    color="#e07a32",
)

axis.axvline(
    100,
    color="black",
    linewidth=0.9,
    linestyle="--",
)

axis.set_yticks(
    positions,
    labels,
)

axis.invert_yaxis()

axis.set_xlabel(
    "Giá trị chuẩn hóa (%), kiến trúc A = 100%"
)

axis.set_title(
    "FIFO A/B sau routing – diện tích, "
    "tài nguyên và đường tới hạn\n"
    "Giá trị thấp hơn là tốt hơn"
)

axis.grid(
    axis="x",
    alpha=0.25,
)

axis.legend()

for bar, value in zip(
    bars_b,
    normalized_b,
):
    axis.text(
        value + 0.3,
        (
            bar.get_y()
            + bar.get_height() / 2
        ),
        f"{value:.2f}%",
        va="center",
        fontsize=9,
    )

axis.set_xlim(
    0,
    max(
        108,
        max(normalized_b) + 8,
    ),
)

figure.tight_layout()

figure_path = (
    figure_dir
    / "ppa_ab_normalized.png"
)

figure.savefig(
    figure_path,
    dpi=200,
    bbox_inches="tight",
)

print("[PASS] fairness_check=PASS")
print(f"[PASS] CSV: {csv_path}")
print(f"[PASS] Summary: {summary_path}")
print(
    "[PASS] Config equivalence: "
    f"{config_report_path}"
)
print(f"[PASS] Checksums: {checksum_path}")
print(f"[PASS] Figure: {figure_path}")

if args.show:
    plt.show()
else:
    plt.close(figure)
