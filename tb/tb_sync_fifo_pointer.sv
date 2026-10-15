`timescale 1ns/1ps

module tb_sync_fifo_pointer;

    parameter integer DATA_WIDTH    = 8;
    parameter integer DEPTH         = 16;
    parameter integer RANDOM_CYCLES = 10000;

    reg clk;
    reg rst_n;

    reg                  wr_en;
    reg [DATA_WIDTH-1:0] wr_data;

    reg                  rd_en;
    wire [DATA_WIDTH-1:0] rd_data;

    wire full;
    wire empty;
    wire overflow;
    wire underflow;

    /*
     * Mô hình FIFO tham chiếu dành riêng cho testbench.
     */
    reg [DATA_WIDTH-1:0] reference_memory [0:DEPTH-1];

    integer reference_write_pointer;
    integer reference_read_pointer;
    integer reference_count;

    reg [DATA_WIDTH-1:0] expected_read_data;
    reg [DATA_WIDTH-1:0] last_read_data;

    integer cycle_count;
    integer check_count;
    integer error_count;

    integer accepted_write_count;
    integer accepted_read_count;
    integer overflow_event_count;
    integer underflow_event_count;
    integer simultaneous_event_count;

    integer seed;
    integer random_word;
    integer i;

    /*
     * Khối DUT: FIFO phương án B.
     */
    sync_fifo_pointer #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),

        .wr_en(wr_en),
        .wr_data(wr_data),

        .rd_en(rd_en),
        .rd_data(rd_data),

        .full(full),
        .empty(empty),

        .overflow(overflow),
        .underflow(underflow)
    );

    /*
     * Clock period = 20 ns tương ứng 50 MHz.
     */
    initial begin
        clk = 1'b0;
    end

    always #10 clk = ~clk;

    /*
     * Ghi nhận một lỗi verification.
     */
    task report_error;
        input [8*120-1:0] message;
        begin
            error_count = error_count + 1;

            $display(
                "[FAIL] cycle=%0d time=%0t : %0s",
                cycle_count,
                $time,
                message
            );
        end
    endtask

    /*
     * Kiểm tra full và empty so với mô hình tham chiếu.
     */
    task check_status_flags;
        begin
            check_count = check_count + 1;

            if (empty !== (reference_count == 0))
                report_error("empty flag mismatch");

            if (full !== (reference_count == DEPTH))
                report_error("full flag mismatch");
        end
    endtask

    /*
     * Thực hiện một chu kỳ kích thích.
     *
     * Input được thay đổi tại cạnh xuống.
     * DUT xử lý tại cạnh lên tiếp theo.
     * Kết quả được kiểm tra sau cạnh lên 1 ns.
     */
    task apply_cycle;

        input request_write;
        input request_read;
        input [DATA_WIDTH-1:0] input_data;

        reg pre_full;
        reg pre_empty;

        reg expected_write_accept;
        reg expected_read_accept;

        begin
            @(negedge clk);

            wr_en   = request_write;
            rd_en   = request_read;
            wr_data = input_data;

            /*
             * Trạng thái ngay trước cạnh clock.
             */
            pre_full  = (reference_count == DEPTH);
            pre_empty = (reference_count == 0);

            expected_write_accept =
                request_write && !pre_full;

            expected_read_accept =
                request_read && !pre_empty;

            /*
             * Lưu trước dữ liệu dự kiến đọc.
             */
            if (expected_read_accept)
                expected_read_data =
                    reference_memory[reference_read_pointer];

            @(posedge clk);
            #1;

            cycle_count = cycle_count + 1;

            /*
             * Kiểm tra overflow và underflow.
             */
            check_count = check_count + 1;

            if (overflow !== (request_write && pre_full))
                report_error("overflow pulse mismatch");

            if (underflow !== (request_read && pre_empty))
                report_error("underflow pulse mismatch");

            /*
             * Kiểm tra dữ liệu đọc.
             */
            check_count = check_count + 1;

            if (expected_read_accept) begin
                if (rd_data !== expected_read_data) begin
                    $display(
                        "       expected=%02h actual=%02h",
                        expected_read_data,
                        rd_data
                    );

                    report_error("read data mismatch");
                end

                last_read_data = expected_read_data;
            end else begin
                /*
                 * rd_data phải giữ nguyên khi không có lần đọc hợp lệ.
                 */
                if (rd_data !== last_read_data)
                    report_error(
                        "rd_data changed without accepted read"
                    );
            end

            /*
             * Cập nhật mô hình tham chiếu.
             */
            if (expected_write_accept) begin
                reference_memory[reference_write_pointer] =
                    input_data;

                reference_write_pointer =
                    (reference_write_pointer + 1) % DEPTH;

                accepted_write_count =
                    accepted_write_count + 1;
            end

            if (expected_read_accept) begin
                reference_read_pointer =
                    (reference_read_pointer + 1) % DEPTH;

                accepted_read_count =
                    accepted_read_count + 1;
            end

            case ({
                expected_write_accept,
                expected_read_accept
            })
                2'b10:
                    reference_count = reference_count + 1;

                2'b01:
                    reference_count = reference_count - 1;

                default:
                    reference_count = reference_count;
            endcase

            if (request_write && pre_full)
                overflow_event_count =
                    overflow_event_count + 1;

            if (request_read && pre_empty)
                underflow_event_count =
                    underflow_event_count + 1;

            if (
                expected_write_accept &&
                expected_read_accept
            )
                simultaneous_event_count =
                    simultaneous_event_count + 1;

            check_status_flags();
        end
    endtask

    /*
     * Reset DUT và mô hình tham chiếu.
     */
    task reset_fifo;
        begin
            @(negedge clk);

            rst_n   = 1'b0;
            wr_en   = 1'b0;
            rd_en   = 1'b0;
            wr_data = {DATA_WIDTH{1'b0}};

            repeat (3) @(posedge clk);
            #1;

            reference_write_pointer = 0;
            reference_read_pointer  = 0;
            reference_count         = 0;
            last_read_data          = {DATA_WIDTH{1'b0}};

            check_count = check_count + 1;

            if (
                empty !== 1'b1 ||
                full !== 1'b0 ||
                overflow !== 1'b0 ||
                underflow !== 1'b0 ||
                rd_data !== {DATA_WIDTH{1'b0}}
            )
                report_error("reset state mismatch");

            @(negedge clk);
            rst_n = 1'b1;

            @(posedge clk);
            #1;

            check_status_flags();
        end
    endtask

    /*
     * Directed tests.
     */
    task run_directed_tests;
        begin
            $display("");
            $display("[TEST T01] Reset");
            reset_fifo();

            $display("");
            $display("[TEST T02-T04] Basic FIFO ordering");

            apply_cycle(1'b1, 1'b0, 8'h11);
            apply_cycle(1'b1, 1'b0, 8'h22);
            apply_cycle(1'b1, 1'b0, 8'h33);
            apply_cycle(1'b1, 1'b0, 8'h44);

            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            $display("");
            $display("[TEST T08] Underflow");

            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            $display("");
            $display("[TEST T05] Fill FIFO");

            for (i = 0; i < DEPTH; i = i + 1)
                apply_cycle(
                    1'b1,
                    1'b0,
                    i[DATA_WIDTH-1:0]
                );

            $display("");
            $display("[TEST T06] Overflow");

            apply_cycle(
                1'b1,
                1'b0,
                {DATA_WIDTH{1'b1}}
            );

            $display("");
            $display(
                "[TEST T10] Simultaneous request at full"
            );

            /*
             * Theo specification:
             * chỉ đọc được chấp nhận, ghi bị từ chối.
             */
            apply_cycle(1'b1, 1'b1, 8'hA5);

            $display("");
            $display(
                "[TEST T09] Normal simultaneous read/write"
            );

            repeat (DEPTH / 2)
                apply_cycle(
                    1'b1,
                    1'b1,
                    $urandom
                );

            $display("");
            $display("[TEST T07] Drain FIFO");

            while (reference_count > 0)
                apply_cycle(
                    1'b0,
                    1'b1,
                    {DATA_WIDTH{1'b0}}
                );

            $display("");
            $display(
                "[TEST T11] Simultaneous request at empty"
            );

            /*
             * Theo specification:
             * chỉ ghi được chấp nhận, đọc bị từ chối.
             */
            apply_cycle(1'b1, 1'b1, 8'h5A);

            /*
             * Đọc lại dữ liệu vừa ghi.
             */
            apply_cycle(
                1'b0,
                1'b1,
                {DATA_WIDTH{1'b0}}
            );

            $display("");
            $display(
                "[TEST T12] Multiple pointer wrap-arounds"
            );

            for (i = 0; i < (3 * DEPTH); i = i + 1) begin
                apply_cycle(
                    1'b1,
                    1'b0,
                    i[DATA_WIDTH-1:0]
                );

                apply_cycle(
                    1'b0,
                    1'b1,
                    {DATA_WIDTH{1'b0}}
                );
            end

            $display("");
            $display(
                "[TEST T13] Reset while FIFO contains data"
            );

            repeat (DEPTH / 2)
                apply_cycle(
                    1'b1,
                    1'b0,
                    $urandom
                );

            reset_fifo();
        end
    endtask

    /*
     * Random regression.
     */
    task run_random_tests;
        begin
            $display("");
            $display(
                "[TEST T14] Random regression: cycles=%0d seed=%0d",
                RANDOM_CYCLES,
                seed
            );

            for (
                i = 0;
                i < RANDOM_CYCLES;
                i = i + 1
            ) begin
                random_word = $urandom;

                apply_cycle(
                    random_word & 1,
                    (random_word >> 1) & 1,
                    $urandom
                );
            end

            /*
             * Đọc hết dữ liệu còn lại và tiếp tục kiểm tra thứ tự.
             */
            while (reference_count > 0)
                apply_cycle(
                    1'b0,
                    1'b1,
                    {DATA_WIDTH{1'b0}}
                );
        end
    endtask

    initial begin
        $dumpfile(
            "sim/waveforms/sync_fifo_pointer.vcd"
        );

        $dumpvars(
            0,
            tb_sync_fifo_pointer
        );

        rst_n   = 1'b0;
        wr_en   = 1'b0;
        wr_data = {DATA_WIDTH{1'b0}};
        rd_en   = 1'b0;

        cycle_count = 0;
        check_count = 0;
        error_count = 0;

        accepted_write_count = 0;
        accepted_read_count = 0;
        overflow_event_count = 0;
        underflow_event_count = 0;
        simultaneous_event_count = 0;

        reference_write_pointer = 0;
        reference_read_pointer = 0;
        reference_count = 0;

        expected_read_data =
            {DATA_WIDTH{1'b0}};

        last_read_data =
            {DATA_WIDTH{1'b0}};

        if (!$value$plusargs("SEED=%d", seed))
            seed = 20260924;

        random_word = $urandom(seed);

        /*
         * Kiểm tra điều kiện tham số.
         */
        if (
            DEPTH < 2 ||
            ((DEPTH & (DEPTH - 1)) != 0)
        )
            $fatal(
                1,
                "DEPTH must be a power of two and >= 2"
            );

        run_directed_tests();
        run_random_tests();

        $display("");
        $display(
            "============================================================"
        );

        $display("FIFO ARCHITECTURE B VERIFICATION SUMMARY");
        $display("DATA_WIDTH             : %0d", DATA_WIDTH);
        $display("DEPTH                  : %0d", DEPTH);
        $display("Random seed            : %0d", seed);
        $display("Cycles                 : %0d", cycle_count);
        $display("Checks                 : %0d", check_count);
        $display(
            "Accepted writes        : %0d",
            accepted_write_count
        );
        $display(
            "Accepted reads         : %0d",
            accepted_read_count
        );
        $display(
            "Overflow events        : %0d",
            overflow_event_count
        );
        $display(
            "Underflow events       : %0d",
            underflow_event_count
        );
        $display(
            "Simultaneous events    : %0d",
            simultaneous_event_count
        );
        $display("Errors                 : %0d", error_count);

        $display(
            "============================================================"
        );

        if (error_count == 0) begin
            $display("ALL TESTS PASSED");
            $finish;
        end else begin
            $fatal(
                1,
                "FIFO VERIFICATION FAILED: %0d errors",
                error_count
            );
        end
    end

endmodule
