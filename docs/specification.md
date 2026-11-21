# Đặc tả chung IP FIFO đồng bộ

## 1. Mục đích và phạm vi

FIFO là bộ đệm dữ liệu hoạt động theo nguyên tắc **vào trước, ra trước** (First-In, First-Out). Dữ liệu được lấy ra theo đúng thứ tự các lần ghi được chấp nhận.

Đặc tả này áp dụng cho hai phương án RTL:

- **FIFO A — `sync_fifo_count`:** dùng bộ đếm `data_count` để xác định trạng thái đầy và rỗng.
- **FIFO B — `sync_fifo_pointer`:** dùng con trỏ đọc và ghi mở rộng, mỗi con trỏ có thêm một bit vòng để phân biệt trạng thái đầy và rỗng.

Cả hai phương án dùng chung giao diện, chung quy tắc chấp nhận giao dịch và chung một miền clock cho cả đọc lẫn ghi. Với cùng cấu hình, cùng trình tự reset và cùng tín hiệu đầu vào, hai phương án phải cho cùng kết quả quan sát được ở các đầu ra sau mỗi cạnh clock. Phạm vi thiết kế là FIFO đồng bộ trong một miền clock.

## 2. Tham số và cấu hình cơ sở

| Thông số | Giá trị cơ sở | Ý nghĩa |
|---|---:|---|
| `DATA_WIDTH` | 8 bit | Số bit của mỗi phần tử dữ liệu. |
| `DEPTH` | 16 phần tử | Số phần tử tối đa có thể lưu. |
| Dung lượng lưu trữ | 128 bit | `DATA_WIDTH × DEPTH`, chưa tính các thanh ghi điều khiển. |
| Chu kỳ clock mục tiêu | 20 ns | Ràng buộc dùng khi đánh giá cấu hình cơ sở. |
| Tần số clock mục tiêu | 50 MHz | Tương ứng chu kỳ 20 ns. |
| Bộ dữ liệu công nghệ (PDK) | SKY130A | Công nghệ mục tiêu cho triển khai vật lý. |
| Thư viện cell chuẩn | `sky130_fd_sc_hd` | Thư viện dùng trong quy trình triển khai ASIC. |

`DATA_WIDTH` phải là số nguyên dương. `DEPTH` phải là lũy thừa của 2 và ít nhất bằng 2. Khi đổi độ sâu, giữ độ rộng địa chỉ theo giá trị mặc định `$clog2(DEPTH)`. Với FIFO A, giữ độ rộng bộ đếm theo `$clog2(DEPTH + 1)` để biểu diễn được cả trạng thái đầy.

Cấu hình **8 bit × 16 phần tử** là mốc so sánh PPA của đồ án. Kết quả kiểm thử chức năng ở cấu hình khác được ghi trong báo cáo kiểm chứng tương ứng.

## 3. Giao diện tín hiệu

| Tín hiệu | Hướng | Độ rộng | Chức năng |
|---|---|---:|---|
| `clk` | Vào | 1 bit | Clock chung. Các cập nhật tuần tự thực hiện tại cạnh lên. |
| `rst_n` | Vào | 1 bit | Reset đồng bộ, tích cực mức thấp. |
| `wr_en` | Vào | 1 bit | Yêu cầu ghi một phần tử. |
| `wr_data` | Vào | `DATA_WIDTH` bit | Dữ liệu được lưu khi giao dịch ghi được chấp nhận. |
| `rd_en` | Vào | 1 bit | Yêu cầu đọc một phần tử. |
| `rd_data` | Ra | `DATA_WIDTH` bit | Dữ liệu của lần đọc được chấp nhận gần nhất, được giữ trong thanh ghi đầu ra. |
| `full` | Ra | 1 bit | Bằng `1` khi FIFO chứa đủ `DEPTH` phần tử. |
| `empty` | Ra | 1 bit | Bằng `1` khi FIFO không còn phần tử hợp lệ. |
| `overflow` | Ra | 1 bit | Cờ được cập nhật tại cạnh lên khi có yêu cầu ghi lúc FIFO đầy. |
| `underflow` | Ra | 1 bit | Cờ được cập nhật tại cạnh lên khi có yêu cầu đọc lúc FIFO rỗng. |

## 4. Thời điểm xử lý giao dịch

Tại mỗi cạnh lên của `clk`, nếu `rst_n = 1`, FIFO xét `wr_en`, `rd_en` và trạng thái `full`, `empty` **ngay trước cạnh clock** để quyết định chấp nhận giao dịch:

```text
write_accept = wr_en AND NOT full
read_accept  = rd_en AND NOT empty
```

`write_accept` và `read_accept` là điều kiện nội bộ. Giao diện của IP gồm các cổng trong bảng ở mục 3.

- **Ghi được chấp nhận:** lưu `wr_data` vào cuối hàng đợi tại cạnh clock đó.
- **Đọc được chấp nhận:** lấy phần tử cũ nhất trong hàng đợi. `rd_data` cập nhật sau chính cạnh clock chấp nhận lần đọc.
- **Không có lần đọc được chấp nhận:** `rd_data` giữ giá trị cũ, trừ khi có reset.
- Sau cạnh clock, `full` và `empty` phản ánh trạng thái FIFO sau khi cập nhật đọc/ghi. Một giao dịch làm thay đổi trạng thái tại cạnh này không làm thay đổi quyết định chấp nhận giao dịch còn lại ở cùng cạnh.

## 5. Hành vi khi đầy, rỗng và đọc/ghi đồng thời

Gọi `N` là **số phần tử hợp lệ ngay trước cạnh clock**. Đây là cách mô tả trạng thái chung cho hai phương án. Trong FIFO A, RTL lưu giá trị này bằng bộ đếm `data_count`.

| Trạng thái trước cạnh | `wr_en` | `rd_en` | Giao dịch được chấp nhận | `N` sau cạnh | `overflow` | `underflow` |
|---|---:|---:|---|---:|---:|---:|
| Bất kỳ | 0 | 0 | Không có | `N` | 0 | 0 |
| Chưa đầy | 1 | 0 | Chỉ ghi | `N + 1` | 0 | 0 |
| Đầy | 1 | 0 | Không có | `DEPTH` | 1 | 0 |
| Chưa rỗng | 0 | 1 | Chỉ đọc | `N − 1` | 0 | 0 |
| Rỗng | 0 | 1 | Không có | 0 | 0 | 1 |
| `0 < N < DEPTH` | 1 | 1 | Ghi và đọc | `N` | 0 | 0 |
| Đầy | 1 | 1 | Chỉ đọc | `DEPTH − 1` | 1 | 0 |
| Rỗng | 1 | 1 | Chỉ ghi | 1 | 0 | 1 |

Bảng áp dụng khi `rst_n = 1`. Các giá trị cờ ở hai cột cuối là giá trị **sau cạnh clock**.

- **Khi đầy:** nếu có cả yêu cầu đọc và ghi, chỗ trống do lần đọc tạo ra có thể dùng để ghi từ cạnh clock tiếp theo.
- **Khi rỗng:** nếu có cả yêu cầu ghi và đọc, dữ liệu mới được lưu vào FIFO và có thể đọc từ cạnh clock tiếp theo. Không có cơ chế chuyển thẳng dữ liệu mới ghi ra `rd_data` (*bypass*).
- `overflow` và `underflow` được tính lại ở mỗi cạnh lên. Một yêu cầu không hợp lệ làm cờ tương ứng lên `1` trong chu kỳ sau cạnh đó. Nếu yêu cầu tiếp tục không hợp lệ ở nhiều cạnh liên tiếp, cờ có thể giữ mức `1` qua các chu kỳ tương ứng.
- Khi địa chỉ đọc hoặc ghi đi qua ô cuối, phần địa chỉ quay lại ô đầu. Thứ tự dữ liệu phải được giữ nguyên qua các lần quay vòng.

## 6. Reset và trạng thái ban đầu

Reset đồng bộ và được lấy mẫu tại cạnh lên của `clk`. Nếu `rst_n = 0` tại cạnh lên, reset được ưu tiên và FIFO bỏ qua các yêu cầu đọc/ghi tại cạnh đó.

| Trạng thái hoặc tín hiệu | Giá trị sau cạnh reset |
|---|---|
| Số phần tử hợp lệ | 0 |
| `full` | `0` |
| `empty` | `1` |
| `overflow`, `underflow` | `0` |
| `rd_data` | Tất cả các bit bằng `0` |
| Con trỏ đọc và ghi của A và B | `0` |
| Bộ đếm `data_count` của FIFO A | `0` |

Mảng lưu trữ không bị xóa toàn bộ khi reset. Sau reset, FIFO xem mọi dữ liệu cũ trong mảng là không hợp lệ. `rd_data` nhận dữ liệu mới sau giao dịch đọc được chấp nhận tiếp theo.

## 7. Ví dụ theo từng cạnh clock

Giả sử FIFO đã reset và đang rỗng. Tại cạnh 1, đưa `wr_data = 8'hA5` và yêu cầu cả đọc lẫn ghi.

| Cạnh clock | `wr_en` | `rd_en` | Giao dịch được chấp nhận | Số phần tử sau cạnh | `rd_data` sau cạnh | `underflow` sau cạnh |
|---|---:|---:|---|---:|---|---:|
| 1 | 1 | 1 | Chỉ ghi `8'hA5` | 1 | `8'h00` | 1 |
| 2 | 0 | 1 | Đọc `8'hA5` | 0 | `8'hA5` | 0 |
| 3 | 0 | 0 | Không có | 0 | `8'hA5` | 0 |

Sau cạnh 2, `empty = 1` vì phần tử cuối cùng đã được lấy ra. `rd_data` vẫn giữ dữ liệu vừa đọc cho đến lần đọc hợp lệ tiếp theo hoặc reset.

## 8. Tiêu chí kiểm chứng chức năng

Dùng cùng tiêu chí cho FIFO A và FIFO B. Testbench đối chiếu dữ liệu và các cờ đầu ra với mô hình tham chiếu FIFO. Chi tiết từng ca có trong [kế hoạch kiểm thử](test_plan.md).

| Nhóm kiểm thử | Hành vi cần kiểm tra |
|---|---|
| T01–T04 | Reset, ghi và đọc một phần tử, giữ đúng thứ tự FIFO. |
| T05–T08 | Ghi đến đầy, chặn ghi khi đầy, đọc đến rỗng và chặn đọc khi rỗng. |
| T09–T11 | Đọc và ghi đồng thời ở trạng thái có dữ liệu, đầy và rỗng. |
| T12–T13 | Quay vòng địa chỉ và reset khi FIFO còn dữ liệu. |
| T14–T15 | Chạy chuỗi giao dịch ngẫu nhiên và lặp với nhiều seed. |
| T16 | Kiểm thử nhiều cấu hình độ rộng dữ liệu và độ sâu. |
| T17 | So sánh đầu ra A/B theo từng chu kỳ và đối chiếu với mô hình tham chiếu. |

Một lượt mô phỏng đạt khi các phép kiểm tra của lượt đó không phát hiện sai lệch. T17 kiểm tra sự tương đương trong các ca mô phỏng đã chạy.

## 9. Tiêu chí triển khai vật lý

Đánh giá cả A và B với cùng cấu hình cơ sở, công nghệ, thư viện cell và ràng buộc clock.

| Hạng mục | Tiêu chí |
|---|---|
| Tổng hợp | Cả A và B tổng hợp thành công và có netlist đầu ra. |
| Phân tích thời gian tĩnh (STA) | Có báo cáo setup và hold ở mục tiêu 50 MHz. Setup WNS ≥ 0, setup TNS = 0 và không còn vi phạm hold chưa được xử lý. |
| Kiểm tra quy tắc thiết kế (DRC) | Không có lỗi DRC trong báo cáo đánh giá. |
| Đối chiếu layout với netlist (LVS) | Layout khớp với netlist và số lỗi LVS bằng 0. |
| Đầu ra vật lý | Xuất được GDSII của cả FIFO A và FIFO B. |
| So sánh PPA | Báo cáo diện tích, kết quả phân tích thời gian và công suất ước lượng dưới các điều kiện đánh giá được ghi rõ. |

## 10. Tài liệu và mã nguồn liên quan

- [Chặng 1 – Đặc tả và kế hoạch kiểm thử FIFO](chang1_specification.md)
- [Kiến trúc FIFO A](chang2_architecture_a.md) và [mã RTL FIFO A](../rtl/sync_fifo_count.v)
- [Kiến trúc FIFO B](chang7_architecture_b.md) và [mã RTL FIFO B](../rtl/sync_fifo_pointer.v)
- [Kế hoạch kiểm thử FIFO](test_plan.md)
