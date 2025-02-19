`timescale 1ns/1ns
module max_calculator_2num(input[3:0] a,b, output[3:0] max);
 wire s; 
 wire eq,ls;

 comparator_4b comp(a,b,eq,s,ls);
 mux2_4bit mux(b,a,s,max);
 
endmodule

module max_calculator(input[3:0] nums[1:4], output[7:0] max);
 wire[3:0] big[1:2]; 

 max_calculator_2num maxi1(nums[1],nums[2],big[1]);
 max_calculator_2num maxi2(nums[3],big[1],big[2]);
 max_calculator_2num maxi3(nums[4],big[2],max[3:0]);

 assign max[7:4] = 4'b0000;
 
endmodule