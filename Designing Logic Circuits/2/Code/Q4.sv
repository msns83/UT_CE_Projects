`timescale 1ns/1ns
module CSA16(input [15:0] A,B, input cin, output [15:0] S , output cout);
 wire couts [3:0];
 wire [1:0] co [2:0];
 wire [3:0] w1 [2:0];
 wire [3:0] w2 [2:0];

 RCA4 f1(A[3:0],B[3:0],cin,S[3:0],couts[0]);
 
 genvar i;
 generate
  for (i = 0; i < 3; i = i + 1) begin : ripple4s
   RCA4 rca1(A[3+(i+1)*4 : (i+1)*4], B[3+(i+1)*4 : (i+1)*4], 1'b0, w1[i], co[i][0]);
   RCA4 rca2(A[3+(i+1)*4 : (i+1)*4], B[3+(i+1)*4 : (i+1)*4], 1'b1, w2[i], co[i][1]); 

   mux2 muxs1(w1[i][0],w2[i][0],couts[i],S[(i+1)*4+0]); 
   mux2 muxs2(w1[i][1],w2[i][1],couts[i],S[(i+1)*4+1]);
   mux2 muxs3(w1[i][2],w2[i][2],couts[i],S[(i+1)*4+2]);
   mux2 muxs4(w1[i][3],w2[i][3],couts[i],S[(i+1)*4+3]);

   mux2 carryMux(co[i][0],co[i][1],couts[i],couts[i+1]);
  end
 endgenerate

 and a1(cout,couts[3],couts[3]);
 
endmodule



