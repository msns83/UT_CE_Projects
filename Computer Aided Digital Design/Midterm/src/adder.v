module adder #(
    parameter WIDTH = 16
)(
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [WIDTH-1:0] c,
    input wire cin,   
    
    output wire [WIDTH-1:0] sum,
    output wire cout   
);
    assign {cout, sum} = a + b + c + cin;
endmodule