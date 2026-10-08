# Chặng 5 – Synthesis và STA kiến trúc FIFO A

## 1. Mục tiêu

Chặng này thực hiện tổng hợp logic và phân tích timing tĩnh cho kiến trúc
FIFO A. Kiến trúc A sử dụng bộ đếm số phần tử (`data_count`) để xác định
trạng thái `full` và `empty`.

Mục tiêu gồm:

- Tổng hợp RTL sang netlist standard cell SKY130.
- Kiểm tra số lượng cell và diện tích cell ước lượng.
- Kiểm tra setup timing và hold timing.
- Lưu netlist, SDF, báo cáo và log để tái lập kết quả.
- Xác minh netlist hậu tổng hợp không có tín hiệu mất driver.

## 2. Phiên bản RTL được sử dụng

- Git commit RTL: `898b96bafda2e72642c273ff71418ac405f2ac80`
- Module top: `sync_fifo_count`
- Kiến trúc: `A_count_based`
- Data width: 8 bit
- FIFO depth: 16 phần tử
- Tổng dung lượng lưu trữ: 128 bit

## 3. Cấu hình synthesis và STA

| Tham số | Giá trị |
|---|---:|
| PDK | sky130A |
| Standard-cell library | sky130_fd_sc_hd |
| Clock port | clk |
| Clock period | 20.0 ns |
| Tần số mục tiêu | 50 MHz |
| Synthesis strategy | AREA 0 |
| Clock uncertainty | 0.25 ns |
| Clock transition | 0.15 ns |
| Timing derate | 0.05 |
| I/O delay ratio | 0.20 |

Cấu hình đầu vào được lưu tại:

- `openlane/sync_fifo_count/config.json`
- `results/synthesis_a/SYNTH_A_50MHZ/resolved_config.tcl`

## 4. Kết quả synthesis

| Chỉ số | Kết quả |
|---|---:|
| Tổng số standard cell | 600 |
| Diện tích cell ước lượng | 7130.588800 µm² |
| Flip-flop `dfxtp_2` | 151 |
| Buffer `buf_1` | 161 |
| Multiplexer `mux2_2` | 144 |
| Multiplexer `mux4_2` | 32 |
| Netlist mapped sang SKY130 | PASS |

Diện tích trên là tổng diện tích standard cell do Yosys báo cáo sau
synthesis. Đây chưa phải diện tích die hoặc core sau placement và routing.
Diện tích physical implementation sẽ được xác định ở Chặng 6.

Mảng nhớ FIFO 16 × 8 bit được triển khai bằng flip-flop và logic
multiplexer của thư viện standard cell, không sử dụng SRAM macro.

## 5. Kết quả STA

| Kiểm tra | Kết quả | Đánh giá |
|---|---:|---|
| WNS | 0.00 ns | MET |
| TNS | 0.00 ns | MET |
| Setup worst slack | +13.81 ns | MET |
| Hold worst slack | +0.22 ns | MET |

Setup slack và hold slack đều dương, do đó thiết kế đạt timing tại clock
period 20 ns, tương ứng tần số mục tiêu 50 MHz.

WNS và TNS bằng 0 cho biết không tồn tại đường timing có slack âm.
Kết quả này chỉ áp dụng cho giai đoạn synthesis/STA hiện tại. Timing sẽ
được kiểm tra lại sau placement, CTS và routing.

## 6. Kiểm tra netlist hậu tổng hợp

Netlist được kiểm tra lại bằng Yosys 0.52 cùng file Liberty đầy đủ:

`sky130_fd_sc_hd__tt_025C_1v80.lib`

Kết quả:

- 428 loại cell được đọc từ Liberty.
- Module top được nhận dạng đúng.
- Tổng số cell là 600.
- `Found and reported 0 problems`.
- Các đầu ra `empty`, `full`, `overflow`, `underflow` và `rd_data[7:0]`
  đều có driver trong netlist.

Kết luận: netlist hậu tổng hợp hợp lệ về mặt cấu trúc.

## 7. Đánh giá cảnh báo công cụ

OpenLane ban đầu tạo các thông báo:

- `ABC: Error: The network is combinational.`
- Một số đầu ra được báo `used but has no driver`.
- `[WARNING] Did not save OpenROAD database!`

Các thông báo được đánh giá như sau:

1. Thông báo ABC xuất hiện trong bước retiming một mạng tổ hợp, nhưng
   không làm dừng synthesis.
2. Các cảnh báo đầu ra không có driver là cảnh báo giả của bước kiểm tra
   khi `SYNTH_READ_BLACKBOX_LIB=0`.
3. Khi đọc đầy đủ Liberty và kiểm tra lại chính netlist đó, Yosys báo
   `0 problems`.
4. Cảnh báo không lưu OpenROAD database là bình thường đối với lần chạy
   chỉ thực hiện synthesis và STA.

Không phát hiện lỗi synthesis hoặc STA chưa được phân loại.

Chi tiết được lưu tại:

- `results/synthesis_a/SYNTH_A_50MHZ/warning_assessment.txt`
- `results/synthesis_a/SYNTH_A_50MHZ/reports/netlist_check.txt`
- `results/synthesis_a/SYNTH_A_50MHZ/logs/unexpected_errors.txt`

## 8. Sản phẩm đầu ra

- Gate-level netlist:
  `results/synthesis_a/SYNTH_A_50MHZ/sync_fifo_count.synthesis.v`
- SDF:
  `results/synthesis_a/SYNTH_A_50MHZ/sync_fifo_count.sdf`
- Chỉ số chính:
  `results/synthesis_a/SYNTH_A_50MHZ/key_metrics.txt`
- Raw synthesis log:
  `results/synthesis_a/SYNTH_A_50MHZ/logs/1-synthesis.full.txt`
- Raw STA log:
  `results/synthesis_a/SYNTH_A_50MHZ/logs/2-sta.full.txt`
- Báo cáo netlist:
  `results/synthesis_a/SYNTH_A_50MHZ/reports/netlist_check.txt`

## 9. Cách tái lập kết quả

Sau khi có OpenLane run `SYNTH_A_50MHZ`, chạy:

```bash
./scripts/collect_synth_sta_a.sh SYNTH_A_50MHZ
```

## 10. Kiểm tra khả năng tái lập

Thiết kế được chạy lại với tag `SYNTH_A_50MHZ_REPRO_20261008`, sử dụng cùng RTL commit `898b96bafda2e72642c273ff71418ac405f2ac80`, cùng cấu hình và cùng phiên bản OpenLane.

Kết quả hai lần chạy giống nhau:

| Chỉ tiêu | Baseline | Reproduction |
|---|---:|---:|
| Standard cells | 600 | 600 |
| Cell area | 7130.5888 µm² | 7130.5888 µm² |
| WNS | 0.00 ns | 0.00 ns |
| TNS | 0.00 ns | 0.00 ns |
| Setup slack | +13.81 ns | +13.81 ns |
| Hold slack | +0.22 ns | +0.22 ns |
| Post-map netlist check | PASS | PASS |

Hai synthesized netlist có cùng mã SHA-256, chứng minh kết quả tổng hợp có thể tái lập trong cùng môi trường công cụ.

Dữ liệu kiểm tra:

`results/synthesis_a/reproducibility_a.txt`

**Trạng thái Chặng 5: PASS.**
