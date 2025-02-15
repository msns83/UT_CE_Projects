`timescale 1ns/1ns
module mux2(input a,b,select, output out);
 wire w0,w1,w2;

 not n1(w0,select);
 and a1(w1,select,b);
 and a2(w2,w0,a);
 or o1(out,w1,w2);
 
endmodule

module mux2_4bit(input[3:0] a,b, input select, output[3:0] out);
 mux2 m1(a[3],b[3],select,out[3]);
 mux2 m2(a[2],b[2],select,out[2]);
 mux2 m3(a[1],b[1],select,out[1]);
 mux2 m4(a[0],b[0],select,out[0]);
endmodule

