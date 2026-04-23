`timescale 1ns/1ns

module message_reg_TB;
    reg clk;
    reg rst;
    reg en;
    reg [31:0] in;
    reg [1:0] sel;
    wire [7:0] out;

    message_reg dut(.clk(clk), .rst(rst), .en(en), .in(in), .sel(sel), .out(out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        en  = 0;
        in  = 32'h0000_0000;
        sel = 2'b00;
        #20;

        rst = 0;

        en  = 1;
        in  = 32'h1122_3344;   
        sel = 2'b00;          
        #10;                  

        sel = 2'b01;         
        #10;
        sel = 2'b10;          
        #10;
        sel = 2'b11;         
        #10;

        
        en  = 0;
        in  = 32'hAABB_CCDD;
        sel = 2'b00;
        #20;

        en  = 1;
        in  = 32'hDEAD_BEEF;
        sel = 2'b00;
        #10;
        sel = 2'b01;
        #10;
        sel = 2'b10;
        #10;
        sel = 2'b11;
        #10;

        #20;
        $stop;
    end

endmodule