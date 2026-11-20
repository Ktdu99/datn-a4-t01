# Báo cáo tiến độ đồ án từ tuần 1 đến mốc bằng chứng 23/10/2026

- **Đề tài:** Thiết kế và đánh giá IP FIFO từ RTL đến GDSII bằng quy trình ASIC mã nguồn mở
- **Mã đề tài:** A4-T01
- **Sinh viên:** Khổng Thị Dung
- **Branch trong repository:** `feature/fifo-ip`

> Tuần 1 bắt đầu ngày nào chưa được ghi trong `PROJECT_CHARTER.md`. Các tuần 6–11 bên dưới lấy theo `DECISION_LOG.md`. Tuần 1–5 được tổng hợp theo tài liệu Chặng 1–4 vì các file hiện có chưa ghi rõ từng hoạt động thuộc tuần nào. Bằng chứng mới nhất được tìm thấy trong ZIP là ngày 23/10/2026.

## Tuần 1–5 — Đặc tả, kiến trúc A, RTL và verification

**Trạng thái theo tài liệu chặng: Hoàn thành. Tuần cụ thể của từng hoạt động chưa được ghi.**

- Xác định FIFO đồng bộ 8 bit × 16 phần tử, giao diện và các ca kiểm thử.
- Xây dựng kiến trúc A dùng bộ đếm occupancy.
- Hiện thực RTL và testbench.
- Kiểm tra reset, ghi/đọc, FIFO đầy/rỗng, overflow/underflow, đọc-ghi đồng thời và con trỏ quay vòng.
- Tài liệu Chặng 1–4 ghi trạng thái PASS.

**Bằng chứng:**

- Đặc tả và kế hoạch kiểm thử: `docs/chang1_specification.md`
- Kiến trúc A: `docs/chang2_architecture_a.md`
- RTL A: `rtl/sync_fifo_count.v`
- Verification A: `docs/chang4_verification_a.md`
- Testbench A: `tb/tb_sync_fifo_count.sv`

## Tuần 6–8 — Chọn baseline và kiểm chứng kiến trúc B

**Trạng thái: Các quyết định và kết quả được ghi trong nhật ký.**

- Chọn FIFO A, DATA_WIDTH=8 và DEPTH=16 làm baseline.
- Chọn synthesis tại 50 MHz, SKY130A, thư viện `sky130_fd_sc_hd`, chiến lược AREA 0.
- Giữ kết quả synthesis A sau khi kiểm tra netlist và STA; hai lần chạy synthesis có kết quả và SHA-256 netlist trùng nhau.
- Tuần 7: chọn FIFO B dùng con trỏ mở rộng.
- Tuần 8: dùng cùng golden model và tập kiểm thử với FIFO A để verification FIFO B công bằng.

**Bằng chứng:**

- Synthesis/STA A: `results/synthesis_a/SYNTH_A_50MHZ/`
- Kiểm tra tái lập synthesis: `results/synthesis_a/reproducibility_a.txt`
- RTL B: `rtl/sync_fifo_pointer.v`
- Verification B: `docs/chang8_verification_b.md`
- Testbench B: `tb/tb_sync_fifo_pointer.sv`

## Tuần 9 — Physical implementation FIFO B

**Trạng thái: Hoàn thành theo báo cáo đã lưu.**

- Dùng cấu hình OpenLane tương đương FIFO A, chỉ thay top module và file RTL.
- FIFO B hoàn thành physical flow và xuất GDSII.
- DRC, LVS và antenna PASS theo báo cáo.
- Còn 6 vi phạm max-fanout trên clock, được ghi nhận bằng QoR waiver.

**Ngày bằng chứng:** 16/10/2026.

**Bằng chứng:**

- Cấu hình B: `openlane/sync_fifo_pointer_phys/config.json`
- Kết quả physical B: `results/physical_b/PHYS_B_50MHZ/`
- GDSII B: `results/physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds`

## Tuần 10 — So sánh PPA A/B

**Trạng thái: Hoàn thành theo báo cáo so sánh.**

- So sánh hai kiến trúc dưới cùng PDK, thư viện, clock và constraint.
- FIFO B có diện tích và số cell synthesis thấp hơn.
- FIFO A có Fmax được báo cáo cao hơn theo STA.
- Chưa kết luận một kiến trúc thắng tuyệt đối trên mọi chỉ số.

**Ngày bằng chứng:** 16/10/2026.

**Bằng chứng:**

- Bảng PPA: `results/ppa_comparison/ppa_ab.csv`
- Tóm tắt PPA: `results/ppa_comparison/ppa_ab_summary.txt`
- Báo cáo PPA: `results/ppa_summary/ppa_comparison.md`
- Biểu đồ: `docs/figures/ppa_ab_normalized.png`

## Tuần 11 — Regression, power, STA và kết luận PPA

**Trạng thái: Có báo cáo và bằng chứng cho các phân tích chính.**

- Regression cơ sở: FIFO A/B đạt tổng 12/12 lượt PASS, không có lỗi.
- Bổ sung ước lượng power với workload streaming 10.000 chu kỳ:
  - FIFO A: khoảng 0.715755 mW.
  - FIFO B: khoảng 0.712251 mW.
  - Đây là ước lượng từ VCD zero-delay và nominal SPEF, không phải đo trên silicon.
- STA độc lập sau routing ghi nhận cả hai kiến trúc đạt constraint 50 MHz:
  - FIFO A: Fmax báo cáo 352.34 MHz.
  - FIFO B: Fmax báo cáo 331.60 MHz.
- Kết luận: FIFO B có lợi thế diện tích và power ước lượng trong workload đã đo; FIFO A có Fmax báo cáo cao hơn.

**Ngày bằng chứng:** 22/10/2026.

**Bằng chứng:**

- Regression A/B: `results/verification_summary/regression_summary.txt`
- Power: `results/power_summary/power_comparison.md`
- STA: `results/sta_summary/sta_comparison.md`
- Tổng hợp PPA: `results/ppa_summary/ppa_comparison.md`

## Công việc sau tuần 11 đến mốc bằng chứng mới nhất

**Ngày bằng chứng:** 23/10/2026. Tuần cụ thể chưa được ghi.

- T16: 16/16 lượt PASS, 104.824 phép kiểm tra.
- T17: 8/8 lượt PASS, 260.985 phép kiểm tra.
- Tổng T16/T17: 24 lượt PASS, 52.303 chu kỳ, 365.809 phép kiểm tra, 0 lỗi.
- T17 là so sánh dựa trên mô phỏng, không phải formal equivalence.
- Có báo cáo kiểm tra nội dung luận văn và rà soát bố cục Word.

**Bằng chứng:**

- T16/T17: `results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md`
- Kiểm toán nội dung luận văn: `results/thesis_finalization/THESIS_MARKDOWN_FINAL_AUDIT.md`
- Rà soát bố cục: `results/thesis_finalization/LAYOUT_VISUAL_REVIEW.md`

## Tình trạng hiện tại theo tài liệu trong ZIP

**Chặng hoàn thiện: Đang thực hiện, chưa đủ căn cứ ghi PASS.**

- Báo cáo rà soát luận văn nêu còn cần bổ sung bìa và phần đầu theo mẫu trường, sau đó kiểm tra lại phân trang.
- Cần xác nhận slide và demo đã được kiểm tra ở bản cuối.
- Cần kiểm tra lại hướng dẫn tái lập, repository và trạng thái phát hành.
- `PROJECT_CHARTER.md` chưa ghi mentor phê duyệt.
- Sáu vi phạm max-fanout trên clock của mỗi kiến trúc vẫn được giữ dưới dạng QoR waiver.
- STA/power chưa phải multi-corner sign-off; power không phải số đo trên chip.

**Tài liệu trạng thái:** `docs/chang11_finalization.md`, `PROJECT_CHARTER.md` và các báo cáo trong `results/thesis_finalization/`.

## Việc cần xác nhận trước khi nộp báo cáo

1. Bổ sung ngày bắt đầu Tuần 1 để đối chiếu hoạt động với tuần thực tế.
2. Kiểm tra lại mục trong `DECISION_LOG.md` gán ngày 08/10/2026 cho cả tuần 6–8 và tuần 11.
3. Cập nhật công việc đã làm sau 23/10/2026 nếu có bằng chứng mới hơn.
4. Xác nhận trạng thái cuối của luận văn, slide, demo và phát hành repository.
