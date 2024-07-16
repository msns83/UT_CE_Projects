`timescale 1ns/1ns
module fibo_TB();
 logic [3:0] number;
 wire out1,out2;

 fibo1 UUT1(number,out1);
 fibo2 UUT2(number,out2);

 initial begin
  number = 4'd0;

  repeat (15) begin
   #10 number = number + 1;
  end

  #10; 
 end
endmodule
