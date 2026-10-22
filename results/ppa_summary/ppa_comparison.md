# BÁO CÁO SO SÁNH PPA HAI KIẾN TRÚC FIFO A/B

## 1. Mục tiêu

So sánh hai kiến trúc Synchronous FIFO 16x8:

- Kiến trúc A: FIFO sử dụng bộ đếm (Count-based FIFO).
- Kiến trúc B: FIFO sử dụng con trỏ mở rộng (Extended-pointer FIFO).

Các chỉ tiêu đánh giá gồm:

- Power: Công suất tiêu thụ ước tính.
- Performance: Kết quả phân tích thời gian.
- Area: Diện tích triển khai.
- Functional Verification: Kiểm thử chức năng.
- Physical Verification: Kiểm tra thiết kế vật lý.

## 2. Môi trường thực nghiệm

| Thông số | Giá trị |
|---|---|
| Công nghệ | Sky130A |
| Thư viện standard cell | sky130_fd_sc_hd |
| Công cụ thiết kế vật lý | OpenLane / OpenROAD |
| Tần số mục tiêu | 50 MHz |
| Chu kỳ clock | 20 ns |
| Điều kiện phân tích công suất | TT, 25°C, 1.80 V |
| Workload đo công suất | Streaming |
| Số chu kỳ đo công suất | 10000 |
| Hoạt động chuyển mạch | Gate-level zero-delay VCD |
| Ký sinh đường dây | Nominal SPEF |

## 3. So sánh diện tích (Area)

| Chỉ tiêu | FIFO A | FIFO B | Thay đổi của B so với A |
|---|---:|---:|---:|
| Diện tích die (mm²) | 0.025295 | 0.024573 | -2.85% |
| Diện tích core (µm²) | 20169.344 | 19462.416 | -3.50% |
| Số cell sau synthesis | 600 | 573 | -4.50% |
| Tổng số cell vật lý | 2425 | 2345 | -3.30% |
| Độ dài dây nối (µm) | 18677 | 18170 | -2.71% |
| Số via | 4905 | 4609 | -6.03% |

Nhận xét:

Kiến trúc B có diện tích die và core nhỏ hơn kiến trúc A.

Số lượng cell, tổng độ dài dây nối và số via của B
cũng thấp hơn trong các lần triển khai đã lưu.

Điều này cho thấy kiến trúc B có lợi thế về tài nguyên
vật lý đối với cấu hình FIFO 16x8 đang khảo sát.

## 4. So sánh thời gian (Performance)

### 4.1. Kết quả từ Physical Design

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Chu kỳ clock mục tiêu (ns) | 20 | 20 |
| Post-route WNS được báo cáo (ns) | 0.0 | 0.0 |
| Post-route TNS được báo cáo (ns) | 0.0 | 0.0 |
| Độ trễ đường được báo cáo (ns) | 2.37 | 2.34 |
| Số đường setup có slack âm được báo cáo | 0 | 0 |

Các báo cáo Physical Design không ghi nhận setup slack âm.

Đường được báo cáo của FIFO A có endpoint `empty`,
trong khi FIFO B có endpoint `full`.

Không sử dụng trực tiếp các giá trị 2.37 ns và
2.34 ns để suy ra Fmax, vì đây không nhất thiết
là các đường giới hạn chu kỳ clock.

### 4.2. Kết quả STA độc lập sau Routing

STA được thực hiện bằng OpenROAD/OpenSTA với
DEF sau Routing, SDC và SPEF nominal.

Điều kiện phân tích: SKY130A, thư viện
`sky130_fd_sc_hd`, corner TT, 25°C, 1.8 V.

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Setup worst slack (ns) | +13.380897 | +13.414628 |
| Setup TNS (ns) | 0.0 | 0.0 |
| Hold worst slack (ns) | +0.340383 | +0.301747 |
| Hold TNS (ns) | 0.0 | 0.0 |
| Minimum clock period báo cáo (ns) | 2.84 | 3.02 |
| Fmax OpenSTA báo cáo (MHz) | 352.34 | 331.60 |
| Setup tại 50 MHz | MET | MET |
| Hold tại 50 MHz | MET | MET |

Worst slack trong bảng STA là giá trị có dấu
được OpenSTA trả về. WNS bằng 0 trong bảng
Physical Design thể hiện cách báo cáo không
có slack âm, không mâu thuẫn với worst slack dương.

FIFO B có Setup worst slack lớn hơn khoảng
0.033731 ns. FIFO A có Hold worst slack
lớn hơn khoảng 0.038636 ns.

Theo `report_clock_min_period`, FIFO A có
Fmax được báo cáo cao hơn FIFO B khoảng 6.26%.

Kết quả Fmax là ước lượng STA trong điều kiện
đang xét, không phải tần số đo trên silicon.

Cả hai kiến trúc không xuất hiện cảnh báo
từ `check_setup -verbose`. Tuy nhiên, điều này
chưa chứng minh đầy đủ độ bao phủ timing.

Chưa thực hiện phân tích đa corner và chưa
đạt mức xác nhận sign-off STA hoàn chỉnh.

## 5. So sánh công suất (Power)

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Internal Power (mW) | 0.493997 | 0.488578 |
| Switching Power (mW) | 0.221753 | 0.223667 |
| Leakage Power (nW) | 5.460372 | 5.384078 |
| Total Power (mW) | 0.715755 | 0.712251 |

Nhận xét:

Tổng công suất ước tính của FIFO B thấp hơn
FIFO A khoảng 0.49%.

Kiến trúc B có Internal Power thấp hơn,
nhưng Switching Power cao hơn một chút.

Chênh lệch tổng công suất tương đối nhỏ và
phụ thuộc vào hoạt động chuyển mạch của workload.

Đây là kết quả ước tính từ OpenROAD,
không phải công suất đo trực tiếp trên silicon.

Zero-delay VCD chưa mô hình hóa đầy đủ
các glitch do trễ đường truyền.

## 6. Kiểm thử chức năng

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Số seed | 6 | 6 |
| Tổng chu kỳ mô phỏng | 60992 | 60992 |
| Tổng số checks | 183000 | 183000 |
| Tổng số lỗi | 0 | 0 |
| Kết quả regression | PASS | PASS |

Tổng cộng hai kiến trúc đã thực hiện:

- 12 lượt regression.
- 121984 chu kỳ mô phỏng.
- 366000 checks.
- 0 lỗi được phát hiện.

Kết quả xác nhận cả hai kiến trúc vượt qua
các trường hợp kiểm thử đã thực hiện.

Không xem đây là bằng chứng kiểm chứng hình thức
hoặc bao phủ toàn bộ không gian trạng thái.

## 7. Kiểm tra thiết kế vật lý

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| TritonRoute violations | 0 | 0 |
| Magic DRC violations | 0 | 0 |
| LVS errors | 0 | 0 |
| Antenna net violations | 0 | 0 |
| Antenna pin violations | 0 | 0 |
| Max slew violations | 0 | 0 |
| Max capacitance violations | 0 | 0 |
| Max fanout violations | 6 | 6 |

Hai kiến trúc đều đạt các kiểm tra DRC và LVS
theo báo cáo đã lưu.

Tuy nhiên, mỗi kiến trúc còn 6 vi phạm max fanout
trên mạng phân phối clock.

Các vi phạm này được ghi nhận với trạng thái
ACCEPTED_QOR_WAIVER và chưa được loại bỏ.

Vì vậy, không kết luận toàn bộ kiểm tra vật lý
và timing đã hoàn toàn không còn vi phạm.

## 8. Đánh giá tổng hợp

Về diện tích:

Kiến trúc B có lợi thế rõ ràng hơn A trong
lần triển khai đang khảo sát.

Về thời gian:

Cả hai kiến trúc đáp ứng Setup và Hold tại
mục tiêu 50 MHz trong mô hình STA đã kiểm tra.

FIFO B có Setup worst slack nhỉnh hơn,
trong khi FIFO A có Hold worst slack lớn hơn.

Theo kết quả `report_clock_min_period`,
FIFO A có Fmax STA được báo cáo cao hơn
FIFO B (352.34 MHz so với 331.60 MHz).

Kết luận này chỉ áp dụng cho corner TT,
25°C, 1.8 V và SPEF nominal.

Về công suất:

Kiến trúc B có tổng công suất ước tính thấp hơn
khoảng 0.49% với workload Streaming.

Mức chênh lệch nhỏ, cần thêm workload để
đánh giá khả năng tiết kiệm công suất tổng quát.

Về chức năng:

Cả hai kiến trúc đều vượt qua regression
với 0 lỗi phát hiện.

## 9. Kết luận

Đối với FIFO đồng bộ 16x8 trên công nghệ Sky130A,
kiến trúc B sử dụng con trỏ mở rộng là phương án
có kết quả diện tích tốt hơn trong các lần chạy
thiết kế vật lý đã lưu.

Kiến trúc B cũng có tổng công suất ước tính
thấp hơn một lượng nhỏ trong workload Streaming.

Cả hai kiến trúc đều vượt qua kiểm thử chức năng,
DRC, LVS và đáp ứng Setup/Hold tại clock 50 MHz
trong điều kiện STA đã phân tích.

FIFO A có Fmax được OpenSTA báo cáo cao hơn
FIFO B trong corner TT với SPEF nominal.

Chưa có đủ bằng chứng để kết luận kiến trúc nào
luôn đạt tần số tối đa cao hơn hoặc luôn tiêu thụ
ít công suất hơn trong mọi điều kiện.

Kết quả so sánh cần được hiểu trong phạm vi
cấu hình, công nghệ, workload và điều kiện
thực nghiệm đã sử dụng.

## 10. Nguồn bằng chứng

- results/physical_summary/physical_comparison.md
- results/physical_summary/A/
- results/physical_summary/B/
- results/power_summary/power_comparison.md
- results/power_summary/A_power.txt
- results/power_summary/B_power.txt
- results/verification_summary/verification_summary.md
- results/verification_summary/regression_summary.txt
- results/sta_summary/sta_comparison.md
- results/sta_summary/A_sta.log
- results/sta_summary/B_sta.log
- results/sta_summary/A_check_setup.log
- results/sta_summary/B_check_setup.log
