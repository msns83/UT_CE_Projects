module mux2to1_32bit(
    input wire [31:0] ALU_Res,
    input wire [31:0] Mem_Data,
    input wire  MEM_R_EN,
    output wire [31:0] WB_Value
);

    assign WB_Value = MEM_R_EN ? Mem_Data : ALU_Res;

endmodule