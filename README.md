# DATN-A4-T01 — Thiết kế và đánh giá IP số FIFO từ RTL đến GDSII bằng quy trình ASIC mã nguồn mở

**Tên tiếng Anh:** Design and Evaluation of a Digital IP from RTL to GDSII Using an Open-Source ASIC Flow

**Mã đề tài:** A4-T01
**Sinh viên:** Khổng Thị Dung
**Giảng viên hướng dẫn:** ThS. Đinh Văn Nam
**Năm học:** 2026–2027
**Loại:** Đồ án tốt nghiệp

## 1. Giới thiệu đề tài

Đề tài tập trung thiết kế, kiểm chứng và đánh giá một IP FIFO đồng bộ (Synchronous FIFO) có độ rộng dữ liệu 8 bit và độ sâu 16 phần tử.

Hai kiến trúc được nghiên cứu:

- **FIFO A — Count-based:** Sử dụng bộ đếm số phần tử để xác định trạng thái đầy và rỗng.
- **FIFO B — Extended-pointer:** Sử dụng con trỏ đọc và ghi mở rộng để xác định trạng thái đầy và rỗng.

Hai kiến trúc được kiểm chứng chức năng và triển khai qua quy trình ASIC mã nguồn mở, từ RTL, synthesis, Static Timing Analysis (STA), floorplanning, placement, Clock Tree Synthesis (CTS), routing đến xuất layout GDSII.

Mục tiêu cuối cùng là so sánh Power, Performance và Area (PPA), đánh giá ưu nhược điểm của từng kiến trúc và lựa chọn phương án phù hợp.

## 2. Cấu hình thiết kế

| Thông số | Giá trị |
|---|---|
| Loại IP | Synchronous FIFO |
| DATA_WIDTH | 8 bit |
| DEPTH | 16 |
| Dung lượng lưu trữ | 128 bit |
| Clock mục tiêu | 50 MHz |
| Chu kỳ clock | 20 ns |
| PDK | SKY130A |
| Standard-cell library | sky130_fd_sc_hd |
| Kiến trúc A | Count-based |
| Kiến trúc B | Extended-pointer |

Các thiết kế sử dụng cùng kích thước FIFO, PDK, thư viện cell và mục tiêu clock để bảo đảm điều kiện so sánh nhất quán.

## 3. Trạng thái triển khai

| Hạng mục | Trạng thái |
|---|---|
| Đặc tả FIFO | Hoàn thành |
| RTL FIFO A/B | Hoàn thành |
| Functional verification A/B | PASS |
| Regression 6 seed mỗi kiến trúc | 12/12 PASS |
| Synthesis và STA | Hoàn thành |
| Physical implementation A/B | Hoàn thành |
| Xuất GDSII A/B | Hoàn thành |
| DRC/LVS/Antenna | PASS theo báo cáo đã lưu |
| Post-route STA | PASS tại điều kiện phân tích |
| Phân tích Power | Đã có kết quả ước lượng |
| So sánh PPA | Đã có báo cáo |
| Hoàn thiện luận văn và demo | Đang rà soát |

## 4. Môi trường và hướng dẫn chạy lại

### 4.1. Công cụ

- Linux/WSL Ubuntu.
- Icarus Verilog và `vvp`.
- Python 3.
- Yosys.
- Docker.
- OpenLane/OpenROAD.
- SKY130A PDK, thư viện `sky130_fd_sc_hd`.
- GTKWave và KLayout để xem waveform và layout khi cần.

Phiên bản công cụ, cấu hình và bằng chứng tương ứng được lưu trong các thư mục kết quả. Một số bước yêu cầu Docker image và PDK tương thích với lần chạy gốc.

### 4.2. Mô phỏng FIFO A

```bash
bash scripts/run_sim_a.sh
```

### 4.3. Mô phỏng FIFO B

```bash
bash scripts/run_sim_b.sh
```

Hai script sử dụng mặc định `SEED=20260924` và `RANDOM_CYCLES=10000`. Có thể thay đổi bằng biến môi trường.

### 4.4. Regression nhiều seed

```bash
python3 scripts/run_evidence_regression.py
```

Script kiểm chứng hai kiến trúc với sáu seed: `1`, `2`, `3`, `4`, `5`, `20260924`.

Kết quả được lưu trong `results/verification_reproduced/`.

### 4.5. Thu thập bằng chứng synthesis FIFO A

```bash
bash scripts/collect_synth_sta_a.sh
```

Lệnh này thu thập và kiểm tra kết quả từ một lần chạy OpenLane synthesis đã tồn tại. Đây không phải lệnh khởi chạy toàn bộ synthesis từ đầu.

### 4.6. Tái lập Post-route STA

```bash
bash scripts/run_postroute_sta.sh
```

Script phân tích STA cho cả FIFO A và FIFO B từ dữ liệu physical đã lưu, bao gồm DEF, SDC và SPEF.

Yêu cầu Docker, SKY130A PDK và các file đầu vào tương ứng.

Kết quả được lưu trong `results/sta_reproduced/`.

### 4.7. Phân tích Power và so sánh PPA

Các script liên quan:

- `scripts/run_power_streaming.sh`
- `scripts/run_power_analysis.sh`
- `scripts/compare_ppa_ab.py`

Các báo cáo chính:

- `results/power_summary/power_comparison.md`
- `results/ppa_summary/ppa_comparison.md`
- `results/sta_summary/sta_comparison.md`
- `results/physical_summary/physical_comparison.md`

Các script phân tích Power cần môi trường và dữ liệu hoạt động chuyển mạch tương ứng. Kết quả Power là ước lượng từ mô hình công cụ, không phải phép đo trên chip chế tạo thực tế.


### 4.8. Kiểm thử mở rộng T16 và T17

Ngoài regression cơ sở, dự án có hai nhóm kiểm thử mở rộng.

**T16 – Parameter matrix**

Lệnh chạy: `python3 scripts/run_t16_parameter_matrix.py`

- Cấu hình: (8,8), (8,16), (8,32), (16,16).
- Hai seed: 1 và 20260924.
- Kết quả: 16/16 PASS.
- Tổng số chu kỳ: 34.920.
- Tổng phép kiểm tra: 104.824.
- Errors: 0.

**T17 – Simulation-based equivalence**

Lệnh chạy: `python3 scripts/run_t17_equivalence_matrix.py`

- So sánh FIFO A và FIFO B dưới cùng kích thích.
- Đối chiếu với mô hình FIFO tham chiếu.
- Kết quả: 8/8 PASS.
- Tổng số chu kỳ: 17.383.
- Tổng phép kiểm tra: 260.985.
- Errors: 0.

Tổng hợp T16/T17: 24/24 lượt PASS,
52.303 chu kỳ, 365.809 phép kiểm tra, 0 lỗi.

Báo cáo:
`results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md`

Lưu ý: T17 là kiểm chứng tương đương dựa trên mô phỏng,
không phải formal equivalence verification.

## 5. Kết quả chính

### 5.1. Functional verification

Mỗi kiến trúc đã vượt qua sáu lần regression với các seed khác nhau, bao gồm directed tests, corner cases và random tests.

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Số seed | 6 | 6 |
| Random cycles mỗi seed | 10.000 | 10.000 |
| Kết quả | 6/6 PASS | 6/6 PASS |
| Errors | 0 | 0 |

### 5.2. Area và Physical Design

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Synthesis cells | 600 | 573 |
| Die area (mm²) | 0.025295 | 0.024573 |
| Core area (µm²) | 20,169.344 | 19,462.416 |
| Physical cells | 2.425 | 2.345 |
| Wire length (µm) | 18.677 | 18.170 |
| Via count | 4.905 | 4.609 |

FIFO B sử dụng ít cell hơn và có diện tích nhỏ hơn FIFO A trong cấu hình đã đánh giá.

### 5.3. Post-route STA

Điều kiện phân tích: SKY130A, nominal SPEF, TT, 25°C, 1.8 V, clock 20 ns.

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Setup WNS (ns) | +13.3809 | +13.4146 |
| Setup TNS (ns) | 0 | 0 |
| Hold WNS (ns) | +0.3404 | +0.3017 |
| Hold TNS (ns) | 0 | 0 |
| Minimum clock period (ns) | 2.84 | 3.02 |
| Fmax báo cáo (MHz) | 352.34 | 331.60 |

Cả hai kiến trúc đáp ứng constraint 50 MHz tại điều kiện STA đã phân tích. Theo chỉ số Fmax của OpenSTA, FIFO A có lợi thế so với FIFO B.

### 5.4. Power

Điều kiện phân tích: 50 MHz, TT, 25°C, 1.8 V, workload streaming 10.000 chu kỳ, sử dụng hoạt động chuyển mạch từ mô phỏng gate-level zero-delay.

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Internal power (mW) | 0.4939972 | 0.4885781 |
| Switching power (mW) | 0.2217526 | 0.2236671 |
| Total power (mW) | 0.7157553 | 0.7122506 |

FIFO B giảm khoảng 0,49% tổng công suất ước lượng so với FIFO A trong workload đã sử dụng.

### 5.5. Kết luận PPA

FIFO B có lợi thế về diện tích và tổng công suất ước lượng. FIFO A có Fmax báo cáo cao hơn trong phép phân tích Post-route STA.

Do đó, không có một kiến trúc vượt trội tuyệt đối trên tất cả các chỉ số PPA. Việc lựa chọn kiến trúc phụ thuộc vào mục tiêu tối ưu của ứng dụng.


### 5.6. Verification mở rộng và phân tích PPA

Kết quả kiểm thử mở rộng:

| Chỉ số | T16 | T17 | Tổng |
|---|---:|---:|---:|
| Số lượt PASS | 16 | 8 | 24 |
| Chu kỳ mô phỏng | 34.920 | 17.383 | 52.303 |
| Phép kiểm tra | 104.824 | 260.985 | 365.809 |
| Errors | 0 | 0 | 0 |

Bằng chứng:
`results/verification_summary/T16_T17_INDEPENDENT_AUDIT.md`

So sánh FIFO 8×16: diện tích và số cell sau synthesis, Fmax từ STA:

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Standard cells | 600 | 573 |
| Synthesis mapped area (µm²) | 7130.5888 | 6904.1216 |
| Fmax từ STA (MHz) | 352.34 | 331.60 |

FIFO B giảm 27 standard cell và khoảng 3,18%
diện tích mapped area, nhưng Fmax thấp hơn khoảng
5,89% so với FIFO A.

Báo cáo phân tích logic và timing:
`results/ppa_root_cause/cell_and_timing_comparison.md`

Cần phân biệt đường setup được báo cáo đầu tiên
với đường quyết định Fmax; không suy diễn rằng
hai đường này luôn giống nhau.

T17 là equivalence dựa trên mô phỏng,
không phải chứng minh hình thức.

Kết quả PPA chỉ áp dụng cho cấu hình 8x16;
các cấu hình T16/T17 khác mới được kiểm chứng
ở mức chức năng.

Hồ sơ luận văn:

- `thesis/thesis_combined_REVIEW.md`
- `thesis/export/thesis_fifo_LAYOUT_APPROVED_REVIEW.docx`
- `results/thesis_finalization/THESIS_MARKDOWN_FINAL_AUDIT.md`
- `results/thesis_finalization/LAYOUT_VISUAL_REVIEW.md`

Bản Word REVIEW có 144 trang, 36 bảng, 9 hình;
đã được người thực hiện kiểm tra dàn trang.
Phần trang đầu cần hoàn thiện theo mẫu trường.

## 6. Cấu trúc repository và hồ sơ bằng chứng

```text
rtl/         RTL của FIFO A/B
tb/          Testbench và golden model
sim/         Log và waveform mô phỏng
openlane/    Cấu hình và dữ liệu triển khai ASIC
scripts/     Script kiểm chứng, phân tích và tái lập
results/     Kết quả synthesis, STA, physical, power và PPA
docs/        Tài liệu kỹ thuật và hình minh họa
```

Tài liệu quản lý:

- `PROJECT_CHARTER.md` — Phạm vi và mục tiêu đề tài.
- `EVIDENCE_LEDGER.md` — Liên kết kết quả với bằng chứng.
- `DECISION_LOG.md` — Nhật ký quyết định thiết kế.

Tài liệu kỹ thuật chính:

- `docs/chang1_specification.md`
- `docs/synthesis_sta_a.md`
- `docs/physical_a.md`
- `docs/physical_b.md`
- `docs/chang10_ppa_comparison.md`
- `docs/chang11_finalization.md`

## 7. Giới hạn của kết quả

- Functional verification dựa trên directed tests và random regression, chưa chứng minh đầy đủ mọi trạng thái bằng formal verification.
- Post-route STA hiện được đánh giá tại điều kiện TT, 25°C, 1.8 V với nominal SPEF; chưa phải kết quả signoff đa corner.
- Cả hai kiến trúc có sáu vi phạm clock max-fanout được ghi nhận dưới dạng QoR waiver. Các vi phạm này chưa được tối ưu triệt để.
- Power được ước lượng từ workload streaming và mô phỏng gate-level zero-delay, chưa đại diện cho mọi workload hoặc công suất silicon thực tế.
- Kết quả GDSII và kiểm tra DRC/LVS được thực hiện trong môi trường PDK và công cụ mã nguồn mở; không đồng nghĩa với việc thiết kế đã được chế tạo hoặc đạt signoff công nghiệp.

## 8. Hướng phát triển

Các hướng phát triển tiếp theo bao gồm tối ưu clock tree để xử lý max-fanout, mở rộng đánh giá STA sang nhiều corner, khảo sát Power với nhiều workload, bổ sung formal verification và thử nghiệm thêm các cấu hình DATA_WIDTH/DEPTH.

Repository cung cấp RTL, testbench, cấu hình ASIC và các báo cáo kỹ thuật để phục vụ kiểm chứng, phân tích và mở rộng nghiên cứu.
