# FIFO A/B Physical Design Comparison

## 1. Experimental Setup

- Design: Synchronous FIFO 16x8
- Architecture A: Count-based FIFO
- Architecture B: Extended-pointer FIFO
- Technology: Sky130A
- Standard-cell library: sky130_fd_sc_hd
- Target frequency: 50 MHz
- Clock period: 20 ns
- Flow: OpenLane / OpenROAD
- Physical implementation: Floorplan, Placement, CTS, Routing, Sign-off

## 2. Physical PPA Results

| Metric | FIFO A | FIFO B |
|---|---:|---:|
| Die area (mm2) | 0.025295 | 0.024573 |
| Core area (um2) | 20169.344 | 19462.416 |
| Placement utilization (%) | 36.68 | 36.83 |
| Synthesis cell count | 600 | 573 |
| Total physical cells | 2425 | 2345 |
| Wire length (um) | 18677 | 18170 |
| Via count | 4905 | 4609 |
| Post-route WNS (ns) | 0.0 | 0.0 |
| Post-route TNS (ns) | 0.0 | 0.0 |
| Reported path delay (ns) | 2.37 | 2.34 |

## 3. Physical Verification

| Check | FIFO A | FIFO B |
|---|---|---|
| TritonRoute violations | 0 | 0 |
| Magic DRC violations | 0 | 0 |
| LVS errors | 0 | 0 |
| LVS result | Circuits match uniquely | Circuits match uniquely |
| Antenna net violations | 0 | 0 |
| Antenna pin violations | 0 | 0 |
| Max slew violations | 0 | 0 |
| Max capacitance violations | 0 | 0 |
| Max fanout violations | 6 | 6 |

## 4. Timing Assessment

Both implementations completed the physical-design flow
with a target clock period of 20 ns.

The recorded post-route WNS and TNS are both 0.0 ns.
The post-route checks report found no negative-slack
setup paths under the applied constraints.

The reported path delays are:
- FIFO A: 2.37 ns, endpoint empty
- FIFO B: 2.34 ns, endpoint full

These path delays should not be interpreted directly
as the minimum achievable clock period or maximum
operating frequency.

Separate hold WNS/TNS evidence has not yet been
established by the archived reports.

## 5. Max Fanout Assessment

Both implementations use:

MAX_FANOUT_CONSTRAINT = 10

Each implementation has six max-fanout violations
reported on the clock distribution network.

The archived key_metrics.txt files classify these
as ACCEPTED_QOR_WAIVER.

This waiver does not mean the violations have been
physically eliminated.

No max slew or max capacitance violations were
reported in postroute_checks.rpt.

## 6. Comparison

Compared with FIFO A, FIFO B has approximately:

- 2.85% lower die area
- 3.50% lower core area
- 4.50% fewer synthesis cells
- 3.30% fewer total physical cells
- 2.71% shorter total wire length
- 6.03% fewer vias

These results describe the archived physical-design
runs and should not be generalized to all configurations.

## 7. Evidence

Each architecture has the following archived files:

- key_metrics.txt
- metrics.csv
- magic_drc.rpt
- lvs.txt
- antenna.txt
- postroute_checks.rpt

GDSII file hashes are recorded in gds_sha256.txt.

The GDSII files themselves are retained in the
original physical-design result directories.

## 8. Limitations

- Only the archived Sky130A physical-design runs
  are evaluated.
- Max fanout violations remain as documented waivers.
- Separate hold timing sign-off requires further
  evidence.
- Timing and physical metrics depend on the
  applied constraints, library, and PVT conditions.
