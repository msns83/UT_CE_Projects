`timescale 1ns/1ns

module adder_TB;
    reg [7:0] a;
    reg [7:0] b;

    wire [7:0] s;

    adder_8b dut(.a(a), .b(b), .s(s));

    initial begin
        a = 8'd5;   b = 8'd18; #10   
        a = 8'd12;  b = 8'd11; #10 
        a = 8'd24;  b = 8'd57; #10  
        a = 8'd101; b = 8'd101; #10   
        a = 8'd233; b = 8'd20; #10 
        a = 8'd0;   b = 8'd17; #10 
        a = 8'd17;  b = 8'd0; #10 

        #20;
        $stop;
    end

endmodule