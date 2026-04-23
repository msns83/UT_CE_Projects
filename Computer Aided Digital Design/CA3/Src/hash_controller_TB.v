`timescale 1ns/1ns

module hash_controller_TB;
    reg  clk;
    reg  rst;
    reg  start;
    reg  rnd_done;
    reg  ok;

    wire rst_m;
    wire message_en;
    wire words_init;
    wire c_en;
    wire rnd_start;
    wire words_en;
    wire done;

    hash_controller dut (.clk(clk), .rst(rst), .start(start), .rnd_done(rnd_done), .ok(ok), .rst_m(rst_m), .message_en(message_en), .words_init(words_init), .c_en(c_en), .rnd_start(rnd_start), .words_en(words_en), .done(done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst      = 1;
        start    = 0;
        rnd_done = 0;
        ok       = 0;
        #20;

        rst = 0;
        start = 1;
        #20;

        start = 0;
        #40;

        rnd_done = 1;
        #10;

        rnd_done = 0;
        ok = 1 ;
        #10;

        ok = 0;
        #40;

        start = 1;
        #20;
        start = 0;

        #100;
        $stop;
    end

endmodule