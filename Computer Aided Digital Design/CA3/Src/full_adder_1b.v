module full_adder_1b(
    input wire a,
    input wire b,
    input wire c,
    
    output wire s,
    output wire cn
);
    wire part1;
    c1 sum_part1(.A0(1'b0), .A1(1'b1), .SA(b), .B0(1'b1), .B1(1'b0), .SB(b), .S0(a), .S1(a), .f(part1));
    c1 sum_part2(.A0(1'b0) , .A1(1'b1) , .SA(part1) , .B0(1'b1) , .B1(1'b0), .SB(part1), .S0(c), .S1(c), .f(s));

    c1 carry(.A0(1'b0) , .A1(c) , .SA(b) , .B0(c) , .B1(1'b1), .SB(b), .S0(a), .S1(a), .f(cn));
endmodule