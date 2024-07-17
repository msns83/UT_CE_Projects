`timescale 1ns/1ns
module priority_encoder(input [3:0] in, output [1:0] out, output en);
 reg [1:0] outr;
 reg enr;

 always @(in)
 begin
  enr = 1;
  casex(in)
   4'bxxx1: outr = 2'd0;
   4'bxx10: outr = 2'd1;
   4'bx100: outr = 2'd2;
   4'b1000: outr = 2'd3;
   default: begin
    enr = 0;
    outr = 2'bxx;
   end
  endcase
 end

 assign en = enr ;
 assign out = outr ;

endmodule
