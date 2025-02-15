module HazardUnit(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdE,
    input [4:0] Rs1E,
    input [4:0] Rs2E,
    input [1:0] PCSrcE,
    input [4:0] RdM,
    input [4:0] RdW,
    input ResultSrcE0,
    input [1:0] ResultSrcM,
    input RegWriteM,
    input RegWriteW,
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);


    parameter Result_imm = 2'b11;
    parameter Forward_none = 2'b00;
    parameter Forward_ResultW = 2'b01;
    parameter Forward_ALUM = 2'b10;
    parameter Forward_ImmM = 2'b11;


    always @(*) begin
        if ( ((Rs1E == RdM) && RegWriteM) && (Rs1E != 0) )
            ForwardAE = (ResultSrcM == Result_imm) ? Forward_ImmM : Forward_ALUM;
        else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
            ForwardAE = Forward_ResultW;
        else
            ForwardAE = Forward_none;
    end

    always @(*) begin
        if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
            ForwardBE = (ResultSrcM == Result_imm) ? Forward_ImmM : Forward_ALUM;
        else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
            ForwardBE = Forward_ResultW;
        else
            ForwardBE = Forward_none;
    end

    wire lwStall;
    assign lwStall = ((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrcE0 && (RdE != 5'b0);

    always @(*) begin
        StallF = lwStall;
        StallD = lwStall;
        FlushE = PCSrcE != 2'b0 || lwStall;
        FlushD = (PCSrcE != 2'b0);
    end
    
endmodule