`timescale 1ns/1ns
module decoder(input [1:0] in, output [3:0] out, input en);
 reg [0:3] Y;

 always @(in or en)
  case ({en, in})
   3'b100: Y = 4'b1000;
   3'b101: Y = 4'b0100;
   3'b110: Y = 4'b0010;
   3'b111: Y = 4'b0001;
   default: Y = 4'b0000;
  endcase

 assign out = Y ;
endmodule
