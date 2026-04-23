module status_register (
    input wire clk,rst,
    input wire S, input wire [3:0] zcvn,
    output reg [3:0] zcvn_out, output reg c_out
    );
    always @(negedge clk, posedge rst) begin
        if (rst) begin
            zcvn_out <= 0;
            c_out <= 0;
        end
        else if (S) begin
            zcvn_out <= zcvn;
            c_out <= zcvn[2];
        end
    end
endmodule