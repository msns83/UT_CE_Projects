module F_mux (
    input wire D1, D2,
    input wire reg_val1, reg_val2,
    input wire C1 , C2,
    input wire [3:0] cycle_num ,

    output reg LUT_F_in1 ,
    output reg LUT_F_in2 ,
    output reg LUT_F_in3
);


    always @(*) begin
        case (cycle_num)
            4'd5: begin
                LUT_F_in1 = reg_val1;
                LUT_F_in2 = D1;
                LUT_F_in3 = C1 ;
            end
            4'd8: begin
                LUT_F_in1 = reg_val2;
                LUT_F_in2 = D2;
                LUT_F_in3 = C2;
            end
            default: begin
                LUT_F_in1 = 1'b0;
                LUT_F_in2 = 1'b0;
                LUT_F_in3 = 1'b0;
            end
        endcase
    end

endmodule