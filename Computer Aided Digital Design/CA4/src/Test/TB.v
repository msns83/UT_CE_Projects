`timescale 1ns/1ns

module TB;
    reg clk;
    reg reset;
    reg start;
    reg [31:0] number;
    wire [31:0] hash;
    wire done;

    top dut(.clk(clk), .reset(reset), .start(start), .number(number), .hash(hash), .done(done));

    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    
    initial begin
        reset = 1'b1;
        start = 1'b0;
        #1;   
        reset = 1'b0;
        

        number = 32'h3761eded;
        start = 1'b1; #5; start = 1'b0;
        #3000;

	    number = 32'hdf01f0b7;
        start = 1'b1; #5; start = 1'b0;
        #3000;
	

        $stop;
    end

endmodule
