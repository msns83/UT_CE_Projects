module controller(input clk,c5,start,rst, output reg ready,done,c_en,reg_en,reset);

 reg[1:0] y,Y;
 parameter idle=2'b00, A=2'b01, B=2'b10 , C= 2'b11 ;

 always @(start or c5 or y)
  begin
   ready = 0;
   c_en = 0;
   reg_en = 0;
   reset = 0;
   done = 0 ;

  case (y)
   idle: if(start)
         begin
          Y = A ;
          ready = 1 ;
          reset = 1 ;
         end
        else
         begin
          Y = idle ;
          reset = 1 ;
          ready =1 ;
         end

   A: if(start)
       begin
        Y= A;
        ready = 1 ;
        reset = 1;
       end
      else
       begin 
        Y = B ;
        c_en = 1 ;
        reg_en = 1 ;
       end

   B: if(c5)
       begin
        done = 1 ;
        Y = C ;
       end
      else
       begin
        Y = B ;
        c_en = 1; 
        reg_en = 1 ;
       end

   C: if(start)
       begin
        reset = 1 ;
        ready = 1 ;
        Y = A ;
       end
      else
       begin
        Y = C ;
        done = 1 ;
       end
   
   default: Y=2'bxx;
  endcase

  end

 always @(posedge clk or posedge rst)
  if (rst == 1'b1) y <= idle ;
  else y <= Y ;

endmodule
