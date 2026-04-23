module Top (
    input clk,
    input rst,
    input wire start,
    input wire [31:0] message,

    output wire [31:0] digest,
    output wire done
);
    wire rst_m, ok, rnd_done, msg_en, words_en, words_init, c_en, rnd_start ;

    hash_dp datapath(
    .clk(clk),
    .rst(rst_m),
    .c_en(c_en),
    .rnd_start(rnd_start),
    .msg_en(msg_en),
    .msg(message),
    .words_en(words_en),
    .words_init(words_init),
    .ok(ok),
    .rnd_done(rnd_done),
    .out(digest)
    );

    hash_controller controller (
    .clk(clk),
    .rst(rst),
    .start(start),
    .rnd_done(rnd_done),
    .ok(ok),
    .rst_m(rst_m),
    .message_en(msg_en),
    .words_init(words_init),
    .c_en(c_en),
    .rnd_start(rnd_start),
    .words_en(words_en),
    .done(done)
    );

endmodule