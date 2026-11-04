# CÂU HỎI PHẢN BIỆN - FIFO A/B RTL ĐẾN GDSII

## Kiến thức và kiến trúc FIFO

### Câu 1. FIFO là gì?
FIFO là bộ đệm dữ liệu hoạt động theo nguyên tắc
vào trước, ra trước.

### Câu 2. Vì sao chọn FIFO?
FIFO có cả lưu trữ và điều khiển, phù hợp để
kiểm chứng chức năng và so sánh kết quả ASIC.

### Câu 3. FIFO đồng bộ khác FIFO bất đồng bộ thế nào?
FIFO đồng bộ sử dụng một clock chung cho ghi và đọc.
FIFO bất đồng bộ sử dụng các miền clock riêng.

### Câu 4. DATA_WIDTH và DEPTH có ý nghĩa gì?
DATA_WIDTH là số bit trong mỗi phần tử.
DEPTH là số phần tử FIFO lưu được.

### Câu 5. FIFO 8x16 có bao nhiêu bit lưu trữ?
Dung lượng lưu trữ logic bằng 8 nhân 16,
tức 128 bit, chưa tính phần điều khiển.

### Câu 6. Vai trò của write pointer và read pointer?
Chúng lần lượt chỉ vị trí ghi và vị trí đọc
tiếp theo trong bộ nhớ FIFO.

### Câu 7. FIFO A xác định full/empty thế nào?
A dùng bộ đếm occupancy: bằng 0 là empty,
bằng DEPTH là full.

### Câu 8. FIFO B xác định full/empty thế nào?
B so sánh hai con trỏ mở rộng:
bằng nhau là empty; địa chỉ bằng nhau
và bit vòng khác nhau là full.

### Câu 9. Tại sao con trỏ cần wrap-around?
Để quay lại vị trí đầu bộ nhớ sau khi đến
vị trí cuối, cho phép tái sử dụng vùng nhớ.

### Câu 10. Ghi và đọc đồng thời thì sao?
Hai thao tác được xét theo quy tắc hợp lệ
của RTL. Khi cả hai cùng hợp lệ,
occupancy không thay đổi.

### Câu 11. Có thể ghi khi full không?
Một yêu cầu ghi khi full phải được xử lý theo
quy tắc thiết kế; không được làm tràn dữ liệu.
Có thể dùng cờ overflow để báo thao tác bị từ chối.

### Câu 12. Có thể đọc khi empty không?
Không có dữ liệu hợp lệ để lấy ra.
Thiết kế phải xử lý theo đặc tả và có thể báo underflow.

## Verification

### Câu 13. Reference model và scoreboard là gì?
Reference model tạo kết quả kỳ vọng;
scoreboard so sánh kết quả DUT với kỳ vọng.

### Câu 14. Directed test và random test khác nhau thế nào?
Directed test nhắm vào tình huống cụ thể.
Random test khảo sát nhiều chuỗi thao tác hơn.

### Câu 15. 365809 checks có chứng minh đúng tuyệt đối không?
Không. Đó là bằng chứng từ mô phỏng và bộ kiểm tra
đã thực hiện, không bao phủ mọi chuỗi đầu vào.

### Câu 16. Simulation equivalence khác formal equivalence?
Simulation kiểm tra những kích thích đã chạy.
Formal sử dụng phương pháp hình thức để chứng minh
thuộc tính trong phạm vi giả thiết đã mô hình hóa.

### Câu 17. Vì sao dùng GTKWave?
Để quan sát tín hiệu theo thời gian và giải thích
các trạng thái full, empty, overflow và underflow.

## ASIC Flow và STA

### Câu 18. Synthesis là gì?
Là quá trình ánh xạ RTL thành các phần tử logic
và standard cell theo công nghệ đích.

### Câu 19. Floorplan, placement, CTS, routing là gì?
Floorplan xác định bố cục; placement đặt cell;
CTS xây dựng mạng clock; routing nối các kết nối.

### Câu 20. Setup time và hold time là gì?
Setup yêu cầu dữ liệu ổn định trước cạnh clock;
hold yêu cầu dữ liệu ổn định sau cạnh clock.

### Câu 21. WNS và TNS là gì?
WNS là slack tệ nhất trong phạm vi báo cáo.
TNS là tổng phần slack âm của các đường vi phạm.

### Câu 22. Vì sao cả hai đạt timing 50 MHz?
Báo cáo STA độc lập ghi nhận setup/hold worst slack
dương dưới các ràng buộc đã kiểm tra.

### Câu 23. Tại sao FIFO B ít cell hơn nhưng Fmax thấp hơn?
Ít cell không đồng nghĩa đường timing giới hạn
nhanh hơn. Logic và đặc tính cell trên đường
tới hạn của hai kiến trúc có thể khác nhau.

### Câu 24. Vì sao setup WNS của B nhỉnh hơn nhưng Fmax thấp hơn?
Đây là các giá trị rút từ phép đánh giá khác nhau.
Không được suy Fmax chỉ từ setup WNS ở 20 ns;
cần đối chiếu báo cáo minimum period và các đường
timing được xét trong từng phép đo.

### Câu 25. Có thể lấy 1/2.34 ns làm Fmax của B không?
Không. Một path delay được liệt kê không nhất thiết
là minimum clock period của toàn thiết kế.

## Vật lý và PPA

### Câu 26. DRC là gì?
DRC kiểm tra các quy tắc hình học trong layout
theo yêu cầu công nghệ.

### Câu 27. LVS là gì?
LVS so sánh kết nối trích xuất từ layout
với netlist tham chiếu.

### Câu 28. DRC/LVS đạt mà vẫn có max-fanout?
Đó là các nhóm kiểm tra khác nhau.
Mỗi FIFO có sáu max-fanout violations trên mạng
clock được báo cáo là ACCEPTED_QOR_WAIVER.

### Câu 29. Mapped area và core area khác nhau thế nào?
Mapped area là tổng diện tích cell sau synthesis.
Core area là vùng bố trí vật lý chứa cell và
khoảng trống phục vụ placement/routing.

### Câu 30. Power được đo hay ước tính?
Được ước tính bằng OpenROAD trên workload streaming,
corner TT, 25 độ C, 1.8 V và SPEF nominal.

### Câu 31. FIFO B luôn tiết kiệm điện hơn A không?
Không. Mức giảm khoảng 0.49% chỉ áp dụng cho
workload và điều kiện đánh giá đã lưu.

### Câu 32. Đóng góp chính và hướng phát triển?
Đề tài tạo hai kiến trúc FIFO, kiểm chứng chức năng,
triển khai đến GDSII và phân tích PPA.
Hướng tiếp theo là formal equivalence, nhiều cấu hình,
PVT corner và workload, cùng tối ưu các ngoại lệ QoR.
