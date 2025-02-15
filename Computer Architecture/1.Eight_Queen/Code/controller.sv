`timescale 1ns/1ns
`define S0 5'b00000
`define S1 5'b00001
`define S2 5'b00010
`define S3 5'b00011
`define S4 5'b00100
`define S5 5'b00101
`define S6 5'b00110
`define S7 5'b00111
`define S8 5'b01000
`define S9 5'b01001
`define S10 5'b01010
`define S11 5'b01011
`define S12 5'b01100
`define S13 5'b01101
`define S14 5'b01110
`define S15 5'b01111
`define S16 5'b10000
`define S17 5'b10001
`define S18 5'b10010
module controller(clk, start, rst, col_cout, row_cout, test_cout, row_Load_cout, col_back_cout, threat, col_en,
                  row_en, test_en, col_rst, row_rst, test_rst, reg_rst, st_rst, row_ld, test_ld, reg_ld, push, pop,
                  UpDown, reg_sel, done, no_answer);

    input clk;
    input start, rst;
    input col_cout, row_cout, test_cout, row_Load_cout, col_back_cout;
    input threat;

    output reg col_en, row_en, test_en ;
    output reg col_rst, row_rst, test_rst, reg_rst, st_rst ;
    output reg row_ld, test_ld, reg_ld, push, pop ;
    output reg UpDown, reg_sel ;
    output reg done, no_answer;

    reg [4:0] ps, ns;

    always @(posedge clk)
        if(rst)
            ps <= `S0;
        else
            ps <= ns;

    always @(ps or start or col_cout or row_cout or test_cout or threat)
    begin
        case (ps)
            `S0: ns = start ? `S1 : `S0;
            `S1: ns = `S2 ;
            `S2: ns = `S3 ;
            `S3: ns = `S4 ;
            `S4: ns = test_cout ? `S5 : (threat ? `S8 : `S7) ;
            `S5: ns = `S14 ;
            `S6: ns = `S4 ;
            `S7: ns = `S6 ;
            `S8: ns = `S9 ;
            `S9: ns = row_cout ? `S10 : `S4 ;
            `S10: ns = col_back_cout ? `S18 : `S11 ;
            `S11: ns = `S12 ;
            `S12: ns = row_Load_cout ? `S10 : `S2 ;
            `S13: ns = `S17 ;
	    `S14: ns = `S16 ;
            `S15: ns = col_cout ? `S0 : `S15 ;
            `S16: ns = col_cout ? `S13 : `S2 ;
            `S17: ns = `S15 ;
            `S18: ns = `S18 ;
            default: ns = `S0 ;
        endcase
    end

    always @(ps)
    begin
        {col_en, row_en, test_en} = 3'b000 ;
        {col_rst, row_rst, test_rst, reg_rst, st_rst} = 5'b00000 ;
        {row_ld, test_ld, reg_ld, push, pop} = 5'b00000 ;
        {UpDown, reg_sel, done, no_answer} = 4'b0000 ;
        

        case (ps)
            `S1: {col_rst, row_rst, test_rst, reg_rst, st_rst} = 5'b11111 ;
            `S2: test_ld = 1'b1 ;
            `S5: {reg_ld, push} = 2'b11 ;
            `S7: test_en = 1'b1 ;
            `S8: {row_en, test_ld} = 2'b11 ;
            `S10: col_en = 1'b1 ;
            `S11: pop = 1'b1 ;
            `S12: row_ld = 1'b1 ;
            `S13: {col_rst, reg_sel, UpDown} = 3'b111 ;
	    `S14: {col_en, row_rst, UpDown} = 3'b111 ;
            `S15: {reg_sel, col_en, UpDown} = 3'b111 ;
            `S17: {reg_sel, col_en, UpDown, done} = 4'b1111 ;
            `S18: no_answer = 1'b1 ;
	        default: done = 1'b0 ;
        endcase
    end






endmodule