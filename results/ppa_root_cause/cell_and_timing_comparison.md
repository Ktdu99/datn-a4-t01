# FIFO A/B – Cell and Timing Evidence

## 1. Scope

- Configuration: DATA_WIDTH=8, DEPTH=16.
- Technology: SKY130A, sky130_fd_sc_hd.
- Data: synthesis statistics and post-route STA logs.
- This is report analysis, not a new synthesis run.

## 2. Synthesis comparison

| Metric | FIFO A | FIFO B | B - A |
|---|---:|---:|---:|
| Standard cells | 600 | 573 | -27 |
| Synthesized cell area (um2) | 7130.5888 | 6904.1216 | -226.4672 |

Synthesized cell area change: -3.18%.

## 3. Complete cell-type differences

| Standard cell | A | B | B - A |
|---|---:|---:|---:|
| `sky130_fd_sc_hd__o211a_2` | 0 | 11 | +11 |
| `sky130_fd_sc_hd__and3_2` | 12 | 3 | -9 |
| `sky130_fd_sc_hd__a211o_2` | 0 | 8 | +8 |
| `sky130_fd_sc_hd__a21o_2` | 10 | 2 | -8 |
| `sky130_fd_sc_hd__o221a_2` | 8 | 0 | -8 |
| `sky130_fd_sc_hd__nand2_2` | 8 | 14 | +6 |
| `sky130_fd_sc_hd__or2_2` | 7 | 1 | -6 |
| `sky130_fd_sc_hd__buf_1` | 161 | 156 | -5 |
| `sky130_fd_sc_hd__o21a_2` | 6 | 1 | -5 |
| `sky130_fd_sc_hd__and2_2` | 7 | 3 | -4 |
| `sky130_fd_sc_hd__and3b_2` | 4 | 1 | -3 |
| `sky130_fd_sc_hd__dfxtp_2` | 151 | 148 | -3 |
| `sky130_fd_sc_hd__inv_2` | 3 | 6 | +3 |
| `sky130_fd_sc_hd__nand3_2` | 0 | 3 | +3 |
| `sky130_fd_sc_hd__nor2_2` | 9 | 6 | -3 |
| `sky130_fd_sc_hd__o2111a_2` | 1 | 4 | +3 |
| `sky130_fd_sc_hd__a2111oi_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__a21bo_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__a21oi_2` | 5 | 4 | -1 |
| `sky130_fd_sc_hd__a221o_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__a22o_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__a22oi_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__a31oi_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__and2b_2` | 10 | 9 | -1 |
| `sky130_fd_sc_hd__and4_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__and4b_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__and4bb_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__mux2_2` | 144 | 145 | +1 |
| `sky130_fd_sc_hd__nand2b_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__nor3_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__o21ba_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__o311a_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__or2b_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__or3b_2` | 1 | 0 | -1 |
| `sky130_fd_sc_hd__or4_2` | 2 | 1 | -1 |
| `sky130_fd_sc_hd__xnor2_2` | 2 | 1 | -1 |
| `sky130_fd_sc_hd__xor2_2` | 3 | 4 | +1 |

The signed sum of cell-count differences is -27.
Individual cell categories change in both directions.

## 4. Post-route STA comparison

| Metric | FIFO A | FIFO B |
|---|---:|---:|
| Minimum clock period (ns) | 2.84 | 3.02 |
| Reported Fmax (MHz) | 352.34 | 331.60 |
| Setup worst slack (ns) | 13.380897 | 13.414628 |
| Hold worst slack (ns) | 0.340383 | 0.301747 |

Fmax change of B relative to A: -5.89%.

## 5. First reported maximum-delay paths

- A startpoint: `_1045_ (rising edge-triggered flip-flop clocked by clk)`
- A endpoint: `empty (output port clocked by clk)`
- B startpoint: `_984_ (rising edge-triggered flip-flop clocked by clk)`
- B endpoint: `full (output port clocked by clk)`

These are the first maximum-delay paths printed by
the saved STA scripts. They must not automatically
be interpreted as the paths defining minimum period.

## 6. Interpretation and limitations

- Differences in cell mapping are observed, but
  block-level causality requires additional netlist
  tracing and RTL-to-cell correspondence.
- Synthesis cell area is distinct from core/die area.
- Setup worst slack and reported minimum period
  answer different timing questions.
- No formal proof of causal attribution is claimed.

## 7. Evidence paths

- A synthesis: `openlane/sync_fifo_count_phys/runs/PHYS_A_50MHZ/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- A STA: `results/sta_summary/A_sta.log`
- B synthesis: `openlane/sync_fifo_pointer_phys/runs/PHYS_B_50MHZ/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- B STA: `results/sta_summary/B_sta.log`

CELL_AND_TIMING_EVIDENCE_AUDIT_PASS
