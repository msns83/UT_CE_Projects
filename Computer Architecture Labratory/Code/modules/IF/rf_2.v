module register_file_2 (input wire clk,rst, input wire flush,freeze,
input wire [31:0] signed_imm_24,PC,val_rn,val_rm,mem_w_en,
output reg [31:0] signed_imm_24,PC,val_rn,val_rm,mem_w_en);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            updated_pc_reg <= 0;
            instruction_reg <= 0;
        end
        else if (~freeze) begin
            if (flush) begin
                updated_pc_reg <= 0;
                instruction_reg <= 0; 
            end
            else begin
                updated_pc_reg <= updated_pc;
                instruction_reg <= instruction; 
            end
        end
    end
endmodule