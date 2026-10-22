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

SEEDS = [1, 2, 3, 4, 5, 20260924]
RANDOM_CYCLES = 10000

DESIGNS = [
    ("A", "sync_fifo_count"),
    ("B", "sync_fifo_pointer"),
]


def read_stat(log, name):
    match = re.search(
        rf"^{re.escape(name)}\s*:\s*(\d+)\s*$",
        log,
        re.MULTILINE,
    )
    return int(match.group(1)) if match else None


def main():
    for tool in ("iverilog", "vvp"):
        if shutil.which(tool) is None:
            print(f"ERROR: Thieu cong cu {tool}")
            return 1

    for _, top in DESIGNS:
        for path in (
            ROOT / "rtl" / f"{top}.v",
            ROOT / "tb" / f"tb_{top}.sv",
        ):
            if not path.is_file():
                print(f"ERROR: Khong tim thay {path}")
                return 1

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
    output = ROOT / "results" / "verification_reproduced" / timestamp
    output.mkdir(parents=True)

    report = {
        "status": "RUNNING",
        "random_cycles_per_seed": RANDOM_CYCLES,
        "seeds": SEEDS,
        "source_sha256": {},
        "runs": [],
    }

    version = subprocess.run(
        ["iverilog", "-V"],
        capture_output=True,
        text=True,
    )
    (output / "tool_version.txt").write_text(
        version.stdout + version.stderr,
        encoding="utf-8",
    )

    summary = [
        "FIFO A/B REGRESSION",
        "",
        "ARCH  SEED        CYCLES    CHECKS    ERRORS  RESULT",
    ]

    try:
        for arch, top in DESIGNS:
            rtl = ROOT / "rtl" / f"{top}.v"
            tb = ROOT / "tb" / f"tb_{top}.sv"

            for source in (rtl, tb):
                report["source_sha256"][
                    str(source.relative_to(ROOT))
                ] = hashlib.sha256(source.read_bytes()).hexdigest()

            run_dir = output / f"run_{arch}"
            wave_dir = run_dir / "sim" / "waveforms"
            wave_dir.mkdir(parents=True)

            executable = run_dir / f"tb_{top}.vvp"

            print(f"\n[COMPILE] Architecture {arch}", flush=True)

            compiled = subprocess.run(
                [
                    "iverilog",
                    "-g2012",
                    "-s", f"tb_{top}",
                    f"-Ptb_{top}.RANDOM_CYCLES={RANDOM_CYCLES}",
                    "-o", str(executable),
                    str(rtl),
                    str(tb),
                ],
                cwd=run_dir,
                capture_output=True,
                text=True,
                timeout=120,
            )

            (output / f"{arch}_compile.txt").write_text(
                compiled.stdout + compiled.stderr,
                encoding="utf-8",
            )

            if compiled.returncode != 0:
                raise RuntimeError(
                    f"Compile {arch} failed. See {arch}_compile.txt"
                )

            for seed in SEEDS:
                print(f"[RUN] {arch}, seed={seed}", flush=True)

                wave = wave_dir / f"{top}.vcd"
                wave.unlink(missing_ok=True)

                simulation = subprocess.run(
                    [
                        "vvp",
                        str(executable),
                        f"+SEED={seed}",
                    ],
                    cwd=run_dir,
                    capture_output=True,
                    text=True,
                    timeout=300,
                )

                log = simulation.stdout + simulation.stderr
                log_name = f"{arch}_seed_{seed}.txt"

                (output / log_name).write_text(
                    log,
                    encoding="utf-8",
                )

                cycles = read_stat(log, "Cycles")
                checks = read_stat(log, "Checks")
                errors = read_stat(log, "Errors")

                passed = (
                    simulation.returncode == 0
                    and "ALL TESTS PASSED" in log
                    and errors == 0
                    and cycles is not None
                    and checks is not None
                    and wave.is_file()
                    and wave.stat().st_size > 0
                )

                result = "PASS" if passed else "FAIL"

                report["runs"].append({
                    "architecture": arch,
                    "seed": seed,
                    "cycles": cycles,
                    "checks": checks,
                    "errors": errors,
                    "result": result,
                    "log_file": log_name,
                })

                summary.append(
                    f"{arch:<5} {seed:<11} "
                    f"{str(cycles):<9} {str(checks):<9} "
                    f"{str(errors):<7} {result}"
                )

                print(
                    f"[{result}] cycles={cycles}, "
                    f"checks={checks}, errors={errors}"
                )

                if not passed:
                    raise RuntimeError(
                        f"{arch}, seed {seed} failed. See {log_name}"
                    )

                if seed == 20260924:
                    shutil.copy2(
                        wave,
                        output / f"{top}_seed_{seed}.vcd",
                    )

        report["status"] = "PASS"

    except Exception as error:
        report["status"] = "FAIL"
        report["error"] = str(error)
        print(f"\n[ERROR] {error}")

    finally:
        summary.append("")
        summary.append(f"OVERALL_RESULT={report['status']}")

        (output / "manifest.json").write_text(
            json.dumps(report, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

        (output / "regression_summary.txt").write_text(
            "\n".join(summary) + "\n",
            encoding="utf-8",
        )

        print(f"\nOUTPUT: {output}")
        print(f"OVERALL_RESULT={report['status']}")

    return 0 if report["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
