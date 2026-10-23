`timescale 1ns/1ps

module tb_fifo_equivalence #(
    parameter integer DATA_WIDTH = 8,
    parameter integer DEPTH = 16,
    parameter integer RANDOM_CYCLES = 2000
);

    reg clk = 0;
    always #10 clk = ~clk;

    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] wr_data;

    wire [DATA_WIDTH-1:0] a_data, b_data;
    wire a_full, a_empty, a_overflow, a_underflow;
    wire b_full, b_empty, b_overflow, b_underflow;

    sync_fifo_count #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut_a (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_data(wr_data),
        .rd_en(rd_en), .rd_data(a_data),
        .full(a_full), .empty(a_empty),
        .overflow(a_overflow), .underflow(a_underflow)
    );

    sync_fifo_pointer #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut_b (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_data(wr_data),
        .rd_en(rd_en), .rd_data(b_data),
        .full(b_full), .empty(b_empty),
        .overflow(b_overflow), .underflow(b_underflow)
    );

    reg [DATA_WIDTH-1:0] model_mem [0:DEPTH-1];
    reg [DATA_WIDTH-1:0] expected_data;

    integer model_wr, model_rd, model_count;
    integer cycles, checks, errors;
    integer writes, reads, overflows, underflows;
    integer simultaneous, full_both, empty_both;
    integer wraps, resets;
    integer seed, i;
    reg [31:0] rng;
    reg random_wr, random_rd;

    task automatic check_bit;
        input [8*64-1:0] name;
        input actual, expected;
        begin
            checks = checks + 1;
            if (actual !== expected) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display(
                        "[FAIL] cycle=%0d %0s actual=%b expected=%b",
                        cycles, name, actual, expected
                    );
            end
        end
    endtask

    task automatic check_word;
        input [8*64-1:0] name;
        input [DATA_WIDTH-1:0] actual, expected;
        begin
            checks = checks + 1;
            if (actual !== expected) begin
                errors = errors + 1;
                if (errors <= 20)
                    $display(
                        "[FAIL] cycle=%0d %0s actual=%h expected=%h",
                        cycles, name, actual, expected
                    );
            end
        end
    endtask

    // Kiểm tra từng DUT so với mô hình tham chiếu,
    // đồng thời so sánh trực tiếp A với B.
    task automatic check_outputs;
        input expected_overflow, expected_underflow;
        begin
            check_bit("A.full", a_full, model_count == DEPTH);
            check_bit("A.empty", a_empty, model_count == 0);
            check_word("A.rd_data", a_data, expected_data);
            check_bit("A.overflow", a_overflow, expected_overflow);
            check_bit("A.underflow", a_underflow, expected_underflow);

            check_bit("B.full", b_full, model_count == DEPTH);
            check_bit("B.empty", b_empty, model_count == 0);
            check_word("B.rd_data", b_data, expected_data);
            check_bit("B.overflow", b_overflow, expected_overflow);
            check_bit("B.underflow", b_underflow, expected_underflow);

            check_bit("A/B.full", a_full, b_full);
            check_bit("A/B.empty", a_empty, b_empty);
            check_word("A/B.rd_data", a_data, b_data);
            check_bit("A/B.overflow", a_overflow, b_overflow);
            check_bit("A/B.underflow", a_underflow, b_underflow);
        end
    endtask

    task automatic reset_fifo;
        begin
            @(negedge clk);
            rst_n = 0;
            wr_en = 0;
            rd_en = 0;
            wr_data = 0;

            repeat (3) @(posedge clk);
            #1;

            model_wr = 0;
            model_rd = 0;
            model_count = 0;
            expected_data = 0;
            resets = resets + 1;

            check_outputs(0, 0);

            @(negedge clk);
            rst_n = 1;
        end
    endtask

    task automatic apply_cycle;
        input req_w, req_r;
        input [DATA_WIDTH-1:0] data;

        reg old_full, old_empty;
        reg accept_w, accept_r;
        reg exp_overflow, exp_underflow;
        reg [DATA_WIDTH-1:0] next_read_data;

        begin
            @(negedge clk);
            wr_en = req_w;
            rd_en = req_r;
            wr_data = data;

            old_full = (model_count == DEPTH);
            old_empty = (model_count == 0);

            accept_w = req_w && !old_full;
            accept_r = req_r && !old_empty;

            exp_overflow = req_w && old_full;
            exp_underflow = req_r && old_empty;

            next_read_data = expected_data;

            if (accept_r)
                next_read_data = model_mem[model_rd];

            @(posedge clk);
            #1;
            cycles = cycles + 1;

            // Model được cập nhật bằng các giao dịch
            // được chấp nhận trước cạnh clock.
            if (accept_w) begin
                model_mem[model_wr] = data;

                if (model_wr == DEPTH - 1)
                    wraps = wraps + 1;

                model_wr = (model_wr + 1) % DEPTH;
                writes = writes + 1;
            end

            if (accept_r) begin
                if (model_rd == DEPTH - 1)
                    wraps = wraps + 1;

                model_rd = (model_rd + 1) % DEPTH;
                reads = reads + 1;
            end

            if (accept_w && !accept_r)
                model_count = model_count + 1;
            else if (accept_r && !accept_w)
                model_count = model_count - 1;

            expected_data = next_read_data;

            if (exp_overflow) overflows = overflows + 1;
            if (exp_underflow) underflows = underflows + 1;
            if (accept_w && accept_r)
                simultaneous = simultaneous + 1;
            if (req_w && req_r && old_full)
                full_both = full_both + 1;
            if (req_w && req_r && old_empty)
                empty_both = empty_both + 1;

            check_outputs(exp_overflow, exp_underflow);
        end
    endtask

    function automatic [31:0] next_random;
        input [31:0] previous;
        reg [31:0] value;
        begin
            value = previous ^ (previous << 13);
            value = value ^ (value >> 17);
            value = value ^ (value << 5);
            next_random = value;
        end
    endfunction

    initial begin
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        cycles = 0;
        checks = 0;
        errors = 0;
        writes = 0;
        reads = 0;
        overflows = 0;
        underflows = 0;
        simultaneous = 0;
        full_both = 0;
        empty_both = 0;
        wraps = 0;
        resets = 0;

        model_wr = 0;
        model_rd = 0;
        model_count = 0;
        expected_data = 0;

        if (!$value$plusargs("SEED=%d", seed))
            seed = 1;

        rng = seed;
        if (rng == 0)
            rng = 32'h13579BDF;

        if (DATA_WIDTH < 1 ||
            DEPTH < 2 ||
            (DEPTH & (DEPTH - 1)) != 0)
            $fatal(1, "Unsupported parameters");

        $dumpfile("t17.vcd");
        $dumpvars(0, tb_fifo_equivalence);

        reset_fifo();

        // Điền đầy FIFO, overflow và simultaneous tại full.
        for (i = 0; i < DEPTH; i = i + 1)
            apply_cycle(1, 0, i + 'hA5);

        apply_cycle(1, 0, {DATA_WIDTH{1'b1}});
        apply_cycle(1, 1, 'h55);

        // Đọc/ghi đồng thời khi FIFO đang hoạt động.
        repeat (DEPTH / 2)
            apply_cycle(1, 1, 'hA6);

        // Xả hết, tạo underflow và simultaneous tại empty.
        while (model_count > 0)
            apply_cycle(0, 1, 0);

        apply_cycle(0, 1, 0);
        apply_cycle(1, 1, 'h5A);
        apply_cycle(0, 1, 0);

        // Nhiều lần wrap-around.
        for (i = 0; i < 3 * DEPTH; i = i + 1) begin
            apply_cycle(1, 0, i);
            apply_cycle(0, 1, 0);
        end

        // Reset khi còn dữ liệu trong FIFO.
        repeat (DEPTH / 2)
            apply_cycle(1, 0, 'h77);

        reset_fifo();

        // Random, cùng kích thích cho hai DUT.
        for (i = 0; i < RANDOM_CYCLES; i = i + 1) begin
            rng = next_random(rng);
            random_wr = rng[0];
            random_rd = rng[1];
            rng = next_random(rng);
            apply_cycle(
                random_wr,
                random_rd,
                rng[DATA_WIDTH-1:0]
            );
        end

        while (model_count > 0)
            apply_cycle(0, 1, 0);

        $display("T17_DATA_WIDTH=%0d", DATA_WIDTH);
        $display("T17_DEPTH=%0d", DEPTH);
        $display("T17_SEED=%0d", seed);
        $display("T17_CYCLES=%0d", cycles);
        $display("T17_CHECKS=%0d", checks);
        $display("T17_ERRORS=%0d", errors);
        $display("T17_WRITES=%0d", writes);
        $display("T17_READS=%0d", reads);
        $display("T17_OVERFLOWS=%0d", overflows);
        $display("T17_UNDERFLOWS=%0d", underflows);
        $display("T17_SIMULTANEOUS=%0d", simultaneous);
        $display("T17_FULL_BOTH=%0d", full_both);
        $display("T17_EMPTY_BOTH=%0d", empty_both);
        $display("T17_WRAPS=%0d", wraps);
        $display("T17_RESETS=%0d", resets);

        if (errors != 0 ||
            overflows == 0 ||
            underflows == 0 ||
            simultaneous == 0 ||
            full_both == 0 ||
            empty_both == 0 ||
            wraps < 3 ||
            resets < 2)
            $fatal(1, "T17_EQUIVALENCE_FAIL");

        $display("T17_EQUIVALENCE_PASS");
        $finish;
    end

endmodule
