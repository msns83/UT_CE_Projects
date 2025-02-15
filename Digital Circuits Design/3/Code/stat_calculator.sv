`timescale 1ns/1ns
module stat_calculator(input[3:0] Numbers[1:4], input[3:0] OP, output Max,Min,Mean,Var, output[7:0] Result);
 wire[7:0] w1,w2,w3,w4 ;
 wire[1:0] select ;
 wire en;

 max_calculator maxC(Numbers,w1);
 min_calculator minC(Numbers,w2);
 mean_calculator meanC(Numbers,w3);
 var_calculator varC(Numbers,w4);

 priority_encoder encoderM(OP, select, en);
 decoder decoderM(select, {Max,Min,Mean,Var}, en);
 mux4 multiplexer(w1, w2, w3, w4, select, Result); 

endmodule
