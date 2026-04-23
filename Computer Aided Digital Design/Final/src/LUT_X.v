module LUT_X (
    input wire [2:0] in,

    output wire out
);

    assign out = in[0] ^ in[1] ^ in[2] ;

endmodule