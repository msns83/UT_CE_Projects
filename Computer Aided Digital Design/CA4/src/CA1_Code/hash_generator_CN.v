module hase_generator_CN (
    input wire clk,
    input wire reset,
    input wire start,
    input wire ok,
    input wire rnd_done,

    output reg control_reset,
    output reg words_en,
    output reg counter_en,
    output reg rnd_start,
    output reg i_en,
    output reg message_en,
    output reg done
);
    localparam [2:0]
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3,
        S4 = 4;
    
    reg [2:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            S0: next_state = start ? S1 : S0;
            S1: next_state = start ? S1 : S2 ;
            S2: next_state = ok ? S0 : S3 ;
            S3: next_state = rnd_done ? S4 : S3;
            S4: next_state = S2;
            default:  next_state = S0;
        endcase
    end

    always @(*) begin
        {control_reset, message_en, counter_en, rnd_start, i_en, words_en, done} = {7{1'b0}};
        case (current_state)
            S0: control_reset = start ;  
            S1: message_en = 1'b1 ;  
            S2: begin
		{counter_en, rnd_start, i_en} = {3{1'b1}} ; 
		done = ok ;
		end 
            S4: words_en = 1'b1 ;  
            default: {control_reset, message_en, counter_en, rnd_start, i_en, words_en, done} = {7{1'b0}};
        endcase
    end

endmodule