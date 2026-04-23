module random (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [5:0] in,
    
    output wire [1:0] out,
    output wire done
);
    wire rst_m, load_en, c_en, c_done ;

    random_dp datapath(.clk(clk), .rst(rst_m), .load_en(load_en), .en(c_en), .load(in), .out(out), .c_done(c_done));
    random_controller controller(.clk(clk), .rst(rst), .start(start), .c_done(c_done), .rst_m(rst_m), .load_en(load_en), .c_en(c_en), .done(done));
endmodule