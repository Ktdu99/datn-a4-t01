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

Kiến trúc B giảm so với kiến trúc A:

- Die area: 2.8544%.
- Core area: 3.5050%.
- Số cell synthesis: 4.5000%.
- Số cell hậu physical implementation: 3.2990%.
- Chiều dài dây: 2.7146%.
- Số via: 6.0347%.
- Critical path: 1.2658%.

Cả hai kiến trúc đều:

- Đạt timing tại 50 MHz.
- Có WNS và TNS bằng 0.
- Không có lỗi TritonRoute.
- Magic DRC sạch.
- LVS sạch.
- Không có lỗi antenna.

Không kết luận kiến trúc thắng toàn diện về PPA vì chưa có dữ liệu
switching activity đủ điều kiện để so sánh công suất.

## 5. Danh sách sản phẩm Chặng 11

| Sản phẩm | Trạng thái |
|---|---|
| Luận văn hoàn chỉnh | Chưa hoàn thành |
| Slide bảo vệ | Chưa hoàn thành |
| Kịch bản demo | Chưa hoàn thành |
| Phương án demo dự phòng | Chưa hoàn thành |
| Final audit report | Chưa hoàn thành |
| Repository release | Chưa hoàn thành |

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
