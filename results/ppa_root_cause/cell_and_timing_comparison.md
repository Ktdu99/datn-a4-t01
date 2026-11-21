# FIFO A/B – Bằng chứng về cell và kết quả phân tích thời gian

## 1. Phạm vi phân tích

- **Cấu hình:** `DATA_WIDTH=8`, `DEPTH=16`.
- **Công nghệ và thư viện cell:** SKY130A, `sky130_fd_sc_hd`.
- **Dữ liệu đầu vào:** thống kê sau tổng hợp và nhật ký phân tích thời gian tĩnh (STA) sau đi dây.
- Phân tích này sử dụng các báo cáo đã lưu. Không thực hiện lần tổng hợp mới trong phạm vi báo cáo.

## 2. So sánh kết quả tổng hợp

| Chỉ số | FIFO A | FIFO B | B − A |
|---|---:|---:|---:|
| Số cell chuẩn | 600 | 573 | −27 |
| Tổng diện tích cell sau tổng hợp (µm²) | 7.130,5888 | 6.904,1216 | −226,4672 |

Tổng diện tích cell sau tổng hợp của FIFO B giảm **3,18%** so với FIFO A.

## 3. Chênh lệch số lượng theo từng loại cell

| Cell chuẩn | FIFO A | FIFO B | B − A |
|---|---:|---:|---:|
| `sky130_fd_sc_hd__o211a_2` | 0 | 11 | +11 |
| `sky130_fd_sc_hd__and3_2` | 12 | 3 | −9 |
| `sky130_fd_sc_hd__a211o_2` | 0 | 8 | +8 |
| `sky130_fd_sc_hd__a21o_2` | 10 | 2 | −8 |
| `sky130_fd_sc_hd__o221a_2` | 8 | 0 | −8 |
| `sky130_fd_sc_hd__nand2_2` | 8 | 14 | +6 |
| `sky130_fd_sc_hd__or2_2` | 7 | 1 | −6 |
| `sky130_fd_sc_hd__buf_1` | 161 | 156 | −5 |
| `sky130_fd_sc_hd__o21a_2` | 6 | 1 | −5 |
| `sky130_fd_sc_hd__and2_2` | 7 | 3 | −4 |
| `sky130_fd_sc_hd__and3b_2` | 4 | 1 | −3 |
| `sky130_fd_sc_hd__dfxtp_2` | 151 | 148 | −3 |
| `sky130_fd_sc_hd__inv_2` | 3 | 6 | +3 |
| `sky130_fd_sc_hd__nand3_2` | 0 | 3 | +3 |
| `sky130_fd_sc_hd__nor2_2` | 9 | 6 | −3 |
| `sky130_fd_sc_hd__o2111a_2` | 1 | 4 | +3 |
| `sky130_fd_sc_hd__a2111oi_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__a21bo_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__a21oi_2` | 5 | 4 | −1 |
| `sky130_fd_sc_hd__a221o_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__a22o_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__a22oi_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__a31oi_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__and2b_2` | 10 | 9 | −1 |
| `sky130_fd_sc_hd__and4_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__and4b_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__and4bb_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__mux2_2` | 144 | 145 | +1 |
| `sky130_fd_sc_hd__nand2b_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__nor3_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__o21ba_2` | 0 | 1 | +1 |
| `sky130_fd_sc_hd__o311a_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__or2b_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__or3b_2` | 1 | 0 | −1 |
| `sky130_fd_sc_hd__or4_2` | 2 | 1 | −1 |
| `sky130_fd_sc_hd__xnor2_2` | 2 | 1 | −1 |
| `sky130_fd_sc_hd__xor2_2` | 3 | 4 | +1 |

Cộng các chênh lệch có dấu trong cột **B − A** được **−27 cell**. Số lượng của một số loại cell tăng, trong khi các loại khác giảm.

## 4. So sánh STA sau đi dây

| Chỉ số | FIFO A | FIFO B |
|---|---:|---:|
| Chu kỳ clock tối thiểu được báo cáo (ns) | 2,84 | 3,02 |
| Tần số tối đa được báo cáo, Fmax (MHz) | 352,34 | 331,60 |
| Biên thời gian setup nhỏ nhất (ns) | 13,380897 | 13,414628 |
| Biên thời gian hold nhỏ nhất (ns) | 0,340383 | 0,301747 |

Fmax được báo cáo của FIFO B thấp hơn FIFO A **5,89%**, tính theo FIFO A làm mốc.

## 5. Đường tín hiệu trễ cực đại được liệt kê đầu tiên

- **FIFO A – Điểm bắt đầu:** `_1045_`, flip-flop kích theo cạnh lên của `clk`.
- **FIFO A – Điểm kết thúc:** `empty`, cổng đầu ra được phân tích theo `clk`.
- **FIFO B – Điểm bắt đầu:** `_984_`, flip-flop kích theo cạnh lên của `clk`.
- **FIFO B – Điểm kết thúc:** `full`, cổng đầu ra được phân tích theo `clk`.

Đây là các đường tín hiệu trễ cực đại được liệt kê đầu tiên trong kết quả STA đã lưu. Cần thêm bằng chứng để xác định đường tín hiệu nào chi phối chu kỳ clock tối thiểu.

## 6. Diễn giải và giới hạn

- Báo cáo cho thấy hai kiến trúc được ánh xạ sang các cell khác nhau. Để xác định khối RTL nào gây ra một chênh lệch cụ thể, cần lần theo kết nối trong netlist và đối chiếu RTL với các cell tương ứng.
- Tổng diện tích cell sau tổng hợp, diện tích vùng lõi (core) và diện tích die là các chỉ số riêng.
- Biên thời gian setup nhỏ nhất cho biết mức dư thời gian dưới ràng buộc dùng khi phân tích. Chu kỳ tối thiểu được báo cáo cho biết giới hạn chu kỳ clock theo kết quả STA.
- Báo cáo chưa chứng minh được quan hệ nhân quả giữa từng thay đổi trong RTL và từng chênh lệch về cell hoặc thời gian.

## 7. Đường dẫn bằng chứng

- **Tổng hợp FIFO A:** `openlane/sync_fifo_count_phys/runs/PHYS_A_50MHZ/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- **STA FIFO A:** `results/sta_summary/A_sta.log`
- **Tổng hợp FIFO B:** `openlane/sync_fifo_pointer_phys/runs/PHYS_B_50MHZ/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- **STA FIFO B:** `results/sta_summary/B_sta.log`

`CELL_AND_TIMING_EVIDENCE_AUDIT_PASS`
