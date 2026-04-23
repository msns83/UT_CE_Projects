module forward (
    input wire mem_wb_en,wb_wb_en,
    input wire[3:0] mem_dest,wb_dest,
    input wire fwd_en,
    input wire [3:0] src1_exe,src2_exe,
    output wire [1:0] sel_src1,sel_src2
);
    assign sel_src1 = (~fwd_en)? 2'b00:
                    ((src1_exe == mem_dest) && mem_wb_en)? 2'b01:
                    ((src1_exe == wb_dest) && wb_wb_en)? 2'b10:
                    2'b00;
    assign sel_src2 = (~fwd_en)? 2'b00:
                    ((src2_exe == mem_dest) && mem_wb_en)? 2'b01:
                    ((src2_exe == wb_dest) && wb_wb_en)? 2'b10:
                    2'b00;
endmodule