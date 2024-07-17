`timescale 1ns/1ns
module min_calculator_2num(input[3:0] a,b, output[3:0] min);
 wire s; 
 wire eq,ls;

 comparator_4b comp(a,b,eq,s,ls);
 mux2_4bit mux(a,b,s,min);
 
endmodule

module min_calculator(input[3:0] nums[1:4], output[7:0] min);
 wire[3:0] smal[1:2]; 

 min_calculator_2num mini1(nums[1],nums[2],smal[1]);
 min_calculator_2num mini2(nums[3],smal[1],smal[2]);
 min_calculator_2num mini3(nums[4],smal[2],min[3:0]);

 assign min[7:4] = 4'b0000;
 
endmodule
