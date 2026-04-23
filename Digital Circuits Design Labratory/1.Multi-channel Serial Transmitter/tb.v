module tb ();
    reg clk=0;
    reg rst,
        serIn,
        clkPB=1;
    wire P0,
        P1,
        P2,
        P3,
        done,
        serOutValid;
    wire [6:0]SSD_out;
    MSSD mir (
        clk,
        rst,
        serIn,
        clkPB,
        P0,
        P1,
        P2,
        P3,
        done,
        serOutValid,
        SSD_out
    );

    always #10 clk = ~clk;
    always #100 clkPB = ~clkPB;
    always begin
        {rst, serIn} = 2'b11;
        #100 rst = 0;
        #100 serIn = 0;
        #300 serIn = 1;
        #200 serIn = 0;
        #400 serIn = 1;
        #400 serIn = 0;
        #200 serIn = 1;
        #200 serIn = 0;
        #200 serIn = 1;
        #600 $stop;
    end
endmodule