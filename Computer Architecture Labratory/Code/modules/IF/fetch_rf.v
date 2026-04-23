module fetch_register_file (input wire clk,rst, input wire flush,freeze,
input wire [31:0] updated_pc,instruction,output reg [31:0] updated_pc_reg,instruction_reg);
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


