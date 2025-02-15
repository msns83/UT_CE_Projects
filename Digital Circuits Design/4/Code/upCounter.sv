module nCounter(Reset,En,Clk,Q);
 parameter n = 4 ;
 output reg[n-1:0] Q ;
 input Reset,En,Clk ;
 
 always @(posedge Reset or posedge Clk)
  if (Reset)
   Q <= 0;
  else if (En)
   Q <= Q + 1;

   
endmodule
 

