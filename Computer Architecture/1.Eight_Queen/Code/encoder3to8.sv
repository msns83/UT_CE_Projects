`timescale 1ns/1ns
module encoder3to8 (
    input [2:0] row,
    output reg [7:0] column_content
);
    always @(*) begin
        case (row)
            3'b000: column_content = 8'b00000001;
            3'b001: column_content = 8'b00000010;
            3'b010: column_content = 8'b00000100;
            3'b011: column_content = 8'b00001000;
            3'b100: column_content = 8'b00010000;
            3'b101: column_content = 8'b00100000;
            3'b110: column_content = 8'b01000000;
            3'b111: column_content = 8'b10000000;
            default: column_content = 8'bx;
        endcase
    end
endmodule