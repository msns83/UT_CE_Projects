module hash_dp (
    input wire clk,
    input wire rst,
    input wire c_en,
    input wire rnd_start,
    input wire msg_en,
    input wire [31:0] msg,
    input wire words_en,
    input wire words_init,
    
    output wire ok,
    output wire rnd_done,
    output wire [31:0] out
);
    wire [5:0] i ;
    wire [1:0] rnd;
    wire [7:0] A, B, C, D ;
    wire [7:0] selected_msg, comb_out, const, summed ;
    wire [7:0] multiplied ;
    wire [7:0] final ;

    assign out = {A,B,C,D} ;

    counter_6b counter(
    .clk(clk),
    .rst(rst),
    .en(c_en),
    .out(i),
    .ok(ok)
    );

    random random_generator(
    .clk(clk),
    .rst(rst),
    .start(rnd_start),
    .in(i),
    .out(rnd),
    .done(rnd_done)
    );

    message_reg message(
    .clk(clk),
    .rst(rst),
    .en(msg_en),
    .in(msg),
    .sel(rnd),
    .out(selected_msg)
    );

    words_reg reg_file(
    .clk(clk),
    .rst(rst),
    .en(words_en),
    .in({D, final, B, C}),
    .init_en(words_init),
    .out({A, B, C, D})
    );

    hash_comb_8b combinational(
    .b(B),
    .c(C),
    .d(D),
    .r(i[5:4]),
    .o(comb_out)
    );

    constant_rom constant_ROM(
    .addr(i),
    .data(const)
    );

    four_num_adder four_num_adder(
    .a(A),
    .b(comb_out),
    .c(const),
    .d(selected_msg),
    .s(summed)
    );

    multiplier_4b multiplier(
    .a(summed[3:0]),
    .b(summed[7:4]),
    .p(multiplied)
    );

    adder_8b two_num_adder(
    .a(multiplied),
    .b(B),
    .s(final)
    );

endmodule