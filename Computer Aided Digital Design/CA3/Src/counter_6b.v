module counter_6b (
    input wire clk,
    input wire rst,
    input wire en,
    
    output wire [5:0] out,
    output wire ok
);
    wire [4:0] condition;

    t_flipflop flip0(.clk(clk), .rst(rst), .t(en), .out(out[0]));
    c1 and0(.A0(1'b0) , .A1(1'b0) , .SA(en) , .B0(1'b0) , .B1(1'b1), .SB(en), .S0(out[0]), .S1(out[0]), .f(condition[0]));

    genvar i;
    generate
        for (i = 1; i < 5; i = i + 1) begin : gen_flip
            t_flipflop flipi(.clk(clk), .rst(rst), .t(condition[i-1]), .out(out[i]));
            c1 andi(.A0(1'b0) , .A1(1'b0) , .SA(condition[i-1]) , .B0(1'b0) , .B1(1'b1), .SB(condition[i-1]), .S0(out[i]), .S1(out[i]), .f(condition[i]));
        end
    endgenerate

    t_flipflop flip5(.clk(clk), .rst(rst), .t(condition[4]), .out(out[5]));

    wire fall_edg;
    c1 not_gate(.A0(1'b1) , .A1(1'b0) , .SA(out[5]) , .B0(1'b0) , .B1(1'b0), .SB(1'b0), .S0(1'b0), .S1(1'b0), .f(fall_edg));
    t_flipflop flip1(.clk(fall_edg), .rst(rst), .t(1'b1), .out(ok));

endmodule


