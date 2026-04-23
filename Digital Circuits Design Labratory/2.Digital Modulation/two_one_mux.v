module two_one_mux #(parameter WIDTH)(a, b, s, c);
input wire [WIDTH - 1 : 0] a, b;
input wire s;
output wire[WIDTH - 1 : 0] c;
assign c = ~s?a:b;
endmodule