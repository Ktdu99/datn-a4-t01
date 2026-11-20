# Nhật ký đồ án

Tuần 1 bắt đầu ngày 07/09/2026. Mỗi tuần tính từ thứ Hai đến Chủ nhật.

## Tóm tắt tiến độ tuần 1–11

Cập nhật đến 20/11/2026 theo [báo cáo tiến độ](BAO_CAO_TIEN_DO_CAC_TUAN.md).

| Tuần | Khoảng ngày | Công việc và kết quả | Bằng chứng hoặc trạng thái |
|---:|---|---|---|
| 1 | 07–13/09 | Tìm hiểu lý thuyết logic số, mạch tuần tự, FIFO đồng bộ, trạng thái đầy/rỗng, reset và thao tác đọc/ghi. | Nội dung lý thuyết theo xác nhận của sinh viên; ZIP không có nhật ký học riêng theo ngày. |
| 2 | 14–20/09 | Tìm hiểu bộ đếm occupancy, con trỏ mở rộng, Verilog cơ bản và các bước RTL–synthesis–STA–physical design–GDSII. | Nội dung lý thuyết theo xác nhận của sinh viên; ZIP không có nhật ký học riêng theo ngày. |
| 3 | 21–27/09 | Xác định cấu hình FIFO 8 bit × 16 phần tử, giao diện, yêu cầu chức năng và ca kiểm thử. | `docs/chang1_specification.md`, `docs/test_plan.md`. Tuần cụ thể được dựng lại theo trình tự công việc. |
| 4 | 28/09–04/10 | Xây dựng kiến trúc A dùng bộ đếm occupancy; hiện thực RTL và testbench ban đầu. | `docs/chang2_architecture_a.md`, `docs/chang3_rtl_a.md`, `rtl/sync_fifo_count.v`, `tb/tb_sync_fifo_count.sv`. Tuần cụ thể được dựng lại theo trình tự công việc. |
| 5 | 05–11/10 | Kiểm chứng FIFO A; chọn baseline synthesis 50 MHz, SKY130A, `sky130_fd_sc_hd`, AREA 0; kiểm tra khả năng tái lập netlist. | Nhật ký quyết định ngày 08/10; `results/synthesis_a/SYNTH_A_50MHZ/`, `results/synthesis_a/reproducibility_a.txt`. |
| 6 | 12–18/10 | Chấp nhận physical FIFO A với QoR waiver; chọn FIFO B dùng con trỏ mở rộng, dùng chung golden model để verification và triển khai physical FIFO B đến GDSII. | Nhật ký ngày 15–16/10; `docs/chang7_architecture_b.md`, `docs/chang8_verification_b.md`, `results/physical_a/`, `results/physical_b/`. Mỗi kiến trúc còn 6 vi phạm clock max-fanout được ghi nhận bằng waiver. |
| 7 | 19–25/10 | Regression A/B đạt 12/12 PASS; phân tích PPA, power streaming và STA sau routing. T16 đạt 16/16, T17 đạt 8/8 theo mô phỏng. | Nhật ký ngày 22/10 và bằng chứng T16/T17 ngày 23/10; `results/verification_summary/`, `results/power_summary/power_comparison.md`, `results/sta_summary/sta_comparison.md`, `results/ppa_summary/ppa_comparison.md`, `results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md`. Power là ước lượng, T17 không phải formal equivalence. |
| 8 | 26/10–01/11 | Hạng mục cần xác nhận: đưa kết quả kỹ thuật vào luận văn. | ZIP chưa có nhật ký tuần hoặc bằng chứng mang ngày trong khoảng này; cần bổ sung công việc thực tế nếu đã làm. |
| 9 | 02–08/11 | Hạng mục cần xác nhận: rà soát bìa, phần đầu, trích dẫn và phân trang. | Báo cáo hoàn thiện luận văn còn nêu các mục cần xử lý; chưa có nhật ký tuần cụ thể trong ZIP để xác nhận hoàn thành. |
| 10 | 09–15/11 | Hạng mục cần xác nhận: kiểm tra slide, demo và khả năng tái lập. | Trạng thái cuối cần được xác nhận bằng file/log tương ứng; ZIP chưa có nhật ký tuần cụ thể cho khoảng này. |
| 11 — hiện tại | 16–22/11 (cập nhật đến 20/11) | Rà soát tài liệu tiến độ, hướng dẫn giảng viên, mẫu issue và các đường dẫn trong repository; dọn các bản backup đã chọn xóa. | Commit `4704cfe` ghi nhận đợt cập nhật repository ngày 20/11. |

## Quyết định đã ghi nhận

| Ngày | Tuần | Quyết định | Lý do (bằng chứng nào dẫn tới) | Ai quyết |
| --- | --- | --- | --- | --- |
| 2026-10-08 | 5 | Chọn FIFO kiến trúc A dùng bộ đếm làm baseline, với DATA_WIDTH=8 và DEPTH=16 | RTL đã vượt qua directed test, corner cases và regression nhiều seed trước synthesis | Sinh viên |
| 2026-10-08 | 5 | Chọn baseline synthesis tại 50 MHz, PDK sky130A, thư viện sky130_fd_sc_hd và chiến lược AREA 0 | Đây là cấu hình ổn định để đánh giá area/timing và làm mốc so sánh với kiến trúc B | Sinh viên |
| 2026-10-08 | 5 | Giữ kết quả synthesis hiện tại và phân loại cảnh báo driver của OpenLane là false-positive | Netlist cho thấy các đầu ra đều được nối; kiểm tra lại bằng Yosys với Liberty đầy đủ báo 0 problems; STA đạt setup và hold | Sinh viên |
| 2026-10-08 | 5 | Giữ `SYNTH_A_50MHZ` làm baseline chính thức và dùng run REPRO để kiểm tra khả năng tái lập | Hai run có metrics, cấu hình và netlist hậu tổng hợp giống nhau; SHA-256 của hai netlist trùng khớp | Sinh viên |
| 2026-10-15 | 6 | Chấp nhận baseline physical FIFO A với 6 vi phạm max-fanout trên clock tree dưới dạng QoR waiver | Post-route WNS/TNS bằng 0; max slew/cap bằng 0; DRC, LVS và antenna đều PASS. Giữ nguyên RTL đã kiểm chứng và xem tối ưu CTS là hướng nghiên cứu tiếp theo | Khổng Thị Dung |
| 2026-10-15 | 6 | Chọn kiến trúc B dùng con trỏ mở rộng | Giữ nguyên giao diện FIFO A, loại bỏ bộ đếm occupancy để tạo phương án so sánh PPA công bằng | Sinh viên |
| 2026-10-15 | 6 | Dùng cùng golden model và cùng tập kiểm thử của kiến trúc A để verification kiến trúc B | Loại bỏ khác biệt do phương pháp verification và bảo đảm so sánh hai kiến trúc công bằng | Sinh viên |
| 2026-10-16 | 6 | Dùng cùng cấu hình OpenLane của kiến trúc A cho kiến trúc B và chỉ thay top module cùng file RTL | Bảo đảm so sánh PPA công bằng; 6 clock max-fanout violations được giữ dưới dạng documented QoR waiver vì timing, routing, DRC, LVS và antenna đều đạt | Sinh viên |
| 2026-10-16 | 6 | Ưu tiên kiến trúc B cho báo cáo và demo cuối kỳ | Trong cùng constraint, B giảm 4.5% cell synthesis, 3.5050% core area, 2.8544% die area và 1.2658% critical path; cả hai signoff sạch. Power chưa đủ dữ liệu nên không tuyên bố B thắng đầy đủ PPA | Sinh viên |
| 2026-10-22 | 7 | Chấp nhận kết quả regression tổng hợp FIFO A/B làm bằng chứng verification cuối kỳ | Cả hai kiến trúc vượt qua 6 seed giống nhau, tổng cộng 12/12 lượt PASS, không phát hiện lỗi; có log, manifest và checksum để truy vết. Tham chiếu E24 và `results/verification_summary/verification_summary.md` | Khổng Thị Dung |
| 2026-10-22 | 7 | Bổ sung ước lượng công suất với workload streaming vào đánh giá PPA | Tại TT, 25°C, 1.8 V và 50 MHz, tổng công suất ước lượng A là 0.715755 mW, B là 0.712251 mW; B thấp hơn khoảng 0.49%. Đây là kết quả từ zero-delay VCD và nominal SPEF, không phải đo trên silicon. Tham chiếu E25 | Khổng Thị Dung |
| 2026-10-22 | 7 | Dùng kết quả STA độc lập sau routing để đánh giá setup, hold và Fmax, không đồng nhất critical_path_ns của báo cáo physical với minimum clock period | Cả A/B đạt 50 MHz với setup/hold TNS bằng 0; Fmax được báo cáo của A là 352.34 MHz, B là 331.60 MHz. FIFO A có lợi thế Fmax khoảng 6.26% trong mô hình phân tích hiện tại. Tham chiếu E26 và E28 | Khổng Thị Dung |
| 2026-10-22 | 7 | Giữ FIFO B làm phương án minh họa tối ưu diện tích trong báo cáo và demo, đồng thời trình bày FIFO A như phương án có Fmax cao hơn; không kết luận B thắng tuyệt đối về PPA | B giảm core/die area và tổng công suất ước lượng trong workload streaming; A có Fmax được báo cáo cao hơn. Cả hai đạt 50 MHz. Kết luận giới hạn ở TT, 25°C, 1.8 V, chưa có multi-corner sign-off hoặc đo silicon; 6 clock max-fanout violations mỗi kiến trúc vẫn được ghi nhận bằng QoR waiver. Tham chiếu E21–E28 và `results/ppa_summary/ppa_comparison.md` | Khổng Thị Dung |
