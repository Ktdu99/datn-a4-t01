# ĐẶC TẢ IP FIFO ĐỒNG BỘ

## 1. Phạm vi

Đề tài thiết kế và đánh giá hai kiến trúc FIFO đồng bộ:

- Phương án A: xác định full/empty bằng bộ đếm data_count.
- Phương án B: xác định full/empty bằng con trỏ mở rộng.

Cả hai phương án sử dụng cùng một clock và có cùng hành vi bên ngoài.

## 2. Cấu hình cơ sở

- DATA_WIDTH = 8 bit.
- DEPTH = 16 phần tử.
- CLOCK_PERIOD = 20 ns.
- CLOCK_FREQUENCY = 50 MHz.
- Reset đồng bộ tích cực mức thấp.
- Đầu ra đọc được đăng ký qua thanh ghi.
- DEPTH phải là lũy thừa của 2 và lớn hơn hoặc bằng 2.

## 3. Giao diện

| Tín hiệu | Hướng | Độ rộng | Chức năng |
|---|---|---:|---|
| clk | Input | 1 | Clock hệ thống |
| rst_n | Input | 1 | Reset tích cực mức thấp |
| wr_en | Input | 1 | Yêu cầu ghi |
| wr_data | Input | DATA_WIDTH | Dữ liệu ghi |
| rd_en | Input | 1 | Yêu cầu đọc |
| rd_data | Output | DATA_WIDTH | Dữ liệu đọc |
| full | Output | 1 | FIFO đầy |
| empty | Output | 1 | FIFO rỗng |
| overflow | Output | 1 | Yêu cầu ghi khi đầy |
| underflow | Output | 1 | Yêu cầu đọc khi rỗng |

## 4. Quy tắc hoạt động

write_accept = wr_en AND NOT full

read_accept = rd_en AND NOT empty

- Chỉ ghi hợp lệ: số phần tử tăng 1.
- Chỉ đọc hợp lệ: số phần tử giảm 1.
- Đọc và ghi hợp lệ đồng thời: số phần tử không đổi.
- Ghi khi đầy: không ghi và bật overflow trong một chu kỳ.
- Đọc khi rỗng: không đọc và bật underflow trong một chu kỳ.
- rd_data chỉ thay đổi khi có lần đọc hợp lệ.

## 5. Quy tắc tại biên

- Khi FIFO đầy và wr_en=rd_en=1: chỉ chấp nhận đọc, từ chối ghi.
- Khi FIFO rỗng và wr_en=rd_en=1: chỉ chấp nhận ghi, từ chối đọc.
- Thiết kế không sử dụng cơ chế bypass khi FIFO rỗng.

## 6. Trạng thái sau reset

- full = 0.
- empty = 1.
- overflow = 0.
- underflow = 0.
- rd_data = 0.
- Con trỏ đọc và ghi bằng 0.
- data_count của phương án A bằng 0.

Không reset toàn bộ mảng memory.

## 7. Mục tiêu vật lý

- Cả hai thiết kế tổng hợp thành công.
- Có báo cáo setup và hold timing.
- Setup WNS lớn hơn hoặc bằng 0.
- Setup TNS bằng 0.
- Không có vi phạm hold chưa được xử lý.
- DRC bằng 0.
- LVS errors bằng 0.
- Xuất được GDSII cho cả A và B.
