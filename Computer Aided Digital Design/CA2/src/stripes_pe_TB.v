`timescale 1ns/1ns

module stripes_pe_TB #(
    parameter N_COUNT = 4,
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 34
);
    reg clk;
    reg rst;

    reg i_is_valid;
    reg i_is_msb;
    reg i_is_lsb;

    reg [N_COUNT-1:0] i_vec_a_bits;
    reg [N_COUNT*INPUT_WIDTH-1:0] i_vec_b;
    reg [OUTPUT_WIDTH-1:0] i_initial_sum;
    wire [OUTPUT_WIDTH-1:0] o_dot_product;

    reg [INPUT_WIDTH-1:0] vec_a [0:N_COUNT-1];
    reg [INPUT_WIDTH-1:0] vec_b [0:N_COUNT-1];

    reg en;
    integer i, j;
    integer bit_idx;

    stripes_pe #(
        .W_SIZE(INPUT_WIDTH),
        .N_COUNT(N_COUNT),
        .OUT_SIZE(OUTPUT_WIDTH)
    ) dut (
        .clk(clk), .rst(rst),
        .i_vec_a_bits(i_vec_a_bits),
        .i_is_msb(i_is_msb), .i_is_lsb(i_is_lsb), .i_is_valid(i_is_valid),
        .i_vec_b(i_vec_b),
        .i_initial_sum(i_initial_sum),
        .o_dot_product(o_dot_product)
    );

    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    initial begin
        vec_b[0] = 16'hff9c; vec_b[1] = 16'hff9c; vec_b[2] = 16'hff9c; vec_b[3] = 16'hff9c;
        vec_a[0] = 16'h1; vec_a[1] = 16'h2; vec_a[2] = 16'h3; vec_a[3] = 16'h4;
    end

    always @* begin
        for (j = 0; j < N_COUNT; j = j + 1)
            i_vec_b[j*INPUT_WIDTH +: INPUT_WIDTH] = vec_b[j];
    end

    initial begin
        rst = 1'b1; en = 1'b0;
        i_is_valid = 1'b0; i_is_msb = 1'b0; i_is_lsb = 1'b0;
        i_initial_sum= {OUTPUT_WIDTH{1'b0}};
        bit_idx = 0;

        #3 rst = 1'b0; en = 1'b1; i_is_valid = 1'b1;

        #(INPUT_WIDTH*2);

        i_is_valid = 1'b0; en = 1'b0;

        #20 $stop;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            i_vec_a_bits <= {N_COUNT{1'b0}};
            bit_idx <= 0;
            i_is_msb <= 1'b0;
            i_is_lsb <= 1'b0;
        end else if (en) begin
            i_is_msb <= (bit_idx == 0);
            i_is_lsb <= (bit_idx == INPUT_WIDTH-1);

            for (i = 0; i < N_COUNT; i = i + 1) begin
                i_vec_a_bits[i] <= vec_a[i][INPUT_WIDTH-1];
                vec_a[i] <= {vec_a[i][INPUT_WIDTH-2:0], 1'b0};
            end

            bit_idx <= bit_idx + 1;
            if (bit_idx == INPUT_WIDTH-1)
                en <= 1'b0;
        end else begin
            i_is_msb <= 1'b0;
            i_is_lsb <= 1'b0;
        end
    end

endmodule
