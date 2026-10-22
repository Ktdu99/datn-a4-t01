
# BÁO CÁO TỔNG HỢP KIỂM THỬ CHỨC NĂNG FIFO A/B

## 1. Thông tin chung

- Thiết kế: Synchronous FIFO 16x8
- Kiến trúc A: FIFO sử dụng bộ đếm (Count-based FIFO)
- Kiến trúc B: FIFO sử dụng con trỏ mở rộng (Extended-pointer FIFO)
- Ngôn ngữ RTL: Verilog
- Ngôn ngữ Testbench: SystemVerilog
- Công cụ mô phỏng: Icarus Verilog
- Tần số clock mô phỏng: 50 MHz
- Chu kỳ clock: 20 ns
- Phương pháp kiểm thử: Directed Test và Random Regression
- Mô hình tham chiếu: Reference Memory Scoreboard
- Số chu kỳ ngẫu nhiên mỗi seed: 10000
- Danh sách seed: 1, 2, 3, 4, 5, 20260924

## 2. Các trường hợp kiểm thử chức năng

| Mã | Nội dung kiểm thử |
|---|---|
| T01 | Kiểm tra trạng thái sau Reset |
| T02-T04 | Kiểm tra ghi, đọc và thứ tự dữ liệu FIFO |
| T05 | Ghi dữ liệu cho đến khi FIFO đầy |
| T06 | Kiểm tra Overflow khi FIFO đầy |
| T07 | Đọc dữ liệu cho đến khi FIFO rỗng |
| T08 | Kiểm tra Underflow khi FIFO rỗng |
| T09 | Kiểm tra đọc và ghi đồng thời |
| T10 | Kiểm tra đọc và ghi đồng thời khi FIFO đầy |
| T11 | Kiểm tra đọc và ghi đồng thời khi FIFO rỗng |
| T12 | Kiểm tra con trỏ quay vòng nhiều lần |
| T13 | Kiểm tra Reset khi FIFO đang chứa dữ liệu |
| T14 | Kiểm thử ngẫu nhiên với nhiều seed |

Các bài kiểm thử có hướng được thực hiện trước
giai đoạn kiểm thử ngẫu nhiên.

Hai kiến trúc A và B sử dụng cùng phương pháp
tạo tín hiệu kích thích và kiểm tra kết quả.

## 3. Kết quả Regression

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Số seed | 6 | 6 |
| Chu kỳ ngẫu nhiên mỗi seed | 10000 | 10000 |
| Tổng chu kỳ mô phỏng | 60992 | 60992 |
| Tổng số checks | 183000 | 183000 |
| Tổng số lỗi | 0 | 0 |
| Số lượt PASS | 6/6 | 6/6 |
| Kết quả | PASS | PASS |

Kết quả tổng hợp hai kiến trúc:

- Tổng số lượt regression: 12
- Tổng số chu kỳ mô phỏng: 121984
- Tổng số checks: 366000
- Tổng số lỗi phát hiện: 0
- Kết quả chung: PASS

## 4. Phương pháp kiểm thử bằng Scoreboard

Testbench sử dụng mô hình FIFO tham chiếu độc lập
để dự đoán kết quả hoạt động của DUT.

Mô hình tham chiếu gồm:

- Mảng bộ nhớ tham chiếu
- Con trỏ ghi tham chiếu
- Con trỏ đọc tham chiếu
- Bộ đếm số phần tử tham chiếu

Testbench xác định các thao tác ghi và đọc hợp lệ
dựa trên trạng thái FIFO trước cạnh clock.

Tín hiệu đầu vào được thay đổi tại cạnh xuống
của clock.

Kết quả đầu ra được kiểm tra sau cạnh lên
của clock với độ trễ mô phỏng 1 ns.

Các nội dung được kiểm tra gồm:

- Thứ tự và tính toàn vẹn của dữ liệu đọc
- Trạng thái Full và Empty
- Tín hiệu Overflow và Underflow
- Khả năng giữ nguyên dữ liệu đầu ra khi không
  có thao tác đọc hợp lệ

Theo đặc tả được sử dụng trong testbench:

- FIFO đầy: từ chối thao tác ghi.
- FIFO rỗng: từ chối thao tác đọc.
- Đọc và ghi đồng thời khi đầy:
  chỉ chấp nhận thao tác đọc.
- Đọc và ghi đồng thời khi rỗng:
  chỉ chấp nhận thao tác ghi.

## 5. Bằng chứng về các sự kiện kiểm thử

Kết quả tiêu biểu với seed đầu vào 20260924:

| Chỉ tiêu | FIFO A | FIFO B |
|---|---:|---:|
| Số chu kỳ | 10171 | 10171 |
| Số checks | 30517 | 30517 |
| Số lần ghi hợp lệ | 4899 | 4899 |
| Số lần đọc hợp lệ | 4891 | 4891 |
| Số sự kiện Overflow | 134 | 134 |
| Số sự kiện Underflow | 162 | 162 |
| Số lần đọc/ghi đồng thời hợp lệ | 2260 | 2260 |
| Số lỗi | 0 | 0 |

Các bộ đếm sự kiện cho thấy những tình huống
Overflow, Underflow và đọc/ghi đồng thời đã
thực sự xuất hiện trong quá trình mô phỏng.

Testbench còn có các bài kiểm thử có hướng
đối với con trỏ quay vòng và Reset khi FIFO
đang chứa dữ liệu.

## 6. Khả năng tái lập kết quả

Script thực hiện regression:

scripts/run_evidence_regression.py

Lệnh chạy từ thư mục gốc repository:

    python3 scripts/run_evidence_regression.py

Script thực hiện:

1. Biên dịch RTL và testbench của hai kiến trúc.
2. Chạy mô phỏng với 6 seed cho mỗi kiến trúc.
3. Kiểm tra trạng thái kết thúc của simulator.
4. Xác nhận thông báo ALL TESTS PASSED.
5. Kiểm tra số lỗi bằng 0.
6. Ghi lại số chu kỳ và số checks.
7. Lưu log mô phỏng và mã SHA256 của mã nguồn.
8. Tạo file manifest.json.
9. Lưu waveform VCD tiêu biểu.

Mã SHA256 của RTL và testbench được lưu trong:

source_sha256.txt

Thư mục kết quả regression gốc:

results/verification_reproduced/20261022_183001_118059/

Bộ bằng chứng tổng hợp chỉ lưu các file văn bản
cần thiết, không đưa VCD và VVP vào Git.

## 7. Giới hạn của quá trình kiểm thử

- Kết quả hiện tại áp dụng cho cấu hình
  DATA_WIDTH=8 và DEPTH=16.
- Regression sử dụng 6 seed, chưa kiểm tra
  toàn bộ các chuỗi trạng thái có thể xảy ra.
- Đã thực hiện kiểm thử chức năng nhưng chưa
  khẳng định đạt Code Coverage hoặc Formal Verification.
- Testbench chưa yêu cầu số lượng tối thiểu
  cho từng loại sự kiện được theo dõi.
- Giá trị Random seed hiển thị trong log có thể
  khác seed đầu vào do cách sử dụng $urandom(seed).
  Seed đầu vào được ghi trong manifest.json.
- Kết quả PASS của mô phỏng chức năng không
  thay thế việc kiểm tra timing và physical sign-off.

## 8. Kết luận

Cả hai kiến trúc FIFO A và FIFO B đều vượt qua
12 lượt kiểm thử regression với 0 lỗi phát hiện.

Tổng cộng đã thực hiện 366000 checks trong
121984 chu kỳ mô phỏng.

Kết quả cho thấy hai kiến trúc hoạt động đúng
trong phạm vi các bài kiểm thử chức năng có hướng
và kiểm thử ngẫu nhiên đã thực hiện.

Đây là cơ sở để tiếp tục đánh giá và so sánh
hai kiến trúc về diện tích, thời gian và công suất
trong quy trình thiết kế ASIC từ RTL đến GDSII.

Kết quả không được xem là bằng chứng kiểm chứng
toàn diện cho mọi cấu hình hoặc điều kiện hoạt động.
EOF

echo "===== KIỂM TRA FILE ====="
wc -l results/verification_summary/verification_summary.md

echo "===== TỔNG SỐ FILE ====="
find results/verification_summary -type f | wc -l

echo "===== DUNG LƯỢNG ====="
du -sh results/verification_summary
