#!/usr/bin/env bash
set -euo pipefail

PROJECT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT"

PDK="$(readlink -f "${FIFO_PDK:-$HOME/.ciel/sky130A}")"
IMAGE="ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69-amd64"

LIB_ROOT="$PDK/libs.ref/sky130_fd_sc_hd"

TECH_LEF="$LIB_ROOT/techlef/sky130_fd_sc_hd__nom.tlef"
CELL_LEF="$LIB_ROOT/lef/sky130_fd_sc_hd.lef"
EF_CELL_LEF="$LIB_ROOT/lef/sky130_ef_sc_hd.lef"
LIB="$LIB_ROOT/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

for FILE in \
    "$TECH_LEF" "$CELL_LEF" "$EF_CELL_LEF" "$LIB" \
    "$PROJECT/scripts/run_postroute_sta.tcl"
do
    if [ ! -s "$FILE" ]; then
        echo "ERROR: Missing or empty file: $FILE"
        exit 1
    fi
done

mkdir -p results/sta_reproduced

OUTPUT="$(mktemp -d "$PROJECT/results/sta_reproduced/run_XXXXXXXX")"

echo "===== POST-ROUTE STA REPRODUCTION ====="
echo "Project: $PROJECT"
echo "PDK: $PDK"
echo "Output: $OUTPUT"

docker image inspect \
    --format '{{.Id}}' \
    "$IMAGE" > "$OUTPUT/docker_image_id.txt"

for ARCH in A B; do

    if [ "$ARCH" = A ]; then
        RUN="results/physical_a/PHYS_A_50MHZ"
        TOP="sync_fifo_count"
    else
        RUN="results/physical_b/PHYS_B_50MHZ"
        TOP="sync_fifo_pointer"
    fi

    DEF="$PROJECT/$RUN/final/def/$TOP.def"
    SDC="$PROJECT/$RUN/final/sdc/$TOP.sdc"
    SPEF="$PROJECT/$RUN/final/spef/$TOP.spef"

    for FILE in "$DEF" "$SDC" "$SPEF"; do
        if [ ! -s "$FILE" ]; then
            echo "ERROR: Missing or empty input: $FILE"
            exit 1
        fi
    done

    echo
    echo "===== RUN STA $ARCH ====="

    docker run --rm \
        --mount "type=bind,source=$PROJECT,target=/work,readonly" \
        --mount "type=bind,source=$PDK,target=/pdk,readonly" \
        -e "STA_TECH_LEF=/pdk/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef" \
        -e "STA_CELL_LEF=/pdk/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef" \
        -e "STA_EF_CELL_LEF=/pdk/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef" \
        -e "STA_LIB=/pdk/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib" \
        -e "STA_DEF=/work/$RUN/final/def/$TOP.def" \
        -e "STA_SDC=/work/$RUN/final/sdc/$TOP.sdc" \
        -e "STA_SPEF=/work/$RUN/final/spef/$TOP.spef" \
        --entrypoint bash \
        "$IMAGE" \
        -lc 'openroad -exit /work/scripts/run_postroute_sta.tcl' \
        2>&1 | tee "$OUTPUT/${ARCH}_sta.log"

    if ! grep -q '^===== POSTROUTE STA COMPLETE =====$' \
        "$OUTPUT/${ARCH}_sta.log"; then
        echo "ERROR: STA $ARCH did not complete"
        exit 1
    fi

    echo "STA $ARCH: COMPLETED"
done

echo
echo "===== REPRODUCTION COMPLETED ====="
echo "OUTPUT=$OUTPUT"
echo "REVIEW REQUIRED BEFORE COMMIT"
