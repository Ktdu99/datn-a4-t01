# Hướng dẫn người mới đọc đồ án FIFO

## Đồ án làm về gì

Đồ án thiết kế FIFO đồng bộ 8 bit × 16 phần tử và so sánh hai cách
quản lý trạng thái đầy/rỗng:

- FIFO A — count-based: dùng bộ đếm số phần tử đang lưu.
- FIFO B — extended-pointer: dùng con trỏ đọc/ghi có thêm bit vòng.

Hai thiết kế được kiểm chứng chức năng, triển khai qua flow ASIC mã nguồn mở
đến layout GDSII, rồi so sánh Power, Performance và Area (PPA).

## Quy trình thực hiện

Đặc tả → RTL → mô phỏng kiểm chứng → synthesis/STA →
floorplan, placement, CTS, routing → DRC/LVS → GDSII → so sánh PPA.

## Đọc repository theo thứ tự

1. [README](README.md) — mục tiêu, cấu hình và kết quả tổng quan.
2. [Đặc tả FIFO](docs/chang1_specification.md) — FIFO cần hoạt động thế nào.
3. `rtl/` và `tb/` — mã thiết kế và testbench.
4. `results/verification_summary/` — kết quả kiểm chứng.
5. `results/sta_summary/` — báo cáo timing.
6. `results/physical_a/` và `results/physical_b/` — triển khai vật lý.
7. `results/ppa_summary/ppa_comparison.md` — bảng so sánh PPA.
8. [Evidence ledger](EVIDENCE_LEDGER.md) — tra từ kết luận đến log/report gốc.
9. `demo/` — hướng dẫn chạy demo bảo vệ.

## Đồ án đã làm đến đâu

Theo README và các báo cáo trong repository:

- Đã có đặc tả và RTL cho hai kiến trúc FIFO.
- Đã có testbench, regression và waveform kiểm chứng.
- Đã có báo cáo synthesis, STA và triển khai vật lý.
- Đã xuất GDSII cho FIFO A và FIFO B.
- Đã có báo cáo DRC/LVS và so sánh PPA.
- Luận văn, slide và demo cần được đối chiếu với trạng thái mới nhất trong repository.

## Kết quả và giới hạn

Đọc số liệu mới nhất tại `results/ppa_summary/ppa_comparison.md`
và điều kiện phân tích tại `results/sta_summary/`.

Power là kết quả ước lượng theo workload được báo cáo, không phải phép đo
trên chip. T17 là kiểm chứng dựa trên mô phỏng, không phải formal equivalence.
Khi thuyết trình, cần nêu các điều kiện và giới hạn này.

## Lệnh xem tài liệu trong Ubuntu

```bash
less README.md
less results/ppa_summary/ppa_comparison.md
