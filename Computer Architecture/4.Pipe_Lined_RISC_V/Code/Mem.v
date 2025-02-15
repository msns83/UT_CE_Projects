module memory_inst(
    input [31:0] A,
    input [31:0]WD,
    input clk, rst, We,
    output reg [31:0] RD
);
    reg [31:0] mem [0:30];
    initial begin
        $readmemb("instruction.mem", mem);
    end

    always @(posedge clk) begin
        if (We) begin
            mem[A] <= WD;
        end
    end

    wire [31:0] addr;
    assign addr = A[31:2];

    always @(*) begin
        RD = mem[A[31:2]];
    end

endmodule

module memory_data(
    input [31:0] A,
    input [31:0]WD,
    input clk, rst, We,
    output reg [31:0] RD
);
    reg [31:0] mem [0:30];
    initial begin
        $readmemb("data.mem", mem);
    end

    always @(posedge clk) begin
        if (We) begin
            mem[A] <= WD;
        end
    end
    
    wire [31:0] addr;
    assign addr = A[31:2];

    always @(*) begin
        RD = mem[A[31:2]];
    end
endmodule
