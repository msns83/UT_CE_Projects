`timescale 1ns/1ns
module data_path(clk, col_en, row_en, test_en, col_rst, row_rst, test_rst, reg_rst, st_rst,
                row_ld, test_ld, reg_ld, push, pop, UpDown, reg_sel, col_cout, row_cout, test_cout,
                row_Load_cout, col_back_cout, threat, reg_out);

    input clk;

    input col_en, row_en, test_en ;
    input col_rst, row_rst, test_rst, reg_rst, st_rst ;
    input row_ld, test_ld, reg_ld, push, pop ;
    input UpDown, reg_sel ;

    output col_cout, row_cout, test_cout, row_Load_cout, col_back_cout;
    output threat;
    output[7:0] reg_out ;

    wire[2:0] col,row,test ;
    wire[2:0] row_Load, test_Load ;
    wire[2:0] read_reg_sel ;
    wire[2:0] decoded, stack_out ;

    wire[7:0] encoded ;
    wire dummy ;

    U_D_counter col_Counter(col_en, UpDown, col_rst, 1'b0, 3'bzzz, clk, col, col_cout);
    U_D_counter row_Counter(row_en, 1'b1, row_rst, row_ld, row_Load, clk, row, row_cout);
    U_D_counter test_Counter(test_en, 1'b0, test_rst, test_ld, test_Load, clk, test, dummy);

    assign {row_Load_cout, row_Load} = stack_out + 3'b001 ;
    assign test_Load = col - 3'b001 ;
    assign test_cout = &test ;
    assign col_back_cout = ~|col ;

    safety_check threat_checker(row, col, decoded, test, threat);

    decoder8to3 Decoder(reg_out ,decoded);
    encoder3to8 Encoder(row,encoded);
    
    block_register board(read_reg_sel, col, reg_ld, encoded, reg_rst, clk, reg_out);
	//stack_3bit(a_rst, push, pop, Load, out, clk)
    stack_3bit stack(st_rst, push, pop, row, stack_out, clk);

    assign read_reg_sel = (reg_sel) ? (col) : (test) ;

endmodule