`timescale 1ns/1ns
module abs_subtractor(
    input [2:0] a,
    input [2:0] b,
    output [2:0] abs_diff
);
    wire [3:0] diff;
    wire [2:0] pos_diff;
    wire [2:0] neg_diff;
    wire is_negative;

    assign diff = a - b;

    assign is_negative = diff[3];

    assign pos_diff = diff[2:0];
    assign neg_diff = ~diff[2:0] + 1;

    assign abs_diff = is_negative ? neg_diff : pos_diff;
endmodule