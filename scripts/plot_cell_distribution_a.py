from pathlib import Path
import matplotlib.pyplot as plt

labels = [
    "Buffer\nbuf_1",
    "Flip-flop\ndfxtp_2",
    "MUX2\nmux2_2",
    "MUX4\nmux4_2",
    "Các cell\nkhác",
]

counts = [161, 151, 144, 32, 112]
total = sum(counts)

output_dir = Path("docs/figures")
output_dir.mkdir(parents=True, exist_ok=True)

fig, ax = plt.subplots(figsize=(10, 6))

bars = ax.bar(
    labels,
    counts,
    color=["#315b96", "#4f81bd", "#6baed6", "#9ecae1", "#a0a0a0"],
    edgecolor="black",
    linewidth=0.7,
)

ax.set_title(
    "Cơ cấu standard cell của FIFO A sau synthesis",
    fontsize=15,
    fontweight="bold",
    pad=15,
)

ax.set_xlabel("Loại standard cell", fontsize=12)
ax.set_ylabel("Số lượng cell", fontsize=12)
ax.set_ylim(0, 200)
ax.grid(axis="y", linestyle="--", alpha=0.35)
ax.set_axisbelow(True)

for bar, count in zip(bars, counts):
    percentage = count / total * 100

    ax.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 4,
        f"{count}\n({percentage:.1f}%)",
        ha="center",
        va="bottom",
        fontsize=10,
    )

fig.text(
    0.5,
    0.01,
    "Tổng số: 600 cell – SKY130, clock mục tiêu 50 MHz",
    ha="center",
    fontsize=10,
)

fig.tight_layout(rect=[0, 0.04, 1, 1])

fig.savefig(
    output_dir / "fifo_a_cell_distribution.png",
    dpi=300,
    bbox_inches="tight",
)

fig.savefig(
    output_dir / "fifo_a_cell_distribution.pdf",
    bbox_inches="tight",
)

print("PASS: đã tạo docs/figures/fifo_a_cell_distribution.png")
print("PASS: đã tạo docs/figures/fifo_a_cell_distribution.pdf")
