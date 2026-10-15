# Nhật ký
| Ngày | Tuần | Quyết định | Lý do (bằng chứng nào dẫn tới) | Ai quyết |
| 2026-10-08 | 6–8 | Chọn FIFO kiến trúc A dùng bộ đếm làm baseline, với DATA_WIDTH=8 và DEPTH=16 | RTL đã vượt qua directed test, corner cases và regression nhiều seed trước synthesis | Sinh viên |
| 2026-10-08 | 6–8 | Chọn baseline synthesis tại 50 MHz, PDK sky130A, thư viện sky130_fd_sc_hd và chiến lược AREA 0 | Đây là cấu hình ổn định để đánh giá area/timing và làm mốc so sánh với kiến trúc B | Sinh viên |
| 2026-10-08 | 6–8 | Giữ kết quả synthesis hiện tại và phân loại cảnh báo driver của OpenLane là false-positive | Netlist cho thấy các đầu ra đều được nối; kiểm tra lại bằng Yosys với Liberty đầy đủ báo 0 problems; STA đạt setup và hold | Sinh viên |
| 2026-10-08 | 6–8 | Giữ `SYNTH_A_50MHZ` làm baseline chính thức và dùng run REPRO để kiểm tra khả năng tái lập | Hai run có metrics, cấu hình và netlist hậu tổng hợp giống nhau; SHA-256 của hai netlist trùng khớp | Sinh viên |
| 2026-10-08 | 11 | Chấp nhận baseline physical FIFO A với 6 vi phạm max-fanout trên clock tree dưới dạng QoR waiver | Post-route WNS/TNS bằng 0; max slew/cap bằng 0; DRC, LVS và antenna đều PASS. Giữ nguyên RTL đã kiểm chứng và xem tối ưu CTS là hướng nghiên cứu tiếp theo | Khổng Thị Dung |
| 2026-10-15 | 7 | Chọn kiến trúc B dùng con trỏ mở rộng | Giữ nguyên giao diện FIFO A, loại bỏ bộ đếm occupancy để tạo phương án so sánh PPA công bằng | Sinh viên |
