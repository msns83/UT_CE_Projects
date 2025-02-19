`timescale 1ns/1ns

module majority3(input [3:0] in [2:0] , output out);
 wire a,b,c;
 fibo2 A(in[2], a);
 fibo2 B(in[1], b);
 fibo2 C(in[0], c);
 assign out = (b&c) | (a&b) | (a&c);
endmodule
