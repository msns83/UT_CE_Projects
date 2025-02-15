`timescale 1ns/1ns
module decoder8to3 (
    input [7:0] column_content,
    output reg [2:0] row
);
    always @(*) begin
        case (column_content)
            8'b00000001: row = 3'b000;
            8'b00000010: row = 3'b001;
            8'b00000100: row = 3'b010;
            8'b00001000: row = 3'b011;
            8'b00010000: row = 3'b100;
            8'b00100000: row = 3'b101;
            8'b01000000: row = 3'b110;
            8'b10000000: row = 3'b111;
            default: row = 3'b000;
        endcase
    end
endmodule