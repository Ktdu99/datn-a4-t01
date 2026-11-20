#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
from collections import Counter
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

DESIGNS = [
    ("A", "sync_fifo_count"),
    ("B", "sync_fifo_pointer"),
]

def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def metric(log, key):
    match = re.search(
        rf"^{re.escape(key)}\s*:\s*(\d+)\s*$",
        log,
        re.MULTILINE
    )
    return int(match.group(1)) if match else None

def main():
    print("===== T16 PARAMETER REGRESSION =====", flush=True)

    for tool in ("iverilog", "vvp"):
        assert shutil.which(tool), f"Missing tool: {tool}"

    branch = subprocess.check_output(
        ["git", "branch", "--show-current"],
        cwd=ROOT,
        text=True
    ).strip()

    print(f"Running on branch: {branch}")

    sources = {}

    for _, top in DESIGNS:
        for path in [
            ROOT / "rtl" / f"{top}.v",
            ROOT / "tb" / f"tb_{top}.sv",
        ]:
            assert path.is_file(), path
            sources[str(path.relative_to(ROOT))] = sha256(path)

    stamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    output = ROOT / "results" / "verification_t16" / stamp
    output.mkdir(parents=True, exist_ok=False)

    print("RESULT_DIRECTORY =", output, flush=True)

    version = subprocess.run(
        ["iverilog", "-V"],
        capture_output=True,
        text=True
    )

    (output / "tool_version.txt").write_text(
        version.stdout + version.stderr,
        encoding="utf-8"
    )

    records = []
    summary = [
        "T16 FIFO PARAMETER MATRIX",
        "Architecture  Width  Depth  Seed      Cycles  Checks  Errors  Result",
    ]

    try:
        for architecture, top in DESIGNS:
            rtl = ROOT / "rtl" / f"{top}.v"
            tb = ROOT / "tb" / f"tb_{top}.sv"
            tb_top = f"tb_{top}"

            for width, depth in CONFIGS:
                case_dir = (
                    output / architecture /
                    f"W{width}_D{depth}"
                )
                case_dir.mkdir(parents=True, exist_ok=False)

                executable = case_dir / f"{tb_top}.vvp"

                compile_cmd = [
                    "iverilog",
                    "-g2012",
                    "-s", tb_top,
                    f"-P{tb_top}.DATA_WIDTH={width}",
                    f"-P{tb_top}.DEPTH={depth}",
                    f"-P{tb_top}.RANDOM_CYCLES={RANDOM_CYCLES}",
                    "-o", str(executable),
                    str(rtl),
                    str(tb),
                ]

                compile_result = subprocess.run(
                    compile_cmd,
                    cwd=case_dir,
                    capture_output=True,
                    text=True,
                    timeout=120
                )

                (case_dir / "compile.txt").write_text(
                    compile_result.stdout +
                    compile_result.stderr,
                    encoding="utf-8"
                )

                if compile_result.returncode != 0:
                    raise RuntimeError(
                        f"Compile failed: {architecture} "
                        f"W{width} D{depth}"
                    )

                for seed in SEEDS:
                    run_dir = case_dir / f"seed_{seed}"
                    wave_dir = run_dir / "sim" / "waveforms"
                    wave_dir.mkdir(
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

                    (run_dir / "simulation.txt").write_text(
                        log,
                        encoding="utf-8"
                    )

                    wave = wave_dir / f"{top}.vcd"

                    cycles = metric(log, "Cycles")
                    checks = metric(log, "Checks")
                    errors = metric(log, "Errors")
                    actual_width = metric(log, "DATA_WIDTH")
                    actual_depth = metric(log, "DEPTH")

                    passed = (
                        result.returncode == 0
                        and "ALL TESTS PASSED" in log
                        and errors == 0
                        and cycles is not None
                        and cycles >= RANDOM_CYCLES
                        and checks is not None
                        and checks > 0
                        and actual_width == width
                        and actual_depth == depth
                        and wave.is_file()
                        and wave.stat().st_size > 0
                    )

                    status = "PASS" if passed else "FAIL"

                    records.append({
                        "architecture": architecture,
                        "data_width": width,
                        "depth": depth,
                        "requested_seed": seed,
                        "random_cycles": RANDOM_CYCLES,
                        "total_cycles": cycles,
                        "checks": checks,
                        "errors": errors,
                        "status": status,
                        "log": str(
                            (run_dir / "simulation.txt")
                            .relative_to(output)
                        ),
                        "waveform": str(
                            wave.relative_to(output)
                        ) if wave.is_file() else None,
                    })

                    line = (
                        f"{architecture:<13} "
                        f"{width:<6} {depth:<6} "
                        f"{seed:<9} {str(cycles):<7} "
                        f"{str(checks):<7} "
                        f"{str(errors):<7} {status}"
                    )

                    summary.append(line)
                    print(line, flush=True)

                    if not passed:
                        raise RuntimeError(
                            f"T16 failed: {architecture} "
                            f"W{width} D{depth} seed={seed}"
                        )

        assert len(records) == 16
        assert all(r["status"] == "PASS" for r in records)

        for relative, digest in sources.items():
            assert sha256(ROOT / relative) == digest

        manifest = {
            "test": "T16",
            "status": "PASS",
            "random_cycles_per_run": RANDOM_CYCLES,
            "source_sha256": sources,
            "runs": records,
        }

        (output / "manifest.json").write_text(
            json.dumps(
                manifest,
                ensure_ascii=False,
                indent=2
            ) + "\n",
            encoding="utf-8"
        )

        summary.append("")
        summary.append("OVERALL_RESULT=PASS")
        summary.append("TOTAL_RUNS=16")

        (output / "regression_summary.txt").write_text(
            "\n".join(summary) + "\n",
            encoding="utf-8"
        )

        print("\n===== FINAL =====")
        print("T16_PARAMETER_MATRIX_PASS")
        print("TOTAL_RUNS = 16")
        print("CONFIGURATIONS = 4")
        print("ARCHITECTURES = 2")
        print("SEEDS_PER_CONFIGURATION = 2")
        print("SOURCE_HASHES_PRESERVED_PASS")
        print("RESULTS =", output)
        print("NO_RTL_OR_BASELINE_RESULTS_MODIFIED")
        return 0

    except Exception as error:
        summary.append("")
        summary.append("OVERALL_RESULT=FAIL")
        summary.append(f"FAILURE={error}")

        (output / "regression_summary.txt").write_text(
            "\n".join(summary) + "\n",
            encoding="utf-8"
        )

        print("T16_PARAMETER_MATRIX_FAIL")
        print("REASON =", error)
        print("PARTIAL_RESULTS =", output)
        return 1

if __name__ == "__main__":
    sys.exit(main())
