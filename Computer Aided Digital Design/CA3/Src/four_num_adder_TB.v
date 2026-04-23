`timescale 1ns/1ns

module four_num_adder_TB;
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;

    wire [7:0] s;

    four_num_adder dut(.a(a), .b(b), .c(c), .d(d), .s(s));

    initial begin
        a = 8'd5;   b = 8'd18;  c = 8'd17; d = 8'd14; #10  
        a = 8'd12;  b = 8'd11;  c = 8'd16; d = 8'd13; #10
        a = 8'd24;  b = 8'd57;  c = 8'd12; d = 8'd12; #10
        a = 8'd101; b = 8'd101; c = 8'd11; d = 8'd11; #10 
        a = 8'd233; b = 8'd20;  c = 8'd0; d = 8'd1; #10
        a = 8'd0;   b = 8'd17;  c = 8'd47; d = 8'd14; #10
        a = 8'd17;  b = 8'd0;   c = 8'd10; d = 8'd19; #10

        #20;
        $stop;
    end

endmodule