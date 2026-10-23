# CHƯƠNG 6. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN

## 6.1. Kết luận

### 6.1.1. Tổng kết mục tiêu nghiên cứu

Đề tài đã thực hiện thiết kế,
kiểm chứng và đánh giá hai kiến trúc
FIFO đồng bộ bằng quy trình ASIC
sử dụng các công cụ EDA mã nguồn mở.

Hai kiến trúc được khảo sát gồm:

- FIFO A: Count-based FIFO.
- FIFO B: Extended-pointer FIFO.

Cả hai sử dụng cấu hình
DATA_WIDTH bằng 8 bit
và DEPTH bằng 16 phần tử.

Mục tiêu clock được lựa chọn
là 50 MHz, tương ứng
chu kỳ clock 20 ns.

Hai kiến trúc được phát triển
từ mô tả RTL,
kiểm chứng chức năng
và đưa qua các bước
synthesis, STA và physical design.

Quá trình triển khai được thực hiện
trên công nghệ SKY130A
với thư viện sky130_fd_sc_hd.

Kết quả cuối cùng bao gồm
các báo cáo kỹ thuật
và dữ liệu layout GDSII
của hai kiến trúc.

Như vậy, đề tài đã xây dựng
được quy trình thực nghiệm
để khảo sát mối quan hệ
giữa kiến trúc RTL
và các chỉ tiêu Power,
Performance và Area.

### 6.1.2. Kết quả kiểm chứng chức năng

Hai kiến trúc được kiểm chứng
bằng testbench và scoreboard.

Các trường hợp kiểm thử
bao gồm hoạt động đọc, ghi,
quản lý trạng thái full và empty,
reset và các tình huống biên.

Mỗi kiến trúc được kiểm thử
với sáu seed regression.

Tổng cộng hai kiến trúc
đã hoàn thành 12 lượt regression.

Kết quả của các lượt kiểm thử
đều ghi nhận trạng thái PASS
và không phát hiện lỗi
trong phạm vi các test đã thực hiện.

Kết quả này hỗ trợ nhận xét
cả hai kiến trúc đáp ứng
đặc tả chức năng được kiểm thử.

Tuy nhiên, kiểm chứng bằng mô phỏng
không chứng minh đầy đủ
toàn bộ không gian trạng thái.

Đề tài chưa thực hiện
formal verification hoàn chỉnh.

### 6.1.3. Kết quả triển khai ASIC và PPA

Cả hai kiến trúc FIFO
đã hoàn thành các bước triển khai
trong flow ASIC được sử dụng.

Các kết quả bao gồm
netlist sau synthesis,
báo cáo timing,
báo cáo triển khai vật lý
và dữ liệu GDSII.

Đối với chỉ tiêu Area,
FIFO B có diện tích thấp hơn FIFO A
trong hai run đang khảo sát.

Die area của FIFO B
giảm khoảng 2.85%.

Core area giảm khoảng 3.50%.

Số lượng cell sau synthesis
giảm từ 600 xuống 573,
tương ứng mức giảm 4.50%.

Báo cáo synthesis còn cho thấy
diện tích standard cell của B
thấp hơn A khoảng 3.18%.

Những kết quả này cho thấy
lợi thế diện tích của FIFO B
xuất hiện từ bước tổng hợp logic
và tiếp tục được ghi nhận
sau quá trình triển khai vật lý.

Đối với chỉ tiêu Performance,
cả hai kiến trúc đáp ứng
ràng buộc clock 50 MHz
theo điều kiện STA đã phân tích.

Kết quả STA độc lập sau routing
ghi nhận minimum clock period
của FIFO A là 2.84 ns,
còn FIFO B là 3.02 ns.

Fmax được báo cáo tương ứng
là 352.34 MHz và 331.60 MHz.

Như vậy, FIFO A có Fmax
cao hơn FIFO B khoảng 6.26%
khi lấy FIFO B làm mốc.

Đây là kết quả phân tích STA,
không phải tần số đo trực tiếp
trên chip đã chế tạo.

Đối với chỉ tiêu Power,
công suất được ước lượng
từ workload streaming
với 10000 chu kỳ đo
cho mỗi kiến trúc.

Total Power của FIFO A
được báo cáo khoảng 0.715755 mW.

Giá trị tương ứng của FIFO B
là khoảng 0.712251 mW.

FIFO B có Total Power thấp hơn
khoảng 0.49% trong thí nghiệm này.

Tuy nhiên, đây là chênh lệch nhỏ
và chỉ phản ánh một workload
ở điều kiện phân tích đã chọn.

Kết quả không chứng minh
FIFO B luôn có công suất thấp hơn
trong mọi điều kiện hoạt động.

### 6.1.4. Kết quả kiểm tra vật lý

Đề tài đã thực hiện
các phép kiểm tra physical verification
theo phạm vi flow đã sử dụng.

Các báo cáo Magic DRC,
LVS, antenna và routing
không ghi nhận lỗi
trong những phép kiểm tra tương ứng.

Ngoài ra, đề tài đã thực hiện
KLayout DRC độc lập
trên dữ liệu GDSII của hai kiến trúc.

Mỗi báo cáo KLayout độc lập
ghi nhận 248 nhóm quy tắc
và 0 violation items.

Kết quả này bổ sung bằng chứng
về tính hợp lệ layout
theo bộ quy tắc được kích hoạt.

Trong các run OpenLane gốc,
RUN_KLAYOUT_DRC được đặt bằng 0.

Do đó, chỉ tiêu klayout_violations
trong metrics gốc có giá trị -1.

Giá trị -1 không được hiểu
là kết quả KLayout PASS.

Kết quả KLayout PASS được xác định
từ những báo cáo kiểm tra độc lập
đã thực hiện bổ sung.

Mỗi kiến trúc hiện vẫn còn
6 clock max-fanout violations
được ghi nhận dưới dạng QoR waiver.

Các ngoại lệ này
chưa được xử lý triệt để.

Vì vậy, đề tài không khẳng định
đã đạt sign-off đầy đủ
cho sản xuất chip.

Giới hạn về timing cũng cần
được xem xét khi đánh giá
mức độ hoàn thiện của thiết kế.

Kết quả STA độc lập sau routing
mới được phân tích tại corner TT,
nhiệt độ 25°C và điện áp 1.8 V,
với dữ liệu SPEF nominal.

Đề tài chưa thực hiện
multi-corner sign-off
để đánh giá setup và hold
ở các điều kiện PVT khác nhau.

Do đó, việc cả hai kiến trúc
đáp ứng clock mục tiêu 50 MHz
chỉ được xác nhận
trong điều kiện STA đã khảo sát.

Không thể dùng kết quả này
để khẳng định thiết kế
đáp ứng timing tại mọi corner.

### 6.1.5. Kết luận về sự đánh đổi kiến trúc

Kết quả thực nghiệm cho thấy
hai phương pháp quản lý FIFO
tạo ra sự khác biệt
về cấu trúc logic và các chỉ tiêu PPA.

FIFO B có lợi thế
về diện tích và số lượng cell
trong cấu hình đã khảo sát.

FIFO B cũng có tổng công suất
ước lượng thấp hơn một lượng nhỏ
trong workload streaming.

Ngược lại, FIFO A có Fmax
được OpenSTA báo cáo cao hơn.

Do đó, không có đủ bằng chứng
để khẳng định một kiến trúc
luôn vượt trội trên mọi tiêu chí PPA.

Khi mục tiêu ưu tiên là diện tích,
FIFO B có thể là lựa chọn phù hợp
trong điều kiện thực nghiệm hiện tại.

Khi ưu tiên Fmax
theo mô hình STA đã sử dụng,
FIFO A có thể mang lại lợi thế.

Đây là kết luận quan trọng
của đề tài: lựa chọn kiến trúc RTL
cần gắn với mục tiêu thiết kế,
các ràng buộc kỹ thuật
và điều kiện công nghệ cụ thể.

Để tổng hợp các mục tiêu nghiên cứu,
đề tài trả lời ba câu hỏi RQ1,
RQ2 và RQ3 như sau.

**Đối với RQ1 – Kiểm chứng chức năng:**

Hai kiến trúc FIFO đã vượt qua
các trường hợp kiểm thử
trong phạm vi testbench đã sử dụng.

Mỗi kiến trúc hoàn thành
6 lượt regression PASS,
tổng cộng 12/12 lượt PASS.

Không phát hiện lỗi
trong các lượt kiểm thử này.

Kết quả chứng minh khả năng
đáp ứng đặc tả chức năng
đối với các trường hợp đã kiểm tra,
nhưng không thay thế
formal verification.

**Đối với RQ2 – Triển khai ASIC:**

Cả FIFO A và FIFO B
đã được triển khai từ RTL
qua synthesis, STA
và các bước physical design
đến dữ liệu GDSII.

Hai kiến trúc đáp ứng
clock mục tiêu 50 MHz
trong điều kiện STA đã phân tích.

Magic DRC, LVS và
KLayout DRC độc lập
không ghi nhận vi phạm
theo phạm vi kiểm tra tương ứng.

Tuy nhiên, mỗi kiến trúc
vẫn còn 6 max-fanout violations
được ghi nhận bằng QoR waiver.

Đề tài cũng chưa thực hiện
multi-corner sign-off.

Vì vậy, kết quả triển khai GDSII
không đồng nghĩa với
sign-off sản xuất hoàn chỉnh.

**Đối với RQ3 – So sánh PPA:**

Sự khác biệt giữa
kiến trúc Count-based
và Extended-pointer
đã tạo ra các kết quả PPA khác nhau.

FIFO B có die area
và core area thấp hơn FIFO A.

FIFO B cũng có Total Power
ước lượng thấp hơn khoảng 0.49%
trong workload streaming đã khảo sát.

Ngược lại, FIFO A có Fmax
được OpenSTA báo cáo cao hơn
FIFO B khoảng 6.26%.

Kết quả cho thấy
không có kiến trúc nào
vượt trội tuyệt đối
trên tất cả các chỉ tiêu PPA.

Do đó, lựa chọn kiến trúc FIFO
phải dựa trên yêu cầu ưu tiên
về diện tích, timing và công suất,
cùng điều kiện công nghệ cụ thể.

## 6.2. Hướng phát triển

### 6.2.1. Mở rộng không gian thiết kế FIFO

Hướng phát triển đầu tiên
là mở rộng các tham số
DATA_WIDTH và DEPTH.

Thay vì chỉ khảo sát FIFO 16 x 8,
có thể thử nghiệm nhiều cấu hình
có độ rộng và độ sâu khác nhau.

Ví dụ, có thể khảo sát
DEPTH bằng 16, 32 hoặc 64
và nhiều giá trị DATA_WIDTH.

Mục tiêu là đánh giá
liệu xu hướng khác biệt về PPA
giữa hai kiến trúc
có được duy trì hay không.

Ngoài ra, có thể khảo sát
nhiều giá trị CLOCK_PERIOD
để đánh giá tác động
của ràng buộc timing
đến số lượng cell,
diện tích và khả năng routing.

Một hướng nghiên cứu khác
là thay bộ nhớ bằng flip-flop
sang kiến trúc sử dụng SRAM macro.

Điều này có thể tạo ra
một không gian đánh đổi mới
giữa diện tích bộ nhớ,
logic điều khiển và hiệu năng.

### 6.2.2. Mở rộng kiểm chứng và STA

Về chức năng,
có thể bổ sung formal verification
để chứng minh các thuộc tính
quan trọng của FIFO.

Những thuộc tính cần kiểm tra
bao gồm tính đúng thứ tự dữ liệu,
không đọc khi FIFO rỗng
và không ghi khi FIFO đầy
theo giao thức đã định nghĩa.

Cần mở rộng tập testbench
với các trường hợp ngẫu nhiên,
điều kiện biên và
các chuỗi giao dịch kéo dài.

Về timing,
cần phân tích thêm
nhiều process corner,
mức điện áp và nhiệt độ.

Mục tiêu là đánh giá
khả năng đáp ứng setup và hold
trong các điều kiện PVT khác nhau.

Đồng thời, cần nghiên cứu
và xử lý các max-fanout violations
đang được giữ bằng QoR waiver.

Sau khi thay đổi ràng buộc
hoặc cấu trúc thiết kế,
cần thực hiện lại
synthesis, STA, routing
và các kiểm tra vật lý liên quan.

Đây là bước quan trọng
nếu muốn tiến gần hơn
đến quy trình sign-off đầy đủ.

### 6.2.3. Hoàn thiện đánh giá công suất

Phân tích Power hiện tại
sử dụng một workload streaming
và mô phỏng gate-level zero-delay.

Để tăng độ tin cậy,
cần khảo sát thêm
nhiều mô hình hoạt động.

Các workload có thể gồm:

- Chỉ ghi dữ liệu.
- Chỉ đọc dữ liệu.
- Đọc và ghi đồng thời.
- Hoạt động ngắt quãng.
- Trạng thái nhàn rỗi.
- Các mẫu dữ liệu có mức chuyển mạch khác nhau.

Mỗi workload cần được áp dụng
tương ứng cho cả hai kiến trúc.

Cũng cần khảo sát công suất
ở những tần số hoạt động khác nhau.

Một hướng phát triển quan trọng
là sử dụng mô phỏng gate-level
có thông tin timing
để phản ánh tốt hơn
các hoạt động glitch.

Đồng thời, cần mở rộng
ước lượng công suất
sang các điều kiện PVT khác nhau.

Những thí nghiệm này
giúp đánh giá rõ hơn
mức độ ổn định của chênh lệch Power.

### 6.2.4. Mở rộng ứng dụng và phương pháp nghiên cứu

Về kiến trúc,
có thể phát triển asynchronous FIFO
sử dụng hai miền clock độc lập.

Đối với asynchronous FIFO,
cần nghiên cứu thêm
các vấn đề clock domain crossing,
đồng bộ con trỏ và metastability.

Về ứng dụng,
có thể tích hợp FIFO
vào hệ thống SoC
hoặc các khối giao tiếp dữ liệu.

Việc tích hợp sẽ giúp đánh giá
FIFO trong môi trường
có nhiều khối chức năng
và các điều kiện tải thực tế hơn.

Về phương pháp nghiên cứu,
có thể tự động hóa việc
thu thập báo cáo PPA
và tổng hợp kết quả
trên nhiều lần chạy ASIC flow.

Cần bổ sung phân tích netlist
theo các nhóm logic chức năng
để xác định rõ hơn nguyên nhân
chênh lệch số cell giữa hai kiến trúc.

Các kết quả từ nhiều lần chạy
cũng có thể được sử dụng
để đánh giá mức độ biến thiên
và tính ổn định của các chỉ tiêu PPA.

Những hướng phát triển trên
giúp mở rộng đề tài
từ phép so sánh hai FIFO 16 x 8
sang việc nghiên cứu
các phương án thiết kế bộ đệm số
với nhiều ràng buộc và mục tiêu khác nhau.
