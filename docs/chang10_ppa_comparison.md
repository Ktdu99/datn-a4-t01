# Chặng 10 – So sánh PPA giữa hai kiến trúc FIFO A và B

## 1. Mục tiêu

Chặng này so sánh hai vi kiến trúc synchronous FIFO sau khi hoàn thành
physical implementation bằng OpenLane:

- Kiến trúc A: FIFO sử dụng bộ đếm số phần tử.
- Kiến trúc B: FIFO sử dụng con trỏ mở rộng.
- Cả hai có chiều rộng dữ liệu 8 bit.
- Cả hai có độ sâu 16 phần tử.
- Cả hai được đánh giá tại clock period 20 ns, tương ứng 50 MHz.

Mục tiêu của phép so sánh là đánh giá:

- Power: công suất.
- Performance: hiệu năng timing.
- Area: diện tích và tài nguyên phần cứng.
- Chất lượng physical implementation.
- Khả năng đạt timing và signoff của hai phương án.

## 2. Hai kiến trúc được so sánh

### 2.1. Kiến trúc A – count based

Kiến trúc A sử dụng biến trạng thái `data_count` để lưu số phần tử
hiện có trong FIFO.

Các trạng thái được xác định như sau:

- `empty` khi `data_count == 0`.
- `full` khi `data_count == DEPTH`.
- Khi chỉ ghi thành công, `data_count` tăng.
- Khi chỉ đọc thành công, `data_count` giảm.
- Khi đọc và ghi đồng thời thành công, `data_count` không đổi.

RTL chính:

`rtl/sync_fifo_count.v`

Kết quả physical implementation:

`results/physical_a/PHYS_A_50MHZ`

Commit hoàn thành physical implementation A:

`302d038`

### 2.2. Kiến trúc B – extended pointer

Kiến trúc B sử dụng read pointer và write pointer mở rộng thêm một bit
để nhận biết trạng thái quay vòng của bộ nhớ.

Các trạng thái được xác định như sau:

- `empty` khi read pointer bằng write pointer.
- `full` khi phần địa chỉ của hai pointer bằng nhau nhưng bit quay vòng
  khác nhau.
- Không sử dụng bộ đếm số phần tử riêng để tạo `full` và `empty`.

RTL chính:

`rtl/sync_fifo_pointer.v`

Kết quả physical implementation:

`results/physical_b/PHYS_B_50MHZ`

Commit hoàn thành physical implementation B:

`faaf8db`

## 3. Điều kiện so sánh công bằng

Hai kiến trúc được triển khai với các điều kiện chung sau:

| Tham số | Kiến trúc A | Kiến trúc B |
|---|---:|---:|
| Data width | 8 bit | 8 bit |
| FIFO depth | 16 | 16 |
| Dung lượng lưu trữ | 128 bit | 128 bit |
| PDK | sky130A | sky130A |
| Standard-cell library | sky130_fd_sc_hd | sky130_fd_sc_hd |
| Clock period | 20.0 ns | 20.0 ns |
| Tần số mục tiêu | 50 MHz | 50 MHz |
| Synthesis strategy | AREA 0 | AREA 0 |

Hai file cấu hình physical chỉ khác các trường bắt buộc theo thiết kế:

- `DESIGN_NAME`.
- `VERILOG_FILES`.

Tất cả các trường cấu hình còn lại giống nhau. Kết quả kiểm tra được
lưu tại:

`results/ppa_comparison/config_equivalence.txt`

Trạng thái kiểm tra công bằng:

```text
fairness_check=PASS
all_other_config_fields=IDENTICAL
