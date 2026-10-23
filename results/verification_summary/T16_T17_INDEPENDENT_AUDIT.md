# Independent Audit — T16 and T17

## Scope

- T16: parameterized FIFO regression for A and B.
- T17: cycle-by-cycle simulation comparison of A and B
  with an independent FIFO reference scoreboard.
- Tested configurations: 8x8, 8x16, 8x32, 16x16.
- Seeds: 1 and 20260924.
- RTL was not modified for these experiments.

## Results

| Test | Runs | Cycles | Checks | Errors |
|---|---:|---:|---:|---:|
| T16 | 16 | 34920 | 104824 | 0 |
| T17 | 8 | 17383 | 260985 | 0 |
| Total | 24 | 52303 | 365809 | 0 |

## Evidence

- T16: `results/verification_t16/20261023_162821_187749`
- T17: `results/verification_t17/matrix_20261023_163641_700949`

Both manifests, all simulation logs and all waveform files
were checked for consistency and existence.

Source SHA-256 hashes in both manifests matched the
current RTL, testbench and script files.

## Interpretation and limitations

- Results support functional correctness for the tested
  configurations and stimuli.
- T17 checks five output signals for both architectures:
  read data, full, empty, overflow and underflow.
- Coverage counters confirm that selected boundary cases
  were exercised, but do not constitute full code coverage.
- Simulation-based equivalence is not formal equivalence.
- These tests do not replace post-layout timing or signoff.
- PPA conclusions remain limited to the physical design
  configurations and conditions actually evaluated.

## Conclusion

T16_INDEPENDENT_AUDIT_PASS
T17_INDEPENDENT_AUDIT_PASS
COMBINED_VERIFICATION_AUDIT_PASS
