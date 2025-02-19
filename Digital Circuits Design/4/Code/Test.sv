`timescale 1ns/1ps
module receiver_TB();
 logic clk, reset, enable;
 logic data_in;
 logic [1:0] func; 
 logic [3:0] m ;
 wire [7:0] word0;
 wire word_ready0;
 wire [7:0] word1;
 wire word_ready1;
 integer k;

 serial_receiver UUT0 (clk, reset, func, data_in, enable, m, word0, word_ready0);
 Sserial_receiver UUT1 (clk, reset, func, data_in, enable, m, word1, word_ready1); 

 initial begin
  clk = 1'b1;
  for (k = 0; k < 310; k = k+1)
   #0.05 clk = ~clk ;
 end

 initial begin
  reset = 1'b0 ;
  enable = 1'b0;
  #0.05 
  reset = 1'b1 ;
  data_in = 1'b1 ;
  #0.05
  reset = 1'b0 ;
  enable = 1'b1 ;

  func = 2'b11;
  m = 4'b0100 ;
  #1.2 data_in = 1'b0;
  #1.2 data_in = 1'b1;
  #1.2 data_in = 1'b0;
  #1.2 data_in = 1'b1;
  #1.2 data_in = 1'b0;
  #1.2 data_in = 1'b1;  
  #1.2 data_in = 1'b0;
  #1.2
  enable = 1'b0 ;
  #2 reset = 1'b1;
  #0.05
  reset = 1'b0;
  enable = 1'b1;
  
 end
endmodule







