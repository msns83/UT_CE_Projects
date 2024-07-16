`timescale 1ns/1ns

module majority13_TB();
 logic [3:0] numbers [12:0];
 wire out;

 majority13 UUT(numbers, out);

 initial begin
  numbers = {4'd3,4'd2,4'd6,4'd2,4'd8,4'd13,4'd8,4'd5,4'd11,4'd12,4'd15,4'd7,4'd12};
  #10 numbers = {4'd3,4'd2,4'd1,4'd2,4'd8,4'd13,4'd8,4'd10,4'd11,4'd2,4'd15,4'd7,4'd12};
  #10 numbers = {4'd7,4'd6,4'd4,4'd2,4'd9,4'd5,4'd0,4'd1,4'd11,4'd6,4'd10,4'd7,4'd13};
  #10 numbers = {4'd3,4'd2,4'd4,4'd2,4'd9,4'd11,4'd8,4'd10,4'd11,4'd12,4'd15,4'd7,4'd12}; 
  #10;
 end
endmodule
