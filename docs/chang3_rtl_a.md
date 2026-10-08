# Chặng 3 – Hiện thực RTL FIFO phương án A

## 1. Mục tiêu

Chặng này hiện thực kiến trúc FIFO A bằng RTL có khả năng tổng hợp.

Mục tiêu gồm:

- Hiện thực module `sync_fifo_count`.
- Tham số hóa độ rộng dữ liệu và độ sâu.
- Hiện thực mảng nhớ, con trỏ và bộ đếm.
- Hiện thực full, empty, overflow và underflow.
- Kiểm tra cú pháp và khả năng elaboration.
- Kiểm tra RTL bằng Verilator và Yosys.
- Chuẩn bị DUT cho functional verification.

## 2. Phiên bản thiết kế

| Thuộc tính | Giá trị |
|---|---|
| Module top | `sync_fifo_count` |
| Kiến trúc | `A_count_based` |
| Data width | 8 bit |
| FIFO depth | 16 phần tử |
| Ngôn ngữ | Verilog/SystemVerilog RTL |
| File nguồn | `rtl/sync_fifo_count.v` |
| Commit hiện thực | `c4ebaa1` |
| Snapshot dùng cho verification | `898b96b` |

Commit `898b96b` kế thừa RTL từ commit `c4ebaa1` và bổ sung môi trường verification.

## 3. Giao diện RTL

Module có các cổng:

```text
clk
rst_n
wr_en
wr_data[7:0]
rd_en
rd_data[7:0]
full
empty
overflow
underflow

**Trạng thái Chặng 3: PASS.**
