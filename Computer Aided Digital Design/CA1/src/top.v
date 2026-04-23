module top #(
    parameter REPEAT_WIDTH = 6,
    parameter WORD_SIZE = 32,
    parameter WORD_COUNT = 4,
    parameter SELECTION_WIDTH = 2,
    parameter RND_REPEAT_WIDTH = 3,
    parameter [RND_REPEAT_WIDTH-1:0] RND_REPEAT = 3'd6
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [WORD_COUNT*WORD_SIZE-1:0] number,

    output wire [WORD_COUNT*WORD_SIZE-1:0] hash,
    output wire done
);

    wire [SELECTION_WIDTH-1:0] random;
    wire rnd_done;
    wire rnd_start;
    wire [REPEAT_WIDTH-1:0] rnd_input; 

    hash_generator #(REPEAT_WIDTH, WORD_SIZE , WORD_COUNT, SELECTION_WIDTH) hash_gen(
        .clk(clk), .reset(reset), .start(start), .number(number), .random(random),
        .rnd_done(rnd_done), .hash(hash), .done(done), .rnd_start(rnd_start), .cur_i(rnd_input)
    );

    random_generator #(REPEAT_WIDTH, SELECTION_WIDTH, RND_REPEAT_WIDTH, RND_REPEAT) rnd_gen(
        .clk(clk), .reset(reset), .start_rnd(rnd_start),
        .value(rnd_input), .done_rnd(rnd_done), .random(random)
    );

endmodule