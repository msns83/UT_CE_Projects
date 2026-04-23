`timescale 1ns/1ns

module Top_TB;
    reg clk;
    reg rst;
    reg start;
    reg [31:0] message;
    wire [31:0] digest;
    wire done;

    Top dut(
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),

        .digest(digest),
        .done(done)
    );


    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    initial begin
	message = 32'd0;
        rst = 1'b1;
        start = 1'b0;
        #4;   
        rst = 1'b0;

        message = 32'h3761eded;
        start = 1'b1; 
        #4;
        start = 1'b0;
        #2400;

	message = 32'hdf01f0b7;
        start = 1'b1; 
        #4;
        start = 1'b0;
        #2400;

        $stop;
    end

endmodule
