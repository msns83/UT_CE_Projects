`timescale 1ns/1ns

module fibo2(input [3:0] in , output out);
 assign w1 = ~in[3] & ~in[2];
 assign w2 = in[2] & ~in[1] & in[0];
 assign w3 = ~in[2] & ~in[1] & ~in[0];
 assign out = w1 | w2 | w3 ;
endmodule