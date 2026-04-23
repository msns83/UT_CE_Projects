module LOD #(
    parameter WIDTH = 8,
    parameter INDEX = $clog2(WIDTH)
)(
    input  wire [WIDTH-1:0] in,

    output wire [INDEX-1:0] shift_count,
    output wire no_one
);
    wire [WIDTH-1:0] one_hot ;
    wire [WIDTH-1:0] n_one_hot ;
    assign n_one_hot = ~one_hot ;

    wire [WIDTH-1:0] ands;
    assign ands[WIDTH-1] = 1'b1;
    assign one_hot[WIDTH-1] = in[WIDTH-1] & ands[WIDTH-1] ;
    genvar gi;
    generate
        for (gi = WIDTH-2; gi >= 0; gi = gi - 1) begin : gen_high_clear
            assign ands[gi] = ands[gi+1] & n_one_hot[gi+1] ;
            assign one_hot[gi] = in[gi] & ands[gi] ;
        end
    endgenerate

/*
    assign one_hot[7] = 1'b1 & in[7] ;
    assign one_hot[6] = n_one_hot[7] & in[6] ;
    assign one_hot[5] = n_one_hot[7] & n_one_hot[6] & in[5] ;
    assign one_hot[4] = n_one_hot[7] & n_one_hot[6] & n_one_hot[5] & in[4] ;
    assign one_hot[3] = n_one_hot[7] & n_one_hot[6] & n_one_hot[5] & n_one_hot[4] & in[3] ;
    assign one_hot[2] = n_one_hot[7] & n_one_hot[6] & n_one_hot[5] & n_one_hot[4] & n_one_hot[3] & in[2] ;
    assign one_hot[1] = n_one_hot[7] & n_one_hot[6] & n_one_hot[5] & n_one_hot[4] & n_one_hot[3] & n_one_hot[2] & in[1] ;
    assign one_hot[0] = n_one_hot[7] & n_one_hot[6] & n_one_hot[5] & n_one_hot[4] & n_one_hot[3] & n_one_hot[2] & n_one_hot[1] & in[0] ;
*/

    onehot_encoder #(.WIDTH(8)) encoder_inst (.in(one_hot), .out(shift_count), .no_one(no_one));
endmodule