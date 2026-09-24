# TEST PLAN FIFO

| ID | Nội dung | Kết quả mong đợi |
|---|---|---|
| T01 | Reset | empty=1, full=0 |
| T02 | Ghi một dữ liệu | Dữ liệu được lưu |
| T03 | Đọc một dữ liệu | Dữ liệu đọc đúng |
| T04 | Kiểm tra thứ tự FIFO | Đúng thứ tự ghi |
| T05 | Ghi đến đầy | full=1 |
| T06 | Ghi khi đầy | overflow=1, không ghi |
| T07 | Đọc đến rỗng | empty=1 |
| T08 | Đọc khi rỗng | underflow=1 |
| T09 | Đọc và ghi đồng thời | Cả hai được xử lý |
| T10 | Đọc/ghi khi đầy | Chỉ đọc được chấp nhận |
| T11 | Đọc/ghi khi rỗng | Chỉ ghi được chấp nhận |
| T12 | Pointer wrap-around | Không mất hoặc đảo dữ liệu |
| T13 | Reset khi đang có dữ liệu | FIFO trở về rỗng |
| T14 | Random 10000 chu kỳ | Không có mismatch |
| T15 | Nhiều random seed | Tất cả PASS |
| T16 | Nhiều WIDTH/DEPTH | Tất cả PASS |
| T17 | So sánh A và B | Hành vi giống nhau |
