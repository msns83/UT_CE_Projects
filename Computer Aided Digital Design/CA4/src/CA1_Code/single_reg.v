module single_reg #(
    parameter WIDTH = 1
)(
    input wire clk,
    input wire reset,
    input wire en,
    input wire [WIDTH-1:0] value,

    output reg [WIDTH-1:0] vari
);


    always @(posedge clk, posedge reset) begin
        if (reset)
            vari <= {WIDTH{1'b0}};            
        else if (en)
            vari <= value; 
    end

endmodule