module hash_comb_8b (
    input wire [7:0] b,
    input wire [7:0] c,
    input wire [7:0] d,
    input wire [5:4] r,
    
    output wire [7:0] o
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_combs
            hash_comb_1b hbi(.b(b[i]), .c(c[i]), .d(d[i]), .r(r), .o(o[i]));
        end
    endgenerate

endmodule