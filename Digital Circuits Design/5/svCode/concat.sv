module concat(clk, rst,start, rom_in, ready, done, mean);
 input clk, rst,start;
 input [7:0] rom_in [0:31];
 output ready, done;
 output [7:0] mean;
 
 wire [1:0] p_ready,p_done ;
 wire [7:0] p_mean [1:0] ;


 higherLevel #(16) h0(clk, rst, start, rom_in[0:15], p_ready[0], p_done[0], p_mean[0]);
 higherLevel #(16) h1(clk, rst, start, rom_in[16:31], p_ready[1], p_done[1], p_mean[1]);

 assign ready = &p_ready ;
 assign done = &p_done ;
 assign mean = (p_mean[0] + p_mean[1]) / 2 ;


endmodule
