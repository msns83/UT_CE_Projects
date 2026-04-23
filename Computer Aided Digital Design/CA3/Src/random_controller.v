module random_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire c_done,
    
    output wire rst_m,
    output wire load_en,
    output wire c_en,
    output wire done
);
    wire cur1, cur0 ;
    wire s_not, d_not ;

    s2 cur1_r(.D00(1'b0), .D01(s_not), .D10(d_not), .D11(1'b0), .A1(cur1), .B1(cur1), .A0(cur0), .B0(cur0), .clr(rst), .clk(clk), .out(cur1));
    s2 cur0_r(.D00(1'b0), .D01(1'b1), .D10(1'b0), .D11(1'b0), .A1(cur1), .B1(cur1), .A0(start), .B0(start), .clr(rst), .clk(clk), .out(cur0));

    c1 start_not(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(start), .S1(start), .f(s_not));
    c1 c_done_not(.A0(1'b1), .A1(1'b1), .SA(1'b1), .B0(1'b0), .B1(1'b0), .SB(1'b0), .S0(c_done), .S1(c_done), .f(d_not));

    c1 rst_m_o(.A0(1'b1), .A1(1'b0), .SA(cur0), .B0(1'b0), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(rst_m));
    c1 load_en_o(.A0(1'b0), .A1(1'b1), .SA(cur0), .B0(1'b0), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(load_en));
    c1 c_en_o(.A0(1'b0), .A1(1'b0), .SA(cur0), .B0(1'b1), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(c_en));
    c1 done_o(.A0(1'b0), .A1(1'b0), .SA(cur0), .B0(c_done), .B1(1'b0), .SB(cur0), .S0(cur1), .S1(cur1), .f(done));

endmodule