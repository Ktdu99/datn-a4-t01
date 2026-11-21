# Chặng 1 – Đặc tả và kế hoạch kiểm thử FIFO

## 1. Mục tiêu

Chặng 1 xác định IP cần làm gì và chuẩn bị cách kiểm tra trước khi viết RTL. Đầu ra của chặng gồm hai tài liệu:

- [Đặc tả chung FIFO](specification.md) quy định cấu hình, giao diện và hành vi mà cả FIFO A và FIFO B phải đáp ứng.
- [Kế hoạch kiểm thử](test_plan.md) chuyển các yêu cầu thành từng ca thử có kết quả mong đợi để viết testbench và đánh giá `PASS` hoặc `FAIL`.

## 2. Phạm vi thiết kế

Đề tài chọn **FIFO đồng bộ**, với thao tác đọc và ghi dùng chung một clock. FIFO lưu dữ liệu theo thứ tự vào trước, ra trước. Thiết kế sử dụng mảng lưu trữ mô tả bằng RTL, không dùng SRAM macro.

**FIFO A** được triển khai trước làm phương án cơ sở. Mô-đun `sync_fifo_count` theo dõi số phần tử bằng bộ đếm. **FIFO B** được phát triển sau để so sánh. Mô-đun `sync_fifo_pointer` dùng con trỏ đọc và ghi mở rộng có thêm bit vòng.

Cả hai dùng cùng yêu cầu ở Chặng 1. Chi tiết hiện thực được trình bày riêng tại [Chặng 2 – Kiến trúc FIFO A](chang2_architecture_a.md) và [Chặng 7 – Kiến trúc FIFO B](chang7_architecture_b.md).

## 3. Tham số thiết kế

Chọn **8 bit × 16 phần tử** làm cấu hình cơ sở. Mỗi phần tử chứa 8 bit, tổng dung lượng lưu dữ liệu là 128 bit.

| Nội dung | Cấu hình đã chốt | Dùng để làm gì? |
|---|---|---|
| Độ rộng dữ liệu | `DATA_WIDTH = 8` | Xác định kích thước mỗi từ dữ liệu ghi và đọc. |
| Độ sâu FIFO | `DEPTH = 16` | Xác định sức chứa và các mốc cần thử khi FIFO đầy hoặc rỗng. |
| Clock mục tiêu | 50 MHz, chu kỳ 20 ns | Dùng cùng một ràng buộc khi triển khai vật lý A và B. |
| Công nghệ và thư viện | SKY130A, `sky130_fd_sc_hd` | Giữ cùng điều kiện khi so sánh diện tích, timing và công suất. |

Các cấu hình độ rộng và độ sâu khác thuộc phạm vi kiểm thử chức năng **T16**. Báo cáo PPA của đồ án dùng cấu hình cơ sở 8 bit × 16 phần tử.

## 4. Giao diện của IP

Để dùng chung tiêu chí kiểm thử cho A và B, Chặng 1 xác định testbench cần điều khiển và quan sát các nhóm tín hiệu sau:

| Nhóm | Tín hiệu | Vai trò trong kiểm thử |
|---|---|---|
| Clock và reset | `clk`, `rst_n` | Tạo cạnh clock và đưa FIFO về trạng thái khởi tạo. |
| Đường ghi | `wr_en`, `wr_data` | Gửi yêu cầu ghi và dữ liệu cần đưa vào FIFO. |
| Đường đọc | `rd_en`, `rd_data` | Gửi yêu cầu đọc và đối chiếu dữ liệu nhận được với kết quả mong đợi. |
| Trạng thái FIFO | `full`, `empty` | Quan sát xem FIFO đã đầy hay rỗng sau khi xử lý yêu cầu. |
| Cờ yêu cầu bị từ chối | `overflow`, `underflow` | Kiểm tra tình huống yêu cầu ghi khi đầy hoặc yêu cầu đọc khi rỗng. |

Bảng hướng, độ rộng và thời điểm cập nhật của từng tín hiệu nằm trong [đặc tả chung](specification.md#3-giao-diện-tín-hiệu).

## 5. Đặc tả hoạt động

### 5.1. Từ yêu cầu đến ca kiểm thử

| Hành vi cần kiểm chứng | Cách đưa vào kế hoạch kiểm thử |
|---|---|
| FIFO khởi tạo đúng và trả dữ liệu theo thứ tự ghi. | Reset, ghi các giá trị phân biệt rồi đọc lại để đối chiếu. **T01–T04** |
| FIFO báo đúng trạng thái đầy, rỗng và yêu cầu vượt giới hạn. | Ghi đến đầy rồi yêu cầu ghi thêm. Đọc đến rỗng rồi yêu cầu đọc thêm. **T05–T08** |
| FIFO xử lý đúng khi đọc và ghi đồng thời. | Gửi đồng thời hai yêu cầu khi FIFO còn chỗ, khi đầy và khi rỗng. **T09–T11** |
| FIFO giữ đúng thứ tự khi địa chỉ quay vòng và trở về rỗng khi reset. | Chạy qua điểm quay vòng địa chỉ, sau đó kiểm tra thêm ca reset khi FIFO còn dữ liệu. **T12–T13** |
| Hai phương án tuân thủ đặc tả trong các ca mở rộng. | Chạy chuỗi ngẫu nhiên, lặp với nhiều seed, thử nhiều cấu hình và đối chiếu A/B. **T14–T17** |

### 5.2. Ví dụ một ca kiểm thử

**T10 – Đọc và ghi đồng thời khi FIFO đầy.** Trước hết, ghi đủ 16 phần tử để `full = 1`. Sau đó, đặt `wr_en = 1` và `rd_en = 1` tại cùng một cạnh lên của clock.

Kết quả mong đợi với cả A và B: phần tử cũ nhất được đưa ra `rd_data`, yêu cầu ghi bị từ chối, `overflow = 1` và `full` hạ xuống `0` vì FIFO còn 15 phần tử.

### 5.3. Hoàn thành chặng

Chặng 1 hoàn thành khi đặc tả và kế hoạch kiểm thử đã đủ rõ để viết RTL và testbench cho cả hai phương án. Kết quả chạy thực tế được lưu riêng trong [báo cáo kiểm chứng tổng hợp](../results/verification_summary/verification_summary.md) và [báo cáo T16/T17](../results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md).
