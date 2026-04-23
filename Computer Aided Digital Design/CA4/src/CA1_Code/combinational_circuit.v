module combinational_circuit #(
    parameter a = 32, 
    parameter rs = 2
) (
    input  wire [a-1:0] B,
    input  wire [a-1:0] C,
    input wire [a-1:0] D,
    input wire [rs-1:0] range_sel, 
    output reg [a-1:0] out
);

    always @(*) begin
        case (range_sel)
            2'b00: out = (B & C) | ((~B) & D);
            2'b01: out = (D & B) | ((~D) & C);
            2'b10: out = (B ^ C ^ D);
            2'b11: out = C ^ (B | (~D));
            default: out = 0;
        endcase
    end

endmodule