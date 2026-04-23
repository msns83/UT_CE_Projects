module message_reg #(
    parameter WORD_SIZE = 32,
    parameter WORD_COUNT = 4,
    parameter SELECTION_WIDTH = 2
)(
    input wire clk,
    input wire reset,
    input wire [WORD_COUNT*WORD_SIZE-1:0] number,
    input wire [SELECTION_WIDTH-1:0] rnd ,
    input wire message_en,

    output wire [WORD_SIZE-1:0] message_part
);

    reg [WORD_SIZE-1:0] message_reg_file [0:WORD_COUNT-1];

    genvar i;
    generate
        for (i = 0; i < WORD_COUNT; i = i + 1) begin : GEN_ASSIGN2
            always @(posedge clk or posedge reset) begin
                if (reset)
                    message_reg_file[WORD_COUNT-1-i] <= {WORD_SIZE{1'b0}};
                else if (message_en)
                    message_reg_file[WORD_COUNT-1-i] <= number[(i+1)*WORD_SIZE-1 : i*WORD_SIZE];
            end
        end
    endgenerate

    assign message_part = message_reg_file[rnd];

endmodule