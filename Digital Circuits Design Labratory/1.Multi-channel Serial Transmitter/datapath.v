module DataPath (
    input clk,
    input rst,
    input clk_en,
    input serIn,
    input cnt1,
    input cnt2,
    input cntD,
    input ldcntD,
    input sh_en,
    input sh_enD,
    output co1,
    output co2,
    output coD,
    output P0,
    output P1,
    output P2,
    output P3,
    output [6:0] SSD_out
);
    
    wire [1:0] port_num;
    wire [3:0] num_data;
    wire [3:0] count_out;

    PSR psr1 (.clk(clk), .clk_en(clk_en), .rst(rst), .sh_en(sh_en), .serin(serIn), .par_ld(port_num));
    DSR dsr1 (.clk(clk), .clk_en(clk_en), .rst(rst), .sh_en(sh_enD), .serin(serIn), .par_ld(num_data));

    port_count pc1 (.clk(clk), .clk_en(clk_en), .rst(rst), .cnt(cnt1), .co(co1)); 
    data_num_cnt dnc1 (.clk(clk), .clk_en(clk_en), .rst(rst), .cnt(cnt2), .co(co2)); 
    data_trans_cnt dtc1 (.clk(clk), .clk_en(clk_en), .rst(rst), .ldcntD(ldcntD), .cntD(cntD), .num_data(num_data), .par_out(count_out), .coD(coD)); 

    SSD ssd (.count(count_out), .SSD_out(SSD_out));

    demnx dmx1 (.serout(serIn), .port_num(port_num), .P0(P0), .P1(P1), .P2(P2), .P3(P3));


endmodule