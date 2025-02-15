module ALU (
    input signed [31:0] A,
    input signed [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] ALUResult,
    output reg Zero,
    output reg Neg
);

    parameter op_add  = 3'b000;
    parameter op_sub  = 3'b001;
    parameter op_and  = 3'b010;
    parameter op_or   = 3'b011;
    parameter op_slt  = 3'b100;
    parameter op_xor  = 3'b110;

    always @(*) begin
        case(ALUOp)
            op_add: ALUResult = A + B;
            op_sub: ALUResult = A - B;
            op_and: ALUResult = A & B;
            op_or: ALUResult = A | B;
            op_slt: ALUResult = A < B;
            op_xor: ALUResult = A ^ B;
        endcase
    end

    always @(*) begin
        Zero = (ALUResult == 0);
        Neg =  ALUResult[31];
    end

endmodule