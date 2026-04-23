`timescale 1ns/1ns

module shifter_6b_TB;
    reg clk;
    reg rst;
    reg in;
    reg sh_en;
    reg load_en;
    reg [5:0] load;
    wire [5:0] out;

    shifter_6b dut(.clk(clk), .rst(rst), .in(in), .sh_en(sh_en), .load_en(load_en), .load(load), .out(out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst     = 1;
        sh_en   = 0;
        load_en = 0;
        in      = 0;
        load    = 6'b000000;
        #20;

        rst = 0;

        load_en = 1;
        load    = 6'b101011;
        sh_en   = 0;
        #20;

        load_en = 0;
        sh_en   = 1;
        in = 0;
        #60;

        in = 1;
        #60;

        sh_en = 0;
        #20;

        load_en = 1;
        load    = 6'b010101;
        #20;

        load_en = 0;
        sh_en   = 1;
        in      = 0;
        #60;

        $stop;
    end

endmodule