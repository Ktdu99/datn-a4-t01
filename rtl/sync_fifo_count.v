`timescale 1ns/1ps
`default_nettype none

module sync_fifo_count #(
    parameter integer DATA_WIDTH = 8,
    parameter integer DEPTH      = 16,
    parameter integer PTR_WIDTH  = $clog2(DEPTH),
    parameter integer CNT_WIDTH  = $clog2(DEPTH + 1)
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
     * DEPTH phải là lũy thừa của 2 và lớn hơn hoặc bằng 2.
     *
     * Ví dụ DEPTH=16:
     * PTR_WIDTH = 4
     * CNT_WIDTH = 5
     */

    localparam [PTR_WIDTH-1:0] LAST_ADDRESS =
        DEPTH - 1;

    localparam [CNT_WIDTH-1:0] DEPTH_COUNT =
        DEPTH;

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    reg [PTR_WIDTH-1:0] write_pointer;
    reg [PTR_WIDTH-1:0] read_pointer;

    reg [CNT_WIDTH-1:0] data_count;

    wire write_accept;
    wire read_accept;

    assign empty = (data_count == {CNT_WIDTH{1'b0}});
    assign full  = (data_count == DEPTH_COUNT);

    assign write_accept = wr_en && !full;
    assign read_accept  = rd_en && !empty;

    always @(posedge clk) begin
        if (!rst_n) begin
            write_pointer <= {PTR_WIDTH{1'b0}};
            read_pointer  <= {PTR_WIDTH{1'b0}};
            data_count    <= {CNT_WIDTH{1'b0}};
            rd_data       <= {DATA_WIDTH{1'b0}};
            overflow      <= 1'b0;
            underflow     <= 1'b0;
        end else begin
            /*
             * Overflow và underflow là xung kéo dài một chu kỳ.
             */
            overflow  <= wr_en && full;
            underflow <= rd_en && empty;

            /*
             * Ghi dữ liệu khi yêu cầu ghi hợp lệ.
             */
            if (write_accept) begin
                memory[write_pointer] <= wr_data;

                if (write_pointer == LAST_ADDRESS)
                    write_pointer <= {PTR_WIDTH{1'b0}};
                else
                    write_pointer <= write_pointer + 1'b1;
            end

            /*
             * Đọc dữ liệu khi yêu cầu đọc hợp lệ.
             * rd_data là registered output.
             */
            if (read_accept) begin
                rd_data <= memory[read_pointer];

                if (read_pointer == LAST_ADDRESS)
                    read_pointer <= {PTR_WIDTH{1'b0}};
                else
                    read_pointer <= read_pointer + 1'b1;
            end

            /*
             * Cập nhật số phần tử.
             */
            case ({write_accept, read_accept})
                2'b10: data_count <= data_count + 1'b1;
                2'b01: data_count <= data_count - 1'b1;
                default: data_count <= data_count;
            endcase
        end
    end

endmodule

`default_nettype wire
