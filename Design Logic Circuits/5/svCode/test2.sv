`timescale 1ns/1ns
module test2();
 logic clk,rst,start;
 logic [7:0] ROM [1:32];
 wire ready_ser, done_ser ;
 wire ready_par, done_par ;
 wire [7:0] mean_ser ;
 wire [7:0] mean_par ;
 integer k, i;

 higherLevel UUT0 (clk, rst, start, ROM, ready_ser, done_ser, mean_ser);
 concat UUT1 (clk, rst, start, ROM, ready_par, done_par, mean_par);

 initial begin
  clk = 1'b0;
  for (k = 0; k < 120; k = k+1)
   #1 clk = ~clk ;
 end

 initial begin

   $readmemb("data.mem", ROM);

 end

 initial begin
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



