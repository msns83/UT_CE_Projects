module stepRotator #(parameter a = 32, b=6, rs=2, sw = 5)(
    input  wire [a-1:0] in,
    input  wire [b-1:0] i,
    input wire [rs-1:0] range_sel,
    output wire [a-1:0] out
);
    wire [sw-1:0] s;

    stepRom #(b,sw,rs) SR(i, range_sel, s);
    leftRotator #(a,sw) lr(in, s, out);
    
endmodule

