`timescale 1ns/1ns
module test();
 logic clk,rst,start;
 logic [7:0] ROM [1:32];
 wire ready,done ;
 wire [7:0] mean;
 integer k, i;

 higherLevel UUT (clk, rst,start,ROM,ready,done,mean);

 initial begin
  clk = 1'b0;
  for (k = 0; k < 120; k = k+1)
   #1 clk = ~clk ;
 end

 initial begin
  for (i = 1; i <= 32; i++) begin
      ROM[i] = i - 1;
  end  
  rst = 1'b0;
  start = 1'b0 ;
  #1
  rst = 1'b1 ;
  #1
  rst = 1'b0 ;
  #6
  start = 1'b1;
  #4
  start = 1'b0 ;
  #74
  start = 1'b1 ;

 end
endmodule



