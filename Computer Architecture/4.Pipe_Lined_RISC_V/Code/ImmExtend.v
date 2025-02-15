module ImmExtend(
    input [24:0] unextend_data,
    input [2:0] extend_func,
    output reg [31:0] extended_data

);
    parameter imm_I_type = 3'b000;
    parameter imm_S_type = 3'b001;
    parameter imm_B_type = 3'b010;
    parameter imm_J_type = 3'b011;
    parameter imm_U_type = 3'b100;

    always @(*)
        begin
            case (extend_func)
                imm_I_type: extended_data = {{20{unextend_data[24]}}, unextend_data[24:13]};
                imm_S_type: extended_data = {{20{unextend_data[24]}}, unextend_data[24:18], unextend_data[4:0]};
                imm_B_type: extended_data = {{20{unextend_data[24]}}, unextend_data[0], unextend_data[23:18], unextend_data[4:1], 1'b0};
                imm_J_type: extended_data = {{12{unextend_data[24]}}, unextend_data[12:5], unextend_data[13], unextend_data[23:14], 1'b0};
                imm_U_type: extended_data = {unextend_data[24:5], {12{1'b0}}};
            endcase
    end
endmodule