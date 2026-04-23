module control_unit (input wire [3:0] opcode, input wire [1:0] mode, input wire s, output wire [8:0] cuo);
    // 8 7 6:3  2     1    0
    // s b exe memw  memr  wb
    assign cuo[8] = s;
    reg [7:0] temp;
    always @(*) begin
        case ({mode, opcode})
            6'b001101: temp = 8'b00001001; //MOV
            6'b001111: temp = 8'b01001001; //MVN
            6'b000100: temp = 8'b00010001; //ADD
            6'b000101: temp = 8'b00011001; //ADC
            6'b000010: temp = 8'b00100001; //SUB
            6'b000110: temp = 8'b00101001; //SBC
            6'b000000: temp = 8'b00110001; //AND
            6'b001100: temp = 8'b00111001; //ORR
            6'b000001: temp = 8'b01000001; //EOR
            6'b001010: temp = 8'b00100000; //CMP
            6'b001000: temp = 8'b00110000; //TST
            6'b010100: temp = s ? 8'b00010011 : 8'b00010100; //LDR
            // 6'b0101000: temp = 8'b00010100; //STR
            // 7'b10xxxxx: temp = 8'b10000000; //BRANCH
            default: temp = 8'd000000;
        endcase
        temp = (mode==2'b10)? 8'b10000000 : temp;
    end
    assign cuo[7:0] = temp;
endmodule