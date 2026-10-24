# Demo 3 - ASIC Layout and PPA

## 1. Môi trường

- IP: Synchronous FIFO 8x16.
- FIFO A: Count-based.
- FIFO B: Extended-pointer.
- PDK: SKY130A.
- Standard cells: sky130_fd_sc_hd.
- Clock mục tiêu: 50 MHz (20 ns).

## 2. Mở GDSII

Chạy từ thư mục gốc repository.

FIFO A:

    klayout results/physical_a/PHYS_A_50MHZ/final/gds/sync_fifo_count.gds

FIFO B:

    klayout results/physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds

Quan sát top cell, các lớp layout, standard-cell rows
và mạng định tuyến. Không sửa hoặc ghi đè GDSII.

## 3. Kết quả thực nghiệm

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Synthesis cells | 600 | 573 |
| Synthesis mapped area (um2) | 7130.5888 | 6904.1216 |
| Core area (um2) | 20169.344 | 19462.416 |
| Die area (mm2) | 0.025295 | 0.024573 |
| Physical cells | 2425 | 2345 |
| Wire length (um) | 18677 | 18170 |
| Independent setup WNS (ns) | +13.380897 | +13.414628 |
| Independent hold WNS (ns) | +0.340383 | +0.301747 |
| Reported Fmax (MHz) | 352.34 | 331.60 |
| Estimated total power (mW) | 0.715755 | 0.712251 |

## 4. Nhận xét

- FIFO B giảm 27 synthesis standard cells.
- FIFO B giảm khoảng 3.18% synthesis mapped area.
- FIFO B giảm khoảng 3.50% core area.
- FIFO B có Fmax báo cáo thấp hơn khoảng 5.89%.
- FIFO B có estimated total power thấp hơn khoảng 0.49%.

Kết quả không chứng minh một kiến trúc tốt hơn tuyệt đối.

Các đường timing đầu tiên được liệt kê trong báo cáo
không nhất thiết quyết định chu kỳ clock tối thiểu.

Các số liệu physical WNS/TNS và independent STA WNS/TNS
thuộc những báo cáo khác nhau, không được đồng nhất.

Power là ước tính cho streaming workload 10000 cycles,
TT, 25 C, 1.8 V, nominal SPEF và zero-delay gate VCD.
Không phải số đo trên silicon.

Báo cáo physical ghi nhận DRC/LVS/antenna đạt,
nhưng có 6 max-fanout violations mỗi kiến trúc
được phân loại ACCEPTED_QOR_WAIVER.

## 5. Câu trả lời khi bảo vệ

Cùng một chức năng FIFO, hai cách xác định full/empty
tạo ra các mạng logic khác nhau. Synthesis cho thấy
FIFO B sử dụng ít cell và mapped area nhỏ hơn.

Tuy nhiên, Fmax còn chịu ảnh hưởng bởi logic trên
đường timing giới hạn và đặc tính các cell tương ứng.
Ở điều kiện STA đã đánh giá, FIFO A có Fmax cao hơn.

Chưa thể quy toàn bộ chênh lệch Fmax cho một cell
hoặc một đường logic riêng lẻ nếu không có phân tích
critical path đầy đủ.

## 6. Nguồn bằng chứng

- results/physical_summary/physical_comparison.md
- results/sta_summary/sta_comparison.md
- results/power_summary/power_comparison.md
- results/ppa_summary/ppa_comparison.md
- results/ppa_root_cause/cell_and_timing_comparison.md

DEMO_3_DOCUMENT_READY
