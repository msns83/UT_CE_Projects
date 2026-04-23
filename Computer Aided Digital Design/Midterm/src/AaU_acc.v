module AaU_acc #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [WIDTH-1:0] in1,
    input wire [WIDTH-1:0] in2,

    output wire [WIDTH-1:0] result
);
    wire [WIDTH-1:0] sum_result;

    adder #(16) adder_inst(.a(in1), .b(in2), .c(result), .cin(1'b0), .sum(sum_result), .cout());

    register #(16) accumulator(.clk(clk), .rst(rst), .en(en), .input_value(sum_result), .output_value(result));
endmodule