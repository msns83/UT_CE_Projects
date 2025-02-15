module file_reg(
    input clk,
    input rst,
    input [4:0] A1, A2, A3,
    input [31:0] WD,
    input We,
    output [31:0] RD1, RD2
);

    reg [31:0] Reg_file [31:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Reg_file[i] <= 32'b0;
            end
        end else if (We) begin
            if (A3 != 5'b00000) begin
                Reg_file[A3] <= WD;
            end
        end
    end

    assign RD1 = Reg_file[A1];
    assign RD2 = Reg_file[A2];
endmodule

module register (
    input clk,
    input rst,
    input [31:0] data_in,
    input enable,
    output reg [31:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 32'b0;
        else if(enable)
            data_out <= data_in;
    end

endmodule

module PC (
    input clk,
    input rst,
    input [31:0] data_in,
    input enable,
    output reg [31:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 32'b0;
        else if(enable)
            data_out <= data_in;
    end

endmodule