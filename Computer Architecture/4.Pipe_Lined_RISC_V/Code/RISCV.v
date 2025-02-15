module RISCV(input clk, rst);

    wire [6:0] op;
    wire [2:0] func3;
    wire [6:0] func7;

    wire RegWrite, MemWrite, ALUSrc;
    wire [1:0] ResultSrc, Jump;
    wire [2:0] Branch, ALUControl, ImmSrc;
    
    wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;

    wire ResultSrcE0;
    wire RegWriteM, RegWriteW;
    wire StallF, StallD, FlushD, FlushE;
    wire [1:0] PCSrcE;
    wire [1:0] ResultSrcM;
    wire [1:0] ForwardAE, ForwardBE;

    Controller controller (op, func3, func7, RegWrite, ResultSrc, MemWrite, Jump, Branch, ALUControl, ALUSrc, ImmSrc);
    HazardUnit hazardUnit (Rs1D, Rs2D, RdE, Rs1E, Rs2E, PCSrcE, RdM, RdW, ResultSrcE0, ResultSrcM, RegWriteM, RegWriteW, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);
    DataPath dataPath (clk, rst, RegWrite, ResultSrc, MemWrite, Jump, Branch, ALUControl, ALUSrc, ImmSrc, op, func3, func7, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE, Rs1D, Rs2D, RdE, Rs1E, Rs2E, PCSrcE, RdM, RdW, ResultSrcE0, ResultSrcM, RegWriteM, RegWriteW);

endmodule