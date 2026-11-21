# Báo cáo kiểm toán độc lập T16 và T17

## Phạm vi kiểm toán

- **T16:** Kiểm thử hồi quy FIFO A và FIFO B với nhiều cấu hình tham số.
- **T17:** So sánh kết quả mô phỏng của FIFO A và FIFO B theo từng chu kỳ, đồng thời đối chiếu với mô hình FIFO tham chiếu độc lập (scoreboard).
- **Cấu hình đã kiểm thử** (độ rộng dữ liệu × số phần tử): 8 × 8, 8 × 16, 8 × 32 và 16 × 16.
- **Giá trị khởi tạo ngẫu nhiên (seed):** `1` và `20260924`.
- Mã RTL được giữ nguyên trong các thử nghiệm này.

## Kết quả

| Bài kiểm thử | Số lượt chạy | Số chu kỳ | Số phép kiểm tra | Số lỗi |
|---|---:|---:|---:|---:|
| T16 | 16 | 34.920 | 104.824 | 0 |
| T17 | 8 | 17.383 | 260.985 | 0 |
| **Tổng cộng** | **24** | **52.303** | **365.809** | **0** |

## Bằng chứng

- T16: `results/verification_t16/20261023_162821_187749`
- T17: `results/verification_t17/matrix_20261023_163641_700949`

Kiểm toán đã đối chiếu sự hiện diện và tính nhất quán của cả hai tệp kê khai kết quả (manifest), toàn bộ nhật ký mô phỏng và toàn bộ tệp dạng sóng.

Các mã băm SHA-256 trong hai tệp kê khai khớp với các tệp RTL, testbench và script tương ứng tại thời điểm kiểm toán.

## Diễn giải và giới hạn

- Kết quả cho thấy FIFO hoạt động đúng trong các cấu hình và chuỗi kích thích đã kiểm thử.
- T17 kiểm tra năm tín hiệu đầu ra của cả hai kiến trúc: dữ liệu đọc, cờ đầy (`full`), cờ rỗng (`empty`), cờ tràn (`overflow`) và cờ đọc khi rỗng (`underflow`).
- Các bộ đếm độ bao phủ xác nhận những trường hợp biên được chọn đã được kiểm thử. Phạm vi này chưa bao quát toàn bộ mã nguồn.
- Kết luận tương đương của T17 dựa trên các ca mô phỏng đã chạy. Chứng minh tương đương hình thức nằm ngoài phạm vi kiểm toán.
- Việc xác nhận timing sau bố trí và đi dây, cũng như các kiểm tra sign-off, cần bằng chứng riêng.
- Các kết luận về công suất, hiệu năng và diện tích (PPA) chỉ áp dụng cho những cấu hình và điều kiện triển khai vật lý đã được đánh giá.

## Kết luận

Cả T16 và T17 đều đạt kiểm toán. Tổng cộng có 24 lượt chạy, 365.809 phép kiểm tra và 0 lỗi được ghi nhận.

```text
T16_INDEPENDENT_AUDIT_PASS
T17_INDEPENDENT_AUDIT_PASS
COMBINED_VERIFICATION_AUDIT_PASS
```
