`timescale 1ns/1ns

module TB;
    reg clk = 0;
    reg rst = 1;
    reg [1:0] in1, in2;
    wire done;

    TOP dut(
        .clk(clk), .rst(rst),
        .in1(in1), .in2(in2),
        .done(done)
    );

    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    initial begin

    in1 = 2'd1 ; in2 = 2'd2 ;
    #4 rst = 0;
	#60 ;
	in1 = 2'd3 ; in2 = 2'd3 ;
    #130 ;
    
    $stop;
    end

endmodule