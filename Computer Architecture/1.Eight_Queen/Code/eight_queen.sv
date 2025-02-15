`timescale 1ns/1ns
module eight_queen(clk, start, rst, done, no_answer, out);

    input clk, start, rst ;
    output done, no_answer ;
    output[7:0] out ;

    wire col_cout, row_cout, test_cout, row_Load_cout, col_back_cout;
    wire col_en, row_en, test_en ;
    wire col_rst, row_rst, test_rst, reg_rst, st_rst ;
    wire row_ld, test_ld, reg_ld, push, pop ;
    wire threat, UpDown, reg_sel ;


    data_path DP(clk, col_en, row_en, test_en, col_rst, row_rst, test_rst, reg_rst, st_rst,
                row_ld, test_ld, reg_ld, push, pop, UpDown, reg_sel, col_cout, row_cout, test_cout,
                row_Load_cout, col_back_cout, threat, out);

    controller CT(clk, start, rst, col_cout, row_cout, test_cout, row_Load_cout, col_back_cout, threat, col_en, row_en,
                  test_en, col_rst, row_rst, test_rst, reg_rst, st_rst, row_ld, test_ld, reg_ld, push, pop, UpDown, reg_sel,
                  done, no_answer);

endmodule