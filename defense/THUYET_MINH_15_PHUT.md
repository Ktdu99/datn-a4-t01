# KỊCH BẢN THUYẾT MINH ĐỒ ÁN TỐT NGHIỆP

Đề tài: Thiết kế và đánh giá một IP số từ RTL đến
GDSII bằng quy trình EDA mã nguồn mở.

IP khảo sát: Synchronous FIFO 8x16.
Kiến trúc A: Count-based.
Kiến trúc B: Extended-pointer.

Thời gian mục tiêu: 15 phút.
Demo trực tiếp được tính riêng.

## Slide 1 - Trang bìa (40 giây)

Kính thưa quý thầy cô trong hội đồng.

Em xin trình bày đề tài thiết kế và đánh giá
một IP số từ RTL đến GDSII bằng quy trình
EDA mã nguồn mở.

Trong đề tài, em lựa chọn FIFO đồng bộ với
hai kiến trúc là count-based và extended-pointer.

Mục tiêu không chỉ là thiết kế RTL đúng chức năng
mà còn triển khai vật lý và đánh giá sự đánh đổi
về công suất, hiệu năng và diện tích.

## Slide 2 - Đặt vấn đề (60 giây)

FIFO là một khối lưu trữ dữ liệu theo nguyên tắc
vào trước, ra trước. FIFO thường được dùng để
đệm dữ liệu giữa các khối trong hệ thống số.

Mặc dù hai thiết kế có thể thực hiện cùng một
chức năng, cách tổ chức logic điều khiển khác nhau
có thể dẫn đến các kết quả phần cứng khác nhau.

Do đó, đề tài đặt ra câu hỏi: Khi thay đổi
kiến trúc xác định trạng thái đầy và rỗng,
diện tích, timing và công suất sau triển khai
ASIC thay đổi như thế nào?

## Slide 3 - Mục tiêu và phạm vi (60 giây)

Đề tài thiết kế hai kiến trúc FIFO đồng bộ,
xây dựng testbench tự kiểm tra và triển khai
quy trình ASIC từ RTL đến GDSII.

Cấu hình dùng để đánh giá PPA là độ rộng
dữ liệu 8 bit và độ sâu 16 phần tử.

Công nghệ sử dụng là SKY130A với thư viện
standard cell sky130_fd_sc_hd.

Tần số mục tiêu là 50 MHz, tương ứng chu kỳ
clock 20 ns.

Phạm vi thực nghiệm tập trung vào so sánh
hai kiến trúc trong cùng điều kiện đánh giá.

## Slide 4 - Quy trình thực hiện (65 giây)

Quy trình bắt đầu từ đặc tả chức năng, thiết kế
RTL và kiểm chứng bằng mô phỏng.

Sau khi đạt yêu cầu kiểm chứng, hai thiết kế
được tổng hợp thành netlist standard cell.

Tiếp theo là phân tích thời gian và các bước
thiết kế vật lý gồm floorplan, placement,
clock tree synthesis và routing.

Sau routing, đề tài kiểm tra kết quả vật lý,
phân tích STA với dữ liệu ký sinh và tạo GDSII.

Các báo cáo cuối cùng được sử dụng để
so sánh Area, Timing và Power của hai FIFO.

## Slide 5 - Đặc tả FIFO (50 giây)

FIFO có độ rộng dữ liệu 8 bit, độ sâu 16 phần tử
và dung lượng lưu trữ logic 128 bit.

Thiết kế sử dụng chung một clock cho hoạt động
ghi và đọc.

Các tín hiệu chính gồm wr_en, rd_en,
dữ liệu đầu vào, dữ liệu đầu ra, full và empty.

Những tình huống quan trọng cần xử lý là
reset, ghi đến đầy, đọc đến rỗng, quay vòng
địa chỉ, ghi đọc đồng thời và thao tác không hợp lệ.

Hai kiến trúc cùng tuân theo đặc tả này.

## Slide 6 - FIFO A count-based (75 giây)

Ở kiến trúc FIFO A, trạng thái FIFO được
theo dõi bằng một bộ đếm số phần tử hiện có.

Write pointer chỉ vị trí ghi tiếp theo,
read pointer chỉ vị trí đọc tiếp theo.

Khi bộ đếm bằng 0, FIFO ở trạng thái empty.
Khi bộ đếm bằng DEPTH, FIFO ở trạng thái full.

Với thao tác ghi hợp lệ, bộ đếm tăng.
Với thao tác đọc hợp lệ, bộ đếm giảm.

Khi ghi và đọc đồng thời đều hợp lệ,
số phần tử thường không thay đổi.

Ưu điểm của cách tiếp cận này là việc xác định
full và empty trực tiếp thông qua occupancy.

## Slide 7 - FIFO B extended-pointer (75 giây)

Ở FIFO B, trạng thái đầy và rỗng được xác định
thông qua hai con trỏ có thêm bit mở rộng.

Nếu hai con trỏ bằng nhau, FIFO ở trạng thái rỗng.

Nếu phần địa chỉ bằng nhau nhưng bit vòng
khác nhau, FIFO ở trạng thái đầy.

Bit mở rộng cho phép phân biệt hai trường hợp
có cùng vị trí địa chỉ nhưng trạng thái khác nhau.

Kiến trúc này không sử dụng bộ đếm occupancy
riêng như FIFO A.

Vì logic điều khiển khác nhau nên sau synthesis,
hai kiến trúc có thể có số lượng và loại standard
cell khác nhau, dù chức năng lưu trữ tương đương.

## Slide 8 - Phương pháp kiểm chứng (55 giây)

Đề tài sử dụng Icarus Verilog để mô phỏng
và testbench tự kiểm tra.

Một reference model đóng vai trò kết quả kỳ vọng.
Scoreboard so sánh dữ liệu và các trạng thái
của hai FIFO với mô hình tham chiếu.

Bài kiểm tra bao gồm các tình huống có chủ đích
và những chuỗi thao tác ngẫu nhiên.

Waveform được quan sát bằng GTKWave.

Đây là kiểm chứng dựa trên mô phỏng,
không phải chứng minh tương đương hình thức.

## Slide 9 - Kết quả verification (60 giây)

Trong kết quả đã lưu, nhóm T16 có 16 trên 16
trường hợp PASS và nhóm T17 có 8 trên 8 PASS.

Tổng cộng có 24 trên 24 trường hợp PASS,
365809 phép kiểm tra và không ghi nhận lỗi.

Waveform cho phép quan sát sự thay đổi của
full, empty, overflow, underflow và dữ liệu.

Kết quả cho thấy hai kiến trúc đáp ứng
các bài kiểm tra đã thực hiện.

Tuy nhiên, không thể từ mô phỏng mà khẳng định
đã chứng minh đúng với mọi chuỗi đầu vào có thể.

## Slide 10 - Kết quả synthesis (50 giây)

Sau synthesis, FIFO A sử dụng 600 standard cell
với mapped area 7130.5888 micromet vuông.

FIFO B sử dụng 573 standard cell với mapped area
6904.1216 micromet vuông.

Như vậy, FIFO B giảm 27 cell và khoảng 3.18%
diện tích mapped area so với FIFO A.

Kết quả cho thấy lựa chọn kiến trúc điều khiển
có ảnh hưởng đến phần cứng sau tổng hợp.

Mapped area ở đây khác với core area
trong thiết kế vật lý.

## Slide 11 - Phân tích STA (65 giây)

Tần số mục tiêu là 50 MHz, tương ứng
chu kỳ clock 20 ns.

Kết quả STA độc lập sau routing cho thấy
setup worst slack của FIFO A khoảng
13.380897 ns và FIFO B khoảng 13.414628 ns.

Hold worst slack tương ứng là
0.340383 ns và 0.301747 ns.

Các giá trị này đều dương ở điều kiện đã phân tích.

Fmax được báo cáo là 352.34 MHz đối với FIFO A
và 331.60 MHz đối với FIFO B.

Các giá trị Fmax cần lấy từ phép đánh giá
chu kỳ clock tối thiểu tương ứng,
không suy trực tiếp từ một path delay riêng lẻ.

## Slide 12 - Thiết kế vật lý (70 giây)

Hai kiến trúc đã được triển khai đến GDSII
và mở bằng công cụ KLayout.

Core area của FIFO A là 20169.344
micromet vuông, trong khi FIFO B là 19462.416.

Báo cáo vật lý ghi nhận Magic DRC bằng 0,
LVS cho kết quả circuits match uniquely,
và antenna violations bằng 0.

Tuy nhiên, mỗi kiến trúc có sáu max-fanout
violations trên mạng clock được phân loại
ACCEPTED_QOR_WAIVER.

Vì vậy, em trình bày kết quả cùng ngoại lệ
này, không khẳng định tất cả kiểm tra
sign-off đều hoàn toàn không có vi phạm.

## Slide 13 - Phân tích Power (50 giây)

Công suất được ước tính bằng OpenROAD
với workload streaming gồm 10000 chu kỳ.

Điều kiện phân tích gồm corner TT,
nhiệt độ 25 độ C, điện áp 1.8 V,
clock 50 MHz và dữ liệu ký sinh nominal SPEF.

Total Power của FIFO A là 0.715755 mW,
của FIFO B là 0.712251 mW.

FIFO B thấp hơn khoảng 0.49% trong workload này.

Đây là số liệu công suất ước tính từ mô hình,
không phải phép đo trên silicon.

## Slide 14 - Tổng hợp PPA (55 giây)

Khi so sánh FIFO B với FIFO A,
mapped area giảm khoảng 3.18%
và core area giảm khoảng 3.50%.

Công suất ước tính giảm khoảng 0.49%,
nhưng Fmax báo cáo lại thấp hơn khoảng 5.89%.

Như vậy, FIFO B có lợi thế về diện tích
và một phần công suất trong điều kiện đã đo,
trong khi FIFO A có lợi thế về Fmax.

Đây là sự đánh đổi giữa Power,
Performance và Area.

Không có cơ sở kết luận một kiến trúc
tốt hơn tuyệt đối cho mọi ứng dụng.

## Slide 15 - Kết luận (70 giây)

Đề tài đã hoàn thành thiết kế hai kiến trúc
FIFO đồng bộ, xây dựng kiểm chứng chức năng
và triển khai quy trình ASIC đến GDSII.

Kết quả thực nghiệm giúp làm rõ sự khác biệt
về tài nguyên và timing của hai cách
tổ chức logic điều khiển.

Giới hạn hiện tại gồm phạm vi PPA chủ yếu 8x16,
công suất chỉ được ước tính trong một workload
và điều kiện PVT, cùng các ngoại lệ vật lý
đã ghi nhận.

Hướng phát triển là mở rộng cấu hình FIFO,
bổ sung formal equivalence và khảo sát thêm
workload, PVT corner cũng như tối ưu QoR.

Em xin kết thúc phần trình bày và cảm ơn
quý thầy cô đã lắng nghe.
