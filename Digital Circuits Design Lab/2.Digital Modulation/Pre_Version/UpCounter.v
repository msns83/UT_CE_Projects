module UpCounter #(parameter N = 1024) (cntEN, init0, clk,rst, cntOUT, carryOUT);

    parameter SIZE = $clog2(N);
	input cntEN, init0;
	input clk, rst;
	output [SIZE-1:0] cntOUT;
	output carryOUT;

	reg [SIZE-1:0] cnt;

	always @(posedge clk, posedge rst) begin

		if(rst)	cnt <= {(SIZE){1'b0}};
		else begin
			if(init0 | carryOUT)		cnt <= {(SIZE){1'b0}};
			else if(cntEN)	cnt <= cnt + 1;
		end

	end

	assign cntOUT = cnt;
	assign carryOUT = (cnt == (N-1)) ? 1'b1 : 1'b0;

endmodule
