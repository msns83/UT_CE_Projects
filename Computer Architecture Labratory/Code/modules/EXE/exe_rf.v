module ex_register_file (input wire clk,rst,
        input wire wb_en,mem_r_en,mem_w_en, 
        input wire [31:0] alu_res,val_rm, input wire [3:0] dest,

        output reg wb_en_out,mem_r_en_out,mem_w_en_out, 
        output reg [31:0] alu_res_out,val_rm_out, output reg [3:0] dest_out
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            wb_en_out <= 0;
            mem_r_en_out <= 0;
            mem_w_en_out <= 0;
            alu_res_out <= 0;
            val_rm_out <= 0;
            dest_out <= 0;
        end
        else begin
            wb_en_out <= wb_en;
            mem_r_en_out <= mem_r_en;
            mem_w_en_out <= mem_w_en;
            alu_res_out <= alu_res;
            val_rm_out <= val_rm;
            dest_out <= dest;
        end
    end
endmodule