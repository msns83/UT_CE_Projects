module memory #(
    parameter WIDTH = 34,
    parameter ADR_WIDTH = 7,
    parameter REG_COUNT = 128,
    parameter FILE_NAME = "input_memory (1).txt"
)(
    input wire clk,
    input wire rst,
    input wire [ADR_WIDTH-1:0] address,
    input wire write,
    input wire [WIDTH-1:0] w_data,

    output wire [WIDTH-1:0] r_data
);
    reg [WIDTH-1:0] mem [0:REG_COUNT-1];

    initial begin
        $readmemh(FILE_NAME, mem);
    end

    always @(posedge clk) begin
        if (write) begin
            mem[address] <= w_data;
        end
    end

    assign r_data = mem[address];

endmodule