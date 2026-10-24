# Demo

Thư mục chứa kịch bản và công cụ demo đồ án FIFO IP.

Nội dung dự kiến:

- Kịch bản demo chính.
- Lệnh chạy verification kiến trúc A.
- Lệnh chạy verification kiến trúc B.
- Cách xem waveform.
- Cách xem layout GDSII.
- Cách hiển thị kết quả so sánh PPA.
- Phương án dự phòng khi OpenLane hoặc GUI không hoạt động.

Trạng thái: Demo 1 và Demo 2 đã kiểm tra; Demo 3 đang chuẩn bị.

## Demo 1 - Functional Verification

Chạy từ thư mục gốc repository:

`bash demo/run_demo_verification.sh`

Mặc định: SEED=1, RANDOM_CYCLES=300.

Kết quả đã kiểm tra:
- FIFO A: PASS, 1402 checks, 0 errors.
- FIFO B: PASS, 1402 checks, 0 errors.
- Tổng chu kỳ của mỗi kiến trúc: 466.

Script tạo workspace riêng trong /tmp/fifo-demo-XXXXXXXX.
Các file trong /tmp có thể bị xóa khi hệ thống dọn dẹp.
Không dùng demo này thay thế báo cáo T16/T17.

## Demo 2 - Waveform FIFO A/B

Mở VCD T17 và cấu hình tín hiệu bằng lệnh:

`gtkwave results/verification_t17/matrix_20261023_163641_700949/W8_D16/seed_1/t17.vcd demo/fifo_t17_w8_d16.gtkw`

Các tín hiệu minh họa:
- clk, rst_n, wr_en, rd_en, wr_data
- a_data, b_data
- a_full, b_full, a_empty, b_empty
- a_overflow, b_overflow
- a_underflow, b_underflow
- model_count

Cấu hình GTKW sử dụng đường dẫn tương đối.
Chạy lệnh từ thư mục gốc repository.
Sau khi sao chép sang máy khác, cần kiểm tra
GTKWave tải đúng VCD và các tín hiệu.

## Công việc còn lại

- Demo 3: layout GDSII và kết quả PPA.
- Kịch bản thuyết minh và phương án dự phòng.
