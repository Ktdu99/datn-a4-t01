# Nhật ký
| Ngày | Tuần | Quyết định | Lý do (bằng chứng nào dẫn tới) | Ai quyết |
| 2026-10-08 | 6–8 | Chọn FIFO kiến trúc A dùng bộ đếm làm baseline, với DATA_WIDTH=8 và DEPTH=16 | RTL đã vượt qua directed test, corner cases và regression nhiều seed trước synthesis | Sinh viên |
| 2026-10-08 | 6–8 | Chọn baseline synthesis tại 50 MHz, PDK sky130A, thư viện sky130_fd_sc_hd và chiến lược AREA 0 | Đây là cấu hình ổn định để đánh giá area/timing và làm mốc so sánh với kiến trúc B | Sinh viên |
| 2026-10-08 | 6–8 | Giữ kết quả synthesis hiện tại và phân loại cảnh báo driver của OpenLane là false-positive | Netlist cho thấy các đầu ra đều được nối; kiểm tra lại bằng Yosys với Liberty đầy đủ báo 0 problems; STA đạt setup và hold | Sinh viên |
| 2026-10-08 | 6–8 | Giữ `SYNTH_A_50MHZ` làm baseline chính thức và dùng run REPRO để kiểm tra khả năng tái lập | Hai run có metrics, cấu hình và netlist hậu tổng hợp giống nhau; SHA-256 của hai netlist trùng khớp | Sinh viên |
