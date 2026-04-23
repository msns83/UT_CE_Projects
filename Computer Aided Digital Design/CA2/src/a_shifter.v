module a_shifter #(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 4,
    parameter OUT_COUNT = 2,
    parameter ADR_WIDTH = 3,
    parameter REG_COUNT = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire [ADR_WIDTH-1:0] adr,
    input  wire load_en,
    input  wire shift_en,
    input  wire [IN_WIDTH-1:0] in,

    output wire [(OUT_COUNT*OUT_WIDTH)-1:0] out
);
    wire [REG_COUNT-1:0] adr_decoded;
    decoder #(ADR_WIDTH,REG_COUNT) adr_decoder(.in(adr), .out(adr_decoded));

    wire [REG_COUNT-1:0] load_vec;
    assign load_vec = {REG_COUNT{load_en}} & adr_decoded;

    genvar i;
    generate
        for (i = 0; i < REG_COUNT; i = i + 1) begin : g_sregs
            left_shift_register #(IN_WIDTH) sreg_i(
                .clk(clk), .rst(rst),
                .load_en(load_vec[i]),
                .shift_en(shift_en),
                .load(in),
                .value(),
                .out_bit(out[i])
            );
        end
    endgenerate

endmodule