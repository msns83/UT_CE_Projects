module TB();
    reg clk = 1'b0;
    reg rst;

    RISCV risc_v (clk, rst);

    always #10 clk = ~clk;

    initial begin
        rst = 1;
        #15 rst = 0;
        #3000 $stop;
    end
endmodule