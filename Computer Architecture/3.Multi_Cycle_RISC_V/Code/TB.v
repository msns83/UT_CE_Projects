module TB();
    reg clk = 1'b0;
    reg rst;

    processor RISCV (.clk(clk), .rst(rst));

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        #10 rst = 0;
        #10000 $stop;
    end
endmodule