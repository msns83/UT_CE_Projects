`timescale 1ns/1ns
module safety_check(
    input [2:0] r_ch, c_ch, r2, c2,
    output threat
);

    wire [2:0]  abs1, abs2;
    wire w1, w2, w3;
    abs_subtractor abs_sub1 (.a(r_ch), .b(r2), .abs_diff(abs1)),
                   abs_sub2 (.a(c_ch), .b(c2), .abs_diff(abs2));
    equality_check eq1 (.a(r_ch), .b(r2), .equal(w1)),
                   eq2 (.a(c_ch), .b(c2), .equal(w2)),
                   eq3 (.a(abs1), .b(abs2), .equal(w3));
    assign threat = (w1 | w2 | w3);

endmodule