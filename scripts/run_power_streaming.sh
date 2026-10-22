#!/usr/bin/env bash

set -euo pipefail

# Xác định thư mục dự án từ vị trí của script.
FIFO_PROJECT="$(
    cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
)"

cd "$FIFO_PROJECT"

# Có thể đặt FIFO_PDK từ bên ngoài khi cần đổi đường dẫn PDK.
FIFO_PDK="${FIFO_PDK:-$HOME/.ciel/sky130A}"
FIFO_MODELS="$FIFO_PDK/libs.ref/sky130_fd_sc_hd/verilog"

# Kiểm tra công cụ.
for TOOL in iverilog vvp; do
    if ! command -v "$TOOL" >/dev/null 2>&1; then
        echo "ERROR: Thieu cong cu $TOOL"
        exit 1
    fi
done

# Kiểm tra testbench và model standard cell.
for REQUIRED_FILE in \
    "tb/tb_fifo_power.sv" \
    "$FIFO_MODELS/primitives.v" \
    "$FIFO_MODELS/sky130_fd_sc_hd.v"
do
    if [ ! -s "$REQUIRED_FILE" ]; then
        echo "ERROR: File khong ton tai hoac rong: $REQUIRED_FILE"
        exit 1
    fi
done

# Mỗi lần chạy lưu vào một thư mục mới.
mkdir -p results/power_streaming

FIFO_OUTPUT="$(
    mktemp -d "$PWD/results/power_streaming/run_XXXXXXXX"
)"

echo "Thu muc ket qua: $FIFO_OUTPUT"

for ARCH in A B; do
    if [ "$ARCH" = "A" ]; then
        TOP="sync_fifo_count"
        PHYSICAL_DIR="physical_a"
    else
        TOP="sync_fifo_pointer"
        PHYSICAL_DIR="physical_b"
    fi

    NETLIST="results/$PHYSICAL_DIR/PHYS_${ARCH}_50MHZ/final/verilog/gl/${TOP}.nl.v"

    if [ ! -s "$NETLIST" ]; then
        echo "ERROR: Khong tim thay netlist: $NETLIST"
        exit 1
    fi

    echo
    echo "=== COMPILE $ARCH ==="

    iverilog \
        -g2012 \
        -DFUNCTIONAL \
        '-DUNIT_DELAY=' \
        "-DDUT_MODULE=$TOP" \
        "-DDUT_MODULE=$TOP" \
        -s tb_fifo_power \
        -o "$FIFO_OUTPUT/${ARCH}.vvp" \
        "$FIFO_MODELS/primitives.v" \
        "$FIFO_MODELS/sky130_fd_sc_hd.v" \
        "$NETLIST" \
        tb/tb_fifo_power.sv \
        2>&1 | tee "$FIFO_OUTPUT/${ARCH}_compile.txt"

    echo
    echo "=== SIMULATE $ARCH ==="

    vvp "$FIFO_OUTPUT/${ARCH}.vvp" \
        "+VCD=$FIFO_OUTPUT/${ARCH}_streaming.vcd" \
        2>&1 | tee "$FIFO_OUTPUT/${ARCH}_streaming.txt"

    if ! grep -q '^POWER_WORKLOAD_PASS$' \
        "$FIFO_OUTPUT/${ARCH}_streaming.txt"; then
        echo "ERROR: Workload $ARCH chua PASS. Hay kiem tra log."
        exit 1
    fi

    if [ ! -s "$FIFO_OUTPUT/${ARCH}_streaming.vcd" ]; then
        echo "ERROR: Khong tao duoc waveform cho $ARCH"
        exit 1
    fi
done

echo
echo "A/B STREAMING SIMULATION PASSED"
echo "OUTPUT: $FIFO_OUTPUT"
