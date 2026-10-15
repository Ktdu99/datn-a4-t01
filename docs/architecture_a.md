# KIẾN TRÚC A — COUNT-BASED SYNCHRONOUS FIFO

## 1. Tổng quan

Phương án A sử dụng bộ đếm data_count để theo dõi số phần tử hiện có trong FIFO.

Các khối chính gồm:

- Mảng memory lưu dữ liệu.
- Write pointer xác định địa chỉ ghi.
- Read pointer xác định địa chỉ đọc.
- Data count theo dõi số phần tử.
- Logic full và empty.
- Logic overflow và underflow.

## 2. Sơ đồ khối

```mermaid
flowchart LR
    WD[wr_data] --> MEM[FIFO Memory]
    WE[wr_en] --> CTRL[Control Logic]
    RE[rd_en] --> CTRL
    CLK[clk] --> CTRL
    RST[rst_n] --> CTRL
    CTRL --> WP[Write Pointer]
    CTRL --> RP[Read Pointer]
    CTRL --> CNT[Data Count]
    WP --> MEM
    RP --> MEM
    MEM --> RD[rd_data]
    CNT --> FLAGS[full / empty]
```
