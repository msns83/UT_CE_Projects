`timescale 1ns/1ns

module TB;
    reg clk;
    reg reset;
    reg start;
    reg [127:0] number;
    wire [127:0] hash;
    wire done;

    top #(.REPEAT_WIDTH(6), .WORD_SIZE(32), .WORD_COUNT(4), .SELECTION_WIDTH(2), .RND_REPEAT_WIDTH(3), .RND_REPEAT(3'd6)
    ) dut(.clk(clk), .reset(reset), .start(start), .number(number), .hash(hash), .done(done));

    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    
    initial begin
        reset = 1'b1;
        start = 1'b0;
        #1;   
        reset = 1'b0;

        number = 128'h1109200100face009119110088cafe88;
        start = 1'b1; #5; start = 1'b0;
        #3000;

	number = 128'h41a801a8e81df62b14a661b85c97bf45;
        start = 1'b1; #5; start = 1'b0;
        #3000;
	

        $stop;
    end

endmodule
