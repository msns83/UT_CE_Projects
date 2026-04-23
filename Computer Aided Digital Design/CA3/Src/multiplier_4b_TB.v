`timescale 1ns/1ns

module multiplier_TB;
    reg [3:0] a;
    reg [3:0] b;

    wire [7:0] p;

    multiplier_4b dut(.a(a), .b(b), .p(p));

    initial begin
        a = 4'd5;   b = 4'd9; #10   
        a = 4'd12;  b = 4'd11; #10 
        a = 4'd14;  b = 4'd3; #10  
        a = 4'd0;   b = 4'd15; #10 
        a = 4'd15;  b = 4'd0; #10 

        #20;
        $stop;
    end

endmodule