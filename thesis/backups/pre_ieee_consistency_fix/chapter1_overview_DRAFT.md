# CHƯƠNG 1. TỔNG QUAN ĐỀ TÀI

## 1.1. Lý do chọn đề tài

Trong các hệ thống điện tử số hiện đại, việc trao đổi và xử lý dữ liệu
giữa các khối chức năng là một yêu cầu quan trọng nhằm bảo đảm hoạt động
ổn định của toàn hệ thống. Trong quá trình truyền nhận dữ liệu, các khối
phần cứng có thể có tốc độ xử lý khác nhau hoặc phát sinh dữ liệu tại
những thời điểm không đồng đều. Do đó, việc sử dụng các bộ đệm dữ liệu
là cần thiết để lưu trữ tạm thời và điều phối quá trình trao đổi dữ liệu
giữa các khối chức năng.

FIFO (First-In, First-Out) là một cấu trúc bộ đệm hoạt động theo nguyên
tắc dữ liệu được ghi vào trước sẽ được đọc ra trước. Nhờ đặc điểm này,
FIFO được sử dụng trong nhiều hệ thống số như các bộ xử lý, hệ thống
trên chip (System-on-Chip – SoC), bộ điều khiển truyền thông và các khối
xử lý dữ liệu [1]. Đối với FIFO đồng bộ (Synchronous FIFO), các thao tác đọc
và ghi được thực hiện trong cùng một miền xung nhịp, giúp đơn giản hóa
việc điều khiển và kiểm chứng so với các cấu trúc sử dụng nhiều miền
xung nhịp.

Trong quy trình thiết kế vi mạch số, một thiết kế hoạt động đúng ở mức
RTL (Register Transfer Level) chưa đủ để khẳng định khả năng triển khai
thành phần cứng thực tế. Thiết kế còn cần được tổng hợp thành các phần
tử logic, phân tích các ràng buộc thời gian và triển khai qua các bước
thiết kế vật lý như floorplan, placement, clock tree synthesis và
routing. Bên cạnh tính đúng đắn chức năng, các chỉ số về công suất tiêu
thụ (Power), hiệu năng thời gian (Performance) và diện tích (Area),
gọi chung là PPA, có vai trò quan trọng trong việc đánh giá chất lượng
thiết kế [R2, R4].

Đối với cùng một chức năng FIFO, việc lựa chọn kiến trúc điều khiển có
thể ảnh hưởng đến tài nguyên logic, đường truyền tín hiệu và các chỉ số
PPA sau khi triển khai. Chẳng hạn, một phương án thiết kế sử dụng
bộ đếm số phần tử để theo dõi mức sử dụng FIFO và xác định trạng thái
đầy, rỗng [1].
Một phương án khác sử dụng các con trỏ đọc, ghi mở rộng để phân biệt
trạng thái đầy và rỗng [2]. Hai phương pháp có cùng mục tiêu chức năng
nhưng khác nhau về tổ chức logic điều khiển. Vì vậy, việc xây dựng và so sánh hai
kiến trúc trong cùng điều kiện công nghệ và ràng buộc thời gian có ý
nghĩa trong việc tìm hiểu mối liên hệ giữa lựa chọn kiến trúc RTL và
kết quả triển khai vật lý.

Bên cạnh đó, sự phát triển của các công cụ thiết kế điện tử tự động hóa
(Electronic Design Automation – EDA) mã nguồn mở tạo điều kiện cho việc
nghiên cứu và thực hành quy trình thiết kế ASIC từ RTL đến GDSII. Khi
kết hợp với bộ công nghệ SKY130A, các công cụ này cho phép thực hiện
những bước cơ bản của quy trình thiết kế vi mạch số, thu thập báo cáo
kỹ thuật và phân tích kết quả mà không yêu cầu chế tạo chip thực tế [R2, R3].

Xuất phát từ những cơ sở trên, đề tài “Thiết kế và đánh giá một IP FIFO
số từ RTL đến GDSII bằng quy trình EDA mã nguồn mở” được lựa chọn nhằm
thiết kế, kiểm chứng và triển khai hai kiến trúc FIFO đồng bộ có độ rộng
dữ liệu 8 bit và độ sâu 16 phần tử. Trên cơ sở sử dụng cùng thư viện
công nghệ và ràng buộc xung nhịp mục tiêu 50 MHz, đề tài tập trung đánh
giá tính đúng đắn chức năng, khả năng đáp ứng thời gian, diện tích, công
suất ước lượng và chất lượng thiết kế vật lý. Qua đó, đề tài góp phần
làm rõ ảnh hưởng của kiến trúc RTL đến kết quả thiết kế ASIC, đồng thời
xây dựng quy trình thực nghiệm có khả năng tái lập phục vụ học tập và
nghiên cứu.

## 1.2. Vấn đề cần giải quyết

Trong thiết kế vi mạch số, việc xây dựng một khối chức năng hoạt động
đúng ở mức mô tả RTL mới chỉ là bước đầu của quá trình phát triển phần
cứng. Để một IP số có thể được triển khai trong quy trình thiết kế ASIC,
thiết kế cần đáp ứng đồng thời các yêu cầu về chức năng, khả năng tổng
hợp, ràng buộc thời gian, tài nguyên phần cứng và tính hợp lệ của kết
quả thiết kế vật lý. Do đó, bài toán đặt ra không chỉ là xây dựng một
bộ đệm FIFO hoạt động đúng nguyên tắc First-In, First-Out mà còn phải
đánh giá được chất lượng của thiết kế sau khi trải qua các công đoạn
từ RTL đến GDSII [3].

Trước hết, về mặt chức năng, FIFO phải bảo đảm dữ liệu được đọc ra theo
đúng thứ tự đã ghi vào. Các thao tác ghi, đọc, ghi và đọc đồng thời,
cũng như các trường hợp FIFO đầy hoặc rỗng cần được xử lý theo đặc tả.
Ngoài ra, thiết kế phải có cơ chế reset và các tín hiệu trạng thái phù
hợp để tránh làm sai lệch dữ liệu khi xuất hiện những yêu cầu thao tác
không hợp lệ. Việc kiểm chứng các trường hợp này đòi hỏi xây dựng
testbench tự kiểm tra, mô hình tham chiếu và các kịch bản kiểm thử bao
gồm cả những điều kiện biên.

Tiếp theo, cùng một chức năng FIFO có thể được thực hiện bằng những
kiến trúc điều khiển khác nhau. Trong phạm vi đề tài, hai phương án
được lựa chọn là kiến trúc sử dụng bộ đếm số phần tử (count-based FIFO)
và kiến trúc sử dụng con trỏ mở rộng (extended-pointer FIFO). Sự khác
biệt trong cách xác định trạng thái đầy, rỗng và tổ chức logic điều
khiển có thể dẫn đến sự khác biệt về số lượng phần tử logic, đường
truyền tín hiệu, diện tích và đặc tính thời gian sau tổng hợp cũng như
thiết kế vật lý. Vì vậy, cần xây dựng một phương pháp thực nghiệm thống
nhất để so sánh hai kiến trúc trong cùng điều kiện công nghệ và ràng
buộc thiết kế.

Bên cạnh đó, việc triển khai từ RTL đến GDSII đặt ra yêu cầu thực hiện
đầy đủ các bước cơ bản của quy trình thiết kế ASIC, bao gồm tổng hợp
logic, phân tích thời gian tĩnh, floorplan, placement, tổng hợp cây xung
nhịp và định tuyến. Kết quả thiết kế cần được kiểm tra bằng các phương
pháp như Design Rule Checking (DRC), Layout Versus Schematic (LVS) và
kiểm tra antenna. Các báo cáo sau triển khai phải cung cấp được thông
tin phục vụ đánh giá thời gian, diện tích, tài nguyên định tuyến và các
vấn đề chất lượng thiết kế còn tồn tại [R2, R5].

Một vấn đề quan trọng khác là đánh giá các chỉ số Power, Performance
và Area (PPA) một cách có cơ sở. Việc so sánh hai kiến trúc cần dựa
trên cùng bộ công nghệ, thư viện standard cell, cấu hình FIFO và ràng
buộc xung nhịp. Các số liệu về thời gian phải được phân biệt rõ giữa
báo cáo thiết kế vật lý và kết quả phân tích thời gian tĩnh sau định
tuyến [4]. Đối với công suất, kết quả ước lượng phụ thuộc vào hoạt động
chuyển mạch và điều kiện phân tích nên cần xác định rõ phạm vi áp dụng,
tránh đồng nhất kết quả mô phỏng với công suất đo được trên chip thực tế [5].

Từ những vấn đề trên, đề tài tập trung giải quyết bài toán thiết kế,
kiểm chứng và triển khai hai kiến trúc FIFO đồng bộ 16×8 trên công nghệ
SKY130A với ràng buộc xung nhịp mục tiêu 50 MHz. Trên cơ sở các kết
quả thu được, đề tài tiến hành so sánh và phân tích những khác biệt về
chức năng, thời gian, diện tích, công suất ước lượng và chất lượng thiết
kế vật lý, qua đó đánh giá ảnh hưởng của lựa chọn kiến trúc RTL trong
một quy trình ASIC mã nguồn mở có khả năng tái lập.

## 1.3. Mục tiêu nghiên cứu

### 1.3.1. Mục tiêu tổng quát

Mục tiêu tổng quát của đề tài là thiết kế, kiểm chứng và đánh giá hai
kiến trúc IP FIFO đồng bộ thông qua quy trình thiết kế vi mạch số sử
dụng các công cụ EDA mã nguồn mở, từ mức mô tả RTL đến kết quả thiết
kế vật lý GDSII.

Trên cơ sở triển khai hai kiến trúc FIFO có cùng chức năng và cấu hình,
đề tài hướng đến việc phân tích ảnh hưởng của phương pháp tổ chức logic
điều khiển đến các chỉ số công suất, hiệu năng thời gian và diện tích
(PPA). Đồng thời, đề tài xây dựng quy trình thực nghiệm có khả năng tái
lập, phục vụ việc đánh giá và so sánh các phương án thiết kế IP số.

### 1.3.2. Mục tiêu cụ thể

Để đạt được mục tiêu tổng quát, đề tài tập trung thực hiện các mục tiêu
cụ thể sau:

1. **Xây dựng đặc tả IP FIFO đồng bộ:** Xác định giao diện, tham số,
nguyên tắc hoạt động và các điều kiện biên của FIFO với độ rộng dữ liệu
8 bit và độ sâu 16 phần tử, sử dụng chung một miền xung nhịp.

2. **Thiết kế hai kiến trúc FIFO bằng RTL:** Triển khai kiến trúc A sử
dụng bộ đếm số phần tử (count-based FIFO) và kiến trúc B sử dụng con
trỏ mở rộng (extended-pointer FIFO) bằng Verilog/SystemVerilog, bảo đảm
cùng chức năng và cấu hình để phục vụ so sánh.

3. **Kiểm chứng tính đúng đắn chức năng:** Xây dựng testbench tự kiểm
tra kết hợp mô hình tham chiếu, thực hiện các kịch bản ghi, đọc, ghi và
đọc đồng thời, reset, trạng thái đầy/rỗng và các điều kiện biên. Thực
hiện kiểm thử hồi quy với nhiều seed để đánh giá tính ổn định của hai
thiết kế.

4. **Thực hiện tổng hợp logic và phân tích thời gian:** Sử dụng thư viện
standard cell `sky130_fd_sc_hd` thuộc công nghệ SKY130A để tổng hợp hai
kiến trúc, phân tích các chỉ số tài nguyên logic và thời gian, đồng thời
kiểm tra khả năng đáp ứng ràng buộc xung nhịp mục tiêu 50 MHz.

5. **Triển khai thiết kế vật lý từ RTL đến GDSII:** Thực hiện các công
đoạn floorplan, placement, clock tree synthesis và routing; tạo dữ liệu
GDSII và đánh giá kết quả kiểm tra DRC, LVS, antenna cùng các vấn đề
chất lượng thiết kế còn tồn tại.

6. **Đánh giá và so sánh các chỉ số PPA:** Thu thập và phân tích các chỉ
số diện tích, hiệu năng thời gian, tài nguyên định tuyến và công suất
ước lượng của hai kiến trúc trong cùng điều kiện thí nghiệm. Phân biệt
rõ kết quả phân tích sau định tuyến, công suất ước lượng và các giới
hạn của phương pháp đánh giá.

7. **Xây dựng tài liệu và quy trình tái lập:** Lưu trữ mã nguồn RTL,
testbench, script, báo cáo và các bằng chứng thực nghiệm; xây dựng
hướng dẫn để có thể kiểm tra lại những kết quả chính của đề tài.

Thông qua các mục tiêu trên, đề tài hướng đến việc hình thành một quy
trình thiết kế và đánh giá IP số tương đối hoàn chỉnh ở quy mô học
thuật, đồng thời cung cấp cơ sở thực nghiệm để nhận xét về ưu điểm và
hạn chế của từng kiến trúc FIFO trong điều kiện triển khai đã lựa chọn.

## 1.4. Phạm vi nghiên cứu

### 1.4.1. Đối tượng nghiên cứu

Đối tượng nghiên cứu của đề tài là IP FIFO đồng bộ (Synchronous FIFO)
được mô tả bằng ngôn ngữ Verilog/SystemVerilog và triển khai thông qua
quy trình thiết kế ASIC sử dụng các công cụ EDA mã nguồn mở.

Đề tài tập trung vào hai phương án tổ chức logic điều khiển FIFO, bao
gồm kiến trúc sử dụng bộ đếm số phần tử (count-based FIFO) và kiến trúc
sử dụng con trỏ mở rộng (extended-pointer FIFO). Hai kiến trúc được
thiết kế với cùng cấu hình và chức năng nhằm tạo cơ sở so sánh các đặc
tính sau tổng hợp và thiết kế vật lý.

### 1.4.2. Phạm vi thiết kế và triển khai

Trong phạm vi thực nghiệm, FIFO được cấu hình với độ rộng dữ liệu 8 bit
và độ sâu 16 phần tử, tương ứng dung lượng lưu trữ 128 bit. Thiết kế sử
dụng một miền xung nhịp chung cho thao tác đọc và ghi, tín hiệu reset
tích cực mức thấp và các tín hiệu điều khiển, trạng thái theo đặc tả
chức năng.

Hai kiến trúc được triển khai trên bộ công nghệ SKY130A với thư viện
standard cell `sky130_fd_sc_hd` và ràng buộc xung nhịp mục tiêu 50 MHz,
tương ứng chu kỳ 20 ns. Phần lưu trữ dữ liệu được mô tả bằng RTL và ánh
xạ sang các phần tử logic của thư viện standard cell; đề tài không sử
dụng SRAM macro chuyên dụng.

Quy trình triển khai bao gồm kiểm chứng chức năng, tổng hợp logic, phân
tích thời gian tĩnh (STA), thiết kế vật lý qua các bước floorplan,
placement, clock tree synthesis và routing, kiểm tra DRC/LVS, kiểm tra
antenna và xuất dữ liệu GDSII.

### 1.4.3. Phạm vi kiểm chứng và đánh giá

Về chức năng, đề tài sử dụng testbench tự kiểm tra kết hợp mô hình tham
chiếu để đánh giá hai kiến trúc FIFO. Các trường hợp kiểm thử bao gồm
ghi, đọc, ghi và đọc đồng thời, reset, trạng thái đầy/rỗng, các yêu cầu
thao tác không hợp lệ và những điều kiện biên. Việc kiểm thử hồi quy
được thực hiện với nhiều seed nhằm tăng khả năng phát hiện lỗi trong
các chuỗi thao tác khác nhau.

Về thời gian, đề tài phân tích các chỉ số setup/hold WNS, TNS, chu kỳ
xung nhịp tối thiểu và tần số hoạt động tối đa ước tính từ báo cáo STA
sau định tuyến. Kết quả STA được đánh giá tại điều kiện danh định TT,
nhiệt độ 25°C và điện áp 1,8 V, sử dụng dữ liệu ký sinh danh định.

Về diện tích và chất lượng thiết kế vật lý, đề tài thu thập các chỉ số
số lượng standard cell, diện tích vùng die/core, chiều dài dây dẫn, số
lượng via và kết quả kiểm tra DRC, LVS, antenna. Các vấn đề chất lượng
thiết kế còn tồn tại, bao gồm ngoại lệ liên quan đến max-fanout của
mạng xung nhịp, được ghi nhận riêng thay vì coi toàn bộ thiết kế đã đạt
sign-off đầy đủ.

Về công suất, đề tài thực hiện ước lượng dựa trên hoạt động chuyển mạch
của workload streaming trong 10.000 chu kỳ, với dữ liệu VCD từ mô phỏng
gate-level zero-delay và dữ liệu ký sinh SPEF danh định. Các thành phần
công suất được phân tích bao gồm internal power, switching power,
leakage power và total power tại điều kiện TT, 25°C, 1,8 V và tần số
50 MHz.

Việc so sánh hai kiến trúc được thực hiện trên cùng cấu hình FIFO, bộ
công nghệ, thư viện standard cell, ràng buộc thời gian và điều kiện
phân tích tương ứng nhằm hạn chế ảnh hưởng của các yếu tố không thuộc
kiến trúc.

### 1.4.4. Giới hạn của đề tài

Đề tài được thực hiện ở quy mô nghiên cứu và thực nghiệm học thuật,
với những giới hạn sau:

- Không nghiên cứu FIFO bất đồng bộ hoặc các vấn đề đồng bộ dữ liệu
  giữa nhiều miền xung nhịp (Clock Domain Crossing – CDC).
- Không sử dụng SRAM macro chuyên dụng và không khảo sát đầy đủ các
  cấu hình độ rộng dữ liệu, độ sâu FIFO khác ngoài cấu hình thực nghiệm
  16×8.
- Không thực hiện chế tạo chip, đóng gói, đo kiểm trên silicon hoặc
  đánh giá độ tin cậy của chip sau sản xuất.
- Phân tích thời gian và công suất tập trung vào điều kiện danh định;
  chưa thực hiện sign-off đa góc công nghệ, điện áp và nhiệt độ
  (multi-corner sign-off).
- Kết quả công suất chỉ phản ánh workload streaming và phương pháp
  ước lượng đã lựa chọn. Mô phỏng gate-level zero-delay không phản ánh
  đầy đủ các chuyển mạch phát sinh do trễ lan truyền.
- Kết quả thiết kế vật lý còn các ngoại lệ chất lượng liên quan đến
  max-fanout của mạng xung nhịp, được ghi nhận và xem xét trong phạm
  vi đánh giá.
- Các kết luận so sánh PPA chỉ áp dụng cho hai kiến trúc và điều kiện
  thí nghiệm đã khảo sát, không được khái quát thành ưu thế tuyệt đối
  của một kiến trúc trong mọi trường hợp.

Việc xác định rõ các giới hạn trên giúp bảo đảm tính nhất quán giữa mục
tiêu nghiên cứu, phương pháp thực nghiệm và các kết luận được rút ra từ
kết quả thiết kế.

## 1.5. Phương pháp nghiên cứu

Đề tài sử dụng phương pháp nghiên cứu kết hợp giữa nghiên cứu lý thuyết,
thiết kế hệ thống số và thực nghiệm mô phỏng trên các công cụ EDA mã
nguồn mở. Trong đó, phương pháp thực nghiệm có kiểm soát được sử dụng
để triển khai và so sánh hai kiến trúc FIFO đồng bộ dưới cùng điều kiện
công nghệ và ràng buộc thiết kế.

### 1.5.1. Nghiên cứu lý thuyết và xây dựng đặc tả

Trước tiên, đề tài nghiên cứu nguyên lý hoạt động của bộ đệm FIFO,
phương pháp quản lý trạng thái đầy/rỗng, các thao tác đọc và ghi dữ liệu,
cũng như các trường hợp hoạt động tại điều kiện biên. Đồng thời, các
kiến thức liên quan đến thiết kế vi mạch số, quy trình ASIC, phân tích
thời gian tĩnh và đánh giá PPA được tổng hợp để làm cơ sở cho việc
triển khai thực nghiệm.

Từ những nội dung lý thuyết đã nghiên cứu, đề tài xây dựng đặc tả cho
IP FIFO đồng bộ với độ rộng dữ liệu 8 bit và độ sâu 16 phần tử, xác định
các tín hiệu giao tiếp, nguyên tắc hoạt động và kế hoạch kiểm chứng
chức năng.

### 1.5.2. Thiết kế RTL và kiểm chứng chức năng

Trên cơ sở đặc tả đã xây dựng, hai kiến trúc FIFO được triển khai bằng
Verilog/SystemVerilog. Kiến trúc A sử dụng bộ đếm số phần tử để xác định
trạng thái đầy và rỗng, trong khi kiến trúc B sử dụng con trỏ đọc và
ghi mở rộng.

Để kiểm chứng chức năng, đề tài xây dựng testbench tự kiểm tra kết hợp
mô hình tham chiếu nhằm đối chiếu dữ liệu và trạng thái hoạt động của
FIFO. Các trường hợp kiểm thử bao gồm ghi, đọc, ghi và đọc đồng thời,
reset, trạng thái đầy/rỗng, thao tác không hợp lệ và các điều kiện biên.

Ngoài các kịch bản kiểm thử xác định trước, phương pháp kiểm thử hồi
quy với nhiều seed được áp dụng để đánh giá hai kiến trúc qua những
chuỗi thao tác khác nhau. Kết quả kiểm thử được ghi nhận bằng log, số
lượng lỗi và trạng thái PASS/FAIL.

### 1.5.3. Tổng hợp logic và phân tích thời gian

Sau khi hoàn thành kiểm chứng chức năng, hai thiết kế được tổng hợp với
cùng bộ công nghệ SKY130A và thư viện standard cell `sky130_fd_sc_hd`.

Các báo cáo tổng hợp được sử dụng để phân tích số lượng phần tử logic
và diện tích của thiết kế. Đồng thời, phương pháp phân tích thời gian
tĩnh (Static Timing Analysis – STA) được áp dụng để kiểm tra khả năng
đáp ứng ràng buộc xung nhịp mục tiêu 50 MHz.

Đối với kết quả sau định tuyến, các chỉ số setup/hold WNS, TNS, chu kỳ
xung nhịp tối thiểu và tần số hoạt động tối đa ước tính được sử dụng để
đánh giá đặc tính thời gian của từng kiến trúc.

### 1.5.4. Triển khai thiết kế vật lý

Hai kiến trúc FIFO được đưa qua quy trình thiết kế vật lý ASIC gồm các
công đoạn floorplan, placement, clock tree synthesis và routing.

Sau khi hoàn thành triển khai, đề tài thu thập các báo cáo về diện tích
die/core, số lượng standard cell, chiều dài dây dẫn và số lượng via.
Các bước kiểm tra DRC, LVS và antenna được thực hiện để đánh giá
mức độ đáp ứng các yêu cầu kiểm tra vật lý. Kết quả của từng phép kiểm
tra và những ngoại lệ chất lượng thiết kế còn tồn tại được ghi nhận
riêng, không đồng nhất với việc đạt sign-off đầy đủ.

Dữ liệu GDSII được tạo ra cho cả hai kiến trúc. Những vấn đề chất lượng
thiết kế còn tồn tại, đặc biệt là các ngoại lệ max-fanout của mạng xung
nhịp, được ghi nhận trong quá trình đánh giá.

### 1.5.5. Ước lượng công suất và so sánh PPA

Đề tài sử dụng hoạt động chuyển mạch thu được từ mô phỏng gate-level
zero-delay với workload streaming để thực hiện ước lượng công suất.
Quá trình phân tích sử dụng dữ liệu VCD, dữ liệu ký sinh SPEF danh định
và điều kiện công nghệ TT, 25°C, 1,8 V tại tần số 50 MHz.

Các thành phần công suất internal, switching, leakage và total power
được thu thập để phục vụ so sánh. Kết quả được xem là công suất ước
lượng trong điều kiện thực nghiệm đã lựa chọn, không phải số liệu đo
trên silicon.

Trên cơ sở các báo cáo kiểm chứng, tổng hợp, STA, thiết kế vật lý và
công suất, đề tài xây dựng bảng so sánh hai kiến trúc FIFO. Các chỉ số
được đối chiếu theo từng nhóm nhằm xác định sự khác biệt về diện tích,
hiệu năng thời gian, tài nguyên định tuyến và công suất ước lượng.

### 1.5.6. Tổng hợp kết quả và đánh giá

Cuối cùng, đề tài sử dụng phương pháp phân tích và đối chiếu kết quả
thực nghiệm để nhận xét ưu điểm, hạn chế của từng kiến trúc. Việc đánh
giá được thực hiện trên cùng cấu hình FIFO, bộ công nghệ, thư viện
standard cell và ràng buộc thiết kế.

Các kết luận được xây dựng dựa trên báo cáo và bằng chứng thực nghiệm,
đồng thời xem xét những giới hạn liên quan đến điều kiện STA danh định,
phương pháp ước lượng công suất và các ngoại lệ chất lượng thiết kế vật
lý.

Toàn bộ mã nguồn, script, log và báo cáo được tổ chức trong repository
nhằm hỗ trợ việc kiểm tra và tái lập các kết quả chính của đề tài.

## 1.6. Đóng góp của đề tài

Trong phạm vi nghiên cứu và thực nghiệm học thuật, đề tài đạt được
các kết quả kỹ thuật chính sau:

**Thứ nhất, xây dựng và triển khai hai kiến trúc IP FIFO đồng bộ có
cùng chức năng.** Đề tài thiết kế FIFO với cấu hình 16 phần tử, mỗi
phần tử có độ rộng 8 bit, sử dụng một miền xung nhịp chung. Hai kiến
trúc được triển khai gồm kiến trúc A sử dụng bộ đếm số phần tử
(count-based FIFO) và kiến trúc B sử dụng con trỏ mở rộng
(extended-pointer FIFO). Việc sử dụng cùng đặc tả chức năng tạo cơ sở
để đánh giá ảnh hưởng của cách tổ chức logic điều khiển đến kết quả
thiết kế.

**Thứ hai, xây dựng môi trường kiểm chứng chức năng có khả năng tự
động đánh giá kết quả.** Đề tài sử dụng testbench tự kiểm tra kết hợp
mô hình tham chiếu để kiểm chứng dữ liệu và trạng thái của FIFO. Các
trường hợp kiểm thử bao gồm thao tác ghi, đọc, ghi và đọc đồng thời,
reset, trạng thái đầy/rỗng và các điều kiện biên. Kiểm thử hồi quy với
nhiều seed được thực hiện cho cả hai kiến trúc nhằm cung cấp bằng chứng
về tính đúng đắn chức năng trong phạm vi các kịch bản đã khảo sát.

**Thứ ba, triển khai quy trình thiết kế ASIC từ RTL đến GDSII bằng
công cụ EDA mã nguồn mở.** Hai kiến trúc FIFO được tổng hợp và triển
khai vật lý trên công nghệ SKY130A với thư viện standard cell
`sky130_fd_sc_hd`. Quy trình bao gồm tổng hợp logic, phân tích thời
gian, floorplan, placement, clock tree synthesis, routing và kiểm tra
kết quả thiết kế vật lý. Các báo cáo DRC, LVS, antenna và dữ liệu
GDSII được sử dụng làm bằng chứng đánh giá kết quả triển khai.

**Thứ tư, xây dựng bộ kết quả thực nghiệm để so sánh PPA giữa hai
kiến trúc.** Đề tài thu thập và đối chiếu các chỉ số diện tích, số
lượng standard cell, thời gian sau định tuyến, tài nguyên định tuyến
và công suất ước lượng. Kết quả cho phép phân tích sự đánh đổi giữa
các kiến trúc trong cùng điều kiện thiết kế, thay vì chỉ đánh giá dựa
trên số lượng phần tử logic ở mức RTL hoặc tổng hợp.

**Thứ năm, ghi nhận rõ các giới hạn và điều kiện áp dụng của kết quả
đánh giá.** Đề tài phân biệt các chỉ số từ báo cáo thiết kế vật lý với
kết quả STA sau định tuyến; xác định phạm vi của ước lượng công suất
dựa trên hoạt động chuyển mạch; đồng thời ghi nhận những ngoại lệ
chất lượng thiết kế còn tồn tại. Điều này giúp các kết luận so sánh có
cơ sở và tránh khái quát vượt quá điều kiện thực nghiệm.

**Thứ sáu, tổ chức mã nguồn và bằng chứng thực nghiệm theo hướng có
khả năng tái lập.** Các thiết kế RTL, testbench, script, log và báo
cáo được lưu trữ trong repository, tạo điều kiện để kiểm tra lại các
bước thực hiện và đối chiếu những kết quả chính của đồ án.

Những đóng góp trên chủ yếu mang tính triển khai, kiểm chứng và đánh
giá thực nghiệm đối với một IP số quy mô nhỏ. Đề tài không đặt mục
tiêu đề xuất một kiến trúc FIFO hoàn toàn mới, mà tập trung làm rõ
mối liên hệ giữa lựa chọn kiến trúc RTL và kết quả triển khai ASIC
trong điều kiện nghiên cứu đã xác định.

## 1.7. Cấu trúc luận văn

Ngoài phần mở đầu, kết luận, tài liệu tham khảo và phụ lục, nội dung
chính của luận văn được tổ chức thành sáu chương như sau:

**Chương 1 – Tổng quan đề tài:** Trình bày lý do lựa chọn đề tài,
vấn đề cần giải quyết, mục tiêu nghiên cứu, phạm vi thực hiện, phương
pháp nghiên cứu và những đóng góp chính của đồ án.

**Chương 2 – Cơ sở lý thuyết:** Trình bày các kiến thức nền tảng về
thiết kế vi mạch số, IP FIFO đồng bộ, hai phương pháp quản lý trạng
thái FIFO, quy trình thiết kế ASIC từ RTL đến GDSII và các chỉ số
đánh giá PPA.

**Chương 3 – Phương pháp và thiết kế hệ thống:** Trình bày
các câu hỏi nghiên cứu, đặc tả chức năng, kiến trúc RTL của hai phương
án FIFO và môi trường kiểm chứng. Đồng thời, chương giới thiệu cấu
hình ASIC flow và phương pháp thiết kế thí nghiệm nhằm bảo đảm điều
kiện so sánh thống nhất giữa hai kiến trúc.

**Chương 4 – Kết quả thực nghiệm:** Trình bày kết quả kiểm chứng
chức năng, tổng hợp logic, phân tích thời gian tĩnh và triển khai
thiết kế vật lý của từng kiến trúc FIFO. Các báo cáo kỹ thuật, kết
quả kiểm tra DRC, LVS, antenna và dữ liệu GDSII được sử dụng để
đánh giá kết quả triển khai.

**Chương 5 – So sánh và thảo luận:** Đối chiếu kết quả thực nghiệm
giữa hai kiến trúc về diện tích, hiệu năng thời gian, tài nguyên
định tuyến và công suất ước lượng. Trên cơ sở đó, chương phân tích
những sự đánh đổi giữa các kiến trúc và trình bày giới hạn của
phương pháp đánh giá.

**Chương 6 – Kết luận và hướng phát triển:** Tổng kết các kết quả
đạt được so với mục tiêu ban đầu, nêu những hạn chế của đề tài và
đề xuất các hướng nghiên cứu, cải tiến hoặc mở rộng trong tương lai.

Cách tổ chức trên nhằm bảo đảm nội dung luận văn được trình bày theo
trình tự từ cơ sở lý thuyết, thiết kế, kiểm chứng đến triển khai vật
lý và phân tích kết quả, giúp người đọc theo dõi được toàn bộ quá
trình thực hiện đề tài.

**Trạng thái: DRAFT – IN PROGRESS.**
