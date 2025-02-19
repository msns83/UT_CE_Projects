module LR_shifter(input In,RL,Reset,En,Clk, output reg[7:0] word);
 integer k;

 always @(posedge Reset or posedge Clk)
  if (Reset)
   word <= 0 ;
  else if (En)
   begin
    if (!RL)
     begin
      for (k = 0; k < 7; k = k+1)
       word[k] <= word[k+1];
      word[7] <= In;
     end
    else
     begin
      for (k = 0; k < 7; k = k+1)
       word[k+1] <= word[k];
      word[0] <= In;
     end
    end
    

   
endmodule
 

