`timescale 1ns/1ns
module RCA4_TB();
 logic [3:0] A,B;
 logic cin;
 wire [3:0] S;
 wire cout;

 RCA4 UUT1(A,B,cin,S,cout);

 initial begin
  A = 4'd3;
  B = 4'd4;
  cin = 1'b0;
  #30; 
  A = 4'd15 ;
  B= 4'd15;
  #30;
  A = 4'd6 ;
  B = 4'd10 ;
  #30;
 end
endmodule


