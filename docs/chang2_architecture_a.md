# Chặng 2 – Kiến trúc FIFO phương án A

## 1. Mục tiêu

Chặng này xây dựng vi kiến trúc FIFO phương án A từ đặc tả Chặng 1.

Phương án A sử dụng bộ đếm số phần tử `data_count` để xác định trực tiếp trạng thái `full` và `empty`.

Mục tiêu gồm:

- Xác định các khối phần cứng của FIFO.
- Xác định read pointer và write pointer.
- Xác định kích thước bộ đếm.
- Xác định phương trình full/empty.
- Xác định quy tắc cập nhật trạng thái.
- Xử lý đọc và ghi đồng thời.
- Xử lý overflow và underflow.
- Chuẩn bị kiến trúc có khả năng tổng hợp ASIC.

## 2. Cấu hình kiến trúc

| Thuộc tính | Giá trị |
|---|---|
| Tên kiến trúc | `A_count_based` |
| Data width | 8 bit |
| FIFO depth | 16 phần tử |
| Dung lượng | 128 bit |
| Cơ chế full/empty | Bộ đếm `data_count` |
| Số clock domain | 1 |
| Bộ nhớ | Register array |
| SRAM macro | Không sử dụng |

## 3. Các khối chính

### 3.1 Mảng nhớ

Mảng nhớ chứa 16 phần tử, mỗi phần tử rộng 8 bit:

```text
memory[0:15]
```

**Trạng thái Chặng 2: PASS.**
