module and_1b(
    input  wire A1,
    input  wire B1,
    output wire out
);
    c1 u_and (
        .A0(1'b0), .A1(1'b0), .SA(1'b0),
        .B0(1'b0), .B1(1'b1), .SB(A1),
        .S0(1'b0), .S1(B1),
        .f(out)
    );
endmodule