module rangeSpecifier #(
	parameter c = 6
)(
	input  wire [c-1:0] in,
	output wire [1:0] out
);

    assign out = in[c-1:c-2];

endmodule

	