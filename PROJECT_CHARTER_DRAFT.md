
# Bản cam kết phạm vi đề tài

**Mã đề tài:** A4-T01
**Sinh viên:** Khổng Thị Dung
**Giảng viên hướng dẫn:** ThS. Đinh Văn Nam
**Năm học:** 2026–2027
**Ngày nhận đề tài (tuần 1 bắt đầu):** Chưa xác nhận

## Bài toán trong 3 câu

Đề tài tập trung thiết kế và kiểm chứng một IP FIFO đồng bộ có khả năng lưu trữ 16 phần tử dữ liệu, mỗi phần tử rộng 8 bit. Hai kiến trúc FIFO được triển khai bằng RTL Verilog/SystemVerilog và đưa qua quy trình ASIC mã nguồn mở từ mô phỏng chức năng đến tổng hợp, phân tích thời gian và thiết kế vật lý. Kết quả được đánh giá và so sánh dựa trên các chỉ số Power, Performance, Area (PPA), tính đúng đắn chức năng và chất lượng thiết kế vật lý.

## Đầu vào → xử lý → đầu ra

**Đầu vào:**
- Đặc tả FIFO đồng bộ 16×8.
- Các tín hiệu `clk`, `rst_n`, `wr_en`, `rd_en`, `data_in`.
- Các ràng buộc thời gian với clock mục tiêu 50 MHz.
- Thư viện công nghệ SKY130A và standard-cell library `sky130_fd_sc_hd`.

**Xử lý:**
1. Xây dựng kiến trúc FIFO A và FIFO B.
2. Viết RTL và testbench kiểm chứng chức năng.
3. Thực hiện regression với nhiều seed.
4. Tổng hợp logic và phân tích STA.
5. Thực hiện floorplan, placement, CTS, routing.
6. Kiểm tra DRC/LVS và tạo GDSII.
7. Phân tích công suất và so sánh PPA.

**Đầu ra:**
- RTL và testbench của hai kiến trúc FIFO.
- Kết quả mô phỏng và regression.
- Báo cáo synthesis, STA và physical design.
- File GDSII của FIFO A và FIFO B.
- Báo cáo công suất, bảng so sánh PPA và tài liệu tái lập.

## Baseline sẽ so sánh với

- **FIFO A — Count-based:** quản lý trạng thái đầy/rỗng bằng bộ đếm số phần tử.
- **FIFO B — Extended-pointer:** quản lý trạng thái đầy/rỗng bằng con trỏ mở rộng.

Hai phương án được đánh giá với cùng cấu hình dữ liệu, công nghệ SKY130A và ràng buộc clock 50 MHz.

## Tiêu chí đo (metric)

| Nhóm | Chỉ số |
|---|---|
| Functional | PASS/FAIL, số lỗi, số chu kỳ kiểm thử |
| Synthesis | Số cell, diện tích logic |
| Timing | Setup/hold WNS, TNS, minimum period, Fmax |
| Area | Die area, core area, utilization |
| Physical | Wire length, via count, DRC/LVS, antenna |
| Power | Internal, switching, leakage, total power |
| Reproducibility | Script, log, report và bằng chứng chạy lại |

**Điều kiện đánh giá:** Cùng PDK, thư viện standard cell và cấu hình clock. Các kết quả STA/power hiện có được đánh giá tại điều kiện danh định TT, 25°C, 1.8 V; không coi là sign-off đa góc.

## Mức chiều sâu nhắm tới

- [x] **D1 — Engineering:** cài đặt đúng, có kiểm chứng
- [x] **D2 — Research:** thí nghiệm có kiểm soát, bằng chứng tái lập
- [ ] **D3 — Publication:** có đóng góp mới, hình/bảng chuẩn bản thảo

**Ghi chú:** D1 và D2 là mức phạm vi đề xuất dựa trên công việc đã thực hiện, chưa thay thế xác nhận của giảng viên hướng dẫn.

## Phần lõi (MVT) — không bao giờ bị cắt

1. Đặc tả và sơ đồ kiến trúc FIFO 16×8.
2. RTL và testbench tự kiểm tra.
3. Regression chức năng với bằng chứng PASS/FAIL.
4. Synthesis và STA.
5. Thiết kế vật lý đến GDSII.
6. Báo cáo DRC/LVS và các ngoại lệ QoR còn tồn tại.
7. Bảng so sánh PPA của hai kiến trúc.
8. README và hướng dẫn tái lập kết quả.

## Phần mở rộng — cắt trước nếu trễ tiến độ

- Đánh giá thêm các giá trị DATA_WIDTH/DEPTH.
- Khảo sát nhiều tần số clock và mức utilization.
- Phân tích multi-corner STA và power chi tiết hơn.
- Cải thiện các vi phạm max-fanout của mạng clock.
- Mở rộng sang FIFO bất đồng bộ hoặc các kiến trúc FIFO khác.

## Kiến thức đầu vào còn thiếu và kế hoạch bù

| Nội dung cần tiếp tục củng cố | Cách bổ sung | Thời hạn |
|---|---|---|
| STA nâng cao và multi-corner | Nghiên cứu tài liệu OpenSTA, kiểm tra báo cáo timing | Theo tiến độ mở rộng |
| Power estimation và hoạt động chuyển mạch | Phân tích VCD, SAIF và các giới hạn mô hình | Theo tiến độ mở rộng |
| Clock-tree QoR và max-fanout | Phân tích CTS và các vi phạm còn tồn tại | Theo tiến độ mở rộng |
| Physical sign-off | Nghiên cứu DRC/LVS, antenna và giới hạn flow | Theo tiến độ mở rộng |

**Mentor duyệt:** Chưa xác nhận.
**Đổi phạm vi giữa kỳ (nếu có):** Ghi vào `DECISION_LOG.md`.

## Trạng thái thực hiện

Tính đến ngày 22/10/2026, hai kiến trúc FIFO đã có kết quả kiểm chứng chức năng, thiết kế vật lý đến GDSII, phân tích STA sau routing và ước lượng công suất. Các báo cáo so sánh được lưu trong thư mục `results/`, tài liệu kỹ thuật trong `docs/`.

Các kết quả hiện tại phục vụ đánh giá kỹ thuật và so sánh có kiểm soát; chưa được xem là bằng chứng silicon measurement hoặc sign-off công nghiệp đầy đủ.
