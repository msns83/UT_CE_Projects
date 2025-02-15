module DataPath (
    input clk,
    input rst,

    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input [1:0] JumpD,
    input [2:0] BranchD,
    input [2:0] ALUControlD,
    input ALUSrcD,
    input [2:0] ImmSrcD,
    output [6:0] op,
    output [2:0] func3,
    output [6:0] func7,

    input StallF,
    input StallD,
    input FlushD,
    input FlushE,
    input [1:0] ForwardAE,
    input [1:0] ForwardBE,
    output [4:0] H_Rs1D,
    output [4:0] H_Rs2D,
    output [4:0] H_RdE,
    output [4:0] H_Rs1E,
    output [4:0] H_Rs2E,
    output [1:0] H_PCSrcE,
    output [4:0] H_RdM,
    output [4:0] H_RdW,
    output H_ResultSrcE0,
    output [1:0] H_ResultSrcM,
    output H_RegWriteM,
    output H_RegWriteW
);

    wire [31:0] PCFP, PCF, PCD, PCE;
    wire [31:0] PCPlus4F, PCTragetE, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    wire [1:0] PCSrcE;

    wire [31:0] InstrF, InstrD;
    wire [31:0] RD1D, RD2D, RD1E, RD2E;
    wire [31:0] ExtImmD, ExtImmE, ExtImmM, ExtImmW;
    wire [4:0] Rs1D, Rs2D, RdD, Rs1E, Rs2E, RdE, RdM, RdW;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;

    wire RegWriteE, RegWriteM, RegWriteW;
    wire MemWriteE, MemWriteM;
    wire [31:0] ReadDataM, ReadDataW;

    wire [1:0] JumpE;
    wire [2:0] BranchE;

    wire [31:0] SrcAE, SrcBE, RegBE, WriteDataE, WriteDataM;
    wire [31:0] ALUResultE, ALUResultM, ALUResultW;
    wire [2:0] ALUControlE;
    wire ALUSrcE;
    wire Zero, Neg;

    wire [31:0] ResultW;

    assign {H_Rs1D, H_Rs2D, H_RdE, H_Rs1E, H_Rs2E, H_PCSrcE, H_RdM, H_RdW, H_ResultSrcE0, H_ResultSrcM, H_RegWriteM, H_RegWriteW} =
           {Rs1D, Rs2D, RdE, Rs1E, Rs2E, PCSrcE, RdM, RdW, ResultSrcE[0], ResultSrcM, RegWriteM, RegWriteW};

    

    assign PCFP = (PCSrcE == 2'b00) ? PCPlus4F : (PCSrcE == 2'b01) ? ALUResultE :
                (PCSrcE == 2'b10) ? PCTragetE : (PCSrcE == 2'b11) ? 32'b0 : 4'b0;
    PC pc(.clk(clk), .rst(rst), .data_in(PCFP), .data_out(PCF), .enable(~StallF));
    memory_inst mem_inst(.A(PCF), .WD(32'b0), .clk(clk), .rst(rst), .We(1'b0), .RD(InstrF));
    assign  PCPlus4F = PCF + 32'd4;



    Register #(.bit(96)) reg_F_D(.clk(clk), .rst(rst | FlushD), .ld(~StallD), .par_in({InstrF, PCF, PCPlus4F}), .par_out({InstrD, PCD, PCPlus4D}));
    RegFile regFile(.clk(~clk), .rst(rst), .A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW), .WD(ResultW), .We(RegWriteW), .RD1(RD1D), .RD2(RD2D));
    ImmExtend immEx(.unextend_data(InstrD[31:7]), .extend_func(ImmSrcD), .extended_data(ExtImmD));
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];
    assign op = InstrD[6:0];
    assign func3 = InstrD[14:12];
    assign func7 = InstrD[31:25];
    Register #(.bit(188)) reg_D_E(.clk(clk), .rst(rst | FlushE), .ld(1'b1), 
    .par_in({RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD , RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ExtImmD, PCPlus4D}), 
    .par_out({RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcE , RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ExtImmE, PCPlus4E})
    );



    assign SrcAE = (ForwardAE == 2'b00) ? RD1E : (ForwardAE == 2'b01) ? ResultW :
                    (ForwardAE == 2'b10) ? ALUResultM : (ForwardAE == 2'b11) ? ExtImmM : 4'b0;
    assign RegBE = (ForwardBE == 2'b00) ? RD2E : (ForwardBE == 2'b01) ? ResultW :
                    (ForwardBE == 2'b10) ? ALUResultM : (ForwardBE == 2'b11) ? ExtImmM : 4'b0;
    assign SrcBE = (ALUSrcE == 1'b0) ? RegBE : ExtImmE;
    ALU alu(.A(SrcAE), .B(SrcBE), .ALUOp(ALUControlE), .ALUResult(ALUResultE), .Zero(Zero), .Neg(Neg));
    assign  PCTragetE = PCE + ExtImmE;
    JumpBranch PCSelector(.Zero(Zero), .Neg(Neg), .Jump(JumpE), .Branch(BranchE), .PCSrc(PCSrcE));
    assign WriteDataE = RegBE;
    Register #(.bit(137)) reg_E_M(.clk(clk), .rst(rst), .ld(1'b1),
    .par_in({RegWriteE, ResultSrcE, MemWriteE, ALUResultE, WriteDataE, RdE, ExtImmE, PCPlus4E}),
    .par_out({RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, RdM, ExtImmM, PCPlus4M}));


    memory_data data_mem(.A(ALUResultM), .WD(WriteDataM), .clk(clk), .rst(rst), .We(MemWriteM), .RD(ReadDataM));
    Register #(.bit(136)) reg_M_W(.clk(clk), .rst(rst), .ld(1'b1),
        .par_in({RegWriteM, ResultSrcM,
        ALUResultM, ReadDataM, RdM, ExtImmM, PCPlus4M}),
        .par_out({RegWriteW, ResultSrcW,
        ALUResultW, ReadDataW, RdW, ExtImmW, PCPlus4W})
    );




    assign ResultW = (ResultSrcW == 2'b00) ? ALUResultW : (ResultSrcW == 2'b01) ? ReadDataW :
                     (ResultSrcW == 2'b10) ? PCPlus4W : (ResultSrcW == 2'b11) ? ExtImmW : 4'b0;
                     
endmodule

module JumpBranch (
    input Zero,
    input Neg,
    input [1:0] Jump,
    input [2:0] Branch,
    output reg [1:0] PCSrc
);

    parameter JumpJalr = 2'b01;
    parameter JumpJal = 2'b10;
    parameter PC_4 = 2'b00;
    parameter PC_reg_imm = 2'b01;
    parameter PC_imm = 2'b10;
    parameter B_type_beq = 3'b001;
    parameter B_type_bne = 3'b100;

    always @(*) begin
        PCSrc = PC_4;
        case(Jump)
            JumpJal: PCSrc = PC_imm;
            JumpJalr: PCSrc = PC_reg_imm;
        endcase

        
        case(Branch)
            B_type_beq: PCSrc = Zero ? PC_imm : PC_4;
            B_type_bne: PCSrc = Zero ? PC_4 : PC_imm;
        endcase
    end
endmodule