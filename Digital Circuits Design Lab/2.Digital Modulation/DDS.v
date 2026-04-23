module DDS (clk, rst, magnitude);
parameter ADDR_WIDTH = 6;
parameter MAG_WIDTH = 8;

input clk, rst;
output [MAG_WIDTH-1:0] magnitude;
wire [MAG_WIDTH-1:0] magnitude_in;

wire Sign_bit, Phase_pos;
wire [ADDR_WIDTH-1:0] addr;
wire [ADDR_WIDTH-1:0] addr_comp;
phase_accumulator PA(.clk(clk), .rst(rst), .sign(Sign_bit), .phase(Phase_pos), .addr(addr));
two_s_complement #(ADDR_WIDTH) compl1(.a(addr), .b(addr_comp));

wire [ADDR_WIDTH-1:0] rom_addr;
two_one_mux #(ADDR_WIDTH) mux1(.a(addr), .b(addr_comp), .s(Phase_pos), .c(rom_addr));

wire mux2_sel;
assign mux2_sel = (~|{addr}) & Phase_pos;

wire [MAG_WIDTH-1:0] rom_out;
ROM #(MAG_WIDTH) sine_ROM (.rom_addr(rom_addr), .rom_out(rom_out));
two_one_mux #(MAG_WIDTH) mux2(.a(rom_out), .b(8'b11111111), .s(mux2_sel), .c(magnitude_in));
sign_to_two_s_comp compl2 (.Sign_bit(Sign_bit), .magnitude_in(magnitude_in), .magnitude_out(magnitude));

endmodule