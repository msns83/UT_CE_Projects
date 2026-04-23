module hash_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire rnd_done,
    input wire ok,
    
    output wire rst_m,
    output wire message_en,
    output wire words_init,
    output wire c_en,
    output wire rnd_start,
    output wire words_en,
    output wire done
);
    wire cur1, cur0 ;
    wire s_not, r_not, o_not;

    s2 cur1_r(.D00(1'b0), .D01(s_not), .D10(o_not), .D11(1'b1), .A1(cur1), .B1(cur1), .A0(cur0), .B0(cur0), .clr(rst), .clk(clk), .out(cur1));
    s2 cur0_r(.D00(start), .D01(start), .D10(o_not), .D11(r_not), .A1(cur1), .B1(cur1), .A0(cur0), .B0(cur0), .clr(rst), .clk(clk), .out(cur0));

    c1 start_not(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(start), .S1(start), .f(s_not));
    c1 rnd_done_not(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(rnd_done), .S1(rnd_done), .f(r_not));
    c1 ok_not(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(ok), .S1(ok), .f(o_not));

    assign c_en = words_en  ;
    assign words_init = message_en ;
    c1 rst_m_o(.A0(start), .A1(1'b0), .SA(cur0), .B0(1'b0), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(rst_m));
    c1 message_en_o(.A0(1'b0), .A1(1'b1), .SA(cur0), .B0(1'b0), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(message_en));
    c1 rnd_start_o(.A0(1'b0), .A1(1'b0), .SA(cur0), .B0(1'b1), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(rnd_start));
    c1 words_en_o(.A0(1'b0), .A1(1'b0), .SA(cur0), .B0(1'b0), .B1(rnd_done), .SB(cur0), .S0(cur1), .S1(cur1), .f(words_en));
    c1 done_o(.A0(1'b0), .A1(1'b0), .SA(cur0), .B0(ok), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(done));

endmodule