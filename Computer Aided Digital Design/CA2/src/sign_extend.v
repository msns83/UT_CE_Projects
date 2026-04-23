module sign_extend #(
    parameter INPUT_WIDTH = 16,
    parameter OUTPUT_WIDTH = 34
)(
    input wire [INPUT_WIDTH-1:0] num,

    output wire [OUTPUT_WIDTH-1:0] num_extend
);

    assign num_extend = { {(OUTPUT_WIDTH-INPUT_WIDTH){num[INPUT_WIDTH-1]}} , num } ;

endmodule