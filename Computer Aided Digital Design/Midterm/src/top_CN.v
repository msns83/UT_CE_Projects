module top_CN (
    input wire clk,
    input wire rst,
    input wire start,
    input wire finish,

    output reg A0_en, A1_en,
    output reg AaU_en,
    output reg ready,
    output reg m_Reset
);
    localparam [1:0]
        Idle = 0,
        Calculate = 1,
        Done = 2 ;

    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= Idle;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            Idle: next_state = start ? Calculate : Idle;
            Calculate: next_state = finish ? Done : Calculate ;
            Done: next_state = start ? Calculate : Done;
            default:  next_state = Idle;
        endcase
    end

    always @(*) begin
        {A0_en, A1_en, AaU_en, ready, m_Reset} = {5{1'b0}};
        case (current_state)
            Idle: {A0_en, A1_en} = {2{1'b1}} ;
            Calculate: {AaU_en} = {1{1'b1}} ;
            Done: begin
                {ready, A0_en, A1_en} = {3{1'b1}} ;
                m_Reset = start ? 1'b1 : 1'b0 ;
            end
            default: {A0_en, A1_en, AaU_en, ready, m_Reset} = {5{1'b0}};
        endcase
    end

endmodule