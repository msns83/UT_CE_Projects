`timescale 1ns/1ns

module testbench1 ();
    reg clk = 0,rst = 0, fwd = 1;

    CA_LAB1_wrapper uut (.clk(clk), .rst(rst), .fwd_en_0(fwd));

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        fwd = 1 ;
        #10 rst = 0;
        #5000 ;
        fwd = 0 ;
        rst = 1;
        #10 rst = 0;
        #10000 $stop;
    end
endmodule