module register #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);


    always @(posedge clk, posedge rst) begin
        if (rst)
            out <= {WIDTH{1'b0}};            
        else if (en)
            out <= in; 
    end

endmodule