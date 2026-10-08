# Chặng 4 – Verification FIFO phương án A

**Trạng thái Chặng 4: PASS**

## Mục tiêu

Kiểm chứng chức năng RTL FIFO A bằng self-checking testbench, directed tests, corner cases và nhiều seed kiểm thử.

## Nội dung kiểm thử

- Reset FIFO.
- Ghi và đọc một phần tử.
- Ghi đầy FIFO.
- Đọc cạn FIFO.
- Kiểm tra thứ tự FIFO.
- Kiểm tra cờ `full` và `empty`.
- Kiểm tra `overflow`.
- Kiểm tra `underflow`.
- Kiểm tra đọc và ghi đồng thời.
- Regression với nhiều random seed.

## Bằng chứng

| Nội dung | Đường dẫn |
|---|---|
| Testbench | `tb/tb_sync_fifo_count.sv` |
| Script mô phỏng | `scripts/run_sim_a.sh` |
| Báo cáo verification | `docs/verification_a_results.md` |
| Log regression | `sim/logs/` |
| Waveform | `sim/waveforms/sync_fifo_count.vcd` |
| Commit hoàn thành | `898b96b` |

## Các seed đã lưu

- `sync_fifo_count_seed_1.log`
- `sync_fifo_count_seed_2.log`
- `sync_fifo_count_seed_3.log`
- `sync_fifo_count_seed_4.log`
- `sync_fifo_count_seed_5.log`
- `sync_fifo_count_seed_20260924.log`

## Tiêu chí hoàn thành

- [x] Testbench tự động so sánh kết quả.
- [x] Các chức năng cơ bản đã được kiểm thử.
- [x] Các điều kiện biên đã được kiểm thử.
- [x] Có regression nhiều seed.
- [x] Có log kết quả.
- [x] Có waveform VCD phục vụ kiểm tra.
- [x] Có báo cáo verification.

## Kết luận

RTL FIFO phương án A đã vượt qua functional verification và đủ điều kiện chuyển sang synthesis và STA.
