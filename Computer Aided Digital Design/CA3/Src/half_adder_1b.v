module half_adder_1b(
    input wire a,
    input wire b,
    
    output wire s,
    output wire cn
);
    c1 sum(.A0(1'b0), .A1(1'b1), .SA(b), .B0(1'b1), .B1(1'b0), .SB(b), .S0(a), .S1(a), .f(s));
    c1 carry(.A0(1'b0), .A1(1'b0), .SA(b), .B0(1'b0), .B1(1'b1), .SB(b), .S0(a), .S1(a), .f(cn));
endmodule