module multi_adder #(
    parameter WIDTH = 34,
    parameter ADD_NUM = 4
)(
    input wire [(ADD_NUM*WIDTH)-1:0] flat_inputs,

    output wire [WIDTH-1:0] sum
);
    reg [WIDTH-1:0] reminder ;

    integer i;
    always @(*) begin
        reminder = {WIDTH{1'b0}};
        for (i = 0; i < ADD_NUM; i = i + 1) begin
            reminder = reminder + flat_inputs[i*WIDTH +: WIDTH];
        end
    end

    assign sum = reminder;
endmodule