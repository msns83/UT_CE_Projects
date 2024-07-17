module Sserial_receiver (input clk, input reset, input [1:0] func, input data_in, input enable, input [3:0] m, output [7:0] word, output word_ready);

 wire shifterEn ; 

 controllerS co (m, reset, func[1], enable, clk, shifterEn, word_ready);
 shifterRL sh (data_in, ~func[0], clk, reset, enable & shifterEn, word);

endmodule
