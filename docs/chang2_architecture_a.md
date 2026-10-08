# Chặng 2 – Kiến trúc FIFO phương án A

**Trạng thái Chặng 2: PASS**

## Mục tiêu

Xây dựng vi kiến trúc FIFO đồng bộ sử dụng bộ đếm số phần tử, gọi là phương án A hoặc kiến trúc count-based.

## Thành phần kiến trúc

- Mảng nhớ lưu dữ liệu FIFO.
- Con trỏ ghi `wr_ptr`.
- Con trỏ đọc `rd_ptr`.
- Bộ đếm số phần tử `count`.
- Logic xác định `full` và `empty`.
- Logic chấp nhận hoặc từ chối yêu cầu đọc/ghi.
- Logic phát hiện `overflow` và `underflow`.

## Nguyên lý chính

- `empty` được kích hoạt khi `count = 0`.
- `full` được kích hoạt khi `count = DEPTH`.
- Ghi hợp lệ làm tăng `count`.
- Đọc hợp lệ làm giảm `count`.
- Đọc và ghi hợp lệ đồng thời giữ nguyên `count`.
- Con trỏ đọc và ghi quay vòng khi đến cuối vùng nhớ.

## Bằng chứng

| Nội dung | Đường dẫn |
|---|---|
| Tài liệu kiến trúc | `docs/architecture_a.md` |
| RTL hiện thực kiến trúc | `rtl/sync_fifo_count.v` |
| Commit hoàn thành | `c4ebaa1` |

## Tiêu chí hoàn thành

- [x] Xác định memory, read pointer và write pointer.
- [x] Xác định bộ đếm số phần tử.
- [x] Xác định điều kiện full/empty.
- [x] Xử lý đọc và ghi đồng thời.
- [x] Xử lý overflow/underflow.
- [x] Có tài liệu mô tả kiến trúc.

## Kết luận

Kiến trúc FIFO A đã được xác định đầy đủ, đủ điều kiện triển khai RTL.
