module equalChecker(In1,In2,result);
 parameter n = 4 ;
 input [n-1:0] In1,In2 ;
 output result;
 genvar k ;

 wire [n-1:0] eachBit;
 
 generate
 for (k = 0; k < n; k = k+1)
    assign eachBit[k] = ~(In1[k] ^ In2[k]) ;
 endgenerate

 assign result = &eachBit ;
 
endmodule
 

module filpflop(input In,Clk,Reset,En, output reg out);
 
 always @(posedge Reset or posedge Clk)
  if(Reset)
   out <= 0 ;
  else
   if (En)
    out <= In ;
  
endmodule

module reducer(In1,In2,result);
 parameter n = 5 ;
 input [n-1:0] In1, In2 ;
 output [n-1:0] result ;

 assign result = In1 - In2 ;

endmodule

module mux2(input In0,In1,s, output out);

 assign out = s ? In1 : In0 ;

endmodule