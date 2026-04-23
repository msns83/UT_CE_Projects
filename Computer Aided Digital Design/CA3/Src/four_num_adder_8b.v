module four_num_adder (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [7:0] c,
    input wire [7:0] d,

    output wire [7:0] s
);
    wire [7:0] result1, result2 ;
    adder_8b first(.a(a), .b(b), .s(result1));
    adder_8b second(.a(c), .b(d), .s(result2));
    adder_8b third(.a(result1), .b(result2), .s(s));
endmodule