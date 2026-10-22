# FIFO A/B Power Comparison

## Experimental setup

- Technology: Sky130 HD
- Corner: TT, 25 C, 1.80 V
- Clock: 50 MHz
- Workload: Streaming
- Measurement: 10,000 cycles
- Activity: Gate-level zero-delay VCD
- Parasitics: Nominal SPEF
- Tool: OpenROAD

## Results

| Metric | FIFO A | FIFO B |
|---|---:|---:|
| Internal Power (mW) | 0.493997 | 0.488578 |
| Switching Power (mW) | 0.221753 | 0.223667 |
| Leakage Power (nW) | 5.460372 | 5.384078 |
| Total Power (mW) | 0.715755 | 0.712251 |
| Unannotated drivers | 0 | 0 |
| Partially unannotated drivers | 0 | 0 |
| Annotated pin activities | 3872 | 3795 |

## Interpretation

FIFO B has approximately 0.49% lower estimated total power
than FIFO A under the streaming workload.

FIFO B has lower internal power but slightly higher switching
power. The result is workload-dependent.

## Limitations

- Power values are estimates, not silicon measurements.
- Zero-delay VCD does not fully represent timing glitches.
- The number of annotated pin activities is not an activity
  coverage percentage.
- Results are for one workload and one PVT corner.
- Further workloads are recommended before drawing general
  power-efficiency conclusions.
