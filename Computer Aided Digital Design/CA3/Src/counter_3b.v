module counter_3b (
    input wire clk,
    input wire rst,
    input wire en,
    
    output wire [2:0] out,
    output wire c_done
);
    wire [1:0] condition;

    t_flipflop flip0(.clk(clk), .rst(rst), .t(en), .out(out[0]));
    c1 and0(.A0(1'b0) , .A1(1'b0) , .SA(en) , .B0(1'b0) , .B1(1'b1), .SB(en), .S0(out[0]), .S1(out[0]), .f(condition[0]));

    t_flipflop flip1(.clk(clk), .rst(rst), .t(condition[0]), .out(out[1]));
    c1 and1(.A0(1'b0) , .A1(1'b0) , .SA(condition[0]) , .B0(1'b0) , .B1(1'b1), .SB(condition[0]), .S0(out[1]), .S1(out[1]), .f(condition[1]));

    t_flipflop flip2(.clk(clk), .rst(rst), .t(condition[1]), .out(out[2]));

    c1 alert_1(.A0(1'b0), .A1(out[2]), .SA(out[1]), .B0(1'b0), .B1(1'b0), .SB(out[1]), .S0(out[0]), .S1(out[0]), .f(c_done));
endmodule