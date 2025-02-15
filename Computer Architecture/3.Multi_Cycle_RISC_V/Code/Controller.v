module controller (
    input clk,
    input rst,
    input [6:0] op,
    input [2:0] func3,
    input [6:0] func7,
    input zero,
    input negetive,
    output reg pc_en,
    output reg adr_src,
    output reg mem_write,
    output reg IR_write,
    output reg reg_write,
    output reg [1:0] alusrcA,
    output reg [1:0] alusrcB,
    output reg [2:0] aluop,
    output reg [1:0] result_src,
    output reg [2:0] imm_src
);
    // op code
    parameter R_type = 7'b0110011;
    parameter I_type_alu = 7'b0010011;
    parameter I_type_load = 7'b0000011;
    parameter I_type_jump = 7'b1100111;
    parameter S_type = 7'b0100011;
    parameter B_type = 7'b1100011;
    parameter J_type = 7'b1101111;
    parameter U_type = 7'b0110111;

    // func3 R type code
    parameter func3_R_type_add_sub = 3'b000;
    parameter func3_R_type_sll = 3'b001;
    parameter func3_R_type_slt = 3'b010;
    parameter func3_R_type_sltu = 3'b011;
    parameter func3_R_type_xor = 3'b100;
    parameter func3_R_type_or = 3'b110;
    parameter func3_R_type_and = 3'b111;
    
    // func3 I type code
    parameter func3_I_type_lw = 3'b010;
    parameter func3_I_type_addi = 3'b000;
    parameter func3_I_type_slti = 3'b010;
    parameter func3_I_type_sltiu = 3'b011;
    parameter func3_I_type_xori = 3'b100;
    parameter func3_I_type_ori = 3'b110;
    parameter func3_I_type_andi = 3'b111;
    parameter func3_I_type_jalr = 3'b000;

    // func3 S type code
    parameter func3_S_type_sb = 3'b000;
    parameter func3_S_type_sh = 3'b001;
    parameter func3_S_type_sw = 3'b010;

    // func3 B type code
    parameter func3_B_type_beq = 3'b000;
    parameter func3_B_type_bne = 3'b001;
    parameter func3_B_type_blt = 3'b100;
    parameter func3_B_type_bge = 3'b101;
    parameter func3_B_type_bltu = 3'b110;
    parameter func3_B_type_bgeu = 3'b111;

    // func3 J type code
    parameter func3_J_type_jal = 3'b000;

    // func3 U type code
    parameter func3_U_type_lui = 3'b011;
    parameter func3_U_type_auipc = 3'b100;

    // func7 R type code
    parameter func7_R_type_default = 7'b0000000;
    parameter func7_R_type_sub = 7'b0100000;

    // immediate extend operation
    parameter imm_I_type = 3'b000;
    parameter imm_S_type = 3'b001;
    parameter imm_B_type = 3'b010;
    parameter imm_J_type = 3'b011;
    parameter imm_U_type = 3'b100;
    parameter imm_default = 3'b000;

    // ALU operation
    parameter op_add  = 3'b000;
    parameter op_sub  = 3'b001;
    parameter op_and  = 3'b010;
    parameter op_or   = 3'b011;
    parameter op_slt  = 3'b100;
    parameter op_sltu = 3'b101;
    parameter op_xor  = 3'b110;
    parameter op_default = 3'b000;

    // alu select
    parameter alu_a_pc = 2'b00;
    parameter alu_a_old_pc = 2'b01;
    parameter alu_a_reg = 2'b10;
    parameter alu_a_default = 2'b10;

    parameter alu_b_reg = 2'b00;
    parameter alu_b_imm = 2'b01;
    parameter alu_b_4 = 2'b10;
    parameter alu_b_default = 2'b00;

    // result select
    parameter result_alu_reg = 2'b00;
    parameter result_alu = 2'b01;
    parameter result_mdr = 2'b10;
    parameter result_imm = 2'b11;
    parameter result_default = 2'b00;

    // address source
    parameter adr_pc = 1'b0;
    parameter adr_result = 1'b1;

    reg [4:0] ps; 
    reg [4:0] ns; 
    parameter IF = 5'b00000,
              ID = 5'b00001,
              EX_R_TYPE = 5'b00010,
              EX_I_TYPE = 5'b00011,
              EX_SW = 5'b00100,
              EX_LW = 5'b00101,
              EX_1_JAL = 5'b00110,
              EX_2_JAL = 5'b00111,
              EX_1_JALR = 5'b01000,
              EX_2_JALR = 5'b01001,
              EX_B_TYPE = 5'b01010,
              MEM_LW = 5'b01011,
              MEM_SW = 5'b01100,
              REG_R_TYPE = 5'b01101,
              REG_I_TYPE = 5'b01110,
              REG_U_TYPE = 5'b01111,
              REG_LW = 5'b10000,
              REG_JAL = 5'b10001,
              REG_JALR = 5'b10010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= IF;
        end else begin
            ps <= ns;
        end
    end

    always @(*) begin
        ns = 5'b0;
        case(ps)
            IF: ns = ID;
            ID: case(op)
                    R_type: ns = EX_R_TYPE;
                    I_type_alu: ns = EX_I_TYPE;
                    I_type_load: ns = EX_LW;
                    I_type_jump: ns = EX_1_JALR;
                    S_type: ns = EX_SW;
                    B_type: ns = EX_B_TYPE;
                    J_type: ns = EX_1_JAL;
                    U_type: ns = REG_U_TYPE;
                    default: ns = IF;
                endcase
            EX_R_TYPE: ns = REG_R_TYPE;
            EX_I_TYPE: ns = REG_I_TYPE;
            EX_SW: ns = MEM_SW;
            EX_LW: ns = MEM_LW;
            EX_1_JAL: ns = EX_2_JAL;
            EX_2_JAL: ns = REG_JAL;
            EX_1_JALR: ns = EX_2_JALR;
            EX_2_JALR: ns = REG_JALR;
            MEM_LW: ns = REG_LW;
            default: ns = IF;
        endcase
    end

    always @(*) begin
        {pc_en, adr_src, mem_write, IR_write, reg_write, alusrcA, alusrcB, aluop, result_src, imm_src} = 17'b0;
        case(ps)
            IF: begin
                pc_en = 1'b1;
                IR_write = 1'b1;
                alusrcA = alu_a_pc;
                alusrcB = alu_b_4;
                result_src = result_alu;
                aluop = op_add;
                adr_src = adr_pc;
            end
            ID: begin
                alusrcA = alu_a_old_pc;
                alusrcB = alu_b_imm;
                aluop = op_add;
                imm_src = imm_B_type;
            end
            EX_R_TYPE: begin
                alusrcA = alu_a_reg;
                alusrcB = alu_b_reg;
                case(func7)
                    func7_R_type_default:
                        case(func3)
                            func3_R_type_add_sub: aluop = op_add;
                            func3_R_type_sll: aluop = op_default;
                            func3_R_type_slt: aluop = op_slt;
                            func3_R_type_sltu: aluop = op_sltu;
                            func3_R_type_xor: aluop = op_xor;
                            func3_R_type_or: aluop = op_or;
                            func3_R_type_and: aluop = op_and;
                        endcase
                    func7_R_type_sub:
                        if (func3 == func3_R_type_add_sub)
                            aluop = op_sub;
                endcase
            end
            EX_I_TYPE: begin
                alusrcA = alu_a_reg;
                alusrcB = alu_b_imm;
                imm_src = imm_I_type;
                case(func3)
                    func3_I_type_addi: aluop = op_add;
                    func3_I_type_slti: aluop = op_slt;
                    func3_I_type_sltiu: aluop = op_sltu;
                    func3_I_type_xori: aluop = op_xor;
                    func3_I_type_ori: aluop = op_or;
                    func3_I_type_andi: aluop = op_and;
                endcase
            end
            EX_B_TYPE: begin
                result_src = result_alu_reg;
                alusrcA = alu_a_reg;
                alusrcB = alu_b_reg;
                aluop = op_sub;
                case(func3)
                    func3_B_type_beq: pc_en = zero ? 1 : 0;
                    func3_B_type_bne: pc_en = zero ? 0 : 1;
                    func3_B_type_blt: pc_en = negetive ? 1 : 0;
                    func3_B_type_bge: pc_en = negetive ? 0 : 1;
                endcase
            end
            EX_SW: begin
                alusrcA = alu_a_reg;
                alusrcB = alu_b_imm;
                aluop = op_add;
                imm_src = imm_S_type;
            end
            EX_LW: begin
                alusrcA = alu_a_reg;
                alusrcB = alu_b_imm;
                aluop = op_add;
                imm_src = imm_I_type;
            end
            EX_1_JAL: begin
                alusrcA = alu_a_old_pc;
                alusrcB = alu_b_imm;
                aluop = op_add;
                imm_src = imm_J_type;
            end
            EX_2_JAL: begin
                alusrcA = alu_a_old_pc;
                alusrcB = alu_b_4;
                aluop = op_add;
                result_src = result_alu_reg;
                pc_en = 1'b1;
            end
            EX_1_JALR: begin
                alusrcA = alu_a_reg;
                alusrcB = alu_b_imm;
                aluop = op_add;
                imm_src = imm_I_type;
            end
            EX_2_JALR: begin
                alusrcA = alu_a_old_pc;
                alusrcB = alu_b_4;
                aluop = op_add;
                result_src = result_alu_reg;
                pc_en = 1'b1;
            end
            MEM_LW: begin
                adr_src = adr_result;
                result_src = result_alu_reg;
            end
            MEM_SW: begin
                adr_src = adr_result;
                result_src = result_alu_reg;
                mem_write = 1'b1;
            end
            REG_R_TYPE: begin
                reg_write = 1'b1;
                result_src = result_alu_reg;
            end
            REG_I_TYPE: begin
                reg_write = 1'b1;
                result_src = result_alu_reg;
            end
            REG_U_TYPE: begin
                reg_write = 1'b1;
                result_src = result_imm;
                imm_src = imm_U_type;
            end
            REG_LW: begin
                reg_write = 1'b1;
                result_src = result_mdr;
            end
            REG_JAL: begin
                reg_write = 1'b1;
                result_src = result_alu_reg;
            end
            REG_JALR: begin
                reg_write = 1'b1;
                result_src = result_alu_reg;
            end
        endcase
    end
endmodule