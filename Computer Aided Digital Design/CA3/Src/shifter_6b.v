module shifter_6b (
    input wire clk,
    input wire rst,
    input wire in,
    input wire sh_en,
    input wire load_en,
    input wire [5:0] load,
    
    output wire [5:0] out
);

    register_1b regis0(.clk(clk), .rst(rst), .en(sh_en), .in(in), .init_en(load_en), .init(load[0]), .out(out[0]));

    genvar i;
    generate
        for (i = 1; i < 6; i = i + 1) begin : gen_regis
            register_1b regisi(.clk(clk), .rst(rst), .en(sh_en), .in(out[i-1]), .init_en(load_en), .init(load[i]), .out(out[i]));
        end
    endgenerate

endmodule