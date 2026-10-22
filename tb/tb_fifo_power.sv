`timescale 1ns/1ps

`ifndef DUT_MODULE
`define DUT_MODULE sync_fifo_count
`endif

module tb_fifo_power;

    reg clk = 0;
    reg rst_n = 0;
    reg wr_en = 0;
    reg rd_en = 0;
    reg [7:0] wr_data = 0;

    wire [7:0] rd_data;
    wire full;
    wire empty;
    wire overflow;
    wire underflow;

    // Chọn kiến trúc A/B bằng tùy chọn khi biên dịch.
    `DUT_MODULE dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .wr_en     (wr_en),
        .rd_en     (rd_en),
        .wr_data   (wr_data),
        .rd_data   (rd_data),
        .full      (full),
        .empty     (empty),
        .overflow  (overflow),
        .underflow (underflow)
    );

    // Chu kỳ 20 ns, tương ứng 50 MHz.
    always #10 clk = ~clk;

    // Golden model độc lập với kiến trúc DUT.
    reg [7:0] reference_memory [0:15];
    reg [7:0] expected_data = 0;

    integer read_index = 0;
    integer write_index = 0;
    integer occupancy = 0;

    integer errors = 0;
    integer measured_writes = 0;
    integer measured_reads = 0;

    integer i;
    integer measure_enable = 0;

    reg write_accept;
    reg read_accept;
    reg expected_overflow;
    reg expected_underflow;

    // Chuỗi dữ liệu cố định, giống nhau cho A và B.
    reg [31:0] rng = 32'h5a17c9e3;

    string vcd_path = "fifo_power.vcd";

    task apply_cycle;
        input write_request;
        input read_request;
        input [7:0] input_data;

        begin
            // Đổi đầu vào tại cạnh xuống để tránh race.
            @(negedge clk);

            wr_en = write_request;
            rd_en = read_request;
            wr_data = input_data;

            write_accept = write_request && (occupancy < 16);
            read_accept = read_request && (occupancy > 0);

            expected_overflow =
                write_request && (occupancy == 16);

            expected_underflow =
                read_request && (occupancy == 0);

            @(posedge clk);

            // Đọc trước khi cập nhật ô nhớ trong golden model.
            if (read_accept) begin
                expected_data = reference_memory[read_index];
                read_index = (read_index + 1) % 16;
            end

            if (write_accept) begin
                reference_memory[write_index] = input_data;
                write_index = (write_index + 1) % 16;
            end

            occupancy = occupancy + write_accept - read_accept;

            if (measure_enable) begin
                measured_writes = measured_writes + write_accept;
                measured_reads = measured_reads + read_accept;
            end

            // Chờ cập nhật thanh ghi và logic zero-delay.
            #1;

            if (
                (rd_data !== expected_data) ||
                (full !== (occupancy == 16)) ||
                (empty !== (occupancy == 0)) ||
                (overflow !== expected_overflow) ||
                (underflow !== expected_underflow)
            ) begin
                errors = errors + 1;

                if (errors <= 10) begin
                    $display(
                        "ERROR t=%0t expected=%h actual=%h count=%0d",
                        $time,
                        expected_data,
                        rd_data,
                        occupancy
                    );
                end
            end
        end
    endtask

    initial begin
        if ($value$plusargs("VCD=%s", vcd_path)) begin
            // Đường dẫn VCD được nhận từ dòng lệnh.
        end

        // Reset đồng bộ.
        repeat (4) @(posedge clk);
        #1;

        if (
            (empty !== 1'b1) ||
            (full !== 1'b0) ||
            (rd_data !== 8'h00) ||
            (overflow !== 1'b0) ||
            (underflow !== 1'b0)
        ) begin
            $fatal(1, "RESET_CHECK_FAILED");
        end

        @(negedge clk);
        rst_n = 1;

        // Khởi tạo toàn bộ memory bằng giao dịch hợp lệ.
        for (i = 0; i < 16; i = i + 1)
            apply_cycle(1, 0, i);

        // Đọc hết dữ liệu để kiểm tra và đưa FIFO về rỗng.
        for (i = 0; i < 16; i = i + 1)
            apply_cycle(0, 1, 0);

        // Nạp trước 8 phần tử.
        for (i = 0; i < 8; i = i + 1)
            apply_cycle(1, 0, i + 64);

        if (errors != 0)
            $fatal(1, "WARMUP_FAILED");

        // Chỉ ghi waveform sau reset và warmup.
        measure_enable = 1;

        $dumpfile(vcd_path);
        $dumpvars(0, tb_fifo_power.dut);

        // Streaming: đồng thời đọc/ghi 10000 chu kỳ.
        // Occupancy duy trì ở mức 8.
        for (i = 0; i < 10000; i = i + 1) begin
            rng = rng ^ (rng << 13);
            rng = rng ^ (rng >> 17);
            rng = rng ^ (rng << 5);

            apply_cycle(1, 1, rng[7:0]);
        end

        $display("WORKLOAD=streaming");
        $display("MEASURED_CYCLES=10000");
        $display("WRITES=%0d", measured_writes);
        $display("READS=%0d", measured_reads);
        $display("ERRORS=%0d", errors);

        if (errors != 0)
            $fatal(1, "POWER_WORKLOAD_FAILED");

        $display("POWER_WORKLOAD_PASS");
        $finish;
    end

endmodule
