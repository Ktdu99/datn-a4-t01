# KẾT QUẢ VERIFICATION PHƯƠNG ÁN A

## 1. Cấu hình

- Architecture: Count-based synchronous FIFO.
- DATA_WIDTH: 8 bit.
- DEPTH: 16.
- Clock period: 20 ns.
- Random cycles: 10000 chu kỳ mỗi seed.
- Seeds: 1, 2, 3, 4, 5 và 20260924.

## 2. Công cụ

- Simulator: Icarus Verilog 12.0.
- Waveform viewer: GTKWave 3.3.126.
- Testbench language: SystemVerilog.

## 3. Directed tests

| Test | Kết quả |
|---|---|
| Reset | PASS |
| FIFO ordering | PASS |
| Full | PASS |
| Empty | PASS |
| Overflow | PASS |
| Underflow | PASS |
| Simultaneous read/write | PASS |
| Full-boundary simultaneous request | PASS |
| Empty-boundary simultaneous request | PASS |
| Pointer wrap-around | PASS |
| Reset while containing data | PASS |

## 4. Random regression

| Seed | Số chu kỳ | Errors | Kết quả |
|---:|---:|---:|---|
| 1 | 10000 | 0 | PASS |
| 2 | 10000 | 0 | PASS |
| 3 | 10000 | 0 | PASS |
| 4 | 10000 | 0 | PASS |
| 5 | 10000 | 0 | PASS |
| 20260924 | 10000 | 0 | PASS |

## 5. Thống kê baseline

- Cycles: 10171
- Checks: 30517
- Accepted writes: 4899
- Accepted reads: 4891
- Overflow events: 134
- Underflow events: 162
- Simultaneous events: 2260
- Errors: 0.

## 6. Kết luận

RTL phương án A đáp ứng các yêu cầu chức năng trong specification. Testbench không phát hiện lỗi dữ liệu, lỗi cờ trạng thái hoặc lỗi xử lý các trường hợp biên trong các directed tests và random regression.
