`timescale 1ns/1ns
module VCSA_RCA16_TB();
 logic [15:0] A,B;
 logic cin;
 wire [15:0] S_rca,S_csa,S_vcsa;
 wire cout_rca,cout_csa,cout_vcsa ;

 RCA16 UUT1(A,B,cin,S_rca,cout_rca);
 CSA16 UUT2(A,B,cin,S_csa,cout_csa);
 V_CSA16 UUT3(A,B,cin,S_vcsa,cout_vcsa); 

 initial begin
  A = 16'b1010101010101010;
  B = 16'b0101010101010101;
  cin = 1'b0;
  #140
  A = 16'hab32;
  B = 16'h2121;
  #140; 
  A = 16'hf800 ;
  B = 16'hfaaa;
  #140;
  A = 16'h0800 ;
  B = 16'hdaaa;
  #140;
  A = 16'h0000 ;
  B = 16'h0003 ;
  #140;

 end
endmodule

