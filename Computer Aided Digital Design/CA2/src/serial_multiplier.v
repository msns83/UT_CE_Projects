module serial_multiplier #(
    parameter OUTPUT_WIDTH = 34,
    parameter INPUT_WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire a_bit,
    input wire i_is_msb,
    input wire i_is_lsb,
    input wire i_is_valid,
    input wire [INPUT_WIDTH-1:0] b,

    output wire [OUTPUT_WIDTH-1:0] final_result
);
    wire [OUTPUT_WIDTH-1:0] add_val ;
    wire [INPUT_WIDTH-1:0] b_final_val ;
    wire [OUTPUT_WIDTH-1:0] b_final_val_extend;
    wire [OUTPUT_WIDTH-1:0] current_result;
    wire dummy;

    add_sub_decider #(INPUT_WIDTH) add_sub_decider_ins(.b(b), .i_is_msb(i_is_msb), .a_bit(a_bit), .b_add_sub_out(b_final_val));
    sign_extend #(INPUT_WIDTH, OUTPUT_WIDTH) for_adder_sign_extend(.num(b_final_val), .num_extend(b_final_val_extend));
    assign add_val = (a_bit) ? b_final_val_extend : {(OUTPUT_WIDTH){1'b0}} ;

    multi_adder #(.WIDTH(OUTPUT_WIDTH), .ADD_NUM(2)) new_result_adder(.flat_inputs({current_result, add_val}), .sum(final_result));

    left_shift_register #(OUTPUT_WIDTH) accumulator_inst(.clk(clk), .rst(rst), .load_en(i_is_valid), .load(final_result), .shift_en(i_is_valid), .value(current_result), .out_bit(dummy));

endmodule