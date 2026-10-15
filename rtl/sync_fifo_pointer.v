`timescale 1ns/1ps
`default_nettype none

module sync_fifo_pointer #(
    parameter integer DATA_WIDTH = 8,
    parameter integer DEPTH      = 16,
    parameter integer PTR_WIDTH  = $clog2(DEPTH)
) (
    input  wire                  clk,
    input  wire                  rst_n,

    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,

    input  wire                  rd_en,
    output reg  [DATA_WIDTH-1:0] rd_data,

    output wire                  full,
    output wire                  empty,

    output reg                   overflow,
    output reg                   underflow
);

    /*
     * Kiến trúc B sử dụng con trỏ mở rộng.
     *
     * Với DEPTH = 16:
     * - PTR_WIDTH     = 4 bit địa chỉ.
     * - EXT_PTR_WIDTH = 5 bit.
     * - Bit cao nhất là bit pha/vòng.
     *
     * DEPTH phải là lũy thừa của 2 và >= 2.
     */

    localparam integer EXT_PTR_WIDTH = PTR_WIDTH + 1;

    localparam [EXT_PTR_WIDTH-1:0] POINTER_ONE =
        {{(EXT_PTR_WIDTH-1){1'b0}}, 1'b1};

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    reg [EXT_PTR_WIDTH-1:0] write_pointer;
    reg [EXT_PTR_WIDTH-1:0] read_pointer;

    wire same_address;
    wire different_phase;

    wire write_accept;
    wire read_accept;

    /*
     * FIFO rỗng khi toàn bộ hai con trỏ bằng nhau.
     */
    assign empty = (write_pointer == read_pointer);

    /*
     * FIFO đầy khi:
     * - Phần địa chỉ của hai con trỏ bằng nhau.
     * - Bit pha của hai con trỏ khác nhau.
     */
    assign same_address =
        (write_pointer[PTR_WIDTH-1:0] ==
         read_pointer[PTR_WIDTH-1:0]);

    assign different_phase =
        (write_pointer[PTR_WIDTH] !=
         read_pointer[PTR_WIDTH]);

    assign full = same_address && different_phase;

    /*
     * Giữ nguyên quy tắc chấp nhận giao dịch của đặc tả.
     */
    assign write_accept = wr_en && !full;
    assign read_accept  = rd_en && !empty;

    always @(posedge clk) begin
        if (!rst_n) begin
            write_pointer <= {EXT_PTR_WIDTH{1'b0}};
            read_pointer  <= {EXT_PTR_WIDTH{1'b0}};

            rd_data   <= {DATA_WIDTH{1'b0}};
            overflow  <= 1'b0;
            underflow <= 1'b0;
        end else begin
            /*
             * Các cờ lỗi là xung kéo dài một chu kỳ.
             */
            overflow  <= wr_en && full;
            underflow <= rd_en && empty;

            /*
             * Ghi dữ liệu bằng phần địa chỉ của write pointer.
             * Bit pha không tham gia địa chỉ memory.
             */
            if (write_accept) begin
                memory[write_pointer[PTR_WIDTH-1:0]]
                    <= wr_data;

                write_pointer
                    <= write_pointer + POINTER_ONE;
            end

            /*
             * Đọc dữ liệu bằng phần địa chỉ của read pointer.
             * rd_data là đầu ra có đăng ký.
             */
            if (read_accept) begin
                rd_data
                    <= memory[
                        read_pointer[PTR_WIDTH-1:0]
                    ];

                read_pointer
                    <= read_pointer + POINTER_ONE;
            end
        end
    end

endmodule

`default_nettype wire
