module top_ex (input wire clk,rst,
    input wire [31:0] pc,val_rn,val_rm, input wire imm, 
    input wire [11:0] shift_operand, input wire [8:0] control_unit_out,
    input wire [23:0] signed_imm_24, input wire [3:0] dest,input wire status_reg_c,
    input wire [31:0] alu_res_mem, wb_value,
    input wire [1:0] sel_src1, sel_src2,

    output wire wb_en_out,mem_r_en_out,mem_w_en_out,
    output wire [31:0] alu_res_out,val_rm_out,branch_addr, output wire [3:0] dest_out,exe_dest,
    output wire carry_out, branch_tacken, exe_wb_en, output wire [3:0] zcvn_out
);

    assign val_rm_out = (sel_src2 == 2'b00) ? val_rm:
                        (sel_src2 == 2'b01) ? alu_res_mem:
                        (sel_src2 == 2'b10) ? wb_value:
                        32'b0;

    wire [31:0] val2;
    Val2Generator v2g (.val_Rm(val_rm_out),.I(imm),
    .Mem_in(control_unit_out[2] | control_unit_out[1]),
    .shift_operand(shift_operand),.result(val2));

    wire [3:0] zcvn;

    wire [31:0] alu_inp_1;

    assign alu_inp_1 = (sel_src1 == 2'b00) ? val_rn:
                       (sel_src1 == 2'b01) ? alu_res_mem:
                       (sel_src1 == 2'b10) ? wb_value:
                       32'b0;

    ALU alu(.command(control_unit_out[6:3]),.in1(alu_inp_1),.in2(val2),.C(status_reg_c),.result(alu_res_out),.zcvn(zcvn));
 
    status_register str(.clk(clk),.rst(rst),.S(control_unit_out[8]),.zcvn(zcvn),
    .zcvn_out(zcvn_out),.c_out(carry_out));

    assign branch_addr = {{8{signed_imm_24[23]}}, signed_imm_24} + pc;

    assign wb_en_out = control_unit_out[0];
    assign mem_r_en_out = control_unit_out[1];
    assign mem_w_en_out = control_unit_out[2];
    assign branch_tacken = control_unit_out[7];

    assign exe_dest = dest;
    assign exe_wb_en = control_unit_out[0];

    assign dest_out = dest;


endmodule