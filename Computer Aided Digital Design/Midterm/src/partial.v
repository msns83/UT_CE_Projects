module partial #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 16,
    parameter SHIFT_COUNT_BITS = $clog2(IN_WIDTH)
)(
    input wire clk,
    input wire rst,
    input wire A_en,
    input wire [IN_WIDTH-1:0] A, W,

    output wire [OUT_WIDTH-1:0] out,
    output wire done
);
    wire [IN_WIDTH-1:0] masked_A ;
    wire [SHIFT_COUNT_BITS-1:0] shift_count ;
    wire no_one ;

    A_reg #(.WIDTH(IN_WIDTH)) A_reg_inst (
        .clk(clk), .rst(rst),
        .en(A_en),
        .in(A),
        .zero_en(~no_one),
        .zero_index(shift_count),
        .out(masked_A)
    );

    LOD #(.WIDTH(IN_WIDTH)) LOD_inst(
        .in(masked_A),
        .shift_count(shift_count),
        .no_one(no_one)
    );

    mult #(IN_WIDTH, OUT_WIDTH, SHIFT_COUNT_BITS) mult_inst(
        .in(W),
        .shift_count(shift_count),
        .gen_empty(no_one),
        .out(out)
    );

    assign done = no_one;
endmodule