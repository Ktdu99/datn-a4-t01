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

Trạng thái: Demo 1 và 2 đã kiểm tra; Demo 3 đã có layout và tài liệu PPA.

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


## Demo 3 - ASIC Layout and PPA

Tài liệu hướng dẫn và số liệu:

`demo/DEMO3_LAYOUT_PPA.md`

Mở layout FIFO A:

`klayout results/physical_a/PHYS_A_50MHZ/final/gds/sync_fifo_count.gds`

Mở layout FIFO B:

`klayout results/physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds`

Cả hai GDSII đã được mở và kiểm tra trực quan
bằng KLayout 0.30.0.

Các số liệu Area, Timing và Power phải được
đối chiếu với báo cáo EDA, không suy ra chỉ
từ hình ảnh layout.

## Kịch bản demo bảo vệ

Kịch bản trình diễn ba phần trong khoảng 5 phút:

`demo/DEFENSE_RUNBOOK.md`

Thứ tự:
1. Chạy Functional Verification cho FIFO A/B.
2. Hiển thị waveform và các điều kiện full/empty.
3. Mở GDSII FIFO A/B và trình bày kết quả PPA.

Tài liệu cũng ghi rõ các giới hạn thực nghiệm
và phương án dự phòng khi demo trực tiếp.

## Ảnh dự phòng

Các ảnh được chụp từ GTKWave và KLayout:

- `demo/screenshots/01_gtkwave_fifo_ab.png`:
  waveform so sánh FIFO A/B.
- `demo/screenshots/02_klayout_fifo_a.png`:
  layout FIFO A, top cell `sync_fifo_count`.
- `demo/screenshots/03_klayout_fifo_b.png`:
  layout FIFO B, top cell `sync_fifo_pointer`.

Sử dụng khi phần mềm đồ họa không mở được
trong buổi bảo vệ.

Ảnh chụp không thay thế log verification,
báo cáo STA, PPA hoặc kết quả DRC/LVS.

## Công việc còn lại

- Chuẩn bị ảnh dự phòng cho GTKWave và KLayout.
- Kiểm toán và lưu kịch bản bảo vệ lên GitHub.
- Chuẩn bị slide và câu hỏi phản biện.
