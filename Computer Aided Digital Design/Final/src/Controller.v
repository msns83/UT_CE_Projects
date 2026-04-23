module Controller (
    input wire clk,
    input wire rst,

    output reg [3:0] D_en,
    output reg [3:0] X_en,
    output reg [3:0] C_en,
    output reg [3:0] reg_en,
    output reg CM_en ,
    output reg [3:0] cycle_num,
    output reg done
);
    reg [3:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= 4'd0;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            4'd0: next_state = 4'd1 ;
            4'd1: next_state = 4'd2 ;
            4'd2: next_state = 4'd3 ;
            4'd3: next_state = 4'd4 ;
            4'd4: next_state = 4'd5 ;
            4'd5: next_state = 4'd6 ;
            4'd6: next_state = 4'd7 ;
            4'd7: next_state = 4'd8 ;
            4'd8: next_state = 4'd9 ;
            4'd9: next_state = 4'd10 ;
	    4'd10: next_state = 4'd1 ;
            default:  next_state = 4'd0;
        endcase
    end

    always @(*) begin
        D_en = 4'b0000; X_en = 4'b0000 ; reg_en = 4'b0000; C_en = 4'b0000 ; CM_en = 1'b0 ; done = 1'b0 ;
        case (current_state)
            4'd0: cycle_num = 4'd0  ;
            4'd1: begin
                D_en[0] = 1 ;
                cycle_num = 4'd1 ;
            end
            4'd2: begin
                X_en[1] = 1;
                cycle_num = 4'd2 ;
            end
            4'd3: begin
                X_en[2] = 1 ;
                cycle_num = 4'd3 ;
            end
            4'd4: begin
                C_en[1] = 1 ;
                D_en[1] = 1 ;
                cycle_num = 4'd4 ;
            end
            4'd5: begin
                CM_en = 1 ;
                reg_en[1] = 1 ;
                C_en[2] = 1 ;
                cycle_num = 4'd5 ;
            end
            4'd6: begin
                X_en[3] = 1 ;
                reg_en[0] = 1;
                cycle_num = 4'd6 ;
            end
            4'd7: begin
                D_en[3] = 1 ;
                D_en[2] = 1 ;
                cycle_num = 4'd7 ;
            end
            4'd8: begin
                reg_en[2] = 1 ;
                C_en[3] = 1 ;
                cycle_num = 4'd8 ;
            end
            4'd9: begin
                reg_en[3] = 1 ;
                cycle_num = 4'd9 ;
            end
	    4'd10: begin
		done = 1 ;
		cycle_num = 4'd10 ;
	    end
            default: cycle_num = 4'd0 ;
        endcase
    end

endmodule