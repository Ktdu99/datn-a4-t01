#!/usr/bin/env python3

import csv
import hashlib
import re
import shutil
import subprocess
import sys
from pathlib import Path


repo_root = Path(__file__).resolve().parents[1]
run_tag = sys.argv[1] if len(sys.argv) > 1 else "PHYS_A_50MHZ"

run_dir = (
    repo_root
    / "openlane"
    / "sync_fifo_count_phys"
    / "runs"
    / run_tag
)

out_dir = (
    repo_root
    / "results"
    / "physical_a"
    / run_tag
)

final_src = run_dir / "results" / "final"
metrics_src = run_dir / "reports" / "metrics.csv"
checks_src = (
    run_dir
    / "reports"
    / "signoff"
    / "31-rcx_sta.checks.rpt"
)
rtl_src = repo_root / "rtl" / "sync_fifo_count.v"

required_files = [
    repo_root
    / "openlane"
    / "sync_fifo_count_phys"
    / "config.json",
    run_dir / "config.tcl",
    metrics_src,
    run_dir / "reports" / "manufacturability.rpt",
    checks_src,
    run_dir / "reports" / "signoff" / "drc.rpt",
    run_dir / "logs" / "synthesis" / "linter.log",
    run_dir / "logs" / "signoff" / "38-lvs.lef.log",
    run_dir / "logs" / "signoff" / "39-drc.log",
    run_dir / "logs" / "signoff" / "40-arc.log",
    final_src / "gds" / "sync_fifo_count.gds",
    final_src / "def" / "sync_fifo_count.def",
    final_src / "lef" / "sync_fifo_count.lef",
    rtl_src,
]

missing_files = [
    path for path in required_files
    if not path.is_file() or path.stat().st_size == 0
]

if missing_files:
    print("[FAIL] Thiếu các file bắt buộc:")

    for path in missing_files:
        print(path)

    raise SystemExit(1)

(out_dir / "reports").mkdir(parents=True, exist_ok=True)
(out_dir / "logs").mkdir(parents=True, exist_ok=True)

copy_list = [
    (
        repo_root
        / "openlane"
        / "sync_fifo_count_phys"
        / "config.json",
        out_dir / "config.json",
    ),
    (
        run_dir / "config.tcl",
        out_dir / "resolved_config.tcl",
    ),
    (
        metrics_src,
        out_dir / "metrics.csv",
    ),
    (
        run_dir / "reports" / "manufacturability.rpt",
        out_dir / "manufacturability.rpt",
    ),
    (
        checks_src,
        out_dir / "reports" / "postroute_checks.rpt",
    ),
    (
        run_dir / "reports" / "signoff" / "drc.rpt",
        out_dir / "reports" / "magic_drc.rpt",
    ),
    (
        run_dir / "logs" / "synthesis" / "linter.log",
        out_dir / "logs" / "linter.txt",
    ),
    (
        run_dir / "logs" / "signoff" / "38-lvs.lef.log",
        out_dir / "logs" / "lvs.txt",
    ),
    (
        run_dir / "logs" / "signoff" / "39-drc.log",
        out_dir / "logs" / "magic_drc.txt",
    ),
    (
        run_dir / "logs" / "signoff" / "40-arc.log",
        out_dir / "logs" / "antenna.txt",
    ),
]

for source, destination in copy_list:
    shutil.copy2(source, destination)

shutil.copytree(
    final_src,
    out_dir / "final",
    dirs_exist_ok=True,
)

with metrics_src.open(
    "r",
    encoding="utf-8",
    newline="",
) as metrics_file:
    metrics = next(csv.DictReader(metrics_file))

checks_text = checks_src.read_text(
    encoding="utf-8",
    errors="replace",
)

fanout_match = re.search(
    r"max fanout violation count\s+(\d+)",
    checks_text,
)

fanout_violations = (
    int(fanout_match.group(1))
    if fanout_match
    else -1
)

linter_text = (
    run_dir
    / "logs"
    / "synthesis"
    / "linter.log"
).read_text(
    encoding="utf-8",
    errors="replace",
)

linter_warnings = linter_text.count("%Warning-")

repository_commit = subprocess.check_output(
    [
        "git",
        "-C",
        str(repo_root),
        "rev-parse",
        "HEAD",
    ],
    text=True,
).strip()

rtl_sha256 = hashlib.sha256(
    rtl_src.read_bytes()
).hexdigest()

summary_items = [
    ("run_tag", run_tag),
    ("repository_commit", repository_commit),
    ("rtl_sha256", rtl_sha256),
    ("architecture", "A_count_based"),
    ("data_width", "8"),
    ("depth", "16"),
    ("pdk", "sky130A"),
    ("std_cell_library", "sky130_fd_sc_hd"),
    ("clock_period_ns", metrics["CLOCK_PERIOD"]),
    ("target_frequency_mhz", "50.0"),
    ("flow_status", metrics["flow_status"]),
    ("total_runtime", metrics["total_runtime"]),
    ("routed_runtime", metrics["routed_runtime"]),
    ("die_area_mm2", metrics["DIEAREA_mm^2"]),
    ("core_area_um2", metrics["CoreArea_um^2"]),
    ("placement_utilization_pct", metrics["OpenDP_Util"]),
    ("synth_cell_count", metrics["synth_cell_count"]),
    ("total_cells_after_physical", metrics["TotalCells"]),
    ("wire_length_um", metrics["wire_length"]),
    ("via_count", metrics["vias"]),
    (
        "tritonroute_violations",
        metrics["tritonRoute_violations"],
    ),
    ("magic_drc_violations", metrics["Magic_violations"]),
    ("lvs_total_errors", metrics["lvs_total_errors"]),
    (
        "pin_antenna_violations",
        metrics["pin_antenna_violations"],
    ),
    (
        "net_antenna_violations",
        metrics["net_antenna_violations"],
    ),
    ("postroute_wns_ns", metrics["spef_wns"]),
    ("postroute_tns_ns", metrics["spef_tns"]),
    ("critical_path_ns", metrics["critical_path_ns"]),
    ("linter_warning_count", str(linter_warnings)),
    (
        "clock_max_fanout_violation_count",
        str(fanout_violations),
    ),
    (
        "clock_max_fanout_assessment",
        "ACCEPTED_QOR_WAIVER",
    ),
    (
        "power_estimate_status",
        "NOT_USED_WITHOUT_QUALIFIED_SWITCHING_ACTIVITY",
    ),
]

key_metrics_path = out_dir / "key_metrics.txt"

key_metrics_path.write_text(
    "\n".join(
        f"{key}={value}"
        for key, value in summary_items
    )
    + "\n",
    encoding="utf-8",
)

failures = []

if metrics["flow_status"].strip().lower() != "flow completed":
    failures.append("flow_status")

zero_metrics = [
    "tritonRoute_violations",
    "Magic_violations",
    "lvs_total_errors",
    "pin_antenna_violations",
    "net_antenna_violations",
]

for name in zero_metrics:
    if float(metrics[name]) != 0.0:
        failures.append(name)

if float(metrics["spef_wns"]) < 0.0:
    failures.append("spef_wns")

if float(metrics["spef_tns"]) < 0.0:
    failures.append("spef_tns")

if failures:
    print("[FAIL] Các điều kiện Chặng 6 chưa đạt:")

    for failure in failures:
        print(failure)

    raise SystemExit(1)

print("[PASS] Đã thu thập physical implementation A")
print(f"[PASS] GDSII: {out_dir / 'final/gds/sync_fifo_count.gds'}")
print(f"[PASS] Metrics: {key_metrics_path}")
print(
    "[INFO] Clock max-fanout được giữ dưới dạng "
    "documented QoR waiver."
)
