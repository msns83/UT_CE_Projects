`timescale 1ns/1ns
module stat_calculator_TB();
 logic [3:0] nums [1:4];
 logic [3:0] op;
 wire [7:0] Result;
 wire Max,Min,Mean,Var;

 stat_calculator UUT(nums, op, Max, Min, Mean, Var, Result);

 initial begin
  op = 4'b0000;
  nums = {4'd13,4'd2,4'd0,4'd7};
  #3; 
  op = 4'b1111;
  #3;
  op = 4'b1010;
  #3;
  op = 4'b1100;
  #3;
  op = 4'b1000;
  #3
  op = 4'b0000;
  nums = {4'd15,4'd15,4'd15,4'd15};
  #3; 
  op = 4'b1111;
  #3;
  op = 4'b1010;
  #3;
  op = 4'b1100;
  #3;
  op = 4'b1000;
  #3
  op = 4'b0000;
  nums = {4'd1,4'd2,4'd3,4'd6};
  #3; 
  op = 4'b1111;
  #3;
  op = 4'b1010;
  #3;
  op = 4'b1100;
  #3;
  op = 4'b1000;
  #3;
 end
endmodule