# Demo 3 – Xem layout ASIC và so sánh PPA

## 1. Môi trường triển khai

- **Thiết kế:** FIFO đồng bộ rộng 8 bit, sâu 16 phần tử.
- **FIFO A:** Dùng bộ đếm số phần tử để xác định trạng thái đầy và rỗng.
- **FIFO B:** Dùng con trỏ mở rộng để xác định trạng thái đầy và rỗng.
- **Bộ dữ liệu công nghệ (PDK):** SKY130A.
- **Thư viện cell chuẩn:** `sky130_fd_sc_hd`.
- **Clock mục tiêu:** 50 MHz, tương ứng chu kỳ 20 ns.

## 2. Mở layout GDSII bằng KLayout

Chạy các lệnh sau từ thư mục gốc của kho mã nguồn. Mở hai layout ở hai cửa sổ terminal riêng nếu muốn xem cùng lúc.

**FIFO A**

```bash
klayout results/physical_a/PHYS_A_50MHZ/final/gds/sync_fifo_count.gds
```

**FIFO B**

```bash
klayout results/physical_b/PHYS_B_50MHZ/final/gds/sync_fifo_pointer.gds
```

Khi trình diễn, hãy chỉ ra cell cấp cao nhất, các lớp layout, các hàng cell chuẩn và các đường đi dây. Mở GDSII để quan sát và tránh ghi đè lên tệp kết quả đã lưu.

## 3. Kết quả thực nghiệm

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Số cell sau tổng hợp | 600 | 573 |
| Tổng diện tích cell sau tổng hợp (µm²) | 7.130,5888 | 6.904,1216 |
| Diện tích vùng lõi (core, µm²) | 20.169,344 | 19.462,416 |
| Diện tích die (mm²) | 0,025295 | 0,024573 |
| Tổng số cell vật lý | 2.425 | 2.345 |
| Tổng chiều dài dây (µm) | 18.677 | 18.170 |
| Biên thời gian setup nhỏ nhất từ STA độc lập (ns) | +13,380897 | +13,414628 |
| Biên thời gian hold nhỏ nhất từ STA độc lập (ns) | +0,340383 | +0,301747 |
| Tần số tối đa được báo cáo, Fmax (MHz) | 352,34 | 331,60 |
| Tổng công suất ước lượng (mW) | 0,715755 | 0,712251 |

## 4. Nhận xét

So với FIFO A, FIFO B:

- Sử dụng ít hơn **27 cell chuẩn** sau tổng hợp.
- Giảm khoảng **3,18%** diện tích cell sau tổng hợp.
- Giảm khoảng **3,50%** diện tích vùng lõi.
- Có Fmax được báo cáo thấp hơn khoảng **5,89%**.
- Có tổng công suất ước lượng thấp hơn khoảng **0,49%** trong tải công việc đã thử.

**FIFO B có lợi thế về diện tích, còn FIFO A có Fmax được báo cáo cao hơn.** Việc chọn kiến trúc phụ thuộc vào chỉ số mà thiết kế ưu tiên.

Đường tín hiệu xuất hiện đầu tiên trong báo cáo timing có thể khác đường quyết định chu kỳ clock tối thiểu. Khi trình bày WNS và TNS, cần ghi rõ số liệu được lấy từ **báo cáo triển khai vật lý** hay **báo cáo STA độc lập**.

Công suất được ước lượng với tải truyền dữ liệu liên tục (streaming) trong **10.000 chu kỳ**, ở góc công nghệ **TT**, nhiệt độ **25 °C** và điện áp **1,8 V**. Phân tích sử dụng SPEF danh định và VCD từ mô phỏng mức cổng với độ trễ bằng 0. Chưa có số liệu đo công suất trên chip thực tế.

Báo cáo triển khai vật lý ghi nhận **DRC, LVS và kiểm tra antenna đều đạt**. Mỗi kiến trúc còn **6 vi phạm giới hạn fanout** trên mạng clock, được ghi nhận theo mã ngoại lệ `ACCEPTED_QOR_WAIVER`.

## 5. Gợi ý trả lời khi bảo vệ

> Hai FIFO có cùng chức năng, nhưng cách xác định trạng thái đầy và rỗng tạo ra hai mạng logic khác nhau. Kết quả tổng hợp cho thấy FIFO B dùng ít cell hơn và có tổng diện tích cell nhỏ hơn.
>
> Fmax còn phụ thuộc vào logic trên đường tín hiệu giới hạn thời gian và đặc tính các cell trên đường đó. Trong điều kiện STA đã đánh giá, FIFO A có Fmax được báo cáo cao hơn. Để xác định một cell hoặc một đường logic cụ thể đóng góp bao nhiêu vào chênh lệch này, cần phân tích đầy đủ đường quyết định timing.

## 6. Nguồn bằng chứng

- [So sánh triển khai vật lý](../results/physical_summary/physical_comparison.md)
- [So sánh STA sau đi dây](../results/sta_summary/sta_comparison.md)
- [So sánh công suất](../results/power_summary/power_comparison.md)
- [Báo cáo so sánh PPA](../results/ppa_summary/ppa_comparison.md)
- [Bằng chứng về cell và kết quả phân tích thời gian](../results/ppa_root_cause/cell_and_timing_comparison.md)

`DEMO_3_DOCUMENT_READY`
