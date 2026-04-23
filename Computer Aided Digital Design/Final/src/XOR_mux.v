module XOR_mux (
    input wire D0, D1, D2, D3,
    input wire reg_val0, reg_val1, reg_val2, reg_val3,
    input wire X1, X2, X3 ,
    input wire C1, C2, C3 ,
    input wire CM1 ,
    input wire [3:0] cycle_num ,

    output reg LUT_X_in1 ,
    output reg LUT_X_in2 ,
    output reg LUT_X_in3
);


    always @(*) begin
        case (cycle_num)
            4'd4: begin
                LUT_X_in1 = X1;
                LUT_X_in2 = X2;
                LUT_X_in3 = 1'b0 ;
            end
            4'd5: begin
                LUT_X_in1 = reg_val1 ;
                LUT_X_in2 = D1  ;
                LUT_X_in3 = C1 ;
            end
            4'd6: begin
                LUT_X_in1 = reg_val0;
                LUT_X_in2 = D0;
                LUT_X_in3 = 1'b0 ;
            end
            4'd7: begin
                LUT_X_in1 = X3;
                LUT_X_in2 = CM1;
                LUT_X_in3 = 1'b0 ;
            end
            4'd8: begin
                LUT_X_in1 = reg_val2;
                LUT_X_in2 = D2 ;
                LUT_X_in3 = C2 ;
            end
            4'd9: begin
                LUT_X_in1 = reg_val3;
                LUT_X_in2 = D3;
                LUT_X_in3 = C3 ;
            end
            default: begin
                LUT_X_in1 = 1'b0;
                LUT_X_in2 = 1'b0;
                LUT_X_in3 = 1'b0;
            end
        endcase
    end

endmodule