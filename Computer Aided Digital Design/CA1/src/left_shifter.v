module left_shifter #(
    parameter WIDTH = 6
)(
    input wire clk,
    input wire reset,        
    input wire enable,       
    input wire load_enable,  
    input wire [WIDTH-1:0] load_value,   
    input wire new_bit,     
    output reg [WIDTH-1:0] data_out     
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= {WIDTH{1'b0}};                   
        else if (load_enable)
            data_out <= load_value;                     
        else if (enable)
            data_out <= {data_out[WIDTH-2:0], new_bit};
    end

endmodule
