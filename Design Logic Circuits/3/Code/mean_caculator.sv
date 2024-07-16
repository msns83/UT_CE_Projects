`timescale 1ns/1ns
module mean_calculator(input[3:0] nums[1:4], output[7:0] mean);
 wire[7:0] w1,w2,w3 ;

 assign w1 = nums[1] + nums[2] ; 
 assign w2 = w1 + nums[3] ;
 assign w3 = w2 + nums[4] ;

 assign mean[5:0] = w3[7:2] ;
 assign mean[7:6] = {1'b0,1'b0} ;
 
endmodule
