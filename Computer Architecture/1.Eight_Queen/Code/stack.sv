`timescale 1ns/1ns

module stack_3bit(a_rst, push, pop, Load, out, clk);
	input clk, push, pop, a_rst;
	input[2:0] Load;
	output reg[2:0] out ;

	reg[2:0] stack [0:7];
	reg[3:0] top ;
	integer i;

	always@(posedge clk or posedge a_rst)
	begin
		if (a_rst)
		begin
			for (i = 0; i < 8; i = i + 1)
                		stack[i] = 3'b000;
			top = 4'b0000 ;
		end
		else
		begin
			if (push && ~(top == 4'b1000) )
			begin
				stack[top] = Load ;
				top = top + 4'b0001 ;
			end
			else if (pop && ~(top == 4'b1111) )
			begin
				top = top - 4'b0001 ;
				out = stack[top] ;
				
			end
		end
		
	end

endmodule
