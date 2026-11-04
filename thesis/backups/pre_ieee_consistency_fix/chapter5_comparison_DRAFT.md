# CHƯƠNG 5. SO SÁNH VÀ THẢO LUẬN

## 5.1. Điều kiện so sánh

### 5.1.1. Nguyên tắc xây dựng phép so sánh

Mục tiêu của chương này là đánh giá
sự khác biệt PPA giữa hai kiến trúc FIFO
trong điều kiện thực nghiệm tương ứng.

Hai kiến trúc được khảo sát gồm:

- FIFO A: Count-based FIFO.
- FIFO B: Extended-pointer FIFO.

FIFO A sử dụng bộ đếm số phần tử
để quản lý trạng thái full và empty.

FIFO B sử dụng hai con trỏ mở rộng
để quản lý các trạng thái tương ứng.

Hai thiết kế có cùng đặc tả chức năng:

- DATA_WIDTH = 8 bit.
- DEPTH = 16 phần tử.
- Một miền clock đồng bộ.
- Clock mục tiêu = 50 MHz.
- Chu kỳ clock = 20 ns.

Các thí nghiệm được thực hiện
trên công nghệ SKY130A,
sử dụng thư viện sky130_fd_sc_hd.

Việc giữ tương ứng các thông số
giúp hạn chế sự khác biệt
do điều kiện triển khai gây ra.

Khác biệt chính được khảo sát
là cách tổ chức logic điều khiển FIFO.

Tuy nhiên, cùng điều kiện cấu hình
không đồng nghĩa với việc
hai kiến trúc có cùng netlist.

### 5.1.2. Đối chiếu cấu hình OpenLane

Để kiểm tra điều kiện triển khai,
đề tài đối chiếu file config.tcl
của hai physical run đã lưu.

Các run được sử dụng:

- FIFO A: PHYS_A_50MHZ.
- FIFO B: PHYS_B_50MHZ.

Cấu hình OpenLane của hai kiến trúc được đối chiếu trong Bảng 5.1.

**Bảng 5.1. So sánh cấu hình OpenLane của FIFO A và FIFO B**

| Thông số | FIFO A | FIFO B |
|---|---:|---:|
| CLOCK_PORT | clk | clk |
| CLOCK_PERIOD (ns) | 20.0 | 20.0 |
| FP_SIZING | relative | relative |
| FP_CORE_UTIL | 35 | 35 |
| FP_ASPECT_RATIO | 1.0 | 1.0 |
| PL_TARGET_DENSITY | 0.45 | 0.45 |
| PL_TIME_DRIVEN | 1 | 1 |
| PL_ROUTABILITY_DRIVEN | 1 | 1 |
| RUN_CTS | 1 | 1 |
| MAX_FANOUT_CONSTRAINT | 10 | 10 |
| RUN_KLAYOUT_DRC | 0 | 0 |

Các thông số clock và floorplan
được thiết lập giống nhau.

Điều kiện placement cũng tương ứng,
bao gồm mật độ mục tiêu,
tối ưu thời gian
và tối ưu khả năng routing.

Cả hai run đều bật CTS
và có cùng giới hạn max fanout.

Điểm khác nhau được xác nhận
ở biến DESIGN_NAME:

- FIFO A: sync_fifo_count.
- FIFO B: sync_fifo_pointer.

Sự khác biệt này phù hợp
với hai module RTL được khảo sát.

Đối với RUN_ROUTING,
không tìm thấy khai báo tường minh
trong cả hai file config.tcl.

Vì vậy, không dùng riêng
việc thiếu biến này
để kết luận routing bị tắt
hoặc có cùng cấu hình chi tiết.

Thay vào đó, kết quả physical flow
đã hoàn thành được xác nhận
qua báo cáo của từng run.

### 5.1.3. Điều kiện đánh giá STA và Power

STA được phân tích độc lập
trên dữ liệu sau routing
của từng kiến trúc.

Các điều kiện gồm:

- Process corner TT.
- Nhiệt độ 25°C.
- Điện áp 1.8 V.
- SDC sau routing.
- SPEF nominal.

Các chỉ tiêu được đối chiếu
bao gồm setup worst slack,
hold worst slack,
minimum clock period và Fmax.

Đối với công suất,
hai kiến trúc cùng sử dụng
workload streaming.

Khoảng đo gồm 10000 chu kỳ clock
cho mỗi kiến trúc.

Dữ liệu hoạt động chuyển mạch
được tạo bằng gate-level zero-delay VCD.

Kết quả ước lượng Power
được tổng hợp từ dữ liệu chuyển mạch
và thông tin ký sinh tương ứng.

### 5.1.4. Phạm vi công bằng của phép so sánh

Việc đối chiếu cho thấy
hai kiến trúc có cùng giá trị
ở các thông số OpenLane
đã được kiểm tra.

Điều này tạo cơ sở
để so sánh PPA trong phạm vi
hai physical run đang khảo sát.

Tuy nhiên, kiểm tra hiện tại
không chứng minh rằng
mọi biến môi trường, phiên bản công cụ
hoặc lựa chọn tối ưu nội bộ
đều hoàn toàn giống nhau.

Đề tài cũng chưa khảo sát
nhiều lần triển khai độc lập
để đánh giá biến thiên thống kê.

Do đó, kết quả được trình bày
như một phép so sánh thực nghiệm
giữa hai kiến trúc FIFO 16 x 8.

Các kết luận không được suy rộng
thành ưu thế tuyệt đối
ở mọi cấu hình FIFO hoặc mọi công nghệ.

Các mục tiếp theo phân tích
diện tích, timing, routing và Power
trong phạm vi các điều kiện này.

## 5.2. So sánh diện tích

Diện tích là một chỉ tiêu quan trọng
khi đánh giá khả năng sử dụng tài nguyên
của một IP số trong hệ thống ASIC.

Các kết quả về diện tích sau triển khai vật lý được tổng hợp trong Bảng 5.2.

**Bảng 5.2. So sánh diện tích của hai kiến trúc FIFO**

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Die area (mm²) | 0.025295 | 0.024573 |
| Core area (µm²) | 20169.344 | 19462.416 |
| Synthesis cells | 600 | 573 |
| Physical cells | 2425 | 2345 |

Kiến trúc B có die area thấp hơn A
khoảng 2.85 phần trăm.

Core area của B thấp hơn
khoảng 3.50 phần trăm.

Số cell sau synthesis giảm từ 600 xuống 573,
tương ứng mức giảm 4.50 phần trăm.

Tổng số cell vật lý giảm từ 2425 xuống 2345,
tương ứng khoảng 3.30 phần trăm.

Những kết quả này cho thấy
kiến trúc Extended-pointer có lợi thế diện tích
trong hai lần triển khai đang khảo sát.

Cần phân biệt synthesis cells
với tổng số physical cells.

Sau physical implementation,
thiết kế có thêm những phần tử
phục vụ yêu cầu bố trí và công nghệ,
chẳng hạn welltap, decap và filler cells.

Do đó, tổng số physical cells
không được sử dụng thay thế
cho số logic cells sau synthesis.

Chênh lệch diện tích phản ánh
kết quả tổng hợp và triển khai
của hai cấu trúc RTL khác nhau.

Tuy nhiên, chỉ từ tổng diện tích
chưa thể xác định chính xác
mỗi khối logic đóng góp bao nhiêu
vào mức chênh lệch giữa A và B.

Để kết luận nguyên nhân ở cấp cell,
cần phân tích sâu hơn netlist sau synthesis
và phân bố diện tích của từng nhóm phần tử.

## 5.3. So sánh performance

Performance được đánh giá chủ yếu
thông qua kết quả STA độc lập sau routing.

Cả hai kiến trúc được phân tích
với clock mục tiêu 50 MHz,
tương ứng chu kỳ 20 ns.

Các chỉ tiêu performance chính được tổng hợp trong Bảng 5.3.

**Bảng 5.3. So sánh các chỉ tiêu performance của hai kiến trúc**

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Setup worst slack (ns) | +13.380897 | +13.414628 |
| Setup TNS (ns) | 0 | 0 |
| Hold worst slack (ns) | +0.340383 | +0.301747 |
| Hold TNS (ns) | 0 | 0 |
| Minimum clock period (ns) | 2.84 | 3.02 |
| Fmax được báo cáo (MHz) | 352.34 | 331.60 |

Các giá trị setup worst slack
đều dương trong điều kiện được phân tích.

Setup TNS và Hold TNS
của cả hai kiến trúc đều bằng 0.

Điều này cho thấy không phát hiện
vi phạm setup hoặc hold
theo dữ liệu và ràng buộc STA đã sử dụng.

Setup worst slack của FIFO B
lớn hơn FIFO A khoảng 0.033731 ns.

Ngược lại, hold worst slack của FIFO A
lớn hơn FIFO B khoảng 0.038636 ns.

Tuy nhiên, một giá trị worst slack lớn hơn
không có nghĩa thiết kế luôn đạt Fmax cao hơn.

Theo kết quả report_clock_min_period,
minimum clock period của FIFO A là 2.84 ns,
trong khi FIFO B là 3.02 ns.

Fmax được báo cáo tương ứng là
352.34 MHz và 331.60 MHz.

Như vậy, FIFO A có Fmax cao hơn FIFO B
khoảng 6.26 phần trăm
khi lấy FIFO B làm mốc so sánh.

Kết quả này cần được phân biệt
với chỉ tiêu critical_path_ns
trong báo cáo physical flow.

Physical flow ghi nhận
reported path delay của FIFO A là 2.37 ns,
còn FIFO B là 2.34 ns.

Mặc dù giá trị của B thấp hơn,
không được suy trực tiếp
minimum clock period hoặc Fmax
bằng nghịch đảo của hai giá trị này.

Worst setup slack tổng thể,
reported path delay
và minimum clock period
có thể chịu ảnh hưởng của
những đường timing và ràng buộc khác nhau.

Vì vậy, khi đánh giá khả năng tăng tần số,
đề tài sử dụng chỉ tiêu minimum clock period
và Fmax do OpenSTA báo cáo.

Fmax ở đây là kết quả phân tích tĩnh,
không phải giá trị đo trên silicon.

Kết luận performance chỉ áp dụng
cho corner TT, 25°C, 1.8 V
và SPEF nominal đang khảo sát.

## 5.4. So sánh routing

Routing thể hiện đặc điểm kết nối vật lý
sau quá trình bố trí cell và xây dựng mạng clock.

Hai chỉ tiêu được sử dụng
để đối chiếu là tổng chiều dài dây
và số lượng via; kết quả đối chiếu được trình bày trong Bảng 5.4.

**Bảng 5.4. So sánh chiều dài dây và số lượng via sau routing**

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Wire length (µm) | 18677 | 18170 |
| Via count | 4905 | 4609 |
| TritonRoute violations | 0 | 0 |

FIFO B có tổng chiều dài dây
thấp hơn FIFO A khoảng 2.71 phần trăm.

Số lượng via của FIFO B
thấp hơn khoảng 6.03 phần trăm.

Các kết quả này cho thấy
thiết kế B sử dụng ít tài nguyên kết nối hơn
theo hai chỉ tiêu routing đang xét.

Sự khác biệt có thể liên quan
đến cấu trúc netlist, vị trí cell
và đặc điểm kết nối giữa các khối logic.

Tuy nhiên, wire length và via count
không đủ để xác định toàn bộ
mức độ congestion hoặc chất lượng timing.

Chiều dài dây thấp hơn cũng không tự động
chứng minh công suất động thấp hơn
trong mọi điều kiện hoạt động.

Cả hai lần triển khai
đều ghi nhận TritonRoute violations bằng 0.

Kết quả routing góp phần giải thích
sự khác biệt về tài nguyên vật lý,
nhưng cần được đánh giá cùng
diện tích, timing và công suất.


Hình 5.1 chuẩn hóa FIFO A bằng 100% và biểu diễn tỷ lệ tương ứng của FIFO B. Biểu đồ gồm die area, core area, synthesis cells, physical cells, wire length, via count và critical_path_ns theo báo cáo physical flow. Biểu đồ không bao gồm Fmax OpenSTA hoặc công suất ước lượng.

![So sánh chuẩn hóa các chỉ tiêu vật lý FIFO A/B](../docs/figures/ppa_ab_normalized.png)

**Hình 5.1. So sánh chuẩn hóa các chỉ tiêu vật lý FIFO A/B**

## 5.5. So sánh công suất ước lượng

Đề tài sử dụng hoạt động chuyển mạch
từ mô phỏng gate-level zero-delay
với workload streaming
để ước lượng công suất hai kiến trúc.

Điều kiện phân tích gồm:

- Corner TT, nhiệt độ 25°C.
- Điện áp 1.8 V.
- Clock 50 MHz.
- 10000 chu kỳ đo cho mỗi kiến trúc.
- Nominal SPEF sau routing.

Các thành phần công suất được tổng hợp trong Bảng 5.5.

**Bảng 5.5. So sánh các thành phần công suất ước lượng**

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Internal power (mW) | 0.493997 | 0.488578 |
| Switching power (mW) | 0.221753 | 0.223667 |
| Leakage power (nW) | 5.460372 | 5.384078 |
| Total power (mW) | 0.715755 | 0.712251 |

Cần chú ý rằng leakage power
được trình bày theo nW,
trong khi các thành phần còn lại
được trình bày theo mW.

Theo kết quả, Internal Power của FIFO B
thấp hơn FIFO A.

Ngược lại, Switching Power của FIFO B
cao hơn một lượng nhỏ.

Leakage Power của B cũng thấp hơn A
trong mô hình công nghệ đang sử dụng.

Tổng công suất ước lượng của FIFO B
thấp hơn FIFO A khoảng 0.49 phần trăm.

Mức chênh lệch này tương đối nhỏ
so với tổng công suất của mỗi thiết kế.

Vì vậy, có thể nhận xét
FIFO B có lợi thế nhỏ về Total Power
trong workload streaming đã khảo sát.

Không thể suy rộng rằng
kiến trúc Extended-pointer
luôn tiêu thụ ít công suất hơn
trong mọi mô hình hoạt động.

Tỷ lệ đọc, ghi, thời gian nhàn rỗi
và trạng thái dữ liệu
đều có thể làm thay đổi
hoạt động chuyển mạch của thiết kế.

Ngoài ra, mô phỏng zero-delay
chưa phản ánh đầy đủ glitch
do trễ lan truyền trong mạch.

Kết quả công suất là ước lượng bằng EDA,
không phải phép đo trực tiếp trên chip.

Để đánh giá tổng quát hơn,
cần khảo sát thêm các workload
và các điều kiện PVT khác nhau.

## 5.6. Phân tích nguyên nhân

### 5.6.1. Khác biệt về tổ chức logic RTL

Hai kiến trúc thực hiện cùng
chức năng FIFO đồng bộ 16 x 8.

Điểm khác biệt chính nằm ở
cơ chế quản lý trạng thái bộ nhớ.

FIFO A sử dụng data_count
để theo dõi số lượng phần tử
đang được lưu trữ.

Trạng thái full và empty
được xác định từ giá trị bộ đếm
và điều kiện giới hạn dung lượng.

FIFO B sử dụng
hai con trỏ đọc và ghi mở rộng.

Trạng thái full và empty
được xác định thông qua
quan hệ giữa hai con trỏ.

Hai phương pháp này có thể
tạo ra các mạng logic khác nhau
khi được tổng hợp bằng Yosys.

Sự khác biệt có thể xuất hiện
ở mạch cập nhật trạng thái,
logic so sánh và đường điều khiển.

Tuy nhiên, không thể chỉ dựa
vào mã RTL để khẳng định
số lượng cell vật lý cuối cùng.

Kết quả còn phụ thuộc vào
quá trình tối ưu và ánh xạ
sang thư viện standard cell.

### 5.6.2. Phân tích số lượng standard cell

Đề tài sử dụng thống kê cell
từ báo cáo synthesis của từng run.

Hai báo cáo nguồn là:

- 1-synthesis.AREA_0.stat.rpt của FIFO A.
- 1-synthesis.AREA_0.stat.rpt của FIFO B.

Thống kê các nhóm standard cell chính được trình bày trong Bảng 5.6.

**Bảng 5.6. So sánh số lượng standard cell sau synthesis**

| Nhóm cell | FIFO A | FIFO B | B - A |
|---|---:|---:|---:|
| Flip-flop dfxtp_2 | 151 | 148 | -3 |
| Buffer buf_1 | 161 | 156 | -5 |
| MUX2 mux2_2 | 144 | 145 | +1 |
| MUX4 mux4_2 | 32 | 32 | 0 |
| Các cell còn lại | 112 | 92 | -20 |
| Tổng cell | 600 | 573 | -27 |

Nhóm các cell còn lại
được tính bằng tổng số cell
trừ bốn nhóm đã liệt kê.

Đây là phép phân nhóm phục vụ
việc đối chiếu số lượng cell.

Không nên hiểu toàn bộ nhóm này
chỉ gồm logic điều khiển trạng thái.

Kết quả cho thấy FIFO B
có ít hơn FIFO A 27 cell,
tương ứng mức giảm 4.50%.

Trong đó, FIFO B có
ít hơn 3 flip-flop.

Số buffer của B
cũng thấp hơn A 5 cell.

Số MUX2 của B
lại cao hơn A 1 cell.

Cả hai kiến trúc
đều sử dụng 32 MUX4.

Chênh lệch lớn nhất theo
cách phân nhóm hiện tại
là 20 cell ở nhóm còn lại.

Như vậy, mức giảm tổng số cell
không đến từ việc giảm đồng đều
tất cả các loại standard cell.

Báo cáo này chứng minh
sự khác biệt về loại và số cell,
nhưng chưa phân tách chính xác
cell theo từng khối RTL.

Đặc biệt, chưa có bằng chứng
để quy toàn bộ 27 cell giảm đi
cho riêng bộ đếm data_count.

Muốn xác định quan hệ nhân quả
ở cấp khối chức năng,
cần truy vết netlist
và tên tín hiệu sau synthesis.

### 5.6.3. Liên hệ với diện tích synthesis

Báo cáo synthesis cũng ghi nhận
diện tích standard cell như trình bày trong Bảng 5.7.

**Bảng 5.7. So sánh diện tích standard cell sau synthesis**

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Synthesis area (µm²) | 7130.5888 | 6904.1216 |
| Synthesis cells | 600 | 573 |
| Core area (µm²) | 20169.344 | 19462.416 |

Synthesis cell area của FIFO B
thấp hơn FIFO A 226.4672 µm².

Tỷ lệ giảm tương ứng
xấp xỉ 3.18%.

Trong khi đó,
core area sau physical flow
của B thấp hơn khoảng 3.50%.

Hai chỉ tiêu có ý nghĩa khác nhau.

Synthesis cell area phản ánh
tổng diện tích của các cell
được ánh xạ tại bước synthesis.

Core area phản ánh
diện tích vùng lõi
được xác định trong physical design.

Core area còn chịu ảnh hưởng
của phương pháp floorplan
và các ràng buộc sử dụng diện tích.

Vì vậy, không được đồng nhất
synthesis area với core area.

Mức giảm synthesis area
cho thấy lợi thế diện tích của B
đã xuất hiện từ bước tổng hợp logic.

Kết quả physical flow
tiếp tục cho thấy B có core area
thấp hơn trong run được khảo sát.

Tuy nhiên, không thể kết luận
toàn bộ mức giảm core area
chỉ do giảm số lượng cell.

### 5.6.4. Liên hệ với timing và công suất

Sự khác biệt về số cell
không dẫn đến cùng một xu hướng
cho mọi chỉ tiêu PPA.

Theo kết quả STA độc lập,
FIFO A có minimum clock period
được báo cáo là 2.84 ns.

Giá trị tương ứng
của FIFO B là 3.02 ns.

Fmax của FIFO A được báo cáo
cao hơn FIFO B khoảng 6.26%.

Điều này cho thấy
FIFO B có ít cell hơn
nhưng không đạt Fmax cao hơn
trong điều kiện STA đang khảo sát.

Timing phụ thuộc vào
đường truyền giới hạn,
đặc tính cell, fanout
và các tải ký sinh.

Tổng số cell không phải
đại lượng đủ để dự đoán
minimum clock period.

Báo cáo physical cũng ghi nhận
wire length của B thấp hơn A.

Tuy nhiên, giảm tổng chiều dài dây
không bảo đảm giảm độ trễ
trên đúng đường timing giới hạn.

Để xác định nguyên nhân timing,
cần đối chiếu các đường truyền
trong báo cáo STA sau routing
với cấu trúc netlist tương ứng.

Đối với công suất,
FIFO B có Internal Power
ước lượng thấp hơn FIFO A.

Ngược lại, Switching Power
của FIFO B cao hơn A.

Total Power của B thấp hơn
khoảng 0.49% trong workload streaming.

Do đó, việc sử dụng ít cell hơn
không đồng nghĩa với
mọi thành phần công suất đều giảm.

Công suất còn phụ thuộc
vào hoạt động chuyển mạch
và đặc điểm tải của các tín hiệu.

### 5.6.5. Mức độ chứng minh và kết luận

Từ các báo cáo thực nghiệm,
đề tài xác nhận những kết quả:

- FIFO B ít hơn A 27 synthesis cells.
- FIFO B ít hơn 3 flip-flop.
- FIFO B ít hơn 5 buffer.
- FIFO B nhiều hơn 1 MUX2.
- Cả hai có 32 MUX4.
- Nhóm cell còn lại của B ít hơn 20.
- Synthesis cell area của B thấp hơn 3.18%.
- Core area của B thấp hơn khoảng 3.50%.
- Fmax báo cáo của FIFO A cao hơn 6.26%.
- Total Power của FIFO B thấp hơn khoảng 0.49%.

Những kết quả này hỗ trợ nhận xét
rằng thay đổi kiến trúc RTL
có liên hệ với khác biệt
về cấu trúc netlist và PPA.

Tuy nhiên, các báo cáo thống kê
chỉ cung cấp số lượng cell
theo loại thư viện.

Chúng chưa chứng minh trực tiếp
mỗi cell thuộc khối RTL nào.

Vì vậy, nghiên cứu không khẳng định
toàn bộ chênh lệch 27 cell
là kết quả trực tiếp
của việc loại bỏ data_count.

Để đánh giá sâu hơn,
cần phân tích netlist,
ánh xạ logic theo từng khối
và các đường timing giới hạn.

Trong phạm vi dữ liệu hiện tại,
FIFO B có lợi thế về diện tích
và Total Power ước lượng.

FIFO A có lợi thế về Fmax
được OpenSTA báo cáo.

Đây là một sự đánh đổi PPA
giữa hai kiến trúc FIFO
trong cấu hình đã khảo sát.

## 5.7. Threats to validity – Giới hạn nghiên cứu

Các kết luận của đề tài
có một số giới hạn thực nghiệm cần làm rõ.

Thứ nhất, chỉ khảo sát một cấu hình FIFO
với DATA_WIDTH bằng 8
và DEPTH bằng 16.

Kết quả chưa chứng minh
xu hướng tương tự ở các cấu hình
có độ rộng hoặc độ sâu lớn hơn.

Thứ hai, hai kiến trúc được triển khai
trên PDK SKY130A
và thư viện sky130_fd_sc_hd.

Các thư viện công nghệ khác
có thể tạo ra kết quả synthesis
và physical implementation khác nhau.

Thứ ba, bộ nhớ FIFO trong thí nghiệm
được ánh xạ bằng các phần tử flip-flop,
không sử dụng SRAM macro.

Vì vậy, kết quả diện tích
chưa đại diện cho trường hợp
FIFO sử dụng bộ nhớ SRAM chuyên dụng.

Thứ tư, STA độc lập sau routing
chỉ được khảo sát tại corner TT,
25°C và 1.8 V.

Chưa có kết quả multi-corner sign-off
để đánh giá đầy đủ các điều kiện
công nghệ, điện áp và nhiệt độ.

Thứ năm, phân tích công suất
chỉ sử dụng một workload streaming
với 10000 chu kỳ đo.

Gate-level zero-delay VCD
không mô hình hóa đầy đủ
hoạt động glitch do trễ lan truyền.

Chưa có phép đo công suất trên silicon,
và chưa đánh giá nhiều workload khác nhau.

Thứ sáu, kết quả physical verification
phải được hiểu theo phạm vi công cụ
và bộ quy tắc đã áp dụng.

Magic DRC và LVS
không ghi nhận lỗi
trong các báo cáo đã lưu.

KLayout DRC độc lập
được thực hiện trên GDSII
với bộ quy tắc SKY130A đã chọn.

Hai báo cáo độc lập
đều ghi nhận 248 nhóm quy tắc
và 0 violation items.

Trong run OpenLane ban đầu,
RUN_KLAYOUT_DRC bằng 0
và klayout_violations bằng -1.

Giá trị -1 không được diễn giải
là kết quả KLayout PASS
hoặc một vi phạm DRC cụ thể.

Mỗi kiến trúc vẫn còn
6 max-fanout violations
được giữ dưới dạng QoR waiver.

Các ngoại lệ này chưa được loại bỏ.

Do đó, đề tài không khẳng định
đã hoàn thành sign-off sản xuất đầy đủ.

Thứ bảy, kết quả so sánh PPA
được tổng hợp từ các run thực nghiệm đã lưu.

Chưa có khảo sát thống kê
trên nhiều lần physical implementation
với các điều kiện khác nhau.

Vì vậy, không thể sử dụng
những chênh lệch nhỏ
để khẳng định ưu thế tuyệt đối.

Trong phạm vi nghiên cứu,
FIFO B có lợi thế về diện tích
và công suất ước lượng
trong workload đã khảo sát.

FIFO A có Fmax
được OpenSTA báo cáo cao hơn.

Cả hai kiến trúc đáp ứng
mục tiêu clock 50 MHz
theo mô hình STA đã sử dụng.

Những kết quả này thể hiện
sự đánh đổi giữa các chỉ tiêu PPA
và là cơ sở cho chương kết luận
và hướng phát triển tiếp theo.
