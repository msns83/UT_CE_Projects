module serial_receiver (input clk, input reset, input [1:0] func, input data_in, input enable, input [3:0] m, output [7:0] word, output word_ready);

 wire shifterEn ; 

 controller controller0 (func[1],reset, enable, clk, m, word_ready, shifterEn);
 LR_shifter shifter0 (data_in,!func[0],reset, enable & shifterEn, clk, word);
 

endmodule
 

