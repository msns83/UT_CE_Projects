`timescale 1ns/1ns
module min_max_TB();
 logic [3:0] nums [1:4];
 wire [7:0] max,min;

 min_calculator UUT1(nums,min);
 max_calculator UUT2(nums,max);

 initial begin
  nums = {4'd13,4'd2,4'd0,4'd7};
  #10; 
  nums = {4'd15,4'd7,4'd10,4'd1};
  #10; 
  nums = {4'd1,4'd2,4'd3,4'd4};
  #10; 
 end
endmodule
