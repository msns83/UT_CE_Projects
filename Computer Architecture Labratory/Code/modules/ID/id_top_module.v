module id_top_module(input wire clk, rst, 
                    input wire [31:0] instr, 
                    input wire [3:0] zcvn,
                    input wire hazard, w_en,
                    input wire [3:0] w_dest,
                    input wire [31:0] w_val,
                    output wire [31:0] val_rn, val_rm,
                    output wire [3:0] addr_rm , addr_rn,
                    output reg two_src,
                    output reg imm,
                    output reg [11:0] shift_operand,
                    output reg [8:0] cuoo,
                    output reg [23:0] signed_imm_24,
                    output reg [3:0] dest,
                    output wire [31:0] r0,r1,r2,r3,r4,r5,r6
                    );
    //PC AZ OONJA VASL SHAVAD
    wire cco;
    wire [8:0] cuo;
    wire [3:0] rm_adr;
    
    wire z, c, n, v ;
    assign z = zcvn[3] ;
    assign c = zcvn[2] ;
    assign n = zcvn[0] ;
    assign v = zcvn[1] ;
    
    condition_check cc(instr[31:28], z, c, n, v, cco);
    
    control_unit cu(instr[24:21], instr[27:26], instr[20], cuo);
    
    register_file_id rf(clk, rst, w_en, w_dest, w_val, instr[19:16], rm_adr, val_rn, val_rm, r0,r1,r2,r3,r4,r5,r6);
    
    assign rm_adr = cuo[2]? instr[15:12] : instr[3:0];
    always@(*)
    begin
        cuoo = (hazard || cco)? 9'd0 : cuo;
        two_src = ~instr[25] || cuo[2];
        imm = instr[25];
        shift_operand = instr[11:0];
        signed_imm_24 = instr[23:0];
        dest = instr[15:12];
    end
    
    assign addr_rm = rm_adr ;
    assign addr_rn = instr[19:16] ;
        
endmodule 