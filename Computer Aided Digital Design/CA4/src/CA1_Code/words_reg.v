module words_reg #(
    parameter WORD_SIZE = 32,
    parameter WORD_COUNT = 4
)(
    input wire clk,
    input wire reset,
    input wire words_en,
    input wire [(WORD_COUNT*WORD_SIZE)-1:0] new_ins,

    output wire [WORD_SIZE-1:0] a,b,c,d
);
    
    wire [(WORD_COUNT*WORD_SIZE)-1:0] init_words ;	
    assign init_words = {8'h01, 8'h89, 8'hfe, 8'h76} ;
    
    reg [WORD_SIZE-1:0] words_reg_file [0:WORD_COUNT-1];
    genvar i;
    generate
        for (i = 0; i < WORD_COUNT; i = i + 1) begin : GEN_ASSIGN
            always @(posedge clk or posedge reset) begin
                if (reset)
                    words_reg_file[WORD_COUNT-1-i] <= init_words[(i+1)*WORD_SIZE-1 : i*WORD_SIZE] ;
                else if (words_en)
                    words_reg_file[WORD_COUNT-1-i] <= new_ins[(i+1)*WORD_SIZE-1 : i*WORD_SIZE];
            end
        end
    endgenerate

    assign a = words_reg_file[0];
    assign b = words_reg_file[1];
    assign c = words_reg_file[2];
    assign d = words_reg_file[3];

endmodule