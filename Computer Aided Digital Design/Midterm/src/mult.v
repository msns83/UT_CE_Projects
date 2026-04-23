module mult #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 16,
    parameter SHIFT_COUNT_BITS = 3
)(
    input wire [IN_WIDTH-1:0] in,
    input wire [SHIFT_COUNT_BITS-1:0] shift_count,
    input wire gen_empty,

    output wire [OUT_WIDTH-1:0] out
);
    wire [OUT_WIDTH-1:0] shifted_result;

    left_shifter #(.IN_WIDTH(8), .SHIFT_COUNT_BITS(3)) shifter_inst(
        .in(in), .shift_count(shift_count), .out(shifted_result)
    );

    assign out = gen_empty ? {OUT_WIDTH{1'b0}} : shifted_result;

endmodule