module A_reg #(
    parameter WIDTH = 8,
    parameter INDEX = $clog2(WIDTH)
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [WIDTH-1:0] in,
    input wire zero_en,
    input wire [INDEX-1:0] zero_index,

    output reg [WIDTH-1:0] out
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            out <= {WIDTH{1'b0}} ;
        else if(en)
            out <= in ;
        else if(zero_en) begin
            out[zero_index] <= 1'b0 ;
        end
    end
endmodule