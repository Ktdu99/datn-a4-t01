# Chặng 3 – RTL FIFO phương án A

**Trạng thái Chặng 3: PASS**

## Mục tiêu

Hiện thực kiến trúc FIFO A bằng Verilog/SystemVerilog có khả năng tổng hợp.

## Cấu hình RTL

| Thuộc tính | Giá trị |
|---|---|
| Top module | `sync_fifo_count` |
| Data width | 8 bit |
| FIFO depth | 16 phần tử |
| Kiến trúc | Count-based |
| Clock domain | Một clock đồng bộ |
| Reset | `rst_n`, active-low |

## Kết quả

- RTL được tham số hóa bằng `DATA_WIDTH` và `DEPTH`.
- Có mảng nhớ và con trỏ đọc/ghi.
- Có bộ đếm số phần tử.
- Có các cờ `full`, `empty`, `overflow`, `underflow`.
- RTL đã được kiểm tra bằng Verilator.
- RTL đã được kiểm tra khả năng tổng hợp bằng Yosys.

## Bằng chứng

| Nội dung | Đường dẫn |
|---|---|
| Mã nguồn RTL | `rtl/sync_fifo_count.v` |
| Log Verilator | `results/verilator_count.log` |
| Log kiểm tra Yosys | `results/yosys_check_count.log` |
| Commit hoàn thành | `c4ebaa1` |

## Tiêu chí hoàn thành

- [x] RTL tồn tại và xác định đúng top module.
- [x] RTL có thể được phân tích bởi Verilator.
- [x] RTL có thể được tổng hợp bởi Yosys.
- [x] Không sử dụng cấu trúc chỉ dành cho mô phỏng trong DUT.
- [x] Các cổng đúng với đặc tả Chặng 1.
- [x] Kiến trúc đúng với tài liệu Chặng 2.

## Kết luận

RTL FIFO phương án A đã hoàn thành và đủ điều kiện chuyển sang functional verification.
