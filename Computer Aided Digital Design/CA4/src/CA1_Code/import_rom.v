module import_rom #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6
)(
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [DATA_WIDTH-1:0] data
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    initial begin
        mem[0]  = 'h78;
        mem[1]  = 'h56;
        mem[2]  = 'hdb;
        mem[3]  = 'hee;
        mem[4]  = 'haf;
        mem[5]  = 'h2a;
        mem[6]  = 'h13;
        mem[7]  = 'h01;
        mem[8]  = 'hd8;
        mem[9]  = 'haf;
        mem[10] = 'hb1;
        mem[11] = 'hbe;
        mem[12] = 'h22;
        mem[13] = 'h93;
        mem[14] = 'h8e;
        mem[15] = 'h21;
        mem[16] = 'h62;
        mem[17] = 'h40;
        mem[18] = 'h51;
        mem[19] = 'haa;
        mem[20] = 'h5d;
        mem[21] = 'h53;
        mem[22] = 'h81;
        mem[23] = 'hc8;
        mem[24] = 'he6;
        mem[25] = 'hd6;
        mem[26] = 'h87;
        mem[27] = 'hed;
        mem[28] = 'h05;
        mem[29] = 'hf8;
        mem[30] = 'hd9;
        mem[31] = 'h8a;
        mem[32] = 'h42;
        mem[33] = 'h81;
        mem[34] = 'h22;
        mem[35] = 'h0c;
        mem[36] = 'h44;
        mem[37] = 'ha9;
        mem[38] = 'h60;
        mem[39] = 'h70;
        mem[40] = 'hc6;
        mem[41] = 'hfa;
        mem[42] = 'h85;
        mem[43] = 'h05;
        mem[44] = 'h39;
        mem[45] = 'he5;
        mem[46] = 'hf8;
        mem[47] = 'h65;
        mem[48] = 'h44;
        mem[49] = 'h97;
        mem[50] = 'ha7;
        mem[51] = 'h39;
        mem[52] = 'hc3;
        mem[53] = 'h92;
        mem[54] = 'h7d;
        mem[55] = 'hd1;
        mem[56] = 'h4f;
        mem[57] = 'he0;
        mem[58] = 'h14;
        mem[59] = 'ha1;
        mem[60] = 'h82;
        mem[61] = 'h35;
        mem[62] = 'hbb;
        mem[63] = 'h91;
    end

    always @(*) begin
        data = mem[addr];
    end

endmodule