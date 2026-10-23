# Dàn ý luận văn – Thiết kế và đánh giá IP FIFO từ RTL đến GDSII

## 1. Thông tin đề tài

- Tên tiếng Việt: Thiết kế và đánh giá một IP FIFO số từ RTL đến GDSII bằng quy trình EDA mã nguồn mở.
- Tên tiếng Anh: Design and Evaluation of a Digital FIFO IP from RTL to GDSII Using an Open-Source ASIC Flow.
- Công nghệ: SKY130.
- Thư viện standard cell: `sky130_fd_sc_hd`.
- Data width: 8 bit.
- FIFO depth: 16 phần tử.
- Tần số mục tiêu: 50 MHz.
- Kiến trúc A: FIFO sử dụng bộ đếm số phần tử.
- Kiến trúc B: FIFO sử dụng con trỏ mở rộng.

## 2. Phần đầu luận văn

1. Trang bìa.
2. Trang phụ bìa.
3. Lời cam đoan.
4. Lời cảm ơn.
5. Tóm tắt tiếng Việt.
6. Abstract tiếng Anh.
7. Mục lục.
8. Danh mục từ viết tắt.
9. Danh mục hình.
10. Danh mục bảng.

## 3. Chương 1 – Tổng quan đề tài

### 1.1 Lý do chọn đề tài

Trình bày nhu cầu sử dụng FIFO trong hệ thống số, SoC, bộ đệm dữ liệu
và giao tiếp giữa các khối phần cứng.

### 1.2 Vấn đề cần giải quyết

Thiết kế FIFO không chỉ cần đúng chức năng ở RTL mà còn phải:

- Có khả năng tổng hợp.
- Đạt yêu cầu timing.
- Có diện tích hợp lý.
- Vượt qua DRC, LVS và antenna checking.
- Có thể xuất layout GDSII.

### 1.3 Mục tiêu

- Xây dựng IP synchronous FIFO có tham số.
- Kiểm chứng bằng testbench tự kiểm tra và golden model.
- Triển khai hai kiến trúc FIFO.
- Thực hiện flow RTL đến GDSII bằng công cụ mã nguồn mở.
- So sánh ảnh hưởng của kiến trúc tới area và performance.

### 1.4 Phạm vi

- FIFO đồng bộ một miền clock.
- Data width 8 bit và depth 16.
- PDK SKY130.
- Thư viện `sky130_fd_sc_hd`.
- Clock mục tiêu 50 MHz.
- Không sử dụng SRAM macro.
- Không đánh giá CDC hoặc asynchronous FIFO.
- Không kết luận power khi chưa có switching activity đủ điều kiện.

### 1.5 Phương pháp nghiên cứu

- Nghiên cứu lý thuyết FIFO và ASIC flow.
- Viết specification và test plan.
- Thiết kế RTL hai kiến trúc.
- Functional verification nhiều seed.
- Synthesis và static timing analysis.
- Physical implementation và signoff.
- So sánh kết quả trên cùng điều kiện thí nghiệm.

### 1.6 Đóng góp của đề tài

- Hai kiến trúc FIFO có cùng giao diện và chức năng.
- Môi trường verification có golden model.
- Flow RTL-to-GDSII có khả năng tái lập.
- Bộ dữ liệu so sánh A/B trên cùng PDK và constraint.

### 1.7 Cấu trúc luận văn

Tóm tắt nội dung từng chương.

## 4. Chương 2 – Cơ sở lý thuyết

### 2.1 Khái niệm FIFO

Nguyên tắc First-In First-Out và các ứng dụng.

### 2.2 Synchronous FIFO

Đặc điểm FIFO dùng chung một clock cho đọc và ghi.

### 2.3 Mảng nhớ và con trỏ

- Write pointer.
- Read pointer.
- Cơ chế quay vòng.
- Quan hệ giữa địa chỉ và trạng thái FIFO.

### 2.4 Trạng thái full và empty

- Phương pháp dùng bộ đếm.
- Phương pháp dùng con trỏ mở rộng.
- Sự khác nhau giữa bit địa chỉ và bit vòng.

### 2.5 Overflow và underflow

Điều kiện xuất hiện và cách thiết kế tín hiệu báo lỗi.

### 2.6 Đọc và ghi đồng thời

Phân tích các trường hợp:

- Chỉ ghi.
- Chỉ đọc.
- Đọc và ghi đồng thời.
- Yêu cầu ghi khi full.
- Yêu cầu đọc khi empty.

### 2.7 Quy trình thiết kế ASIC

- Specification.
- RTL design.
- Functional verification.
- Synthesis.
- Static Timing Analysis.
- Floorplan.
- Placement.
- Clock Tree Synthesis.
- Routing.
- Parasitic extraction.
- Signoff.
- GDSII.

### 2.8 Standard cell và PDK

Giải thích standard-cell library, Liberty, LEF, GDS và PDK SKY130.

### 2.9 Static Timing Analysis

- Setup time.
- Hold time.
- Slack.
- WNS và TNS.
- Clock uncertainty.
- Timing trước và sau routing.

### 2.10 Chỉ số PPA

- Power.
- Performance.
- Area.
- Giới hạn của kết luận khi chưa có dữ liệu power hợp lệ.

### 2.11 DRC, LVS và antenna

Giải thích mục đích và ý nghĩa của từng phép kiểm tra.

## 5. Chương 3 – Phương pháp và thiết kế hệ thống

### 3.1 Câu hỏi nghiên cứu

- RQ1: Hai kiến trúc FIFO có đáp ứng đúng specification không?
- RQ2: Hai kiến trúc có thể triển khai đến GDSII và đạt 50 MHz không?
- RQ3: Kiến trúc full/empty ảnh hưởng như thế nào tới area và performance?

### 3.2 Đặc tả FIFO

Trình bày giao diện, tham số, reset và quy tắc hoạt động.

### 3.3 Kiến trúc A – Count based

- Mảng nhớ.
- Read/write pointer.
- Bộ đếm `data_count`.
- Logic full và empty.
- Overflow và underflow.

### 3.4 Kiến trúc B – Extended pointer

- Mảng nhớ.
- Con trỏ mở rộng.
- Bit vòng.
- Logic so sánh full và empty.
- Khác biệt so với kiến trúc A.

### 3.5 Môi trường verification

- Testbench tự kiểm tra.
- Reference memory scoreboard.
- Directed tests.
- Random regression.
- Kiểm thử corner cases.
- Kiểm tra A/B cùng seed.

### 3.6 Cấu hình ASIC flow

- OpenLane.
- Yosys.
- OpenROAD.
- Magic.
- Netgen.
- KLayout.
- SKY130.
- Constraint 50 MHz.

### 3.7 Thiết kế thí nghiệm công bằng

Hai kiến trúc sử dụng cùng:

- Data width và depth.
- Clock period.
- PDK và standard-cell library.
- Synthesis strategy.
- Floorplan parameters.
- Verification workload.

## 6. Chương 4 – Kết quả thực nghiệm

### 4.1 Kết quả verification kiến trúc A

Trình bày test cases, regression, waveform và số lỗi.

### 4.2 Kết quả synthesis và STA kiến trúc A

- 600 standard cells.
- Cell area 7130.588800 µm².
- Setup worst slack +13.81 ns.
- Hold worst slack +0.22 ns.
- WNS và TNS bằng 0.

### 4.3 Physical implementation kiến trúc A

- Die area 0.025295218625 mm².
- Core area 20169.344 µm².
- 2425 physical cells.
- Wire length 18677 µm.
- 4905 vias.
- Critical path 2.37 ns.
- DRC, LVS và antenna đều sạch.

### 4.4 Kết quả verification kiến trúc B

- Sáu random seed.
- 10000 random cycle mỗi seed.
- Không phát hiện lỗi.
- A/B same-seed check đạt PASS.

### 4.5 Physical implementation kiến trúc B

- Die area 0.0245731929 mm².
- Core area 19462.416 µm².
- 2345 physical cells.
- Wire length 18170 µm.
- 4609 vias.
- Critical path 2.34 ns.
- DRC, LVS và antenna đều sạch.

## 7. Chương 5 – So sánh và thảo luận

### 5.1 Điều kiện so sánh

Chứng minh cấu hình A và B tương đương ngoài tên thiết kế và RTL.

### 5.2 So sánh diện tích

Kiến trúc B giảm:

- Die area 2.8544%.
- Core area 3.5050%.
- Synthesis cells 4.5000%.
- Physical cells 3.2990%.

### 5.3 So sánh performance

Critical path của B giảm 1.2658% tại cùng constraint 50 MHz.

### 5.4 So sánh routing

Kiến trúc B giảm:

- Wire length 2.7146%.
- Via count 6.0347%.

### 5.5 Giới hạn so sánh power

Không so sánh power vì chưa có VCD hoặc SAIF đủ điều kiện và chưa
xây dựng workload power thống nhất.

### 5.6 Phân tích nguyên nhân

Phân tích ảnh hưởng của logic `data_count` và logic con trỏ mở rộng
đến số cell, routing và critical path.

### 5.7 Threats to validity

- Chỉ khảo sát cấu hình 8 × 16.
- Chỉ sử dụng một PDK và một standard-cell library.
- Chỉ khảo sát constraint 50 MHz.
- Memory được ánh xạ thành flip-flop, không dùng SRAM macro.
- Chưa đánh giá power động có switching activity.

## 8. Chương 6 – Kết luận và hướng phát triển

### 6.1 Kết luận

Tóm tắt kết quả chức năng, synthesis, timing, physical implementation
và so sánh hai kiến trúc.

### 6.2 Hướng phát triển

- Thử nghiệm nhiều depth và data width.
- Thử nghiệm nhiều clock constraint.
- Đánh giá power với VCD hoặc SAIF hợp lệ.
- Dùng SRAM macro.
- Phát triển asynchronous FIFO.
- Thực hiện formal verification.
- Tích hợp FIFO vào một hệ thống SoC lớn hơn.

## 9. Tài liệu tham khảo

Chỉ sử dụng tài liệu có thể truy xuất và kiểm chứng.

Không tạo tài liệu tham khảo giả. Thông tin tác giả, tên tài liệu,
năm xuất bản, DOI và URL phải được kiểm tra trước khi đưa vào luận văn.

## 10. Phụ lục

- Specification.
- Test plan.
- RTL quan trọng.
- Kết quả regression.
- Cấu hình OpenLane.
- Báo cáo synthesis và STA.
- Báo cáo physical implementation.
- Dữ liệu so sánh PPA.
- Hướng dẫn tái lập kết quả.

## 11. Hình và bảng bắt buộc

- Sơ đồ quy trình RTL-to-GDSII.
- Sơ đồ khối kiến trúc A.
- Sơ đồ khối kiến trúc B.
- Dạng sóng verification A.
- Dạng sóng verification B.
- Layout GDSII A.
- Layout GDSII B.
- Biểu đồ so sánh PPA A/B.
- Bảng specification.
- Bảng test plan.
- Bảng synthesis và STA.
- Bảng physical implementation.
- Bảng so sánh A/B.

## 12. Kế hoạch dung lượng tham khảo

| Phần | Số trang tham khảo |
|---|---:|
| Phần đầu | 8–12 |
| Chương 1 | 5–7 |
| Chương 2 | 12–16 |
| Chương 3 | 12–16 |
| Chương 4 | 15–20 |
| Chương 5 | 8–12 |
| Chương 6 | 3–5 |
| Tài liệu tham khảo và phụ lục | Theo nội dung |

Số trang thực tế phải điều chỉnh theo quy định của trường.

**Trạng thái dàn ý luận văn: DRAFT.**
