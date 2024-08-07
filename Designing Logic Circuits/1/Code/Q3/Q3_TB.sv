`timescale 1ns/1ns

module majority3_TB();
 wire out;
 logic [3:0] numbers [2:0];
 majority3 UUT(numbers,out);

 initial begin
  numbers = {4'd3,4'd4,4'd11};
  #10 numbers = {4'd7,4'd5,4'd3};
  #10 numbers = {4'd9,4'd7,4'd13};
  #10 numbers = {4'd0,4'd1,4'd2};
  #10 numbers = {4'd14,4'd15,4'd13};
  #10;
 end
endmodule
