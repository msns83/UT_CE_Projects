module one_pulser (
  input clk,
  input clkPB,
  input rst,
  output reg clk_en
);
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
reg [1:0] CS , NS ;
always @(posedge clk, posedge rst) begin
  if(rst)
    CS <= A;
  else
    CS <= NS;
end
always begin
  NS = CS ;
  clk_en = 1'b0 ;
    
  case(CS)
    A: NS = clkPB? B: A ;
    B: begin
      NS = C ;
      clk_en = 1'b1 ;
    end
  C: begin
    NS = clkPB?C:A;
    clk_en = 1'b0;
    end
  endcase
end
endmodule