module stepRom #(parameter a = 6 , b = 5 , c = 2) (
	input  wire [a-1:0] i,            
	input  wire [c-1:0] range_sel,    
	output reg  [b-1:0] s             
);
	wire [1:0] idx = i[1:0]; 
	
	always @(*) begin
		case (range_sel)
			2'b00: begin 
				case (idx)
					2'd0: s = 5'd7;
					2'd1: s = 5'd12;
					2'd2: s = 5'd17;
					default: s = 5'd22;
				endcase
			end
			2'b01: begin 
				case (idx)
					2'd0: s = 5'd5;
					2'd1: s = 5'd9;
					2'd2: s = 5'd14;
					default: s = 5'd20;
				endcase
			end
			2'b10: begin 
				case (idx)
					2'd0: s = 5'd4;
					2'd1: s = 5'd11;
					2'd2: s = 5'd16;
					default: s = 5'd23;
				endcase
			end
			default: begin 
				case (idx)
					2'd0: s = 5'd6;
					2'd1: s = 5'd10;
					2'd2: s = 5'd15;
					default: s = 5'd21;
				endcase
			end
		endcase
	end
endmodule

