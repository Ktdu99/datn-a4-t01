# BÁO CÁO PHÂN TÍCH STA SAU ROUTING – FIFO A/B

## 1. Mục tiêu

Báo cáo trình bày kết quả phân tích thời gian tĩnh (Static Timing Analysis – STA) sau Routing cho hai kiến trúc FIFO đồng bộ 16×8:

- **FIFO A:** Kiến trúc sử dụng bộ đếm số phần tử (Count-based), module `sync_fifo_count`.
- **FIFO B:** Kiến trúc sử dụng con trỏ mở rộng (Extended-pointer), module `sync_fifo_pointer`.

Mục tiêu là đánh giá khả năng đáp ứng ràng buộc thời gian tại tần số clock 50 MHz, so sánh Setup/Hold slack và xem xét sự khác biệt giữa hai kiến trúc.

## 2. Môi trường và điều kiện phân tích

| Thông số | Giá trị |
|---|---|
| Công cụ | OpenROAD / OpenSTA |
| Công nghệ | SkyWater SKY130A |
| Thư viện standard cell | `sky130_fd_sc_hd` |
| Process corner | TT (Typical-Typical) |
| Nhiệt độ | 25°C |
| Điện áp | 1,8 V |
| Clock mục tiêu | 50 MHz |
| Chu kỳ clock | 20 ns |
| Dữ liệu vật lý | DEF sau Routing |
| Dữ liệu ký sinh | SPEF nominal |
| Ràng buộc timing | SDC sau Routing |

Phân tích sử dụng dữ liệu DEF, SDC và SPEF từ các kết quả Physical Design đã hoàn thành. Không thực hiện lại quy trình Placement, CTS hoặc Routing.

## 3. Phương pháp phân tích

Quy trình phân tích được thực hiện độc lập cho từng kiến trúc:

1. Đọc Technology LEF và Standard Cell LEF.
2. Đọc thư viện Liberty tại corner TT.
3. Nạp DEF sau Routing.
4. Nạp SDC chứa các ràng buộc timing.
5. Nạp SPEF để xét ảnh hưởng ký sinh của hệ thống dây dẫn.
6. Thực hiện `check_setup` và `check_setup -verbose`.
7. Trích xuất các đường Setup và Hold bằng `report_checks`.
8. Trích xuất worst slack và total negative slack từ OpenSTA.

Cả hai kiến trúc đều chạy thành công, không xuất hiện cảnh báo từ `check_setup -verbose` trong log kiểm tra.

Việc không xuất hiện cảnh báo không được xem là bằng chứng tuyệt đối rằng mọi đường timing đều đã được ràng buộc đầy đủ.

## 4. Kết quả STA

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Chu kỳ clock mục tiêu | 20 ns | 20 ns |
| Setup worst slack | +13,380897 ns | +13,414628 ns |
| Setup TNS | 0 ns | 0 ns |
| Hold worst slack | +0,340383 ns | +0,301747 ns |
| Hold TNS | 0 ns | 0 ns |
| Clock minimum period được báo cáo | 2,84 ns | 3,02 ns |
| Fmax được báo cáo | 352,34 MHz | 331,60 MHz |
| Kết quả Setup tại 50 MHz | MET | MET |
| Kết quả Hold tại 50 MHz | MET | MET |

Các giá trị worst slack ở bảng trên là giá trị có dấu do OpenSTA trả về. Vì không có slack âm, Setup TNS và Hold TNS của cả hai kiến trúc đều bằng 0.

## 5. Phân tích Setup Timing

### 5.1. FIFO A

- Setup worst slack: **+13,380897 ns**.
- Đường Setup có slack nhỏ nhất trong báo cáo: từ `_1045_` đến đầu ra `empty`.
- Các đường tiếp theo được báo cáo liên quan đến đầu ra `full` và tín hiệu `wr_en`.

### 5.2. FIFO B

- Setup worst slack: **+13,414628 ns**.
- Đường Setup có slack nhỏ nhất trong báo cáo: từ `_984_` đến đầu ra `full`.
- Các đường tiếp theo được báo cáo liên quan đến đầu ra `empty` và `rd_data[4]`.

### 5.3. So sánh

FIFO B có Setup worst slack lớn hơn FIFO A khoảng **0,033731 ns**.

Chênh lệch này nhỏ so với chu kỳ clock mục tiêu 20 ns. Cả hai kiến trúc đều đáp ứng yêu cầu Setup tại 50 MHz trong điều kiện phân tích đã sử dụng.

## 6. Phân tích Hold Timing

### 6.1. FIFO A

- Hold worst slack: **+0,340383 ns**.
- Đường Hold có slack nhỏ nhất trong báo cáo: từ `_1037_` đến `_1037_`.

### 6.2. FIFO B

- Hold worst slack: **+0,301747 ns**.
- Đường Hold có slack nhỏ nhất trong báo cáo: từ `_980_` đến `_981_`.

### 6.3. So sánh

FIFO A có Hold worst slack lớn hơn FIFO B khoảng **0,038636 ns**.

Cả hai kiến trúc đều có Hold worst slack dương và Hold TNS bằng 0, cho thấy không phát hiện vi phạm Hold trong mô hình STA hiện tại.

## 7. Đánh giá tần số clock

OpenSTA báo cáo:

- FIFO A: minimum clock period **2,84 ns**, tương ứng Fmax **352,34 MHz**.
- FIFO B: minimum clock period **3,02 ns**, tương ứng Fmax **331,60 MHz**.

Theo kết quả `report_clock_min_period`, FIFO A có Fmax được báo cáo cao hơn FIFO B khoảng **6,26%**.

Cần phân biệt Fmax do STA ước lượng với tần số hoạt động được đo trên chip thực tế. Các kết quả trên chỉ có ý nghĩa trong mô hình và điều kiện phân tích đang xét.

Ngoài ra, worst Setup slack tổng thể và minimum clock period không nhất thiết được quyết định bởi cùng một đường timing, do có thể bao gồm các ràng buộc đầu vào/đầu ra khác nhau.

## 8. Giới hạn phân tích

- Chỉ phân tích tại corner TT, 25°C và 1,8 V.
- Sử dụng SPEF nominal từ kết quả Routing.
- Chưa thực hiện phân tích đa corner cho các trường hợp nhanh/chậm khác nhau.
- Chưa chứng minh đầy đủ độ bao phủ của mọi đường timing chưa được ràng buộc.
- Kết quả Fmax là kết quả phân tích tĩnh, không phải phép đo trên silicon.
- Báo cáo không thay thế cho quy trình sign-off STA hoàn chỉnh.

## 9. Kết luận

Phân tích STA sau Routing cho thấy cả FIFO A và FIFO B đều đáp ứng ràng buộc clock 50 MHz trong điều kiện TT, 25°C, 1,8 V và SPEF nominal.

FIFO B có Setup worst slack nhỉnh hơn FIFO A, trong khi FIFO A có Hold worst slack lớn hơn và Fmax được OpenSTA báo cáo cao hơn.

Kết quả STA bổ sung bằng chứng định lượng cho việc so sánh hai kiến trúc FIFO, đồng thời cho thấy cần tiếp tục phân tích đa corner nếu muốn đưa ra kết luận về khả năng đáp ứng timing trong toàn bộ điều kiện vận hành.
