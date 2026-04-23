module decoder #(
    parameter IN_WIDTH = 3,
    parameter OUT_WIDTH = 8
)(
    input wire [IN_WIDTH-1:0] in,
    
    output wire [OUT_WIDTH-1:0] out
);
    assign out = {{OUT_WIDTH-1{1'b0}} , 1'b1} << in ;

endmodule