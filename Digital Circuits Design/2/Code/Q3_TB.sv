`timescale 1ns/1ns
module RCA16_TB();
 logic [15:0] A,B;
 logic cin;
 wire [15:0] S;
 wire cout;

 RCA16 UUT1(A,B,cin,S,cout);

 initial begin
  A = 16'hab32;
  B = 16'h2121;
  cin = 1'b0;
  #120; 
  A = 16'hf800 ;
  B = 16'hfaaa;
  #120;
  A = 16'h0800 ;
  B = 16'hdaaa;
  #120;
  A = 16'h0000 ;
  B = 16'h0003 ;
  #120;
 end
endmodule


