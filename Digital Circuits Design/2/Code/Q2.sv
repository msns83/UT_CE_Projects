`timescale 1ns/1ns
module RCA4(input [3:0] A,B, input cin, output [3:0] S, output cout);
 wire w0,w1,w2;

 fullAdder fa1(A[0],B[0],cin,S[0],w0);
 fullAdder fa2(A[1],B[1],w0,S[1],w1);
 fullAdder fa3(A[2],B[2],w1,S[2],w2);
 fullAdder fa4(A[3],B[3],w2,S[3],cout);
 
endmodule



