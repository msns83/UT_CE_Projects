module register_file_id (
    input wire clk, rst,                  
    input wire we,                      
    input wire [3:0] wDest,        
    input wire [31:0] wValu,       
    input wire [3:0] Rn,         
    input wire [3:0] Rm,         
    output wire [31:0] valRn,      
    output wire [31:0] valRm,
    output wire [31:0] r0,r1,r2,r3,r4,r5,r6
);
    reg [31:0] registers [15:0];

    assign valRn = registers[Rn];
    assign valRm = registers[Rm];
    assign r0 = registers[0];
    assign r1 = registers[1];
    assign r2 = registers[2];
    assign r3 = registers[3];
    assign r4 = registers[4];
    assign r5 = registers[5];
    assign r6 = registers[6];

    integer i;

    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= i;
            end
        end
        else if (we) begin
            registers[wDest] <= wValu;
        end
    end

endmodule