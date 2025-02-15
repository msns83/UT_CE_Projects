module FrequencyDivider (init, H_L, SW, clk,rst, co);
    input init;
    input H_L;
    input [2:0] SW;
    input clk,rst;
    output co;

    reg [8:0] cnt;

    wire [8:0] ld_val;
    //assign ld_val[8] = H_L;
    //assign ld_val[7:5] = SW;
    //assign ld_val[4:0] = 5'b00000;


    always @(posedge clk, posedge rst) begin
        if(rst) cnt <= 9'b000000000;
        else begin
            if(init || co) cnt <= {H_L, SW, 5'b00000 };
            else cnt <= cnt + 1;
        end
    end

    assign co = &{cnt};
endmodule