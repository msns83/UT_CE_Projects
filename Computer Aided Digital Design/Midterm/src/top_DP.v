module top_DP #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 16
)(
    input wire clk,
    input wire Reset,
    input wire m_Reset,
    input wire [IN_WIDTH-1:0] A0, A1, W0, W1,
    input wire A0_en, A1_en,
    input wire AaU_en,

    output wire [OUT_WIDTH-1:0] result,
    output wire finish
);
    wire [OUT_WIDTH-1:0] partial_out0 , partial_out1 ;
    wire done0 , done1 ;
    wire rst ;

    assign rst = Reset | m_Reset ;

    partial #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) partial_0 (
        .clk(clk), .rst(Reset),
        .A_en(A0_en),
        .A(A0),
        .W(W0),
        .out(partial_out0),
        .done(done0)
    );

    partial #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) partial_1 (
        .clk(clk), .rst(Reset),
        .A_en(A1_en),
        .A(A1),
        .W(W1),
        .out(partial_out1),
        .done(done1)
    );

    AaU_acc #(OUT_WIDTH) Aau_acc_inst(
        .clk(clk), .rst(rst),
        .en(AaU_en),
        .in1(partial_out0),
        .in2(partial_out1),
        .result(result)
    );

    assign finish = done0 & done1 ;
endmodule