`timescale 1ns/1ns

module words_reg_TB;
    reg clk;
    reg rst;
    reg en;
    reg [31:0] in;
    reg init_en;
    wire [31:0] out;

    words_reg dut (.clk(clk), .rst(rst), .en(en), .in(in), .init_en(init_en), .out(out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        en = 0;
        init_en = 0;
        in = 32'h0530_1051;
        #20;

        rst = 0;
        init_en = 1;
        #20

        en = 1;
        in = 32'hDEAD_BEEF;   
        #20;
        init_en = 0; 

        in = 32'h1122_3344;
        #20;
        in = 32'hA5A5_5A5A;
        #20;

        en = 0;
        in = 32'hFFFF_0000;
        #40;

        init_en = 1;
        #20;
        init_en = 0;

        #10;
        $stop;
    end

endmodule