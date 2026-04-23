module t_flipflop (
    input wire clk,
    input wire rst,
    input wire t,
    
    output wire out
);
    wire val;
    s2 en_register(.D00(1'b0), .D01(1'b1), .D10(1'b1), .D11(1'b0), .A1(t), .B1(t), .A0(val), .B0(val), .clr(rst), .clk(clk), .out(val));
    assign out = val ;
endmodule