module message_reg (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] in,
    input wire [1:0] sel,
    
    output wire [7:0] out
);

    wire [31:0] vals;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_regs
            register_word_8b wi(.clk(clk), .rst(rst), .en(en), .in(in[(i*8)+7:i*8]), .init_en(1'b0), .init(8'd0), .out(vals[(i*8)+7:i*8]));
        end
    endgenerate

    four_mux_8b four_mux(.a(vals[31:24]), .b(vals[23:16]), .c(vals[15:8]), .d(vals[7:0]), .sel(sel), .out(out));

endmodule