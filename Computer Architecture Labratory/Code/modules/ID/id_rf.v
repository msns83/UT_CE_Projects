module id_register_file (input wire clk,rst, input wire flush,
input wire [31:0] pc,val_rn,val_rm, input wire imm, 
input wire [11:0] shift_operand, input wire [8:0] control_unit_out,
input wire [23:0] signed_imm_24, input wire [3:0] dest,input wire status_reg,
input wire [3:0] addr_rm , addr_rn,

output reg [31:0] pc_out,val_rn_out,val_rm_out, output reg imm_out, 
output reg [11:0] shift_operand_out, output reg [8:0] control_unit_out_out,
output reg [23:0] signed_imm_24_out, output reg [3:0] dest_out,output reg status_reg_out,
output reg [3:0] addr_rm_out , addr_rn_out);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pc_out <= 0;
            val_rn_out <= 0;
            val_rm_out <= 0; 
            imm_out <= 0;
            shift_operand_out <= 0;
            control_unit_out_out <= 0;
            signed_imm_24_out <= 0;
            dest_out <= 0;
            status_reg_out <= 0;
        end
        else if (flush) begin
                pc_out <= 0;
                val_rn_out <= 0;
                val_rm_out <= 0; 
                imm_out <= 0;
                shift_operand_out <= 0;
                control_unit_out_out <= 0;
                signed_imm_24_out <= 0;
                dest_out <= 0;
                status_reg_out <= 0;
                addr_rm_out <= 0;
                addr_rn_out <= 0;
        end else begin
                pc_out <= pc;
                val_rn_out <= val_rn;
                val_rm_out <= val_rm; 
                imm_out <= imm;
                shift_operand_out <= shift_operand;
                control_unit_out_out <= control_unit_out;
                signed_imm_24_out <= signed_imm_24;
                dest_out <= dest;
                status_reg_out <= status_reg;
                addr_rm_out <= addr_rm;
                addr_rn_out <= addr_rn;
            end
    end
endmodule