`timescale 1ns/1ns

module random_controller_TB;
    reg  clk;
    reg  rst;
    reg  start;
    reg  c_done;

    wire rst_m;
    wire load_en;
    wire c_en;
    wire done;

    random_controller dut (.clk(clk), .rst(rst), .start(start), .c_done(c_done), .rst_m(rst_m), .load_en(load_en), .c_en(c_en), .done(done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        start  = 0;
        c_done = 0;
        #20;

        rst = 0;

        start = 1;
        #20;
        start = 0;
        #50;

        c_done = 1;
        #10;
        c_done = 0;

        #20;

        start = 1;
        #20;
        start = 0;
        #50;

        c_done = 1;
        #10;
        c_done = 0;
        #20;
        
        $stop;
    end

endmodule