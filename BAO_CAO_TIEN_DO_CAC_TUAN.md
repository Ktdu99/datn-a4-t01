# Báo cáo tiến độ đồ án từ tuần 1 đến tuần 11 (cập nhật 20/11/2026)

- **Đề tài:** Thiết kế và đánh giá IP FIFO từ RTL đến GDSII bằng quy trình ASIC mã nguồn mở
- **Mã đề tài:** A4-T01
- **Sinh viên:** Khổng Thị Dung
- **Branch trong repository:** `feature/fifo-ip`

> Tuần 1 bắt đầu ngày 07/09/2026; mỗi tuần tính từ thứ Hai đến Chủ nhật. Nhật ký có ngày cụ thể trong DECISION_LOG.md.

## Tiến độ theo tuần

| Tuần | Khoảng ngày | Công việc và kết quả | Bằng chứng hoặc trạng thái |
|---:|---|---|---|
| 1 | 07–13/09 | Tìm hiểu lý thuyết logic số, mạch tuần tự, FIFO đồng bộ, trạng thái đầy/rỗng, reset và thao tác đọc/ghi. | Theo xác nhận của sinh viên. |
| 2 | 14–20/09 | Tìm hiểu bộ đếm occupancy, con trỏ mở rộng, Verilog cơ bản và các bước RTL–synthesis–STA–physical design–GDSII. | Theo xác nhận của sinh viên|
| 3 | 21–27/09 | Xác định cấu hình FIFO 8 bit × 16 phần tử, giao diện, yêu cầu chức năng và ca kiểm thử. | `docs/chang1_specification.md`, `docs/test_plan.md`. Tuần cụ thể được dựng lại theo trình tự công việc. |
| 4 | 28/09–04/10 | Xây dựng kiến trúc A dùng bộ đếm occupancy; hiện thực RTL và testbench ban đầu. | `docs/chang2_architecture_a.md`, `docs/chang3_rtl_a.md`, `rtl/sync_fifo_count.v`, `tb/tb_sync_fifo_count.sv`. Tuần cụ thể được dựng lại theo trình tự công việc. |
| 5 | 05–11/10 | Kiểm chứng FIFO A; chọn baseline synthesis 50 MHz, SKY130A, `sky130_fd_sc_hd`, AREA 0; kiểm tra khả năng tái lập netlist. | `results/synthesis_a/SYNTH_A_50MHZ/`, `results/synthesis_a/reproducibility_a.txt`. |
| 6 | 12–18/10 | Chấp nhận physical FIFO A với QoR waiver; chọn FIFO B dùng con trỏ mở rộng, dùng chung golden model để verification và triển khai physical FIFO B đến GDSII. |  `docs/chang7_architecture_b.md`, `docs/chang8_verification_b.md`, `results/physical_a/`, `results/physical_b/`. Mỗi kiến trúc còn 6 vi phạm clock max-fanout được ghi nhận bằng waiver. |
| 7 | 19–25/10 | Regression A/B đạt 12/12 PASS; phân tích PPA, power streaming và STA sau routing. T16 đạt 16/16, T17 đạt 8/8 theo mô phỏng. |  `results/verification_summary/`, `results/power_summary/power_comparison.md`, `results/sta_summary/sta_comparison.md`, `results/ppa_summary/ppa_comparison.md`, `results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md`. Power là ước lượng, T17 không phải formal equivalence. |
| 8 | 26/10–01/11 | Đưa kết quả kỹ thuật vào luận văn. | Đã rà soát |
| 9 | 02–08/11 | Rà soát bìa, phần đầu, trích dẫn và phân trang luận văn. | Đã rà soát |
| 10 | 09–15/11 | Kiểm tra slide, demo và khả năng tái lập. | Đã rà soát |
| 11 — hiện tại | 16–22/11 (cập nhật đến 20/11) | Rà soát tài liệu tiến độ, hướng dẫn giảng viên, mẫu issue và các đường dẫn trong repository | Commit `4704cfe` ghi nhận đợt cập nhật repository ngày 20/11. |

## Kết quả kỹ thuật chính đến 23/10/2026

- Regression cơ sở A/B: 12/12 lượt PASS.
- T16/T17: 24/24 lượt PASS, 365.809 phép kiểm tra, 0 lỗi. T17 là kiểm chứng dựa trên mô phỏng.
- Power ước lượng với workload streaming: FIFO A khoảng 0.715755 mW, FIFO B khoảng 0.712251 mW; không phải phép đo trên silicon.
- Fmax được báo cáo từ STA: FIFO A 352.34 MHz, FIFO B 331.60 MHz. Cả hai đáp ứng constraint 50 MHz trong điều kiện phân tích đã ghi.
- FIFO B có lợi thế diện tích và power ước lượng trong workload đã đánh giá; FIFO A có Fmax cao hơn. Không kết luận một kiến trúc thắng tuyệt đối trên mọi chỉ số.

## Tình trạng cần hoàn tất trước khi báo cáo

- Hoàn thiện luận văn và kiểm tra lại phân trang theo mẫu trường.
- Xác nhận trạng thái của slide, demo và hướng dẫn tái lập.
- Nêu rõ các giới hạn: QoR waiver clock max-fanout; STA chưa phải multi-corner sign-off; power là ước lượng.
