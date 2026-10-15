# Chặng 4 – Functional Verification FIFO p
hương án A

## 1. Mục tiêu

Chặng này kiểm chứng chức năng RTL FIFO A trước khi synthesis.

Mục tiêu gồm:

- Xây dựng self-checking testbench.
- So sánh DUT với reference model.
- Kiểm thử các thao tác đọc và ghi cơ bản.
- Kiểm thử full, empty, overflow và underflow.
- Kiểm thử con trỏ quay vòng.
- Kiểm thử đọc và ghi đồng thời.
- Chạy regression với nhiều random seed.
- Lưu log và waveform làm bằng chứng.

## 2. Phiên bản RTL được kiểm chứng

| Thuộc tính | Giá trị |
|---|---|
| Git commit | `898b96bafda2e72642c273ff71418ac405f2ac80` |
| DUT | `sync_fifo_count` |
| RTL | `rtl/sync_fifo_count.v` |
| Data width | 8 bit |
| FIFO depth | 16 phần tử |
| Testbench | `tb/tb_sync_fifo_count.sv` |
| Script chạy | `scripts/run_sim_a.sh` |

Đây cũng là RTL commit được sử dụng làm đầu vào cho synthesis và STA ở Chặng 5.

## 3. Môi trường verification

Testbench thực hiện:

- Tạo clock và reset.
- Điều khiển `wr_en`, `wr_data` và `rd_en`.
- Theo dõi `rd_data`, `full`, `empty`, `overflow` và `underflow`.
- Duy trì reference model của FIFO.
- So sánh đầu ra DUT với dữ liệu mong đợi.
- Phát hiện sai khác và báo FAIL.
- Kết thúc với PASS khi không phát hiện lỗi.

Môi trường verification được lưu trong Git để có thể chạy lại độc lập.

## 4. Ma trận kiểm thử

| Nhóm kiểm thử | Nội dung | Trạng thái |
|---|---|---|
| Reset | Kiểm tra trạng thái ngay sau reset | PASS |
| Basic write | Ghi một hoặc nhiều phần tử | PASS |
| Basic read | Đọc và so sánh dữ liệu | PASS |
| FIFO order | Kiểm tra first-in first-out | PASS |
| Fill FIFO | Ghi đến khi `full=1` | PASS |
| Overflow | Ghi khi FIFO đã đầy | PASS |
| Drain FIFO | Đọc đến khi `empty=1` | PASS |
| Underflow | Đọc khi FIFO đang rỗng | PASS |
| Simultaneous | Đọc và ghi trong cùng chu kỳ | PASS |
| Pointer wrap | Kiểm tra con trỏ quay vòng | PASS |
| Random traffic | Chuỗi đọc/ghi ngẫu nhiên | PASS |
| Multiple seeds | Chạy lại với nhiều seed | PASS |

## 5. Kiểm tra các corner case

### 5.1 Ghi khi đầy

Testbench kiểm tra:

- Dữ liệu hợp lệ không bị ghi đè.
- Occupancy không vượt quá `DEPTH`.
- `full` tiếp tục phản ánh đúng trạng thái.
- `overflow` được kích hoạt.

### 5.2 Đọc khi rỗng

Testbench kiểm tra:

- Occupancy không giảm dưới 0.
- Không lấy một phần tử không hợp lệ khỏi reference model.
- `empty` tiếp tục phản ánh đúng trạng thái.
- `underflow` được kích hoạt.

### 5.3 Đọc và ghi đồng thời

Testbench kiểm tra:

- Hai thao tác hợp lệ có thể xảy ra cùng chu kỳ.
- Dữ liệu đọc vẫn đúng thứ tự FIFO.
- Dữ liệu mới được ghi đúng vị trí.
- Occupancy giữ nguyên khi cả hai thao tác đều được chấp nhận.

### 5.4 Con trỏ quay vòng

Chuỗi kiểm thử thực hiện nhiều lần ghi và đọc để con trỏ đi qua cuối mảng nhớ và quay lại vị trí đầu tiên.

Reference model được sử dụng để phát hiện mất dữ liệu, lặp dữ liệu hoặc sai thứ tự.

## 6. Regression nhiều seed

Các log đã lưu:

```text
sim/logs/sync_fifo_count_seed_1.log
sim/logs/sync_fifo_count_seed_2.log
sim/logs/sync_fifo_count_seed_3.log
sim/logs/sync_fifo_count_seed_4.log
sim/logs/sync_fifo_count_seed_5.log
sim/logs/sync_fifo_count_seed_20260924.log

## Hình dạng sóng mô phỏng

Hình dưới đây thể hiện hoạt động đọc, ghi và cập nhật trạng thái của FIFO kiến trúc A. Dạng sóng được sinh ra từ testbench tự kiểm tra với Icarus Verilog và quan sát bằng GTKWave.

![Dạng sóng verification FIFO A](figures/fifo_a_waveform.png)
**Trạng thái Chặng 4: PASS.**
