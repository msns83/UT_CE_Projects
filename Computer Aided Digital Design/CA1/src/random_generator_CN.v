module random_generator_CN (
    input wire clk,
    input wire reset,
    input wire start_rnd,
    input wire counter_done,

    output reg control_reset,
    output reg load_en,
    output reg counter_en,
    output reg done_rnd
);

    localparam [1:0]
        S0 = 0,
        S1 = 1,
        S2 = 2,
        S3 = 3;
    
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            S0: next_state = start_rnd ? S1 : S0;
            S1: next_state = start_rnd ? S1 : S2 ;
            S2: next_state = counter_done ? S3 : S2 ;
            S3: next_state = S0;
            default:  next_state = S0;
        endcase
    end

    always @(*) begin
        {control_reset, load_en, counter_en, done_rnd} = {4{1'b0}};
        case (current_state)
            S0: control_reset = 1'b1 ;  
            S1: load_en = 1'b1 ;  
            S2: counter_en = 1'b1 ;  
            S3: done_rnd = 1'b1 ;
            default: {control_reset, load_en, counter_en, done_rnd} = {4{1'b0}} ;
        endcase
    end

endmodule