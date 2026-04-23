`timescale 1ns/1ns

module random_TB;
    reg clk;
    reg rst;
    reg start;
    reg [5:0] in;
    wire [1:0] out;
    wire done;

    random dut(.clk(clk), .rst(rst), .start(start), .in(in), .out(out), .done(done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1;
        start = 0;
        in    = 6'b000000;
        #20;
        rst = 0;

        in    = 6'd43;
        start = 1;
        #20;
        start = 0;
        #80;

        in = 6'd37;
        start = 1;
        #20;
        start = 0;
        #80;

        in = 6'd4;
        start = 1;
        #20;
        start = 0;
        #80;

        in = 6'd54;
        start = 1;
        #20;
        start = 0;
        #80;

        $stop;
    end

endmodule