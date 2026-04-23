module onehot_encoder #(
    parameter WIDTH = 8,
    parameter INDEX = $clog2(WIDTH)
)(
    input wire [WIDTH-1:0] in,

    output reg [INDEX-1:0] out,
    output wire no_one
);

    always @(*) begin
        if (in == 8'b00000001)
            out = 3'b000;
        else if (in == 8'b00000010)
            out = 3'b001;
        else if (in == 8'b00000100)
            out = 3'b010;
        else if (in == 8'b00001000)
            out = 3'b011;
        else if (in == 8'b00010000)
            out = 3'b100;
        else if (in == 8'b00100000)
            out = 3'b101;
        else if (in == 8'b01000000)
            out = 3'b110;
        else if (in == 8'b10000000)
            out = 3'b111;
        else 
            out = 3'b000;
    end

    assign no_one = ~(|in);

endmodule