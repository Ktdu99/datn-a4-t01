# TÀI LIỆU THAM KHẢO – BẢN NHÁP

**Đề tài:** Thiết kế và đánh giá một IP FIFO số từ RTL
đến GDSII bằng quy trình EDA mã nguồn mở.

**Trạng thái:** DRAFT – Chưa đánh số trích dẫn chính thức.

## R1. FIFO Generator

- Đơn vị phát hành: AMD/Xilinx.
- Tên tài liệu: FIFO Generator v13.2 Product Guide.
- Mã tài liệu: PG057.
- Ngày phát hành: 04/10/2017.
- URL: https://docs.amd.com/v/u/en-US/pg057-fifo-generator
- Sử dụng: Nguyên tắc FIFO, chức năng lưu trữ và đọc dữ liệu.
- Vị trí dự kiến: Mục 1.1, 1.2 và Chương 2.
- Ghi chú: Tài liệu về IP FIFO cho FPGA; không dùng
  làm bằng chứng trực tiếp cho kết quả ASIC của đề tài.

## R2. OpenLane

- Đơn vị phát hành: The OpenROAD Project.
- Tên tài liệu: OpenLane – Automated RTL to GDSII Flow.
- URL: https://github.com/The-OpenROAD-Project/OpenLane
- Sử dụng: Quy trình RTL-to-GDSII và công cụ EDA.
- Vị trí dự kiến: Mục 1.1, 1.2, Chương 2 và Chương 3.
- Ghi chú: Khi mô tả thực nghiệm, đối chiếu với
  phiên bản OpenLane thực tế được sử dụng.

## R3. SKY130 PDK

- Đơn vị phát hành: SkyWater / FOSSi Foundation.
- Tên tài liệu: SkyWater SKY130 PDK Documentation.
- URL: https://skywater-pdk.readthedocs.io/en/main/
- Sử dụng: Công nghệ SKY130 và bộ thư viện công nghệ.
- Vị trí dự kiến: Mục 1.1, 1.4, Chương 2 và Chương 3.
- Ghi chú: Không suy diễn rằng kết quả GDSII đồng nghĩa
  với khả năng sản xuất thương mại.

## R4. Static Timing Analysis

- Đơn vị phát hành: OpenROAD / OpenSTA.
- Tên tài liệu: Parallax Static Timing Analyzer.
- URL: https://openroad.readthedocs.io/en/latest/main/src/sta/README.html
- Sử dụng: STA, Liberty, SDC, SPEF, VCD và SAIF.
- Vị trí dự kiến: Mục 1.1, 1.2, Chương 2 và Chương 4.
- Ghi chú: Phân biệt tài liệu phương pháp với báo cáo
  STA thực nghiệm của dự án.

## R5. SKY130 Design Rules

- Đơn vị phát hành: SkyWater / FOSSi Foundation.
- Tên tài liệu: SkyWater SKY130 Process Design Rules.
- URL: https://skywater-pdk.readthedocs.io/en/main/rules.html
- Sử dụng: Quy tắc thiết kế vật lý, DRC, LVS và antenna.
- Vị trí dự kiến: Mục 1.2, Chương 2 và Chương 4.
- Ghi chú: Kết quả DRC/LVS thực tế phải dẫn chứng
  bằng log hoặc báo cáo của chính dự án.

## R6. Power Analysis

- Đơn vị phát hành: The OpenROAD Project / OpenSTA.
- Tên tài liệu: OpenSTA Examples – Power Analysis.
- URL: https://openroad.readthedocs.io/en/latest/main/src/sta/doc/Examples.html
- Sử dụng: Ước lượng công suất từ hoạt động chuyển mạch,
  dữ liệu VCD, ký sinh SPEF và lệnh report_power.
- Vị trí dự kiến: Mục 1.2, Chương 2 và Chương 4.
- Ghi chú: Kết quả là công suất ước lượng dựa trên
  mô hình thư viện và dữ liệu hoạt động, không phải
  công suất đo trực tiếp trên chip thực tế.

## R7. FIFO Pointer-Based Full/Empty Detection

- Tác giả: Clifford E. Cummings.
- Tên tài liệu: Simulation and Synthesis Techniques
  for Asynchronous FIFO Design.
- Hội nghị: SNUG San Jose, 2002.
- URL: https://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
- Sử dụng: Nguyên lý con trỏ đọc/ghi, bit mở rộng
  và phương pháp phân biệt trạng thái full/empty.
- Vị trí dự kiến: Mục 1.1, Chương 2 và Chương 3.
- Giới hạn: Tài liệu trình bày asynchronous FIFO.
  Chỉ tham khảo nguyên lý xác định full/empty,
  không áp dụng trực tiếp toàn bộ kiến trúc
  hoặc kỹ thuật đồng bộ miền xung nhịp.
- Ghi chú: Cơ chế cụ thể của FIFO đồng bộ trong
  đề tài phải được đối chiếu với mã RTL thực tế.

## Nguồn cần bổ sung

- Tài liệu về kiến trúc count-based FIFO.
- Tài liệu về extended-pointer FIFO.
- Tài liệu về phương pháp kiểm chứng FIFO.
- Tài liệu chuyên sâu về đánh giá công suất ASIC.

## Quy tắc sử dụng

1. Chỉ trích dẫn nội dung mà nguồn thực sự hỗ trợ.
2. Không tự tạo tác giả, năm xuất bản hoặc DOI.
3. Không dùng tài liệu lý thuyết thay cho bằng chứng thực nghiệm.
4. Chưa đánh số [1], [2] trước khi thống nhất thứ tự trích dẫn.
5. Kiểm tra quy định trích dẫn của trường trước khi hoàn thiện.
