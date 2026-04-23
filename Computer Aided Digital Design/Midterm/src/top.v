module top (
    input wire Clock,
    input wire Reset,
    input wire Start,
    input wire [7:0] A0, A1, W0, W1,

    output wire Ready,
    output wire [15:0] Result
);
    wire finish ;
    wire A0_en, A1_en, AaU_en, m_Reset;

    top_CN controller (
        .clk(Clock),
        .rst(Reset),
        .start(Start),
        .finish(finish),

        .A0_en(A0_en),
        .A1_en(A1_en),
        .AaU_en(AaU_en),
        .ready(Ready),
        .m_Reset(m_Reset)
    );

    top_DP datapath (
        .clk(Clock),
        .Reset(Reset),
        .m_Reset(m_Reset),
        .A0(A0), .A1(A1), .W0(W0), .W1(W1),
        .A0_en(A0_en),
        .A1_en(A1_en),
        .AaU_en(AaU_en),

        .result(Result),
        .finish(finish)
    );


endmodule