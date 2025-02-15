`timescale 1ns/1ns

module majority13(input [3:0] numbers [12:0] , output out);
 wire w [4:0];
 
 genvar i;
 generate
  for (i = 12; 0 < i ; i = i - 3) begin : majority3Maker
   majority3 checkMajority3(numbers[i:i-2], w[(i/3)]);
  end
 endgenerate

 fibo2 E(numbers[0],w[0]);
 
 assign G1 = (w[4]&w[3]&w[1])|(w[4]&w[2]&w[1])|(w[3]&w[2]&w[1]);
 assign G2 = (w[4]&w[3]&w[2])|(w[4]&w[3]&w[0])|(w[2]&w[1]&w[0]);
 assign G3 = (w[3]&w[1]&w[0])|(w[4]&w[1]&w[0])|(w[4]&w[2]&w[0]);
 assign G4 = (w[3]&w[2]&w[0]);

 assign out = G1 | G2 | G3 | G4;

endmodule
