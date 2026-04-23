module LUT_F (
    input wire [2:0] in,

    output wire out
);

    assign out = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]) ;

endmodule