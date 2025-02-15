`timescale 1ns/1ns
module mux2(input a,b,select, output out);
 wire w0,w1,w2,w3;

 not n1(w0,select);
 and a1(w1,select,b);
 and a2(w2,w0,a);
 or o1(w3,w1,w2);
 and #(2) a3(out,w3,w3);
 
endmodule



