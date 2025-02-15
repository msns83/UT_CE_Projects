module higherLevel_16(clk, rst,start, rom_in, ready, done, mean);
 parameter n = 16 ;

 input clk, rst,start;
 input [7:0] rom_in [0:n-1];
 output ready, done;
 output [7:0] mean;
 
 wire c_en, reset, reg_en, c5  ;
 
 data_path #(n) dp(c_en,clk,reset,reg_en,rom_in,c5,mean);
 controller co(clk,c5,start,rst,ready,done,c_en,reg_en,reset);


endmodule
