module top #(
    parameter IN_WIDTH = 34,
    parameter SLICE_WIDTH = 16,
    parameter B_OUT_WIDTH = 64,
    parameter A_OUT_WIDTH = 4,
    parameter ADR_WIDTH = 3,
    parameter CYCLE_WIDTH = 4,
    parameter MEM_ADR_WIDTH = 7,
    parameter A_B_REG_COUNT = 8,
    parameter MEM_REG_COUNT = 128,
    parameter FILE_NAME = "input_memory (1).txt"
)(
    input wire clk,
    input wire reset,
    input wire start,
    output wire done
); 

    wire [IN_WIDTH-1:0] r_data;
    wire [MEM_ADR_WIDTH-1:0] address;
    wire write;
    wire [IN_WIDTH-1:0] o_dot_product;

    mv_multiplication #(.IN_WIDTH(IN_WIDTH), .B_OUT_WIDTH(B_OUT_WIDTH), .A_OUT_WIDTH(A_OUT_WIDTH), .ADR_WIDTH(ADR_WIDTH), .MEM_ADR_WIDTH(MEM_ADR_WIDTH), .A_B_REG_COUNT(A_B_REG_COUNT), .MEM_REG_COUNT(MEM_REG_COUNT)) mv_multiplication_top_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .r_data(r_data),
        .address(address),
        .done(done),
        .write(write),
        .o_dot_product(o_dot_product)
    );

    memory #(.WIDTH(IN_WIDTH), .ADR_WIDTH(MEM_ADR_WIDTH), .REG_COUNT(MEM_REG_COUNT), .FILE_NAME(FILE_NAME)) memory_inst (
        .clk(clk),
        .rst(reset),
        .address(address),
        .write(write),
        .w_data(o_dot_product),
        .r_data(r_data)
    );
    
endmodule 