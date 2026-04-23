module import_rom #(
    parameter DATA_WIDTH = 32,      
    parameter ADDR_WIDTH = 8,       
    parameter MEM_FILE   = "constant.mem"
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    initial begin
        $readmemh(MEM_FILE, mem);
    end

    always @(*) begin
        data = mem[addr];
    end

endmodule
