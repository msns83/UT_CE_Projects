module ALU (
    input wire [3:0] command, input wire [31:0] in1,in2,input wire C,
    output reg [31:0] result, output reg [3:0] zcvn
);
always @(*) begin
    zcvn = 4'b0000;
    case (command)
        4'b0001: begin // MOV
            result = in2;
        end
        4'b0010: begin // ADD
            {zcvn[2], result} = in1 + in2;
        end
        4'b0011: begin // ADC
            {zcvn[2], result} = in1 + in2 + C;
        end
        4'b0100: begin // SUB
            {zcvn[2], result} = in1 - in2;
        end
        4'b0101: begin // SBC
            {zcvn[2], result} = in1 - in2 - !C;
        end
        4'b0110: begin // AND
            result = in1 & in2;
        end
        4'b0111: begin // ORR
            result = in1 | in2;
        end
        4'b1000: begin // EOR (XOR)
            result = in1 ^ in2;
        end
        4'b1001: begin // MVN
            result = ~in2;
        end
        default: begin
            result = 32'd0;
        end
    endcase
    
    // Z flag (Zero)
    zcvn[3] = (result == 32'd0);
    
    // N flag (Negative)
    zcvn[0] = result[31];
    
    // V flag (Overflow) - only for ADD, ADC, SUB, SBC
    if (command == 4'b0010 || command == 4'b0011) // ADD, ADC
        zcvn[1] = (in1[31] == in2[31]) && (result[31] != in1[31]);
    else if (command == 4'b0100 || command == 4'b0101) // SUB, SBC
        zcvn[1] = (in1[31] != in2[31]) && (result[31] != in1[31]);
end
endmodule