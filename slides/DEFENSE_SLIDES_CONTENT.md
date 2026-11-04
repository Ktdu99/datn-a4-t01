# NỘI DUNG SLIDE BẢO VỆ ĐỒ ÁN

Chủ đề:
Thiết kế và đánh giá hai kiến trúc FIFO đồng bộ
từ RTL đến GDSII bằng quy trình ASIC mã nguồn mở.

Cấu hình: DATA_WIDTH=8, DEPTH=16.
Công nghệ: SKY130A.
Clock mục tiêu: 50 MHz.

Dự kiến: 15 slide / khoảng 15 phút.
Demo kỹ thuật: khoảng 5 phút riêng biệt.

---

## SLIDE 1 — TRANG BÌA

Tiêu đề:
THIẾT KẾ VÀ ĐÁNH GIÁ HAI KIẾN TRÚC FIFO ĐỒNG BỘ
TỪ RTL ĐẾN GDSII

Nội dung:
- Đồ án tốt nghiệp.
- Sinh viên thực hiện: điền theo hồ sơ trường.
- Giảng viên hướng dẫn: điền theo hồ sơ trường.
- Khoa, trường, năm: điền theo mẫu chính thức.

Hình minh họa:
- Layout GDSII FIFO A hoặc B.

## SLIDE 2 — ĐẶT VẤN ĐỀ

- FIFO là IP lưu trữ dữ liệu theo thứ tự vào trước,
  ra trước.
- FIFO được sử dụng trong hệ thống số để đệm dữ liệu.
- Các kiến trúc RTL có thể thực hiện cùng chức năng
  nhưng tạo ra kết quả phần cứng khác nhau.
- Cần đánh giá chức năng và PPA sau khi triển khai.

Thông điệp:
Không chỉ viết RTL đúng chức năng, mà còn đánh giá
ảnh hưởng của lựa chọn kiến trúc đến phần cứng ASIC.

## SLIDE 3 — MỤC TIÊU VÀ PHẠM VI

Mục tiêu:
- Thiết kế FIFO A theo kiến trúc count-based.
- Thiết kế FIFO B theo kiến trúc extended-pointer.
- Kiểm chứng hai kiến trúc bằng mô phỏng.
- Tổng hợp, phân tích STA và thiết kế vật lý.
- So sánh Power, Performance và Area.

Phạm vi:
- FIFO đồng bộ, một clock.
- DATA_WIDTH=8, DEPTH=16 cho PPA.
- SKY130A, standard-cell library sky130_fd_sc_hd.

## SLIDE 4 — QUY TRÌNH THỰC HIỆN

Các giai đoạn:
1. Đặc tả và thiết kế RTL.
2. Functional Verification.
3. Logic Synthesis.
4. Static Timing Analysis.
5. Floorplan và Placement.
6. Clock Tree Synthesis.
7. Routing.
8. DRC/LVS, GDSII và phân tích PPA.

Hình minh họa:
Sơ đồ RTL -> Verification -> Synthesis -> Physical
Design -> GDSII -> PPA.

## SLIDE 5 — ĐẶC TẢ FIFO 8x16

- Độ rộng dữ liệu: 8 bit.
- Độ sâu: 16 phần tử.
- Dung lượng lưu trữ logic: 128 bit.
- Clock đồng bộ.
- Các tín hiệu điều khiển: wr_en, rd_en.
- Các trạng thái: full, empty.
- Dữ liệu đầu vào và đầu ra.

Các trường hợp cần xử lý:
Reset, ghi đến đầy, đọc đến rỗng, wrap-around,
ghi/đọc đồng thời và thao tác không hợp lệ.

## SLIDE 6 — KIẾN TRÚC FIFO A

Count-based FIFO:
- Write pointer và read pointer.
- Bộ đếm số phần tử hiện có.
- empty khi bộ đếm bằng 0.
- full khi bộ đếm bằng DEPTH.
- Điều khiển tăng/giảm bộ đếm theo thao tác hợp lệ.

Hình cần vẽ:
Memory + write pointer + read pointer + counter
+ full/empty control.

## SLIDE 7 — KIẾN TRÚC FIFO B

Extended-pointer FIFO:
- Write pointer và read pointer có bit mở rộng.
- empty dựa vào sự bằng nhau của hai con trỏ.
- full dựa vào sự khác nhau của bit vòng và
  sự bằng nhau của phần địa chỉ.
- Không sử dụng bộ đếm occupancy như kiến trúc A.

Hình cần vẽ:
Memory + extended write/read pointers
+ full/empty comparison logic.

Lưu ý:
Hai kiến trúc cùng đặc tả chức năng nhưng
có cấu trúc logic điều khiển khác nhau.

## SLIDE 8 — PHƯƠNG PHÁP KIỂM CHỨNG

- RTL simulation bằng Icarus Verilog.
- Testbench tự kiểm tra.
- Reference model / scoreboard.
- So sánh dữ liệu và trạng thái của FIFO A/B.
- Directed test và randomized test.
- Quan sát waveform bằng GTKWave.

Phạm vi:
Kiểm chứng tương đương dựa trên mô phỏng,
không phải chứng minh tương đương hình thức.

## SLIDE 9 — KẾT QUẢ VERIFICATION

- T16: 16/16 PASS.
- T17: 8/8 PASS.
- Tổng cộng: 24/24 PASS.
- Tổng số phép kiểm tra: 365809.
- Tổng số lỗi: 0.

Hình:
demo/screenshots/01_gtkwave_fifo_ab.png

Nhận xét:
Hai kiến trúc vượt qua các bài kiểm tra
đã thực hiện trong phạm vi thực nghiệm.

## SLIDE 10 — KẾT QUẢ SYNTHESIS

                      FIFO A       FIFO B
Standard cells          600          573
Mapped area (um2)      7130.5888    6904.1216

FIFO B:
- Giảm 27 standard cells.
- Giảm khoảng 3.18% mapped area.

Giải thích:
Khác biệt kiến trúc điều khiển làm thay đổi
thành phần logic sau synthesis.

## SLIDE 11 — PHÂN TÍCH TIMING

Mục tiêu:
- Clock 50 MHz, chu kỳ 20 ns.

                         FIFO A       FIFO B
Setup WNS (ns)          +13.380897   +13.414628
Hold WNS (ns)            +0.340383    +0.301747
Reported Fmax (MHz)      352.34       331.60

- Cả hai đạt yêu cầu setup/hold theo
  điều kiện STA độc lập đã kiểm tra.
- FIFO A có Fmax báo cáo cao hơn.

Lưu ý:
Không suy Fmax trực tiếp từ giá trị path delay
2.37 ns hoặc 2.34 ns của báo cáo physical.

## SLIDE 12 — THIẾT KẾ VẬT LÝ

                         FIFO A       FIFO B
Core area (um2)         20169.344    19462.416
Die area (mm2)          0.025295     0.024573
Physical cells          2425         2345

Hình:
demo/screenshots/02_klayout_fifo_a.png
demo/screenshots/03_klayout_fifo_b.png

Kết quả:
- Hai thiết kế có GDSII.
- Magic DRC: 0 violations.
- LVS: circuits match uniquely.
- Antenna violations: 0.

Giới hạn:
Có 6 max-fanout violations mỗi kiến trúc
được phân loại ACCEPTED_QOR_WAIVER.
Không mô tả là sign-off hoàn toàn không ngoại lệ.

## SLIDE 13 — KẾT QUẢ POWER

Điều kiện:
- SKY130A, TT, 25 C, 1.8 V.
- Clock 50 MHz.
- Streaming workload, 10000 cycles.
- Gate-level zero-delay VCD.
- Nominal SPEF.

Estimated total power:
- FIFO A: 0.715755 mW.
- FIFO B: 0.712251 mW.

FIFO B thấp hơn khoảng 0.49%.

Lưu ý:
Đây là công suất ước tính, không phải
giá trị đo trực tiếp trên chip.

## SLIDE 14 — TỔNG HỢP PPA

So sánh FIFO B với FIFO A:
- Synthesis mapped area: -3.18%.
- Reported Fmax: -5.89%.
- Estimated total power: -0.49%.
- Core area: khoảng -3.50%.

Kết luận:
FIFO B tiết kiệm diện tích và có công suất
ước tính thấp hơn một chút trong workload đã đo.
FIFO A có lợi thế về Fmax báo cáo.

Không có kiến trúc tốt nhất trên mọi tiêu chí.

## SLIDE 15 — KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

Kết quả đạt được:
- Hoàn thành hai kiến trúc FIFO đồng bộ.
- Kiểm chứng chức năng và so sánh A/B.
- Triển khai ASIC đến GDSII.
- Thu thập kết quả STA, Area và Power.
- Phân tích sự đánh đổi giữa hai kiến trúc.

Giới hạn:
- PPA tập trung vào FIFO 8x16.
- Power chỉ cho workload và corner đã đo.
- Tương đương dựa trên mô phỏng.
- Có max-fanout waiver trong physical reports.

Hướng phát triển:
- Khảo sát thêm DATA_WIDTH và DEPTH.
- Bổ sung formal equivalence.
- Đánh giá nhiều PVT corner và workload.
- Cải thiện timing và power.
- Xem xét xử lý các max-fanout violations.

---

## NGUỒN DỮ LIỆU

- results/physical_summary/physical_comparison.md
- results/sta_summary/sta_comparison.md
- results/power_summary/power_comparison.md
- results/ppa_summary/ppa_comparison.md
- results/ppa_root_cause/cell_and_timing_comparison.md
- demo/DEMO3_LAYOUT_PPA.md
- demo/DEFENSE_RUNBOOK.md

SLIDE_CONTENT_DRAFT_READY
