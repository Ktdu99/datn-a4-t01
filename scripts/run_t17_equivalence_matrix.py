#!/usr/bin/env python3

from pathlib import Path
from datetime import datetime
import hashlib
import json
import re
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]

CONFIGS = [
    (8, 8),
    (8, 16),
    (8, 32),
    (16, 16),
]

SEEDS = [1, 20260924]
RANDOM_CYCLES = 2000

RTL_A = ROOT / "rtl/sync_fifo_count.v"
RTL_B = ROOT / "rtl/sync_fifo_pointer.v"
TB = ROOT / "tb/tb_fifo_equivalence.sv"

def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def get_metric(text, name):
    match = re.search(
        rf"^{re.escape(name)}=(\d+)$",
        text,
        re.MULTILINE
    )
    return int(match.group(1)) if match else None

def save_text(path, text):
    path.write_text(text, encoding="utf-8")

def main():
    print("===== T17 EQUIVALENCE MATRIX =====", flush=True)

    for tool in ("iverilog", "vvp"):
        assert shutil.which(tool), f"Missing tool: {tool}"

    branch = subprocess.check_output(
        ["git", "branch", "--show-current"],
        cwd=ROOT,
        text=True
    ).strip()

    print(f"Running on branch: {branch}")

    sources = [
        RTL_A,
        RTL_B,
        TB,
        Path(__file__).resolve(),
    ]

    assert all(p.is_file() for p in sources)

    hashes = {
        str(p.relative_to(ROOT)): sha256(p)
        for p in sources
    }

    stamp = datetime.now().strftime(
        "%Y%m%d_%H%M%S_%f"
    )

    output = (
        ROOT / "results/verification_t17"
        / f"matrix_{stamp}"
    )

    output.mkdir(parents=True, exist_ok=False)

    print("RESULT_DIRECTORY =", output, flush=True)

    version = subprocess.run(
        ["iverilog", "-V"],
        capture_output=True,
        text=True
    )

    save_text(
        output / "tool_version.txt",
        version.stdout + version.stderr
    )

    records = []

    summary = [
        "T17 FIFO EQUIVALENCE MATRIX",
        "",
        "Width Depth Seed Cycles Checks Errors Result",
    ]

    failure = None

    try:
        for width, depth in CONFIGS:
            case_dir = output / f"W{width}_D{depth}"
            case_dir.mkdir(parents=True, exist_ok=False)

            executable = case_dir / "t17.vvp"

            compile_cmd = [
                "iverilog",
                "-g2012",
                "-s", "tb_fifo_equivalence",
                f"-Ptb_fifo_equivalence.DATA_WIDTH={width}",
                f"-Ptb_fifo_equivalence.DEPTH={depth}",
                f"-Ptb_fifo_equivalence.RANDOM_CYCLES={RANDOM_CYCLES}",
                "-o", str(executable),
                str(RTL_A),
                str(RTL_B),
                str(TB),
            ]

            compile_result = subprocess.run(
                compile_cmd,
                cwd=case_dir,
                capture_output=True,
                text=True,
                timeout=120
            )

            save_text(
                case_dir / "compile.txt",
                compile_result.stdout +
                compile_result.stderr
            )

            if compile_result.returncode != 0:
                raise RuntimeError(
                    f"COMPILE_FAIL W{width} D{depth}"
                )

            print(
                f"COMPILE_PASS W{width} D{depth}",
                flush=True
            )

            for seed in SEEDS:
                run_dir = case_dir / f"seed_{seed}"
                run_dir.mkdir(
                    parents=True,
                    exist_ok=False
                )

                result = subprocess.run(
                    [
                        "vvp",
                        str(executable),
                        f"+SEED={seed}",
                    ],
                    cwd=run_dir,
                    capture_output=True,
                    text=True,
                    timeout=180
                )

                log = result.stdout + result.stderr

                log_path = run_dir / "simulation.txt"
                save_text(log_path, log)

                wave = run_dir / "t17.vcd"

                keys = [
                    "T17_DATA_WIDTH",
                    "T17_DEPTH",
                    "T17_SEED",
                    "T17_CYCLES",
                    "T17_CHECKS",
                    "T17_ERRORS",
                    "T17_WRITES",
                    "T17_READS",
                    "T17_OVERFLOWS",
                    "T17_UNDERFLOWS",
                    "T17_SIMULTANEOUS",
                    "T17_FULL_BOTH",
                    "T17_EMPTY_BOTH",
                    "T17_WRAPS",
                    "T17_RESETS",
                ]

                metrics = {
                    key: get_metric(log, key)
                    for key in keys
                }

                cycles = metrics["T17_CYCLES"]
                checks = metrics["T17_CHECKS"]
                errors = metrics["T17_ERRORS"]
                resets = metrics["T17_RESETS"]

                coverage_keys = [
                    "T17_WRITES",
                    "T17_READS",
                    "T17_OVERFLOWS",
                    "T17_UNDERFLOWS",
                    "T17_SIMULTANEOUS",
                    "T17_FULL_BOTH",
                    "T17_EMPTY_BOTH",
                    "T17_WRAPS",
                ]

                coverage_ok = all(
                    metrics[key] is not None
                    and metrics[key] > 0
                    for key in coverage_keys
                )

                checks_ok = (
                    cycles is not None
                    and checks is not None
                    and resets is not None
                    and checks == 15 * (cycles + resets)
                )

                passed = (
                    result.returncode == 0
                    and log.count("T17_EQUIVALENCE_PASS") == 1
                    and errors == 0
                    and metrics["T17_DATA_WIDTH"] == width
                    and metrics["T17_DEPTH"] == depth
                    and metrics["T17_SEED"] == seed
                    and cycles is not None
                    and cycles >= RANDOM_CYCLES
                    and resets is not None
                    and resets >= 2
                    and coverage_ok
                    and checks_ok
                    and wave.is_file()
                    and wave.stat().st_size > 0
                )

                status = "PASS" if passed else "FAIL"

                records.append({
                    "width": width,
                    "depth": depth,
                    "seed": seed,
                    "status": status,
                    "returncode": result.returncode,
                    "metrics": metrics,
                    "check_count_consistent": checks_ok,
                    "coverage_nonzero": coverage_ok,
                    "simulation_log": str(
                        log_path.relative_to(output)
                    ),
                    "waveform": (
                        str(wave.relative_to(output))
                        if wave.is_file()
                        else None
                    ),
                })

                line = (
                    f"{width:<5} {depth:<5} {seed:<8} "
                    f"{str(cycles):<6} "
                    f"{str(checks):<7} "
                    f"{str(errors):<6} {status}"
                )

                summary.append(line)
                print(line, flush=True)

                if not passed:
                    raise RuntimeError(
                        f"T17_FAIL W{width} "
                        f"D{depth} SEED={seed}"
                    )

        assert len(records) == 8
        assert all(r["status"] == "PASS" for r in records)

        for name, expected_hash in hashes.items():
            assert sha256(ROOT / name) == expected_hash

        overall_status = "PASS"

    except Exception as exc:
        overall_status = "FAIL"
        failure = str(exc)

    manifest = {
        "test": "T17",
        "status": overall_status,
        "configurations": CONFIGS,
        "seeds": SEEDS,
        "random_cycles_per_run": RANDOM_CYCLES,
        "source_sha256": hashes,
        "runs": records,
        "failure": failure,
    }

    save_text(
        output / "manifest.json",
        json.dumps(
            manifest,
            ensure_ascii=False,
            indent=2
        ) + "\n"
    )

    summary.extend([
        "",
        f"OVERALL_RESULT={overall_status}",
        f"TOTAL_RUNS={len(records)}",
        f"TOTAL_CHECKS={sum((r['metrics']['T17_CHECKS'] or 0) for r in records)}",
    ])

    if failure:
        summary.append(f"FAILURE={failure}")

    save_text(
        output / "regression_summary.txt",
        "\n".join(summary) + "\n"
    )

    print("\n===== FINAL =====")

    if overall_status == "PASS":
        print("T17_EQUIVALENCE_MATRIX_PASS")
        print("TOTAL_RUNS = 8")
        print("CONFIGURATIONS = 4")
        print("SEEDS_PER_CONFIGURATION = 2")
        print(
            "TOTAL_CHECKS =",
            sum(r["metrics"]["T17_CHECKS"] for r in records)
        )
        print("ALL_COVERAGE_COUNTERS_NONZERO_PASS")
        print("CHECK_COUNT_CONSISTENCY_PASS")
        print("SOURCE_HASHES_PRESERVED_PASS")
        print("RESULTS =", output)
        print("NO_RTL_OR_BASELINE_RESULTS_MODIFIED")
        return 0

    print("T17_EQUIVALENCE_MATRIX_FAIL")
    print("REASON =", failure)
    print("PARTIAL_RESULTS =", output)
    return 1

if __name__ == "__main__":
    sys.exit(main())
