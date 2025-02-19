`timescale 1ns/1ns
module mean_varr_TB();
 logic [3:0] nums [1:4];
 wire [7:0] mean,varr;

 mean_calculator UUT1(nums,mean);
 var_calculator UUT2(nums,varr);

 initial begin
  nums = {4'd13,4'd2,4'd0,4'd7};
  #10; 
  nums = {4'd15,4'd15,4'd15,4'd15};
  #10; 
  nums = {4'd1,4'd2,4'd3,4'd6};
  #10; 
 end
endmodule
