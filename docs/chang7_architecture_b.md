# Chặng 7 – Kiến trúc và RTL FIFO B

## 1. Mục tiêu

Chặng này xây dựng kiến trúc FIFO B sử dụng con trỏ mở rộng để xác định trạng thái full và empty.

Kiến trúc B phải giữ nguyên giao diện và hành vi bên ngoài của kiến trúc A. Điểm khác biệt duy nhất là phương pháp theo dõi trạng thái chứa dữ liệu.

## 2. Cấu hình

- DATA_WIDTH: 8 bit.
- DEPTH: 16 phần tử.
- Clock period mục tiêu: 20 ns.
- Reset đồng bộ tích cực mức thấp.
- Đầu ra đọc được đăng ký.
- DEPTH là lũy thừa của 2.

## 3. Nguyên lý con trỏ mở rộng

Với DEPTH bằng 16, địa chỉ memory cần 4 bit. Mỗi con trỏ được mở rộng thêm một bit pha nên tổng độ rộng là 5 bit.

Bốn bit thấp xác định địa chỉ memory. Bit cao nhất ghi nhận số vòng quay của con trỏ.

- Empty khi toàn bộ write pointer bằng read pointer.
- Full khi phần địa chỉ bằng nhau nhưng bit pha khác nhau.

## 4. Ví dụ trạng thái

| Write pointer | Read pointer | Trạng thái |
|---|---|---|
| 00000 | 00000 | Empty |
| 00001 | 00000 | Có một phần tử |
| 10000 | 00000 | Full |
| 10000 | 00001 | Không full |
| 10000 | 10000 | Empty |

## 5. Quy tắc giao dịch

- write_accept = wr_en AND NOT full.
- read_accept = rd_en AND NOT empty.
- Ghi khi full bị từ chối và tạo overflow.
- Đọc khi empty bị từ chối và tạo underflow.
- Khi full và đồng thời đọc/ghi, chỉ đọc được chấp nhận.
- Khi empty và đồng thời đọc/ghi, chỉ ghi được chấp nhận.
- rd_data chỉ thay đổi sau một giao dịch đọc hợp lệ.

## 6. So sánh kiến trúc A và B

| Nội dung | Kiến trúc A | Kiến trúc B |
|---|---|---|
| Xác định empty | data_count = 0 | Hai con trỏ bằng nhau |
| Xác định full | data_count = DEPTH | Địa chỉ bằng, pha khác |
| Write pointer | 4 bit | 5 bit |
| Read pointer | 4 bit | 5 bit |
| Data count | 5 bit | Không sử dụng |
| Tổng bit theo dõi | 13 bit | 10 bit |

Kiến trúc B giảm ba bit trạng thái theo dõi ở mức RTL. Ảnh hưởng thực tế đến area, timing và power sẽ được đánh giá sau synthesis và physical implementation.

## 7. Sản phẩm đầu ra

- RTL: `rtl/sync_fifo_pointer.v`
- Script kiểm tra: `scripts/check_rtl_b.sh`
- Báo cáo Yosys: `results/rtl_b/yosys_check.txt`
- Tóm tắt kiểm tra: `results/rtl_b/check_summary.txt`

## 8. Giới hạn của Chặng 7

Kết quả PASS ở Chặng 7 chỉ xác nhận RTL biên dịch được và không có lỗi cấu trúc do Yosys phát hiện.

Functional verification bằng golden model, directed tests và random regression sẽ được thực hiện ở Chặng 8.

**Trạng thái Chặng 7: PASS.**
