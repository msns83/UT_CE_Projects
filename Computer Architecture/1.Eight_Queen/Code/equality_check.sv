`timescale 1ns/1ns
module equality_check(
    input [2:0] a,
    input [2:0] b,
    output equal
);
    assign equal = (a == b);
endmodule