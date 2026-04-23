module stripes_pe #(
    parameter W_SIZE = 16,
    parameter N_COUNT = 4,
    parameter OUT_SIZE = 34
)(
    input clk,
    input rst,
    input wire [N_COUNT-1:0] i_vec_a_bits,
    input wire i_is_msb,
    input wire i_is_lsb,
    input wire i_is_valid,
    input wire [(N_COUNT*W_SIZE)-1:0] i_vec_b,
    input wire [OUT_SIZE-1:0] i_initial_sum,

    output wire [OUT_SIZE-1:0] o_dot_product
);

    wire [(N_COUNT*OUT_SIZE)-1:0] multi_results;
    wire [OUT_SIZE-1:0] dot_result;

    genvar i;
    generate
        for (i = 0; i < N_COUNT; i = i + 1) begin : gen_mutiplier
            serial_multiplier #(OUT_SIZE, W_SIZE) multiplier_inst(
                .clk(clk), .rst(rst), .a_bit(i_vec_a_bits[i]), .i_is_msb(i_is_msb),
                .i_is_lsb(i_is_lsb), .i_is_valid(i_is_valid), 
                .b(i_vec_b[((i+1)*W_SIZE)-1:i*W_SIZE]), .final_result(multi_results[((i+1)*OUT_SIZE)-1:i*OUT_SIZE])
            );
        end
    endgenerate

    multi_adder #(.WIDTH(OUT_SIZE), .ADD_NUM(N_COUNT)) elements_adder(.flat_inputs(multi_results), .sum(dot_result));
    multi_adder #(.WIDTH(OUT_SIZE), .ADD_NUM(2)) final_adder(.flat_inputs({i_initial_sum,dot_result}), .sum(o_dot_product));

endmodule