`timescale 1ns/1ns

module top_TB;
    localparam IN_WIDTH = 34;
    localparam SLICE_WIDTH = 16;
    localparam B_OUT_WIDTH = 64;
    localparam A_OUT_WIDTH = 4;
    localparam ADR_WIDTH = 3;
    localparam CYCLE_WIDTH = 4;
    localparam MEM_ADR_WIDTH = 7;
    localparam A_B_REG_COUNT = 8;
    localparam MEM_REG_COUNT = 128;

    reg clk = 0;
    reg reset = 1;
    reg start = 0;

    wire done;

    top #(
        .IN_WIDTH(IN_WIDTH),
	    .SLICE_WIDTH(SLICE_WIDTH),
        .B_OUT_WIDTH(B_OUT_WIDTH),
        .A_OUT_WIDTH(A_OUT_WIDTH),
        .ADR_WIDTH(ADR_WIDTH),
        .CYCLE_WIDTH(CYCLE_WIDTH),
	    .MEM_ADR_WIDTH(MEM_ADR_WIDTH),
        .A_B_REG_COUNT(A_B_REG_COUNT),
        .MEM_REG_COUNT(MEM_REG_COUNT),
        .FILE_NAME("input_memory (3).txt")
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done)
    );

    initial begin
        clk = 1'b0;
        forever #1 clk = ~clk;
    end

    initial begin
        #4 reset = 0;
        #6 start = 1;
        #10 start = 0;

        #1200
        $stop;
    end

endmodule
