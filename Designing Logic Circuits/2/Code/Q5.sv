`timescale 1ns/1ns
module V_CSA16(input [15:0] A,B, input cin, output [15:0] S , output cout);

 wire [1:0] couts [15:2];
 wire [1:0] w [15:2];
 wire reCout [4:0];

 fullAdder f1(A[0],B[0],cin,S[0],reCout[0]);
 fullAdder f2(A[1],B[1],reCout[0],S[1],reCout[1]);
 
 genvar i;
 generate
  for (i = 0; i < 2; i = i + 1) begin : fa2
   fullAdder f11(A[2],B[2],i,w[2][i],couts[2][i]);
   fullAdder f12(A[3],B[3],couts[2][i],w[3][i],couts[3][i]);
  end
 endgenerate
 mux2 muxs11(w[2][0],w[2][1],reCout[1],S[2]); 
 mux2 muxs12(w[3][0],w[3][1],reCout[1],S[3]);
 mux2 muxsf2(couts[3][0],couts[3][1],reCout[1],reCout[2]);


 genvar j;
 generate
  for (j = 0; j < 2; j = j + 1) begin : fa3
   fullAdder f21(A[4],B[4],j,w[4][j],couts[4][j]);
   fullAdder f22(A[5],B[5],couts[4][j],w[5][j],couts[5][j]);
   fullAdder f23(A[6],B[6],couts[5][j],w[6][j],couts[6][j]);
  end
 endgenerate
 mux2 muxs21(w[4][0],w[4][1],reCout[2],S[4]); 
 mux2 muxs22(w[5][0],w[5][1],reCout[2],S[5]);
 mux2 muxs23(w[6][0],w[6][1],reCout[2],S[6]);
 mux2 muxsf3(couts[6][0],couts[6][1],reCout[2],reCout[3]);


 genvar k;
 generate
  for (k = 0; k < 2; k = k + 1) begin : fa4
   fullAdder f31(A[7],B[7],k,w[7][k],couts[7][k]);
   fullAdder f32(A[8],B[8],couts[7][k],w[8][k],couts[8][k]);
   fullAdder f33(A[9],B[9],couts[8][k],w[9][k],couts[9][k]);
   fullAdder f34(A[10],B[10],couts[9][k],w[10][k],couts[10][k]);
  end
 endgenerate
 mux2 muxs31(w[7][0],w[7][1],reCout[3],S[7]); 
 mux2 muxs32(w[8][0],w[8][1],reCout[3],S[8]);
 mux2 muxs33(w[9][0],w[9][1],reCout[3],S[9]); 
 mux2 muxs34(w[10][0],w[10][1],reCout[3],S[10]); 
 mux2 muxsf4(couts[10][0],couts[10][1],reCout[3],reCout[4]);
 

 genvar l;
 generate
  for (l = 0; l < 2; l = l + 1) begin : fa5
   fullAdder f41(A[11],B[11],l,w[11][l],couts[11][l]);
   fullAdder f42(A[12],B[12],couts[11][l],w[12][l],couts[12][l]);
   fullAdder f43(A[13],B[13],couts[12][l],w[13][l],couts[13][l]);
   fullAdder f44(A[14],B[14],couts[13][l],w[14][l],couts[14][l]);
   fullAdder f45(A[15],B[15],couts[14][l],w[15][l],couts[15][l]);
  end
 endgenerate
 mux2 muxs41(w[11][0],w[11][1],reCout[4],S[11]); 
 mux2 muxs42(w[12][0],w[12][1],reCout[4],S[12]);
 mux2 muxs43(w[13][0],w[13][1],reCout[4],S[13]); 
 mux2 muxs44(w[14][0],w[14][1],reCout[4],S[14]); 
 mux2 muxs45(w[15][0],w[15][1],reCout[4],S[15]); 
 mux2 muxsf5(couts[15][0],couts[15][1],reCout[4],cout);
 
endmodule

