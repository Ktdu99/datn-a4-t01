# Chặng 1 – Specification và Test Plan

**Trạng thái Chặng 1: PASS**

## Mục tiêu

Xác định đầy đủ yêu cầu chức năng, giao diện, tham số và kế hoạch kiểm thử cho IP Synchronous FIFO.

## Kết quả

- IP được chọn: Synchronous FIFO.
- Kiến trúc mục tiêu: FIFO đồng bộ một miền clock.
- Tham số cơ sở: `DATA_WIDTH=8`, `DEPTH=16`.
- Đã định nghĩa các cổng clock, reset, đọc, ghi và dữ liệu.
- Đã quy định hoạt động của `full`, `empty`, `overflow` và `underflow`.
- Đã liệt kê trường hợp kiểm thử thông thường và corner cases.

## Bằng chứng

| Nội dung | Đường dẫn |
|---|---|
| Đặc tả IP | `docs/specification.md` |
| Kế hoạch kiểm thử | `docs/test_plan.md` |
| Commit hoàn thành | `4870052` |

## Tiêu chí hoàn thành

- [x] Có đặc tả đầu vào và đầu ra.
- [x] Có tham số dữ liệu và độ sâu FIFO.
- [x] Có quy tắc đọc và ghi.
- [x] Có định nghĩa trạng thái full/empty.
- [x] Có định nghĩa overflow/underflow.
- [x] Có test plan và corner cases.

## Kết luận

Đặc tả và kế hoạch kiểm thử đã hoàn thành, đủ điều kiện chuyển sang thiết kế kiến trúc A.
