module mv_multiplication_CN (
    input wire clk,
    input wire reset,
    input wire start,
    input wire index_ok,
    input wire cycle_ok,
    input wire row_ok,

    output reg b_en,
    output reg cycle_en,
    output reg index_en,
    output reg offset,
    output reg load_en,
    output reg shift_en,
    output reg row_en,
    output reg done,
    output reg i_is_valid,
    output reg write,
    output reg i_is_lsb,
    output reg reset_m

);
    localparam [2:0]
        Idle = 0,
        Load_B = 1,
        Load_A = 2,
        Calc = 3,
        Result = 4,
        Done = 5;
    reg [2:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= Idle;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            Idle: next_state = start ? Load_B : Idle;
            Load_B: next_state = index_ok ? Load_A : Load_B ;
            Load_A: next_state = index_ok ? Calc : Load_A;
            Calc: next_state = cycle_ok ? Result : Calc;
            Result: next_state = row_ok ? Done : Load_A;
            Done: next_state = Idle;
            default:  next_state = Idle;
        endcase
    end

    always @(*) begin
        {b_en, index_en, cycle_en, offset, load_en, shift_en, i_is_valid, write, i_is_lsb, done, reset_m, row_en} = {12{1'b0}};
        case (current_state)
            Load_B: {b_en, index_en} = {2{1'b1}} ;
            Load_A: {offset, load_en, index_en, reset_m} = {4{1'b1}} ;
            Calc: {cycle_en, shift_en, i_is_valid} = {3{1'b1}} ;
            Result: {row_en, write, i_is_lsb, i_is_valid} = {4{1'b1}} ;
            Done: {done} = 1'b1 ;
            default: {b_en, index_en, cycle_en, offset, load_en, shift_en, i_is_valid, write, i_is_lsb, done, reset_m, row_en} = {12{1'b0}};
        endcase
    end

endmodule