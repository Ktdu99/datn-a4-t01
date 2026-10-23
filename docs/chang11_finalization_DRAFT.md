# Chặng 11 – Hoàn thiện luận văn, slide, demo và repository

## 1. Mục tiêu

Chặng 11 hoàn thiện toàn bộ sản phẩm phục vụ nộp đồ án và bảo vệ:

- Hoàn thiện nội dung luận văn.
- Hoàn thiện slide thuyết trình.
- Chuẩn bị kịch bản demo.
- Chuẩn bị phương án dự phòng khi demo.
- Kiểm tra khả năng tái lập kết quả.
- Kiểm tra repository cuối cùng.
- Đóng gói và phát hành phiên bản nộp đồ án.

## 2. Baseline kỹ thuật

| Thuộc tính | Giá trị |
|---|---|
| Repository | `datn-a4-t01` |
| Branch | `feature/fifo-ip` |
| Commit nền kỹ thuật | `0d0de8f` |
| Kiến trúc A | FIFO dùng bộ đếm |
| Kiến trúc B | FIFO dùng con trỏ mở rộng |
| Data width | 8 bit |
| FIFO depth | 16 |
| Clock mục tiêu | 50 MHz |
| PDK | SKY130 |
| Standard-cell library | `sky130_fd_sc_hd` |

## 3. Trạng thái các chặng kỹ thuật

| Chặng | Nội dung | Trạng thái |
|---:|---|---|
| 1 | Specification | PASS |
| 2 | Kiến trúc A | PASS |
| 3 | RTL phương án A | PASS |
| 4 | Verification A | PASS |
| 5 | Synthesis và STA A | PASS |
| 6 | Physical implementation và GDSII A | PASS |
| 7 | Kiến trúc và RTL B | PASS |
| 8 | Verification B | PASS |
| 9 | Physical implementation và GDSII B | PASS |
| 10 | So sánh PPA A/B | PASS |

## 4. Kết quả chính

### 4.1 Kết quả verification

- Hai kiến trúc synchronous FIFO 16 × 8 đều vượt qua regression.
- Tổng cộng 12/12 lượt regression PASS, không phát hiện lỗi
  trong các workload đã kiểm thử.

### 4.2 Kết quả area và routing

Kiến trúc B giảm so với kiến trúc A:

- Die area: 2.8544%.
- Core area: 3.5050%.
- Số cell synthesis: 4.5000%.
- Số cell hậu physical implementation: 3.2990%.
- Chiều dài dây: 2.7146%.
- Số via: 6.0347%.

Báo cáo physical ghi nhận `critical_path_ns`:

- FIFO A: 2.37 ns.
- FIFO B: 2.34 ns.
- FIFO B thấp hơn khoảng 1.2658%.

Chỉ số `critical_path_ns` trong báo cáo physical không được
đồng nhất với minimum clock period hoặc Fmax của STA độc lập.

### 4.3 Kết quả STA độc lập sau routing

Điều kiện: TT, 25°C, 1.8 V, clock mục tiêu 50 MHz,
sử dụng nominal SPEF.

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Setup WNS | +13.380897 ns | +13.414628 ns |
| Setup TNS | 0 | 0 |
| Hold WNS | +0.340383 ns | +0.301747 ns |
| Hold TNS | 0 | 0 |
| Minimum clock period | 2.84 ns | 3.02 ns |
| Fmax được báo cáo | 352.34 MHz | 331.60 MHz |

- Cả hai kiến trúc đáp ứng clock mục tiêu 50 MHz.
- Fmax được báo cáo của FIFO A cao hơn FIFO B khoảng 6.26%.
- Kết quả chưa đại diện cho multi-corner sign-off.

### 4.4 Kết quả power streaming

Điều kiện: TT, 25°C, 1.8 V, clock 50 MHz,
workload streaming 10000 chu kỳ.

Phương pháp: gate-level zero-delay VCD kết hợp nominal SPEF.

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Internal power | 0.4939972 mW | 0.4885781 mW |
| Switching power | 0.2217526 mW | 0.2236671 mW |
| Leakage power | 5.460372 nW | 5.384078 nW |
| Total power | 0.7157553 mW | 0.7122506 mW |

- FIFO B có total power ước lượng thấp hơn khoảng 0.49%.
- Đây là kết quả cho một workload và một điều kiện PVT.
- Zero-delay VCD không phản ánh đầy đủ glitch switching.
- Không xem kết quả là công suất đo trên silicon.

### 4.5 Kết quả physical verification

Cả hai kiến trúc:

- Có GDSII.
- TritonRoute violations: 0.
- Magic DRC violations: 0.
- LVS errors: 0.
- Antenna violations: 0.
- Còn 6 clock max-fanout violations mỗi kiến trúc,
  được ghi nhận bằng `ACCEPTED_QOR_WAIVER`.

### 4.6 Kết luận so sánh PPA

- FIFO B có lợi thế về diện tích và công suất ước lượng
  trong workload streaming đã khảo sát.
- FIFO A có lợi thế về Fmax được báo cáo.
- Không có kiến trúc thắng tuyệt đối trên tất cả chỉ số PPA.
- Kết luận chỉ áp dụng cho cấu hình FIFO 16 × 8,
  PDK, thư viện và điều kiện thực nghiệm đã phân tích.

## 5. Danh sách sản phẩm Chặng 11

| Sản phẩm | Trạng thái | Ghi chú |
|---|---|---|
| README dự án | Đã cập nhật | Tài liệu tổng quan repository |
| PROJECT_CHARTER | Đã cập nhật | Mục tiêu, phạm vi và tiêu chí |
| EVIDENCE_LEDGER | Đã cập nhật | Danh mục bằng chứng kỹ thuật |
| DECISION_LOG | Đã cập nhật | Các quyết định thiết kế |
| Đề cương luận văn 6 chương | Đã cập nhật | `thesis/thesis_outline.md`, commit `a9135a9` |
| Luận văn hoàn chỉnh | Chưa hoàn thành | Cần viết, rà soát và định dạng |
| Slide bảo vệ | Chưa hoàn thành | Chưa có file slide |
| Kịch bản demo | Chưa hoàn thành | Chưa có kịch bản thực hiện |
| Phương án demo dự phòng | Chưa hoàn thành | Cần chuẩn bị bằng chứng thay thế |
| Final audit report | Chưa hoàn thành | Cần kiểm tra tổng thể |
| Repository release | Chưa hoàn thành | Chưa tạo release/tag nộp đồ án |

Các tài liệu quản lý và đề cương đã được cập nhật,
nhưng chưa thay thế cho luận văn, slide hoặc demo hoàn chỉnh.

## 6. Điều kiện hoàn thành

Chặng 11 chỉ được đánh dấu PASS khi:

1. Luận văn đã được kiểm tra nội dung và hình thức.
2. Slide đã được kiểm tra bằng trình chiếu thực tế.
3. Demo chạy thành công theo kịch bản.
4. Có phương án dự phòng khi OpenLane hoặc GUI không hoạt động.
5. Repository vượt qua final audit.
6. Mọi sản phẩm đã được commit và đẩy lên GitHub.
7. Phiên bản nộp đồ án được đánh tag.

**Trạng thái Chặng 11: IN PROGRESS.**
