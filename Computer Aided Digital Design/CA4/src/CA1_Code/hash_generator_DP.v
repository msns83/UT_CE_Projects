module hase_generator_DP #(
    parameter REPEAT_WIDTH = 6,
    parameter WORD_SIZE = 8,
    parameter WORD_COUNT = 4,
    parameter SELECTION_WIDTH = 2
)(
    input wire clk,
    input wire reset,
    input wire [WORD_COUNT*WORD_SIZE-1:0] number,
    input wire counter_en,
    input wire i_en,
    input wire message_en,
    input wire words_en,
    input wire [SELECTION_WIDTH-1:0] random,

    output wire ok,
    output wire [WORD_COUNT*WORD_SIZE-1:0] hash,
    output wire [REPEAT_WIDTH-1:0] cur_i
);
    
    wire [REPEAT_WIDTH-1:0] counter_num;
    wire [WORD_SIZE-1:0] comb_output;
    wire [WORD_SIZE-1:0] rotate_input;
    wire [WORD_SIZE-1:0] rotate_output;
    wire [WORD_SIZE-1:0] constant_val;
    wire [SELECTION_WIDTH-1:0] range_idx ;
    wire [WORD_SIZE-1:0] message_part;
    wire [(WORD_COUNT*WORD_SIZE)-1:0] new_ins;
    wire [WORD_SIZE-1:0] a,b,c,d;
    wire [REPEAT_WIDTH-1:0] i_val ;
    wire [SELECTION_WIDTH-1:0] rnd ;

    
    message_reg #(WORD_SIZE, WORD_COUNT, SELECTION_WIDTH) m_reg(.clk(clk), .reset(reset), .number(number), .rnd(rnd), .message_en(message_en), .message_part(message_part));
    words_reg #(WORD_SIZE, WORD_COUNT) w_reg(.clk(clk), .reset(reset), .words_en(words_en), .new_ins(new_ins), .a(a), .b(b), .c(c), .d(d));
    up_counter #(REPEAT_WIDTH) counter(.clk(clk), .reset(reset), .enable(counter_en), .count(counter_num));
    rangeSpecifier #(REPEAT_WIDTH) range_specifier(.in(i_val),.out(range_idx));

    import_rom #(.DATA_WIDTH(WORD_SIZE), .ADDR_WIDTH(REPEAT_WIDTH)) constant_rom (.addr(i_val), .data(constant_val));

    combinational_circuit #(WORD_SIZE, SELECTION_WIDTH) value_calc (.B(b), .C(c), .D(d), .range_sel(range_idx), .out(comb_output));

    assign rotate_output = rotate_input[3:0] * rotate_input[7:4] ;

    single_reg #(SELECTION_WIDTH) rnd_reg (.clk(clk), .reset(reset), .en(1'b1), .value(random), .vari(rnd));
    single_reg #(REPEAT_WIDTH) i_reg (.clk(clk), .reset(reset), .en(i_en), .value(counter_num), .vari(i_val));

    assign ok = &i_val ;
    assign cur_i = i_val ;
    assign new_ins = {d, b+rotate_output  , b, c} ;
    assign rotate_input = comb_output + a + constant_val + message_part ;
    assign hash = {a, b, c, d};

endmodule