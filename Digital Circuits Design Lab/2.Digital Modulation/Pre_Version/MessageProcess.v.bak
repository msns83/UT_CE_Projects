module MessageProcess (send, Msg, clk, rst, msg_bit);

    input send;
    input [4:0] Msg;
    input clk,rst;
    output msg_bit;

    wire [8:0] shr_out;
    reg ldEN, shEN;

    ShiftRegister MSG_REG ({{4'b0101},Msg}, shEN, ldEN, clk,rst, shr_out);
    assign msg_bit = shr_out[8];

    reg cnt_cen;
    reg cnt_init0;
    wire [9:0] sine_maker_cntout;
    wire sine_maker_co;
    UpCounter #(1024) SineMaker (cnt_cen, cnt_init0, clk,rst, sine_maker_cntout, sine_maker_co);
    wire [3:0] sine_counter_cntout;
    wire sine_counter_co;
    UpCounter #(10) SineCounter (sine_maker_co, cnt_init0, clk,rst, sine_counter_cntout, sine_counter_co);


    reg ps, ns;
    parameter IDLE = 0, SEND_MSG=1;
    always @(posedge clk, posedge rst) begin
        if(rst) ps <= IDLE;
        else ps <= ns;
    end

    always @(ps, send, sine_maker_co, sine_counter_co) begin
        ns = IDLE;
        case(ps)
            IDLE: ns = send ? SEND_MSG : IDLE;
            SEND_MSG: ns = sine_counter_co ? IDLE : SEND_MSG;
        endcase
    end

    always @(ps, send, sine_maker_co, sine_counter_co) begin
        cnt_cen = 1'b0;
        cnt_init0 = 1'b0;
        ldEN = 1'b0;
        shEN = 1'b0;
        case(ps)
            IDLE: begin
                cnt_init0 = 1'b1;
                ldEN = 1'b1;
            end
            SEND_MSG: begin
                cnt_cen = 1'b1;
                shEN = sine_maker_co;
            end
        endcase
    end

endmodule