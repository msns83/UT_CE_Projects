module Val2Generator(
    input [31:0] val_Rm, 
    input I, 
    input Mem_in, 
    input [11:0] shift_operand, 
    output reg [31:0] result
);

    reg [7:0] immediate_value;
    reg [31:0] rotated_value;
    reg [4:0] rotate_amount;
    reg [1:0] shift_type;
    reg [4:0] shift_imm;

    always @(*) begin
        if (I == 1'b1) begin
            immediate_value = shift_operand[7:0];
            rotated_value = {24'b0, immediate_value};
            rotate_amount = 2 * shift_operand[11:8];
            result = (rotated_value >> rotate_amount) | (rotated_value << (32 - rotate_amount));
        end else if (Mem_in == 1'b1) begin
            result = {20'b0, shift_operand};
        end else if (I == 1'b0) begin
            if (shift_operand[4] == 1'b0) begin
                shift_type = shift_operand[6:5];
                shift_imm = shift_operand[11:7];
                
                case (shift_type)
                    2'b00: result = val_Rm << shift_imm;
                    2'b01: result = val_Rm >> shift_imm;
                    2'b10: result = $signed(val_Rm) >>> shift_imm;
                    2'b11: result = (val_Rm >> shift_imm) | (val_Rm << (32 - shift_imm));
                    default: result = val_Rm;
                endcase
            end else begin
                result = val_Rm;
            end
        end else begin
            result = val_Rm;
        end
    end

endmodule