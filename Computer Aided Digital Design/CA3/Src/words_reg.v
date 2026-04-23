module words_reg (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] in,
    input wire init_en,
    
    output wire [31:0] out
);
    wire [31:0] inits ;
    assign inits[7:0]   = 8'b01110110 ;
    assign inits[15:8]  = 8'b11111110 ;
    assign inits[23:16] = 8'b10001001 ;
    assign inits[31:24] = 8'b00000001 ;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_regs
            register_word_8b wi(.clk(clk), .rst(rst), .en(en), .in(in[(i*8)+7:i*8]), .init_en(init_en), .init(inits[(i*8)+7:i*8]), .out(out[(i*8)+7:i*8]));
        end
    endgenerate

endmodule