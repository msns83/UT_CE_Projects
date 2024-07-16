`timescale 1ns/1ns
module var_calculator(input[3:0] nums[1:4], output[7:0] varr);
 wire[7:0] u ;
 wire[7:0] w [1:16] ;

 mean_calculator mean(nums,u);

 assign w[1] = u - nums[1] ; 
 assign w[2] = u - nums[2] ;
 assign w[3] = u - nums[3] ;
 assign w[4] = u - nums[4] ;

 assign w[5] = w[1] * w[1];
 assign w[6] = w[2] * w[2];
 assign w[7] = w[3] * w[3];
 assign w[8] = w[4] * w[4];

 assign w[9] = w[5] + w[6];
 assign w[10] = w[9] + w[7];
 assign w[11] = w[10] + w[8];

 assign varr[5:0] = w[11][7:2] ;
 assign varr[7:6] = {1'b0,1'b0} ;
 
endmodule