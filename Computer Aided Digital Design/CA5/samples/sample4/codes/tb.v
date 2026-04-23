`timescale 1ns/1ns
module tb;
  reg clk, rst, start;
  reg [31:0] i1;
  reg [31:0] i2;
  reg [31:0] i3;
  wire [31:0] result;
  wire done;

  top uut(
    .clk(clk), .rst(rst), .start(start),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .result(result), .done(done)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1; start = 0;
    i1 = 10;
    i2 = 20;
    i3 = 30;
    #15 rst = 0;
    #10 start = 1;
    #10 start = 0;
    wait(done);
    #20;
    $stop;
  end
endmodule