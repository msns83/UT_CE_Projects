`timescale 1ns/1ns

module random_dp_TB;
    reg clk;
    reg rst;
    reg load_en;
    reg en;
    reg [5:0] load;
    wire [1:0] out;
    wire c_done;

    random_dp dut(.clk(clk), .rst(rst), .load_en(load_en), .en(en), .load(load), .out(out), .c_done(c_done));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        load_en = 0;
        en = 0;
        load = 6'b000000;
        #20;

        rst = 0;

        load_en = 1;
        load = 6'b101011;
        en = 0;
        #20;

        load_en = 0;
	load = 6'b000000;

        en = 1;
        #60;

        en = 0;
        #10;

        $stop;
    end

endmodule