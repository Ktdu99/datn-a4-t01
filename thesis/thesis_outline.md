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
- Đánh giá công suất ước lượng bằng workload streaming, gate-level zero-delay VCD và nominal SPEF tại TT, 25°C, 1.8 V, 50 MHz.
- Kết quả power chỉ đại diện cho workload và điều kiện phân tích đã chọn; không phải số liệu đo trên silicon hoặc multi-corner sign-off.

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
- Giới hạn của kết quả power ước lượng: chỉ sử dụng workload streaming,
  gate-level zero-delay VCD và nominal SPEF tại TT, 25°C, 1.8 V, 50 MHz;
  chưa đánh giá nhiều workload, glitch switching đầy đủ hoặc multi-corner PVT.

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
- Kết quả STA ở bước synthesis/implementation ban đầu:
  setup worst slack +13.81 ns và hold worst slack +0.22 ns.
- Kết quả STA độc lập sau routing tại TT, 25°C, 1.8 V:
  setup WNS +13.380897 ns, setup TNS 0;
  hold WNS +0.340383 ns, hold TNS 0.
- Minimum clock period được báo cáo: 2.84 ns.
- Fmax được báo cáo: 352.34 MHz.
- Đạt yêu cầu clock mục tiêu 50 MHz.

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

### 4.6 Kết quả STA độc lập sau routing kiến trúc B

- Điều kiện phân tích: TT, 25°C, 1.8 V, clock 50 MHz.
- Setup WNS: +13.414628 ns.
- Setup TNS: 0.
- Hold WNS: +0.301747 ns.
- Hold TNS: 0.
- Minimum clock period được báo cáo: 3.02 ns.
- Fmax được báo cáo: 331.60 MHz.
- Đạt yêu cầu clock mục tiêu 50 MHz.
- Kết quả chỉ áp dụng cho điều kiện STA đã phân tích,
  không đại diện cho multi-corner sign-off.

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

- Cả FIFO A và FIFO B đều đáp ứng clock mục tiêu 50 MHz.
- Kết quả STA độc lập sau routing tại TT, 25°C, 1.8 V:
  - FIFO A: minimum clock period 2.84 ns, Fmax 352.34 MHz.
  - FIFO B: minimum clock period 3.02 ns, Fmax 331.60 MHz.
- Fmax được báo cáo của FIFO A cao hơn FIFO B khoảng 6.26%.
- Báo cáo physical ghi critical_path_ns của A là 2.37 ns,
  B là 2.34 ns (B thấp hơn khoảng 1.27%).
- Không đồng nhất critical_path_ns trong báo cáo physical
  với minimum clock period hoặc dùng riêng chỉ số này để suy ra Fmax.
- Kết luận performance chỉ áp dụng cho điều kiện STA đã phân tích;
  chưa thực hiện multi-corner sign-off.

### 5.4 So sánh routing

Kiến trúc B giảm:

- Wire length 2.7146%.
- Via count 6.0347%.

### 5.5 So sánh công suất ước lượng

- Điều kiện: TT, 25°C, 1.8 V, clock 50 MHz.
- Workload streaming: 10000 chu kỳ đo cho mỗi kiến trúc.
- Phương pháp: gate-level zero-delay VCD kết hợp nominal SPEF.
- FIFO A:
  - Internal power: 0.4939972 mW.
  - Switching power: 0.2217526 mW.
  - Leakage power: 5.460372 nW.
  - Total power: 0.7157553 mW.
- FIFO B:
  - Internal power: 0.4885781 mW.
  - Switching power: 0.2236671 mW.
  - Leakage power: 5.384078 nW.
  - Total power: 0.7122506 mW.
- Tổng công suất ước lượng của FIFO B thấp hơn FIFO A khoảng 0.49%.
- Đây là kết quả ước lượng cho một workload streaming;
  zero-delay VCD không phản ánh đầy đủ glitch switching.
- Không xem kết quả này là công suất đo trên silicon
  hoặc kết luận power cho mọi workload và điều kiện PVT.
- Bằng chứng: `results/power_summary/power_comparison.md`.

### 5.6 Phân tích nguyên nhân

Phân tích ảnh hưởng của logic `data_count` và logic con trỏ mở rộng
đến số cell, routing và critical path.

### 5.7 Threats to validity – Giới hạn nghiên cứu

- Chỉ khảo sát cấu hình FIFO có DATA_WIDTH=8 và DEPTH=16.
- Chỉ sử dụng PDK SKY130 và thư viện `sky130_fd_sc_hd`.
- Hai kiến trúc được triển khai với clock mục tiêu 50 MHz.
- Memory được ánh xạ thành flip-flop, không sử dụng SRAM macro.
- STA độc lập sau routing được thực hiện tại TT, 25°C, 1.8 V;
  chưa có multi-corner sign-off.
- Công suất được ước lượng từ gate-level zero-delay VCD
  kết hợp nominal SPEF với một workload streaming 10000 chu kỳ.
- Zero-delay VCD không phản ánh đầy đủ glitch switching;
  chưa đánh giá nhiều workload và nhiều điều kiện PVT.
- Kết quả power là ước lượng bằng công cụ EDA,
  không phải số liệu đo trên silicon.
- Mỗi kiến trúc còn 6 clock max-fanout violations
  được ghi nhận bằng QoR waiver; không coi đây là sign-off sạch
  đối với mọi kiểm tra timing và thiết kế vật lý.
- Các kết luận so sánh chỉ áp dụng cho cấu hình,
  thư viện và điều kiện thí nghiệm đã thực hiện.

## 8. Chương 6 – Kết luận và hướng phát triển

### 6.1 Kết luận

- Thiết kế và triển khai hai kiến trúc synchronous FIFO 16 × 8:
  FIFO A dùng bộ đếm và FIFO B dùng con trỏ mở rộng.
- Verification tổng hợp: 12/12 lượt regression PASS,
  không phát hiện lỗi trong các workload đã kiểm thử.
- Cả hai kiến trúc được triển khai đến GDSII bằng ASIC flow
  mã nguồn mở trên SKY130.
- Cả hai đáp ứng yêu cầu timing tại clock mục tiêu 50 MHz.
- FIFO B giảm die area khoảng 2.85% và core area khoảng 3.51%.
- FIFO B có tổng công suất ước lượng thấp hơn khoảng 0.49%
  trong workload streaming đã phân tích.
- FIFO A có Fmax được báo cáo cao hơn FIFO B khoảng 6.26%
  theo STA độc lập sau routing.
- Không có kiến trúc thắng tuyệt đối trên tất cả chỉ số PPA.
- DRC, LVS, antenna và routing không ghi nhận lỗi trong
  các phép kiểm tra đã thực hiện; mỗi kiến trúc vẫn có
  6 clock max-fanout violations được ghi nhận bằng QoR waiver.
- Các kết luận chỉ áp dụng cho cấu hình và điều kiện
  thực nghiệm đã khảo sát.

### 6.2 Hướng phát triển

- Thử nghiệm nhiều giá trị DATA_WIDTH và DEPTH.
- Thử nghiệm nhiều clock constraint.
- Mở rộng STA sang nhiều process corner, điện áp
  và nhiệt độ để tiến tới multi-corner sign-off.
- Đánh giá power với nhiều workload và switching activity
  phản ánh chính xác hơn ảnh hưởng của glitch.
- Khảo sát power bằng mô phỏng gate-level có timing
  thay vì chỉ sử dụng zero-delay VCD.
- Nghiên cứu khắc phục clock max-fanout violations
  và đánh giá lại các chỉ số QoR.
- Khảo sát sử dụng SRAM macro thay cho flip-flop memory.
- Phát triển asynchronous FIFO và kiểm chứng CDC.
- Bổ sung formal verification.
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
