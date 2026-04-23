module random_generator_DP #(
    parameter INPUT_SIZE = 6,
    parameter OUT_SIZE = 2,
    parameter COUNT_WIDTH = 3,
    parameter [COUNT_WIDTH-1:0] COUNT_CEIL = 3'd6
)(
    input wire clk,     
    input wire reset,
    input wire load_en,
    input wire counter_en,
    input wire [INPUT_SIZE-1:0] value,

    output wire counter_done,
    output wire [OUT_SIZE-1:0] random
);

    wire shifter_en;
    wire [COUNT_WIDTH-1:0] counter_out;
    wire [INPUT_SIZE-1:0] shifter_num ;

    assign shifter_en = |counter_out;

    left_shifter #(INPUT_SIZE) shifter_inst(.clk(clk), .reset(reset), .enable(shifter_en), .load_enable(load_en), .load_value(value), .new_bit(shifter_num[1]^shifter_num[3]^shifter_num[5]), .data_out(shifter_num));
    up_counter #(COUNT_WIDTH) counter_inst(.clk(clk), .reset(reset), .enable(counter_en), .count(counter_out));

    assign counter_done = counter_out == COUNT_CEIL ;
    assign random = shifter_num[INPUT_SIZE-1:INPUT_SIZE-OUT_SIZE] ;

endmodule