`timescale 1ns/1ns
module RCA16(input [15:0] A,B, input cin, output [15:0] S, output cout);
 wire w0,w1,w2;

 RCA4 fa1(A[3:0],B[3:0],cin,S[3:0],w0);
 RCA4 fa2(A[7:4],B[7:4],w0,S[7:4],w1);
 RCA4 fa3(A[11:8],B[11:8],w1,S[11:8],w2);
 RCA4 fa4(A[15:12],B[15:12],w2,S[15:12],cout);
 
endmodule



