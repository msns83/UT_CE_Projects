module four_mux_8b (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [7:0] c,
    input wire [7:0] d,
    input wire [1:0] sel,
    
    output wire [7:0] out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_regs
            c1 mux(.A0(a[i]) , .A1(b[i]) , .SA(sel[0]) , .B0(c[i]) , .B1(d[i]), .SB(sel[0]), .S0(sel[1]), .S1(sel[1]), .f(out[i]));
        end
    endgenerate
endmodule