module controllerS(input [3:0] m , input Reset,control,En,Clk, output shifterEn,word_ready);

 wire [3:0] Q1;
 wire [3:0] Q2;
 wire [1:0] countReset;
 wire [4:0] num;
 wire [1:0] pshifter ;

 reducer r1 (5'd16,{0,m},num);
 equalChecker e1 (num[3:0],Q1,countReset[0]);
 mux2 m0 (0,countReset[0],control,countReset[1]);

 equalChecker e2 (~m,Q1,pshifter); 
 mux2 m1 (&Q1 , pshifter,control,shifterEn);
 
 nCounter #(4) c1(Reset | countReset[1] ,En, Clk, Q1);
 nCounter #(4) c2(Reset, En & shifterEn, Clk, Q2);

 assign word_ready = Q2[3] ;
endmodule 
