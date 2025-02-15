`timescale 1ns/1ns
module fullAdder(input A,B,cin, output S,cout);
 wire w1,w2,w3;

 xor #(3) x1(w1,A,B);
 and #(2) a1(w2,A,B);
 xor #(3) x2(S,w1,cin);
 and #(2) a2(w3,w1,cin);
 or #(2) o1(cout,w2,w3);
 
endmodule