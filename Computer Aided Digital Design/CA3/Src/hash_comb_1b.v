module hash_comb_1b (
    input wire b,
    input wire c,
    input wire d,
    input wire [5:4] r,
    
    output wire o
);
    wire [4:1] combs;
    wire part1;

    c1 comb1(.A0(1'b0), .A1(1'b1), .SA(d), .B0(1'b0), .B1(1'b1), .SB(c), .S0(b), .S1(b), .f(combs[1]));
    c1 comb2(.A0(1'b0), .A1(1'b1), .SA(c), .B0(1'b0), .B1(1'b1), .SB(b), .S0(d), .S1(d), .f(combs[2]));

    c1 comb31(.A0(1'b0), .A1(1'b1), .SA(d), .B0(1'b1), .B1(1'b0), .SB(d), .S0(c), .S1(c), .f(part1));
    c1 comb32(.A0(1'b0), .A1(1'b1), .SA(part1), .B0(1'b1), .B1(1'b0), .SB(part1), .S0(b), .S1(b), .f(combs[3]));

    c1 comb4(.A0(1'b1), .A1(b), .SA(d), .B0(d), .B1(1'b0), .SB(b), .S0(c), .S1(c), .f(combs[4]));

    c1 mux(.A0(combs[1]), .A1(combs[2]), .SA(r[4]), .B0(combs[3]), .B1(combs[4]), .SB(r[4]), .S0(r[5]), .S1(r[5]), .f(o));

endmodule