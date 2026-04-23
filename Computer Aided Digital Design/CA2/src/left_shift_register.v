module left_shift_register #(
    parameter WIDTH = 34
)(
    input wire clk,
    input wire rst,  
    input wire load_en,
    input wire shift_en,
    input wire [WIDTH-1:0] load,

    output reg [WIDTH-1:0] value,
    output reg out_bit
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            value <= {WIDTH{1'b0}};
            out_bit <= 1'b0 ;
        end 
	else begin
            if (load_en) begin
                out_bit = load[WIDTH-1] ;
                value = load; 
            end
            if (shift_en) begin
                out_bit = value[WIDTH-1] ;
                value = {value[WIDTH-2:0], 1'b0} ;
            end
        end 
    end

endmodule