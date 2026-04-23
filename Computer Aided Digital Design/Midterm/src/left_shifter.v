module left_shifter #(
    parameter IN_WIDTH = 8,
    parameter SHIFT_COUNT_BITS = 3,    
    parameter OUT_WIDTH = IN_WIDTH + (1 << SHIFT_COUNT_BITS)
)(
    input wire [IN_WIDTH-1:0] in,
    input wire [SHIFT_COUNT_BITS-1:0] shift_count,
    
    output wire [OUT_WIDTH-1:0] out
);
    wire [OUT_WIDTH-1:0] x = {{(OUT_WIDTH-IN_WIDTH){1'b0}}, in};
    assign out = x << shift_count;
endmodule