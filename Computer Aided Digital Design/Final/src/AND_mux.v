module AND_mux (
    input wire [1:0] in1, in2 ,
    input wire D0 ,
    input wire reg_val0 ,
    input wire X1 , X2, X3 ,
    input wire CM1 ,
    input wire [3:0] cycle_num ,


    output reg LUT_A_in1 ,
    output reg LUT_A_in2
);


    always @(*) begin
        case (cycle_num)
            4'd1: begin
                LUT_A_in1 = in1[0];
                LUT_A_in2 = in2[0];
            end
            4'd2: begin
                LUT_A_in1 = in1[0];
                LUT_A_in2 = in2[1];
            end
            4'd3: begin
                LUT_A_in1 = in1[1];
                LUT_A_in2 = in2[0];
            end
            4'd4: begin
                LUT_A_in1 = D0;
                LUT_A_in2 = reg_val0;
            end
            4'd5: begin
                LUT_A_in1 = X1;
                LUT_A_in2 = X2;
            end
            4'd6: begin
                LUT_A_in1 = in1[1];
                LUT_A_in2 = in2[1];
            end
            4'd7: begin
                LUT_A_in1 = X3;
                LUT_A_in2 = CM1;
            end
            default: begin
                LUT_A_in1 = 1'b0;
                LUT_A_in2 = 1'b0;
            end
        endcase
    end

endmodule