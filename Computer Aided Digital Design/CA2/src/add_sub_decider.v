module add_sub_decider #(
    parameter WIDTH = 16
)(
    input wire a_bit,
    input wire i_is_msb,
    input wire [WIDTH-1:0] b,

    output wire [WIDTH-1:0] b_add_sub_out
);

    wire [WIDTH-1:0] b_negative;
    multi_adder #(.WIDTH(WIDTH), .ADD_NUM(2)) incrementor(.flat_inputs({~b, {{(WIDTH-1){1'b0}}, 1'b1}}), .sum(b_negative));

    assign b_add_sub_out = (a_bit & i_is_msb) ? (b_negative) : b ; 

endmodule