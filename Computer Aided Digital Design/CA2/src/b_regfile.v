module b_regfile #(
    parameter IN_WIDTH = 16,
    parameter OUT_WIDTH = 64,
    parameter OUT_COUNT = 2,
    parameter ADR_WIDTH = 3,
    parameter REG_COUNT = 8
)(
    input wire clk,
    input wire rst,  
    input wire [ADR_WIDTH-1:0] adr,
    input wire b_en,
    input wire [IN_WIDTH-1:0] in,

    output wire [OUT_COUNT*OUT_WIDTH-1:0] out
);
    wire [REG_COUNT-1:0] adr_decoded;
    decoder #(ADR_WIDTH,REG_COUNT) adr_decoder(.in(adr), .out(adr_decoded));

    wire [REG_COUNT-1:0] load_vec;
    assign load_vec = {REG_COUNT{b_en}} & adr_decoded;

    genvar i;
    generate
        for (i = 0; i < REG_COUNT; i = i + 1) begin : g_regs
            register #(IN_WIDTH) reg_i(
                .clk(clk), .rst(rst), .en(load_vec[i]),
                .in(in), .out(out[(i+1)*IN_WIDTH-1: i*IN_WIDTH])
            );
        end
    endgenerate
    
endmodule
