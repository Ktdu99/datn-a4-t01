# Kết quả kiểm chứng chức năng FIFO phương án A

## 1. Cấu hình kiểm thử

- **Kiến trúc:** FIFO đồng bộ dùng bộ đếm số phần tử.
- **Độ rộng dữ liệu (`DATA_WIDTH`):** 8 bit.
- **Độ sâu (`DEPTH`):** 16 phần tử.
- **Chu kỳ clock:** 20 ns.
- **Số chu kỳ kiểm thử ngẫu nhiên:** 10.000 chu kỳ cho mỗi seed.
- **Giá trị khởi tạo ngẫu nhiên (seed):** `1`, `2`, `3`, `4`, `5` và `20260924`.

## 2. Công cụ

- **Công cụ mô phỏng:** Icarus Verilog 12.0.
- **Công cụ xem dạng sóng:** GTKWave 3.3.126.
- **Ngôn ngữ viết testbench:** SystemVerilog.

## 3. Kiểm thử theo tình huống định trước

| Ca kiểm thử | Kết quả |
|---|---|
| Đặt lại mạch (reset) | PASS |
| Kiểm tra thứ tự dữ liệu vào trước, ra trước | PASS |
| Trạng thái FIFO đầy | PASS |
| Trạng thái FIFO rỗng | PASS |
| Yêu cầu ghi khi FIFO đầy (`overflow`) | PASS |
| Yêu cầu đọc khi FIFO rỗng (`underflow`) | PASS |
| Đọc và ghi đồng thời | PASS |
| Yêu cầu đọc và ghi đồng thời khi FIFO đầy | PASS |
| Yêu cầu đọc và ghi đồng thời khi FIFO rỗng | PASS |
| Con trỏ quay vòng địa chỉ | PASS |
| Reset khi FIFO còn dữ liệu | PASS |

## 4. Kiểm thử hồi quy ngẫu nhiên

| Seed | Số chu kỳ | Số lỗi | Kết quả |
|---:|---:|---:|---|
| 1 | 10.000 | 0 | PASS |
| 2 | 10.000 | 0 | PASS |
| 3 | 10.000 | 0 | PASS |
| 4 | 10.000 | 0 | PASS |
| 5 | 10.000 | 0 | PASS |
| 20260924 | 10.000 | 0 | PASS |

## 5. Thống kê của lần chạy cơ sở

| Chỉ số | Giá trị |
|---|---:|
| Tổng số chu kỳ mô phỏng | 10.171 |
| Số phép kiểm tra | 30.517 |
| Số yêu cầu ghi được chấp nhận | 4.899 |
| Số yêu cầu đọc được chấp nhận | 4.891 |
| Số sự kiện `overflow` | 134 |
| Số sự kiện `underflow` | 162 |
| Số sự kiện đọc và ghi đồng thời | 2.260 |
| Số lỗi | 0 |

## 6. Kết luận

RTL của FIFO A đáp ứng các yêu cầu chức năng đã được kiểm thử theo đặc tả. Testbench không phát hiện lỗi về dữ liệu, cờ trạng thái hoặc cách xử lý các trường hợp biên trong các ca kiểm thử định trước và các lượt hồi quy ngẫu nhiên.
