module two_s_complement #(parameter WIDTH)(a,b);
input [WIDTH - 1 : 0] a;
output [WIDTH -1 : 0] b;
assign b = ~a + 1;
endmodule