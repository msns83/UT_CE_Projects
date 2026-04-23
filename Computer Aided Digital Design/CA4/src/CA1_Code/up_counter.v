module up_counter #(
    parameter WIDTH = 3
)(
    input wire clk,     
    input wire reset,   
    input wire enable,
    output reg [WIDTH-1:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= {WIDTH{1'b0}};            
        else if (enable)
            count <= count + 1'b1;            
    end

endmodule
