module register_1b (
    input wire clk,
    input wire rst,
    input wire en,
    input wire in,
    input wire init_en,
    input wire init,
    
    output wire out
);
    wire val;
    s2 en_register(.D00(val), .D01(init), .D10(in), .D11(in), .A1(en), .B1(en), .A0(init_en), .B0(init_en), .clr(rst), .clk(clk), .out(val));
    assign out = val ;
endmodule