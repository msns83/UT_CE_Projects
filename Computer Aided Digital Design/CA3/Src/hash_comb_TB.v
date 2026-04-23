`timescale 1ns/1ns

module hash_comb_verifier #(
    parameter a = 8, 
    parameter rs = 2
) (
    input  wire [a-1:0] B,
    input  wire [a-1:0] C,
    input wire [a-1:0] D,
    input wire [rs-1:0] range_sel, 
    output reg [a-1:0] out
);
    always @(*) begin
        case (range_sel)
            2'b00: out = (B & C) | ((~B) & D);
            2'b01: out = (D & B) | ((~D) & C);
            2'b10: out = (B ^ C ^ D);
            2'b11: out = C ^ (B | (~D));
            default: out = 0;
        endcase
    end
endmodule

module hash_comb_8b_TB;

    reg  [7:0] b;
    reg  [7:0] c;
    reg  [7:0] d;
    reg  [5:4] r;
    
    wire [7:0] o;
    wire [7:0] result_check;

    hash_comb_8b dut(.b(b), .c(c), .d(d), .r(r), .o(o));
    hash_comb_verifier #(8,2) checker(.B(b), .C(c), .D(d), .range_sel(r), .out(result_check));

    initial begin

        b = 8'b0000_0000;
        c = 8'b0000_0000;
        d = 8'b0000_0000;
        r = 2'b00;          
        #10;

        b = 8'b0000_1111;
        c = 8'b1111_0000;
        d = 8'b1010_1010;
        r = 2'b01;
        #10;

        b = 8'b0101_0101;
        c = 8'b0011_1100;
        d = 8'b1111_0000;
        r = 2'b10;
        #10;

        b = 8'hFF;
        c = 8'hFF;
        d = 8'hFF;
        r = 2'b11;
        #10;

        b = 8'h3C;
        c = 8'hA7;
        d = 8'h5D;
        r = 2'b01;
        #10;

        b = 8'h12;
        c = 8'hE4;
        d = 8'h9B;
        r = 2'b10;
        #10;

        b = 8'hF0;
        c = 8'h0F;
        d = 8'hAA;
        r = 2'b00;
        #10;

        #20;
        $stop;
    end

endmodule