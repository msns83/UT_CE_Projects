module processor(input clk, rst);
    wire [6:0] op;
    wire [2:0] func3;
    wire [6:0] func7;
    wire zero;
    wire negetive;
    wire pc_en;
    wire adr_src;
    wire mem_write;
    wire IR_write;
    wire reg_write;

    wire [1:0] alusrcA;
    wire [1:0] alusrcB;
    wire [2:0] aluop;
    wire [1:0] result_src;
    wire [2:0] imm_src;

    controller ctrl(
        .clk(clk),
        .rst(rst),
        .op(op),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .negetive(negetive),
        .pc_en(pc_en),
        .adr_src(adr_src),
        .mem_write(mem_write),
        .IR_write(IR_write),
        .reg_write(reg_write),
        .alusrcA(alusrcA),
        .alusrcB(alusrcB),
        .aluop(aluop),
        .result_src(result_src),
        .imm_src(imm_src)
    );

    data_path dp(
        .clk(clk),
        .rst(rst),
        .opcode(op),
        .func3(func3),
        .func7(func7),
        .zer(zero),
        .neg(negetive),
        .pcen(pc_en),
        .adrsrc(adr_src),
        .memwrite(mem_write),
        .irwrite(IR_write),
        .regwrite(reg_write),
        .alusrca(alusrcA),
        .alusrcb(alusrcB),
        .aluop(aluop),
        .resultsrc(result_src),
        .immsrc(imm_src)
    );

endmodule