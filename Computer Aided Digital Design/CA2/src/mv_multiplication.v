module mv_multiplication #(
    parameter IN_WIDTH = 34,
    parameter SLICE_WIDTH = 16,
    parameter B_OUT_WIDTH = 64,
    parameter OUT_COUNT = 2,
    parameter A_OUT_WIDTH = 4,
    parameter ADR_WIDTH = 3,
    parameter CYCLE_WIDTH = 4,
    parameter MEM_ADR_WIDTH = 7,
    parameter A_B_REG_COUNT = 8,
    parameter MEM_REG_COUNT = 128
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [IN_WIDTH-1:0] r_data,
    output wire [MEM_ADR_WIDTH-1:0] address,
    output wire done,
    output wire write,
    output wire [IN_WIDTH-1:0] o_dot_product
);

    wire b_en;
    wire index_en;
    wire offset;
    wire load_en;
    wire shift_en;
    wire row_en;
    wire i_is_valid;
    wire i_is_lsb;
    wire reset_m;

    wire index_ok;
    wire cycle_ok;
    wire row_ok;
    wire cycle_en;

    mv_multiplication_DP  #(
        .IN_WIDTH(IN_WIDTH),
        .B_OUT_WIDTH(B_OUT_WIDTH),
        .A_OUT_WIDTH(A_OUT_WIDTH),
        .ADR_WIDTH(ADR_WIDTH),
        .MEM_ADR_WIDTH(MEM_ADR_WIDTH),
        .A_B_REG_COUNT(A_B_REG_COUNT),
        .MEM_REG_COUNT(MEM_REG_COUNT)
    ) mv_multiplication (
        .clk(clk),
        .rst(reset),
        .row_en(row_en),
        .index_en(index_en),
        .b_en(b_en),
        .load_en(load_en),
        .shift_en(shift_en),
        .write(write),
        .offset(offset),
        .i_is_lsb(i_is_lsb),
        .i_is_valid(i_is_valid),
        .r_data(r_data),
        .o_dot_product(o_dot_product),
        .cycle_ok(cycle_ok),
        .row_ok(row_ok),
        .index_ok(index_ok),
        .cycle_en(cycle_en),
        .address(address),
        .reset_m(reset_m)
    );

    mv_multiplication_CN control_unit (
        .clk(clk),
        .reset(reset),
        .start(start),
        .index_ok(index_ok),
        .cycle_ok(cycle_ok),
        .row_ok(row_ok),
        .b_en(b_en),
        .cycle_en(cycle_en),
        .index_en(index_en),
        .offset(offset),
        .load_en(load_en),
        .shift_en(shift_en),
        .row_en(row_en),
        .done(done),
        .i_is_valid(i_is_valid),
        .write(write),
        .i_is_lsb(i_is_lsb),
        .reset_m(reset_m)
    );

endmodule