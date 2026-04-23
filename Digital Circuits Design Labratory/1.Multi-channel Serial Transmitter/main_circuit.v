module MSSD (
    input clk,
    input rst,
    input serIn,
    input clkPB,
    output P0,
    output P1,
    output P2,
    output P3,
    output done,
    output serOutValid,
    output [6:0] SSD_out
);
    wire clk_en;
    wire cnt1, cnt2, cntD, ldcntD;
    wire sh_en, sh_enD;

    wire co1, co2, coD;

    OnePulser op1 (.clk(clk), .rst(rst), .LP(clkPB), .SP(clk_en));

    DataPath dp1 (.clk(clk), .rst(rst), .clk_en(clk_en), .serIn(serIn), .cnt1(cnt1), .cnt2(cnt2), .cntD(cntD), .ldcntD(ldcntD), .sh_en(sh_en), .sh_enD(sh_enD)
                , .co1(co1), .co2(co2), .coD(coD), .P0(P0), .P1(P1), .P2(P2), .P3(P3), .SSD_out(SSD_out));

    controller cntrl1 (.clk(clk), .rst(rst), .clk_en(clk_en), .serin(serIn), .co1(co1), .co2(co2), .coD(coD)
                      , .cnt1(cnt1), .cnt2(cnt2), .cntD(cntD), .ldcntD(ldcntD), .sh_enP(sh_en), .sh_enD(sh_enD), .SerOutValid(serOutValid), .done(done));
    

endmodule