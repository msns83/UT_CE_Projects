module ROM #(parameter MAG_WIDTH)(rom_addr, rom_out);
input [5:0] rom_addr;
output [7:0] rom_out;
(* romstyle = "M9K" *)(* ram_init_file = "sine.mif" *) reg[MAG_WIDTH-1:0] LUT[0:63];
//reg[MAG_WIDTH-1:0] LUT[0:63];
//initial begin
//    $readmemb("sine.mem", LUT);
//end
assign rom_out = LUT[rom_addr];
endmodule