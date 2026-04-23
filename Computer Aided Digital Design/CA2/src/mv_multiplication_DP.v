`timescale 1ns/1ns

module mv_multiplication_DP #(
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
    input wire rst,
    input wire row_en,
    input wire index_en,
    input wire b_en,
    input wire load_en,
    input wire shift_en,
    input wire write,
    input wire offset,
    input wire i_is_lsb,
    input wire i_is_valid,
    input wire cycle_en,
    input wire reset_m,
    input wire [IN_WIDTH-1:0] r_data,

    output wire cycle_ok,
    output wire row_ok,
    output wire index_ok,
    output wire [MEM_ADR_WIDTH-1:0] address,
    output wire [IN_WIDTH-1:0] o_dot_product
);
    wire [ADR_WIDTH-1:0] index_adr, row_adr;
    wire [CYCLE_WIDTH-1:0] cycle_count;

    wire [B_OUT_WIDTH*OUT_COUNT-1:0] i_vec_b;
    wire [A_OUT_WIDTH*OUT_COUNT-1:0] i_vec_a_bits;

    wire [IN_WIDTH-1:0] out_pe1;
    wire [MEM_ADR_WIDTH-1:0] element_index, read_address, write_address;
    wire i_is_msb;

    up_counter #(.WIDTH(3)) row(.clk(clk), .reset(rst), .enable(row_en), .count(row_adr));
    up_counter #(.WIDTH(3)) index(.clk(clk), .reset(rst), .enable(index_en), .count(index_adr));
    up_counter #(.WIDTH(4)) cycle(.clk(clk), .reset(rst), .enable(cycle_en), .count(cycle_count));

    b_regfile #(.IN_WIDTH(SLICE_WIDTH), .OUT_WIDTH(B_OUT_WIDTH), .ADR_WIDTH(ADR_WIDTH), .REG_COUNT(A_B_REG_COUNT)) b_regfile (
        .clk(clk), .rst(rst), 
        .b_en(b_en), 
        .adr(index_adr), 
        .in(r_data[15:0]), 
        .out(i_vec_b)
    );
    
    a_shifter #(.IN_WIDTH(SLICE_WIDTH), .OUT_WIDTH(A_OUT_WIDTH), .ADR_WIDTH(ADR_WIDTH), .REG_COUNT(A_B_REG_COUNT)) a_shifter_inst (
        .clk(clk), .rst(rst),
        .adr(index_adr),
        .load_en(load_en),
        .shift_en(shift_en),
        .in(r_data[15:0]),
        .out(i_vec_a_bits)
    );

    stripes_pe #(.W_SIZE(16), .N_COUNT(4), .OUT_SIZE(IN_WIDTH)) pe1 (
        .clk(clk), .rst(rst | reset_m),
        .i_is_msb(i_is_msb), .i_is_lsb(i_is_lsb), .i_is_valid(i_is_valid),
        .i_vec_a_bits(i_vec_a_bits[A_OUT_WIDTH-1:0]),
        .i_vec_b(i_vec_b[B_OUT_WIDTH-1:0]),
        .i_initial_sum({IN_WIDTH{1'b0}}),
        .o_dot_product(out_pe1)
    );

    stripes_pe #(.W_SIZE(16), .N_COUNT(4), .OUT_SIZE(IN_WIDTH)) pe2 (
        .clk(clk), .rst(rst | reset_m),
        .i_is_msb(i_is_msb), .i_is_lsb(i_is_lsb), .i_is_valid(i_is_valid),
        .i_vec_a_bits(i_vec_a_bits[A_OUT_WIDTH*OUT_COUNT-1:A_OUT_WIDTH]),
        .i_vec_b(i_vec_b[B_OUT_WIDTH*OUT_COUNT-1:B_OUT_WIDTH]),
        .i_initial_sum(out_pe1),
        .o_dot_product(o_dot_product)
    );

    wire [MEM_ADR_WIDTH-1:0] row_offset_mult ;
    assign row_offset_mult = row_adr << 3 ;

    multi_adder #(MEM_ADR_WIDTH, 2) row_offset_adder(
        .flat_inputs({row_offset_mult, {{MEM_ADR_WIDTH-ADR_WIDTH{1'b0}}, index_adr}}),
        .sum(element_index)
    );

    multi_adder #(MEM_ADR_WIDTH, 2) b_offset_adder(
        .flat_inputs({element_index, offset ? 7'd8 : 7'd0}),
        .sum(read_address)
    );

    multi_adder #(MEM_ADR_WIDTH, 2) write_offset_adder(
        .flat_inputs({7'd72, {{MEM_ADR_WIDTH-ADR_WIDTH{1'b0}}, row_adr} }),
        .sum(write_address)
    );

    assign address = write ? write_address : read_address;

    assign row_ok = &row_adr;
    assign index_ok = &index_adr;
    assign cycle_ok = &cycle_count;
    assign i_is_msb = (~(|(cycle_count))) & cycle_en;

endmodule