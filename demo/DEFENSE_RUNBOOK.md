# Kịch bản demo bảo vệ FIFO A/B

Thời lượng mục tiêu: khoảng 5 phút.
Chạy từ thư mục gốc repository.

## Phần 1 - Functional Verification (khoảng 1 phút)

Lệnh:

    bash demo/run_demo_verification.sh

Nội dung thuyết minh:

Hai kiến trúc FIFO có cùng cấu hình 8 bit,
độ sâu 16 phần tử nhưng khác cách xác định
trạng thái đầy và rỗng.

Testbench kiểm tra reset, ghi, đọc, overflow,
underflow, ghi/đọc đồng thời và wrap-around.

Lần demo đã kiểm tra:
- FIFO A: 1402 checks, 0 errors.
- FIFO B: 1402 checks, 0 errors.

Đây là demo ngắn, không thay thế bằng chứng
T16/T17 với 365809 phép kiểm tra.

## Phần 2 - GTKWave (khoảng 1,5 phút)

Lệnh:

    gtkwave results/verification_t17/matrix_20261023_163641_700949/W8_D16/seed_1/t17.vcd demo/fifo_t17_w8_d16.gtkw

Tín hiệu cần giải thích:

- wr_en, rd_en, wr_data
- a_data, b_data
- a_full, b_full
- a_empty, b_empty
- a_overflow, b_overflow
- model_count

Nhấn mạnh hai FIFO nhận cùng kích thích.
Trạng thái full xuất hiện khi số phần tử đạt 16.
Trạng thái empty xuất hiện khi số phần tử về 0.

Các dữ liệu đầu ra được kiểm tra bằng reference
scoreboard trong mô phỏng T17.

## Phần 3 - GDSII và PPA (khoảng 2,5 phút)

FIFO A:

    klayout results/physical_a/PHYS_A_50MHZ/final/gds/sync_fifo_count.gds

FIFO B:

    klayout results/physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds

Hiển thị hai layout rồi mở báo cáo:

    less results/ppa_summary/ppa_comparison.md

Các số liệu nổi bật:

- Standard cells: A=600, B=573.
- Mapped area: A=7130.5888, B=6904.1216 um2.
- Fmax: A=352.34, B=331.60 MHz.
- Estimated power: A=0.715755, B=0.712251 mW.

Kết luận:

FIFO B giảm khoảng 3.18% mapped area,
nhưng Fmax báo cáo thấp hơn khoảng 5.89%.
Công suất ước tính của B thấp hơn khoảng 0.49%.

Không có kiến trúc nào tốt nhất tuyệt đối.

## Giới hạn và lưu ý

- T17 là simulation-based equivalence, không phải formal.
- PPA vật lý được đánh giá cho cấu hình FIFO 8x16.
- Power là ước tính tại workload streaming đã đo.
- Không suy ra Fmax từ đường setup đầu tiên.
- Báo cáo physical có max-fanout waiver trên clock.
- Ảnh GDSII không thay thế bằng chứng DRC/LVS.

## Phương án dự phòng

Nếu mô phỏng trực tiếp không chạy:
  trình bày log và báo cáo verification đã lưu.

Nếu GTKWave không mở:
  trình bày ảnh waveform đã chuẩn bị trước buổi bảo vệ.

Nếu KLayout không mở:
  trình bày ảnh layout FIFO A/B và báo cáo physical.

Nếu không có Docker hoặc OpenLane:
  sử dụng bằng chứng EDA đã lưu trong results/.

Không khẳng định một lệnh đã PASS nếu chưa chạy
thành công trong phiên trình diễn đó.

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

## Kiểm tra trước buổi bảo vệ

- Kiểm tra terminal WSL.
- Kiểm tra Icarus Verilog, GTKWave và KLayout.
- Mở thử VCD T17 và cả hai GDSII.
- Chuẩn bị ảnh chụp waveform và layout.
- Đọc lại báo cáo PPA và các giới hạn thực nghiệm.

DEFENSE_RUNBOOK_DRAFT_READY
