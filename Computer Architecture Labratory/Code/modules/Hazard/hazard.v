module data_hazard_unit (
    input wire two_src, mem_wb_en, exe_wb_en,
    input wire [3:0] mem_dest, exe_dest, rn, rm,
    input wire exe_mem_r_en,fwd_en,
    output wire hazard
);
    assign hazard = (~fwd_en)? 
                    ((rn == mem_dest) && mem_wb_en) ||
                    ((rn == exe_dest) && exe_wb_en) ||
                    (two_src && (rm == mem_dest) && mem_wb_en) ||
                    (two_src && (rm == exe_dest) && exe_wb_en):
                    (exe_mem_r_en)? 
                    (rn == exe_dest) ||
                    (two_src && (rm == exe_dest)) :
                    1'b0
                    ;
endmodule