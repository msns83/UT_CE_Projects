module counter(clk,En,reset,c);
 parameter n = 5;
 input clk,En,reset;
 output reg [n:0] c;

 always @(posedge clk or posedge reset)
  if (reset)
   c <= 0 ;
  else 
   if(En)
    c <= c+1 ;

endmodule

module register(input clk,En,reset, input [12:0] in, output reg [12:0] out);

 always @(posedge clk or posedge reset)
  if (reset)
    out <= 0 ;
  else 
   if(En)
     out <= in ;
    
 

endmodule
