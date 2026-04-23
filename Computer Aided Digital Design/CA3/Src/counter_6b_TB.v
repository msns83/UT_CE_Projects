`timescale 1ns/1ns

module counter_6b_TB;
    reg clk;
    reg rst;
    reg en;
    wire [5:0] out;
    wire ok;

    counter_6b dut (.clk(clk), .rst(rst), .en(en), .out(out), .ok(ok));

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
        #650;

        en = 0;
        #20;
        rst = 1;
        #5;
        rst = 0;
        en = 1;
        #20;

        $stop;
    end

endmodule