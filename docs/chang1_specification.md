# Chặng 1 – Đặc tả và kế hoạch kiểm thử FIFO

## 1. Mục tiêu

Chặng này xác định yêu cầu chức năng, giao diện, tham số và kế hoạch kiểm thử cho IP Synchronous FIFO trước khi thiết kế RTL.

Mục tiêu gồm:

- Xác định chức năng của FIFO.
- Xác định các tín hiệu vào và ra.
- Xác định tham số độ rộng dữ liệu và độ sâu.
- Quy định hành vi đọc, ghi và reset.
- Quy định hoạt động của `full`, `empty`, `overflow` và `underflow`.
- Xây dựng test plan bao gồm các trường hợp thông thường và corner cases.
- Xác định tiêu chí đánh giá PASS/FAIL.

## 2. Phạm vi thiết kế

Thiết kế là FIFO đồng bộ, trong đó thao tác đọc và ghi sử dụng chung một tín hiệu clock.

Phạm vi của phiên bản được đánh giá:

| Thuộc tính | Giá trị |
|---|---|
| Loại FIFO | Synchronous FIFO |
| Số miền clock | 1 |
| Data width | 8 bit |
| FIFO depth | 16 phần tử |
| Dung lượng lưu trữ | 128 bit |
| Reset | Active-low |
| RTL top dự kiến | `sync_fifo_count` |
| Công nghệ mục tiêu | SKY130 |
| SRAM macro | Không sử dụng |

Thiết kế không xử lý clock-domain crossing và không phải asynchronous FIFO.

## 3. Tham số thiết kế

| Tham số | Giá trị mặc định | Ý nghĩa |
|---|---:|---|
| `DATA_WIDTH` | 8 | Số bit của mỗi phần tử |
| `DEPTH` | 16 | Số phần tử tối đa trong FIFO |

Cấu hình `DATA_WIDTH=8`, `DEPTH=16` được sử dụng xuyên suốt từ verification đến synthesis và physical implementation.

Các cấu hình tham số khác phải được kiểm chứng lại trước khi kết luận tương đương.

## 4. Giao diện của IP

| Tín hiệu | Hướng | Độ rộng | Chức năng |
|---|---|---:|---|
| `clk` | Input | 1 | Clock đồng bộ |
| `rst_n` | Input | 1 | Reset active-low |
| `wr_en` | Input | 1 | Yêu cầu ghi |
| `wr_data` | Input | 8 | Dữ liệu cần ghi |
| `rd_en` | Input | 1 | Yêu cầu đọc |
| `rd_data` | Output | 8 | Dữ liệu đọc ra |
| `full` | Output | 1 | FIFO đang đầy |
| `empty` | Output | 1 | FIFO đang rỗng |
| `overflow` | Output | 1 | Có yêu cầu ghi khi FIFO đầy |
| `underflow` | Output | 1 | Có yêu cầu đọc khi FIFO rỗng |

## 5. Đặc tả hoạt động

### 5.1 Reset

Khi `rst_n=0`:

- Con trỏ đọc trở về vị trí ban đầu.
- Con trỏ ghi trở về vị trí ban đầu.
- Số phần tử hợp lệ trở về 0.
- `empty` được kích hoạt.
- `full` không được kích hoạt.
- `overflow` và `underflow` được xóa.

### 5.2 Ghi dữ liệu

Một thao tác ghi được chấp nhận khi:

```text
wr_en = 1 và full = 0

**Trạng thái Chặng 1: PASS.**
