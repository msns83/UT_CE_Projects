module register #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [WIDTH-1:0] input_value,

    output reg [WIDTH-1:0] output_value
);
    always @(posedge clk or posedge rst) begin
        if(rst)
            output_value <= {WIDTH{1'b0}} ;
        else if(en)
            output_value <= input_value ;
    end
endmodule