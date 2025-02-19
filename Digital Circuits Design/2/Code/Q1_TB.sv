`timescale 1ns/1ns
module fullAdd_TB();
 logic A,B,cin;
 wire S,cout;

 fullAdder UUT1(A,B,cin,S,cout);

 initial begin
  A = 1'b0;
  B = 1'b0;
  cin = 1'b0;
  #10; 
  A = 1'b1 ;
  #10;
  B = 1'b1 ;
  #10;
  cin = 1'b1;
  #10;
  A = 1'b0;
  #10;
  B= 1'b0;
  #10;
 end
endmodule

