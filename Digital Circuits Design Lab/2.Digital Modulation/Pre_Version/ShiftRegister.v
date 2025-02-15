module ShiftRegister (parallelIN, shEN, ldEN, clk,rst, parallelOUT);
    input [8:0] parallelIN;
    input shEN, ldEN;
    input clk,rst;
    output [8:0] parallelOUT;

    reg [8:0] register;

    always @(posedge clk or posedge rst) begin
        if(rst) register <= 8'b00000000;
        else begin
            if(ldEN) register <= parallelIN;
            else if(shEN) register = register << 1;
        end
    end

    assign parallelOUT = register;

endmodule