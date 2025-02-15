`timescale 1ns/1ns
module eight_queen_TB();

    reg start, clk, rst;
    wire done, no_answer ;
    wire[7:0] out ;

    eight_queen DUT(clk, start, rst, done, no_answer, out);

    always #1 clk = ~clk;
    initial begin
        start = 1'b0;
        rst = 1'b1;
        clk = 1'b0;
	    #1
	    rst = 1'b0 ;
        #3
        start = 1'b1;
        #3
        start = 1'b0;

	wait(done);
        #30

	$stop;
    end

endmodule
