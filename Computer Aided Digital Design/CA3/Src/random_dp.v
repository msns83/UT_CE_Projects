module random_dp (
    input wire clk,
    input wire rst,
    input wire load_en,
    input wire en,
    input wire [5:0] load,
    
    output wire [1:0] out,
    output wire c_done
);
    wire [5:0] shifter_val ;
    wire xor_part1, xor_part2 ;

    c1 xors1(.A0(1'b1), .A1(1'b0), .SA(shifter_val[3]), .B0(1'b0), .B1(1'b1), .SB(shifter_val[3]), .S0(shifter_val[5]), .S1(shifter_val[5]), .f(xor_part1));
    c1 xors2(.A0(1'b1), .A1(1'b0), .SA(xor_part1), .B0(1'b0), .B1(1'b1), .SB(xor_part1), .S0(shifter_val[1]), .S1(shifter_val[1]), .f(xor_part2));

    shifter_6b shifter(.clk(clk), .rst(rst), .in(xor_part2), .sh_en(en), .load_en(load_en), .load(load), .out(shifter_val));

    counter_3b counter(.clk(clk), .rst(rst), .en(en), .out(), .c_done(c_done));

    assign out = shifter_val[5:4];

endmodule