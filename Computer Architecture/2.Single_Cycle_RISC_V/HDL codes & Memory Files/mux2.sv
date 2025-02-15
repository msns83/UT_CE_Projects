module mux_2to1 (
    input wire S, 
    input wire [31:0]D0, 
    input wire [31:0]D1, 
    output wire [31:0]Y 
);
    assign Y = (S == 1'b0) ? D0 : D1;
endmodule
