module leftRotator #(
    parameter WIDTH = 32,
    parameter SHW = 5
)(
    input  wire [WIDTH-1:0] in,
    input  wire [SHW-1:0] s,
    output wire [WIDTH-1:0] out
);
    wire [2*WIDTH-1:0] pre_out;
    assign pre_out = ({in, in} << s);
    assign out = pre_out[2*WIDTH-1:WIDTH];

endmodule

