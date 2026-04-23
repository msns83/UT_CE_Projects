module adder_8b (
    input wire [7:0] a,
    input wire [7:0] b,

    output wire [7:0] s
);
    wire [6:0] carries;

    half_adder_1b a0(.a(a[0]), .b(b[0]), .s(s[0]), .cn(carries[0]));

    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : gen_f_adders
            full_adder_1b ai (.a(a[i]), .b(b[i]), .c(carries[i-1]), .s(s[i]), .cn(carries[i]));
        end
    endgenerate

    wire part1;
    c1 sum7_part1(.A0(1'b0), .A1(1'b1), .SA(b[7]), .B0(1'b1), .B1(1'b0), .SB(b[7]), .S0(a[7]), .S1(a[7]), .f(part1));
    c1 sum7_part2(.A0(1'b0) , .A1(1'b1) , .SA(part1) , .B0(1'b1) , .B1(1'b0), .SB(part1), .S0(carries[6]), .S1(carries[6]), .f(s[7]));
endmodule