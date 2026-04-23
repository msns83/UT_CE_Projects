module random_generator #(
    parameter INPUT_SIZE = 6,
    parameter OUT_SIZE = 2,
    parameter COUNT_WIDTH = 3,
    parameter [COUNT_WIDTH-1:0] COUNT_CEIL = 3'd6
)(
    input wire clk,
    input wire reset,
    input wire start_rnd,
    input wire [INPUT_SIZE-1:0] value,

    output wire done_rnd,
    output wire [OUT_SIZE-1:0] random
);

    wire counter_done ;
    wire control_reset;
    wire load_en;
    wire counter_en;


    random_generator_CN controller(
    .clk(clk), .reset(reset), .start_rnd(start_rnd), .counter_done(counter_done),
    .control_reset(control_reset), .load_en(load_en), .counter_en(counter_en), .done_rnd(done_rnd)
    );

    random_generator_DP #(.INPUT_SIZE(INPUT_SIZE), .OUT_SIZE(OUT_SIZE), .COUNT_WIDTH(COUNT_WIDTH), .COUNT_CEIL(COUNT_CEIL))
    datapath(
        .clk(clk), .reset(control_reset), .load_en(load_en), .counter_en(counter_en),
        .value(value), .counter_done(counter_done), .random(random)
    );

endmodule