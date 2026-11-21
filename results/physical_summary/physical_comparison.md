# So sánh kết quả triển khai vật lý FIFO A và FIFO B

## 1. Thiết lập thực nghiệm

- **Thiết kế:** FIFO đồng bộ, sâu 16 phần tử, mỗi phần tử rộng 8 bit.
- **FIFO A:** Dùng bộ đếm số phần tử.
- **FIFO B:** Dùng con trỏ mở rộng.
- **Công nghệ:** SKY130A.
- **Thư viện cell chuẩn:** `sky130_fd_sc_hd`.
- **Tần số mục tiêu:** 50 MHz, tương ứng chu kỳ clock 20 ns.
- **Công cụ:** OpenLane và OpenROAD.
- **Các bước triển khai:** Quy hoạch mặt bằng (floorplan), bố trí cell (placement), tổng hợp cây clock (CTS), đi dây (routing) và kiểm tra cuối quy trình.

## 2. Kết quả triển khai vật lý

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Diện tích die (mm²) | 0,025295 | 0,024573 |
| Diện tích core (µm²) | 20.169,344 | 19.462,416 |
| Tỷ lệ sử dụng diện tích bố trí (%) | 36,68 | 36,83 |
| Số cell sau tổng hợp | 600 | 573 |
| Tổng số cell vật lý | 2.425 | 2.345 |
| Tổng chiều dài dây (µm) | 18.677 | 18.170 |
| Số via | 4.905 | 4.609 |
| WNS sau đi dây (ns) | 0,0 | 0,0 |
| TNS sau đi dây (ns) | 0,0 | 0,0 |
| Độ trễ đường tín hiệu được báo cáo (ns) | 2,37 | 2,34 |

## 3. Kết quả kiểm tra vật lý

| Hạng mục kiểm tra | FIFO A | FIFO B |
|---|---:|---:|
| Số vi phạm đi dây do TritonRoute báo cáo | 0 | 0 |
| Số vi phạm DRC do Magic báo cáo | 0 | 0 |
| Số lỗi LVS | 0 | 0 |
| Kết quả đối chiếu LVS | Mạch khớp duy nhất | Mạch khớp duy nhất |
| Số vi phạm antenna trên net | 0 | 0 |
| Số vi phạm antenna trên chân | 0 | 0 |
| Số vi phạm giới hạn slew | 0 | 0 |
| Số vi phạm giới hạn điện dung | 0 | 0 |
| Số vi phạm giới hạn fanout | 6 | 6 |

## 4. Đánh giá thời gian

Cả hai thiết kế đã hoàn thành quy trình triển khai vật lý với chu kỳ clock mục tiêu **20 ns**, tương ứng **50 MHz**.

Báo cáo sau đi dây ghi nhận WNS và TNS đều bằng **0,0 ns**. Báo cáo kiểm tra sau đi dây không ghi nhận đường setup có slack âm dưới các ràng buộc đã áp dụng.

Độ trễ đường tín hiệu được báo cáo:

- **FIFO A:** 2,37 ns, với điểm cuối là cổng `empty`.
- **FIFO B:** 2,34 ns, với điểm cuối là cổng `full`.

Các giá trị trên là độ trễ của những đường tín hiệu được nêu trong báo cáo vật lý. Để xác định chu kỳ clock tối thiểu và Fmax, xem [báo cáo STA độc lập](../sta_summary/sta_comparison.md).

Bộ báo cáo triển khai vật lý lưu trữ dùng cho tài liệu này chưa cung cấp riêng số liệu hold WNS và hold TNS. Kết quả hold được trình bày trong báo cáo STA độc lập.

## 5. Đánh giá vi phạm max-fanout

Cả hai thiết kế dùng cùng ràng buộc:

`MAX_FANOUT_CONSTRAINT = 10`

Mỗi thiết kế có **6 vi phạm max-fanout** trên mạng phân phối clock. Tệp `key_metrics.txt` của mỗi phương án ghi nhận các vi phạm này dưới mã `ACCEPTED_QOR_WAIVER`, tức ngoại lệ chất lượng kết quả đã được chấp nhận. Sáu vi phạm vẫn tồn tại trên mỗi thiết kế.

Báo cáo `postroute_checks.rpt` không ghi nhận vi phạm giới hạn slew hoặc điện dung.

## 6. So sánh FIFO B với FIFO A

| Chỉ số | Mức giảm của FIFO B so với FIFO A |
|---|---:|
| Diện tích die | 2,85% |
| Diện tích core | 3,50% |
| Số cell sau tổng hợp | 4,50% |
| Tổng số cell vật lý | 3,30% |
| Tổng chiều dài dây | 2,71% |
| Số via | 6,03% |

Trong các lần chạy SKY130A đã lưu, FIFO B sử dụng ít cell hơn và có diện tích die, diện tích core nhỏ hơn FIFO A. Tổng chiều dài dây và số via cũng giảm trong cấu hình được đánh giá.

## 7. Tệp bằng chứng

Các tệp sau được lưu trong thư mục `A/` và `B/` tương ứng:

- `key_metrics.txt`: Tổng hợp các chỉ số chính.
- `metrics.csv`: Bảng số liệu triển khai vật lý.
- `magic_drc.rpt`: Báo cáo kiểm tra quy tắc thiết kế.
- `lvs.txt`: Kết quả đối chiếu layout với netlist.
- `antenna.txt`: Kết quả kiểm tra antenna.
- `postroute_checks.rpt`: Báo cáo kiểm tra sau đi dây.

Mã băm của hai tệp GDSII được lưu trong `gds_sha256.txt`. Có thể mở các tệp GDSII bằng KLayout:

- [GDSII của FIFO A](../physical_a/PHYS_A_50MHZ/final/gds/sync_fifo_count.gds)
- [GDSII của FIFO B](../physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds)

## 8. Giới hạn của kết quả

- Phạm vi đánh giá là các lần triển khai vật lý SKY130A đã lưu.
- Mỗi mạng clock vẫn còn 6 vi phạm max-fanout được ghi nhận dưới dạng ngoại lệ.
- Để đánh giá hold, cần đọc thêm báo cáo STA độc lập.
- Các chỉ số thời gian và bố trí vật lý phụ thuộc vào ràng buộc, thư viện cell và điều kiện công nghệ, điện áp, nhiệt độ (PVT) của lần phân tích.
