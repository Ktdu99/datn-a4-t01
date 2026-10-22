#!/usr/bin/env bash

set -euo pipefail

FIFO_PROJECT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
)"

cd "$FIFO_PROJECT"

if [ "$#" -ne 1 ]; then
    echo "Cach dung:"
    echo "bash scripts/run_power_analysis.sh results/power_streaming/run_..."
    exit 1
fi

FIFO_INPUT="$(realpath "$1")"
FIFO_PDK="$(readlink -f "${FIFO_PDK:-$HOME/.ciel/sky130A}")"

FIFO_IMAGE="ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69-amd64"

# Kiểm tra các đầu vào trước khi chạy.
for REQUIRED_FILE in \
    "$FIFO_INPUT/A_streaming.vcd" \
    "$FIFO_INPUT/B_streaming.vcd" \
    "$FIFO_INPUT/A_streaming.txt" \
    "$FIFO_INPUT/B_streaming.txt" \
    "$FIFO_PDK/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib" \
    "$FIFO_PROJECT/scripts/analyze_power_streaming.tcl"
do
    if [ ! -s "$REQUIRED_FILE" ]; then
        echo "ERROR: File khong ton tai hoac rong:"
        echo "$REQUIRED_FILE"
        exit 1
    fi
done

for ARCH in A B; do
    grep -q '^POWER_WORKLOAD_PASS$' \
        "$FIFO_INPUT/${ARCH}_streaming.txt"
done

mkdir -p results/power_analysis

FIFO_OUTPUT="$(
    mktemp -d "$PWD/results/power_analysis/run_XXXXXXXX"
)"

FIFO_RELATIVE="${FIFO_OUTPUT#"$FIFO_PROJECT"/}"

echo "Input:  $FIFO_INPUT"
echo "Output: $FIFO_OUTPUT"

# VCD chỉ bắt đầu ghi sau warmup.
# Dời mốc timestamp đầu tiên về 0 để cửa sổ activity
# không bao gồm thời gian trước khi bắt đầu ghi.
# Giữ nguyên VCD gốc và khoảng cách giữa các sự kiện.
python3 - "$FIFO_INPUT" "$FIFO_OUTPUT" <<'PY'
from pathlib import Path
import hashlib
import json
import re
import sys

source_dir = Path(sys.argv[1])
output_dir = Path(sys.argv[2])

metadata = {
    "workload": "streaming",
    "activity_model": "gate_level_zero_delay",
    "qualification": "REVIEW_REQUIRED",
    "files": [],
}

for arch in ("A", "B"):
    source = source_dir / f"{arch}_streaming.vcd"
    destination = output_dir / f"{arch}_streaming_zero.vcd"

    first = None
    last = None

    with source.open() as reader, destination.open("w") as writer:
        for line in reader:
            stripped = line.strip()

            if re.fullmatch(r"#\d+", stripped):
                timestamp = int(stripped[1:])

                if first is None:
                    first = timestamp

                if last is not None and timestamp < last:
                    raise RuntimeError("VCD timestamps are not ordered")

                last = timestamp
                writer.write(f"#{timestamp - first}\n")
            else:
                writer.write(line)

    if first is None or last <= first:
        raise RuntimeError(f"Invalid VCD time range: {source}")

    metadata["files"].append({
        "architecture": arch,
        "source": str(source),
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "normalized_file": destination.name,
        "first_timestamp": first,
        "last_timestamp": last,
        "duration_ticks": last - first,
    })

    print(
        f"{arch}: first={first}, last={last}, "
        f"duration={last - first} VCD ticks"
    )

if metadata["files"][0]["duration_ticks"] != \
        metadata["files"][1]["duration_ticks"]:
    raise RuntimeError("A/B have different activity durations")

(output_dir / "activity_metadata.json").write_text(
    json.dumps(metadata, indent=2),
    encoding="utf-8",
)
PY

# Lưu thông tin image để truy xuất môi trường chạy.
docker image inspect \
    --format '{{.Id}}' \
    "$FIFO_IMAGE" > "$FIFO_OUTPUT/docker_image_id.txt"

for ARCH in A B; do
    echo
    echo "=== POWER ANALYSIS $ARCH ==="

    docker run --rm \
        --mount "type=bind,source=$FIFO_PROJECT,target=/work,readonly" \
        --mount "type=bind,source=$FIFO_PDK,target=/pdk,readonly" \
        -e "FIFO_ARCH=$ARCH" \
        -e "FIFO_ACTIVITY_DIR=/work/$FIFO_RELATIVE" \
        --entrypoint bash \
        "$FIFO_IMAGE" \
        -lc 'openroad -exit /work/scripts/analyze_power_streaming.tcl' \
        2>&1 | tee "$FIFO_OUTPUT/${ARCH}_power.txt"

    if ! grep -q '^POWER_REPORT_COMPLETED$' \
        "$FIFO_OUTPUT/${ARCH}_power.txt"; then
        echo "ERROR: Chua hoan thanh bao cao power $ARCH"
        exit 1
    fi
done

echo
echo "POWER REPORTS GENERAT
ED - REVIEW REQUIRED"
echo "OUTPUT: $FIFO_OUTPUT"
