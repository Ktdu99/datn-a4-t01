# So sánh công suất FIFO A và FIFO B

## 1. Thiết lập thực nghiệm

- **Công nghệ:** Sky130 HD.
- **Điều kiện phân tích:** góc công nghệ TT, nhiệt độ 25 °C, điện áp 1,80 V.
- **Tần số clock:** 50 MHz.
- **Tải công việc:** truyền dữ liệu liên tục (streaming).
- **Khoảng thời gian thu thập dữ liệu:** 10.000 chu kỳ clock.
- **Dữ liệu hoạt động chuyển mạch:** tệp VCD từ mô phỏng mức cổng với độ trễ bằng 0.
- **Dữ liệu ký sinh:** tệp SPEF danh định.
- **Công cụ phân tích:** OpenROAD.

## 2. Kết quả

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Công suất nội bộ (mW) | 0,493997 | 0,488578 |
| Công suất chuyển mạch (mW) | 0,221753 | 0,223667 |
| Công suất rò (nW) | 5,460372 | 5,384078 |
| **Tổng công suất ước lượng (mW)** | **0,715755** | **0,712251** |
| Số bộ điều khiển tín hiệu chưa được gán dữ liệu hoạt động | 0 | 0 |
| Số bộ điều khiển tín hiệu được gán dữ liệu hoạt động chưa đầy đủ | 0 | 0 |
| Số chân được gán dữ liệu hoạt động | 3.872 | 3.795 |

## 3. Nhận xét

Trong tải công việc streaming đã thử, tổng công suất ước lượng của FIFO B thấp hơn FIFO A khoảng **0,49%**.

FIFO B có công suất nội bộ thấp hơn, trong khi công suất chuyển mạch cao hơn một chút. Mức chênh lệch tổng công suất phụ thuộc vào tải công việc.

## 4. Giới hạn của kết quả

- Các giá trị công suất là ước lượng từ mô phỏng và phân tích bằng công cụ. Chưa có số liệu đo trên chip thực tế.
- VCD từ mô phỏng với độ trễ bằng 0 có thể bỏ sót các xung chuyển mạch ngắn do chênh lệch độ trễ lan truyền.
- Số chân được gán dữ liệu hoạt động là số đếm. Để tính tỷ lệ bao phủ, cần xác định tổng số chân thuộc phạm vi đánh giá.
- Phép so sánh sử dụng một tải công việc và một điều kiện công nghệ, điện áp, nhiệt độ (PVT).
- Cần đánh giá thêm các tải công việc khác trước khi đưa ra kết luận chung về hiệu quả sử dụng công suất.
