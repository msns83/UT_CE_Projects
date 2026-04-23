`timescale 1ns/1ns

module counter_3b_TB;
    reg clk;
    reg rst;
    reg en;
    wire [2:0] out;
    wire c_done;

    counter_3b dut (.clk(clk), .rst(rst), .en(en), .out(out), .c_done(c_done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        en  = 0;
        #20;

        rst = 0;

        en = 1;
        #200;

        en = 0;
        #40;

        rst = 1;
        #10;
        rst = 0;
        en  = 1;
        #100;

        $stop;
    end

endmodule