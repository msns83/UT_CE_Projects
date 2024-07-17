module controller(input control,Reset,En,Clk, input[3:0] m, output reg ready,shifterEn);

 wire [3:0] Q1;
 wire [3:0] Q2;
 reg countReset ;
 
 nCounter #(4) c1(Reset | countReset ,En, Clk, Q1);
 nCounter #(4) c2(Reset, En & shifterEn, Clk, Q2);

 assign ready = Q2[3];

 always @(m,Q1,control)
  begin
   if (!control)
    begin
     shifterEn = &Q1;
     countReset = 1'b0 ;
    end
   else
    begin
     if(Q1 == (4'd15 - m) )
       shifterEn = 1'b1;
     else
       shifterEn = 1'b0;
     if(Q1 == (5'd16 - m))
       countReset = 1'b1 ;
     else
       countReset = 1'b0 ;
    end

  end

endmodule
 

