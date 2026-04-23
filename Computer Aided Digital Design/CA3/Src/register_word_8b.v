module register_word_8b (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] in,
    input wire init_en,
    input wire [7:0] init,
    
    output wire [7:0] out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_regs
            register_1b ri(.clk(clk), .rst(rst), .en(en), .in(in[i]), .init_en(init_en), .init(init[i]), .out(out[i]));
        end
    endgenerate
endmodule