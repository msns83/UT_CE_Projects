module hash_generator #(
    parameter REPEAT_WIDTH = 6,
    parameter WORD_SIZE = 32,
    parameter WORD_COUNT = 4,
    parameter SELECTION_WIDTH = 2
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [WORD_COUNT*WORD_SIZE-1:0] number,
    input wire [SELECTION_WIDTH-1:0] random,
    input wire rnd_done,

    output wire [WORD_COUNT*WORD_SIZE-1:0] hash,
    output wire done,
    output wire rnd_start,
    output wire [REPEAT_WIDTH-1:0] cur_i
);

    wire control_reset;
    wire ok;
    wire words_en;
    wire counter_en;
    wire i_en;
    wire message_en;


    hase_generator_DP #(REPEAT_WIDTH, WORD_SIZE, WORD_COUNT, SELECTION_WIDTH) datapath(
        .clk(clk), .reset(control_reset), .number(number), .counter_en(counter_en), .i_en(i_en), .words_en(words_en),
        .message_en(message_en), .random(random), .ok(ok), .hash(hash), .cur_i(cur_i)
    );

    hase_generator_CN controller(
        .clk(clk), .reset(reset), .start(start), .ok(ok), .rnd_done(rnd_done),
        .control_reset(control_reset), .message_en(message_en), .counter_en(counter_en),
        .rnd_start(rnd_start), .i_en(i_en), .words_en(words_en), .done(done)
    );

endmodule