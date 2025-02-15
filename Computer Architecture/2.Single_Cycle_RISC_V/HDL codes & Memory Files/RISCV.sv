module RISCV(input clk, rst);
    wire [6:0]op;
    wire [2:0]func3;
    wire [6:0]func7;
    wire zero;
    wire negetive;
    wire [1:0]pcsel;
    wire [1:0]regsel;
    wire [2:0]extend_func;
    wire wereg;
    wire wedata;
    wire aluselb;
    wire [2:0]aluop;
    wire outsel;

    controller cont(
        .clk(clk),
        .rst(rst),
        .op(op),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .negetive(negetive),
        .pcsel(pcsel),
        .regsel(regsel),
        .extend_func(extend_func),
        .wereg(wereg),
        .wedata(wedata),
        .aluselb(aluselb),
        .aluop(aluop),
        .outsel(outsel)
    );

    data_path dp(
        .clk(clk),
        .rst(rst),
        .pcsel(pcsel),
        .regsel(regsel),
        .extend_func(extend_func),
        .wereg(wereg),
        .wedata(wedata),
        .aluselb(aluselb),
        .aluop(aluop),
        .outsel(outsel),
        .op(op),
        .func3(func3),
        .func7(func7),
        .ZERO(zero),
        .neg(negetive)
    );
endmodule