//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Tue Jul 22 14:14:07 2025
//Host        : Ali_Laptop running 64-bit major release  (build 9200)
//Command     : generate_target CA_LAB1.bd
//Design      : CA_LAB1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "CA_LAB1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CA_LAB1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=16,numReposBlks=14,numNonXlnxBlks=0,numHierBlks=2,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=10,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "CA_LAB1.hwdef" *) 
module CA_LAB1
   (clk,
    fwd_en_0,
    r0_0,
    r1_0,
    r2_0,
    r3_0,
    r4_0,
    r5_0,
    r6_0,
    rst);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET rst, CLK_DOMAIN CA_LAB1_clk, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk;
  input fwd_en_0;
  output [31:0]r0_0;
  output [31:0]r1_0;
  output [31:0]r2_0;
  output [31:0]r3_0;
  output [31:0]r4_0;
  output [31:0]r5_0;
  output [31:0]r6_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input rst;

  wire [31:0]blk_mem_gen_0_douta;
  wire clk_0_1;
  wire data_hazard_unit_0_hazard;
  wire debouncer_0_SIGNAL_O;
  wire [31:0]dist_mem_gen_0_spo;
  wire [31:0]ex_register_file_0_alu_res_out;
  wire [3:0]ex_register_file_0_dest_out;
  wire ex_register_file_0_mem_r_en_out;
  wire ex_register_file_0_mem_w_en_out;
  wire [31:0]ex_register_file_0_val_rm_out;
  wire ex_register_file_0_wb_en_out;
  wire [31:0]fetch_instruction_0_updated_pc;
  wire [31:0]fetch_register_file_0_instruction_reg;
  wire [31:0]fetch_register_file_0_updated_pc_reg;
  wire [1:0]forward_0_sel_src1;
  wire [1:0]forward_0_sel_src2;
  wire fwd_en_0_1;
  wire [3:0]id_register_file_0_addr_rm_out;
  wire [3:0]id_register_file_0_addr_rn_out;
  wire [8:0]id_register_file_0_control_unit_out_out;
  wire [3:0]id_register_file_0_dest_out;
  wire id_register_file_0_imm_out;
  wire [31:0]id_register_file_0_pc_out;
  wire [11:0]id_register_file_0_shift_operand_out;
  wire [23:0]id_register_file_0_signed_imm_24_out;
  wire id_register_file_0_status_reg_out;
  wire [31:0]id_register_file_0_val_rm_out;
  wire [31:0]id_register_file_0_val_rn_out;
  wire [3:0]id_top_module_0_addr_rm;
  wire [3:0]id_top_module_0_addr_rn;
  wire [8:0]id_top_module_0_cuoo;
  wire [3:0]id_top_module_0_dest;
  wire id_top_module_0_imm;
  wire [31:0]id_top_module_0_r0;
  wire [31:0]id_top_module_0_r1;
  wire [31:0]id_top_module_0_r2;
  wire [31:0]id_top_module_0_r3;
  wire [31:0]id_top_module_0_r4;
  wire [31:0]id_top_module_0_r5;
  wire [31:0]id_top_module_0_r6;
  wire [11:0]id_top_module_0_shift_operand;
  wire [23:0]id_top_module_0_signed_imm_24;
  wire id_top_module_0_two_src;
  wire [31:0]id_top_module_0_val_rm;
  wire [31:0]id_top_module_0_val_rn;
  wire [31:0]mem_register_file_0_alu_res_out;
  wire [3:0]mem_register_file_0_dest_out;
  wire [31:0]mem_register_file_0_mem_out_out;
  wire mem_register_file_0_mem_r_en_out;
  wire mem_register_file_0_wb_en_out;
  wire [31:0]mux2to1_32bit_0_WB_Value;
  wire [31:0]top_ex_0_alu_res_out;
  wire [31:0]top_ex_0_branch_addr;
  wire top_ex_0_branch_tacken;
  wire top_ex_0_carry_out;
  wire [3:0]top_ex_0_dest_out;
  wire [3:0]top_ex_0_exe_dest;
  wire top_ex_0_exe_wb_en;
  wire top_ex_0_mem_r_en_out;
  wire top_ex_0_mem_w_en_out;
  wire [31:0]top_ex_0_val_rm_out;
  wire top_ex_0_wb_en_out;
  wire [3:0]top_ex_0_zcvn_out;

  assign clk_0_1 = clk;
  assign debouncer_0_SIGNAL_O = rst;
  assign fwd_en_0_1 = fwd_en_0;
  assign r0_0[31:0] = id_top_module_0_r0;
  assign r1_0[31:0] = id_top_module_0_r1;
  assign r2_0[31:0] = id_top_module_0_r2;
  assign r3_0[31:0] = id_top_module_0_r3;
  assign r4_0[31:0] = id_top_module_0_r4;
  assign r5_0[31:0] = id_top_module_0_r5;
  assign r6_0[31:0] = id_top_module_0_r6;
  IF_Stage_imp_1YGY16Y IF_Stage
       (.branch_tacken_1(top_ex_0_branch_tacken),
        .clk(clk_0_1),
        .douta(blk_mem_gen_0_douta),
        .freeze(data_hazard_unit_0_hazard),
        .mux_inp_BA(top_ex_0_branch_addr),
        .rst(debouncer_0_SIGNAL_O),
        .updated_pc(fetch_instruction_0_updated_pc));
  Mem_Stage_imp_1HJZ3ZA Mem_Stage
       (.Din(ex_register_file_0_alu_res_out),
        .clk(clk_0_1),
        .d(ex_register_file_0_val_rm_out),
        .spo(dist_mem_gen_0_spo),
        .we(ex_register_file_0_mem_w_en_out));
  CA_LAB1_data_hazard_unit_0_0 data_hazard_unit_0
       (.exe_dest(top_ex_0_exe_dest),
        .exe_mem_r_en(top_ex_0_mem_r_en_out),
        .exe_wb_en(top_ex_0_exe_wb_en),
        .fwd_en(fwd_en_0_1),
        .hazard(data_hazard_unit_0_hazard),
        .mem_dest(ex_register_file_0_dest_out),
        .mem_wb_en(ex_register_file_0_wb_en_out),
        .rm(id_top_module_0_addr_rm),
        .rn(id_top_module_0_addr_rn),
        .two_src(id_top_module_0_two_src));
  CA_LAB1_ex_register_file_0_0 ex_register_file_0
       (.alu_res(top_ex_0_alu_res_out),
        .alu_res_out(ex_register_file_0_alu_res_out),
        .clk(clk_0_1),
        .dest(top_ex_0_dest_out),
        .dest_out(ex_register_file_0_dest_out),
        .mem_r_en(top_ex_0_mem_r_en_out),
        .mem_r_en_out(ex_register_file_0_mem_r_en_out),
        .mem_w_en(top_ex_0_mem_w_en_out),
        .mem_w_en_out(ex_register_file_0_mem_w_en_out),
        .rst(debouncer_0_SIGNAL_O),
        .val_rm(top_ex_0_val_rm_out),
        .val_rm_out(ex_register_file_0_val_rm_out),
        .wb_en(top_ex_0_wb_en_out),
        .wb_en_out(ex_register_file_0_wb_en_out));
  CA_LAB1_fetch_register_file_0_0 fetch_register_file_0
       (.clk(clk_0_1),
        .flush(top_ex_0_branch_tacken),
        .freeze(data_hazard_unit_0_hazard),
        .instruction(blk_mem_gen_0_douta),
        .instruction_reg(fetch_register_file_0_instruction_reg),
        .rst(debouncer_0_SIGNAL_O),
        .updated_pc(fetch_instruction_0_updated_pc),
        .updated_pc_reg(fetch_register_file_0_updated_pc_reg));
  CA_LAB1_forward_0_0 forward_0
       (.fwd_en(fwd_en_0_1),
        .mem_dest(ex_register_file_0_dest_out),
        .mem_wb_en(ex_register_file_0_wb_en_out),
        .sel_src1(forward_0_sel_src1),
        .sel_src2(forward_0_sel_src2),
        .src1_exe(id_register_file_0_addr_rn_out),
        .src2_exe(id_register_file_0_addr_rm_out),
        .wb_dest(mem_register_file_0_dest_out),
        .wb_wb_en(mem_register_file_0_wb_en_out));
  CA_LAB1_id_register_file_0_0 id_register_file_0
       (.addr_rm(id_top_module_0_addr_rm),
        .addr_rm_out(id_register_file_0_addr_rm_out),
        .addr_rn(id_top_module_0_addr_rn),
        .addr_rn_out(id_register_file_0_addr_rn_out),
        .clk(clk_0_1),
        .control_unit_out(id_top_module_0_cuoo),
        .control_unit_out_out(id_register_file_0_control_unit_out_out),
        .dest(id_top_module_0_dest),
        .dest_out(id_register_file_0_dest_out),
        .flush(top_ex_0_branch_tacken),
        .imm(id_top_module_0_imm),
        .imm_out(id_register_file_0_imm_out),
        .pc(fetch_register_file_0_updated_pc_reg),
        .pc_out(id_register_file_0_pc_out),
        .rst(debouncer_0_SIGNAL_O),
        .shift_operand(id_top_module_0_shift_operand),
        .shift_operand_out(id_register_file_0_shift_operand_out),
        .signed_imm_24(id_top_module_0_signed_imm_24),
        .signed_imm_24_out(id_register_file_0_signed_imm_24_out),
        .status_reg(top_ex_0_carry_out),
        .status_reg_out(id_register_file_0_status_reg_out),
        .val_rm(id_top_module_0_val_rm),
        .val_rm_out(id_register_file_0_val_rm_out),
        .val_rn(id_top_module_0_val_rn),
        .val_rn_out(id_register_file_0_val_rn_out));
  CA_LAB1_id_top_module_0_0 id_top_module_0
       (.addr_rm(id_top_module_0_addr_rm),
        .addr_rn(id_top_module_0_addr_rn),
        .clk(clk_0_1),
        .cuoo(id_top_module_0_cuoo),
        .dest(id_top_module_0_dest),
        .hazard(data_hazard_unit_0_hazard),
        .imm(id_top_module_0_imm),
        .instr(fetch_register_file_0_instruction_reg),
        .r0(id_top_module_0_r0),
        .r1(id_top_module_0_r1),
        .r2(id_top_module_0_r2),
        .r3(id_top_module_0_r3),
        .r4(id_top_module_0_r4),
        .r5(id_top_module_0_r5),
        .r6(id_top_module_0_r6),
        .rst(debouncer_0_SIGNAL_O),
        .shift_operand(id_top_module_0_shift_operand),
        .signed_imm_24(id_top_module_0_signed_imm_24),
        .two_src(id_top_module_0_two_src),
        .val_rm(id_top_module_0_val_rm),
        .val_rn(id_top_module_0_val_rn),
        .w_dest(mem_register_file_0_dest_out),
        .w_en(mem_register_file_0_wb_en_out),
        .w_val(mux2to1_32bit_0_WB_Value),
        .zcvn(top_ex_0_zcvn_out));
  CA_LAB1_mem_register_file_0_0 mem_register_file_0
       (.alu_res(ex_register_file_0_alu_res_out),
        .alu_res_out(mem_register_file_0_alu_res_out),
        .clk(clk_0_1),
        .dest(ex_register_file_0_dest_out),
        .dest_out(mem_register_file_0_dest_out),
        .mem_out(dist_mem_gen_0_spo),
        .mem_out_out(mem_register_file_0_mem_out_out),
        .mem_r_en(ex_register_file_0_mem_r_en_out),
        .mem_r_en_out(mem_register_file_0_mem_r_en_out),
        .rst(debouncer_0_SIGNAL_O),
        .wb_en(ex_register_file_0_wb_en_out),
        .wb_en_out(mem_register_file_0_wb_en_out));
  CA_LAB1_mux2to1_32bit_0_0 mux2to1_32bit_0
       (.ALU_Res(mem_register_file_0_alu_res_out),
        .MEM_R_EN(mem_register_file_0_mem_r_en_out),
        .Mem_Data(mem_register_file_0_mem_out_out),
        .WB_Value(mux2to1_32bit_0_WB_Value));
  CA_LAB1_top_ex_0_0 top_ex_0
       (.alu_res_mem(ex_register_file_0_alu_res_out),
        .alu_res_out(top_ex_0_alu_res_out),
        .branch_addr(top_ex_0_branch_addr),
        .branch_tacken(top_ex_0_branch_tacken),
        .carry_out(top_ex_0_carry_out),
        .clk(clk_0_1),
        .control_unit_out(id_register_file_0_control_unit_out_out),
        .dest(id_register_file_0_dest_out),
        .dest_out(top_ex_0_dest_out),
        .exe_dest(top_ex_0_exe_dest),
        .exe_wb_en(top_ex_0_exe_wb_en),
        .imm(id_register_file_0_imm_out),
        .mem_r_en_out(top_ex_0_mem_r_en_out),
        .mem_w_en_out(top_ex_0_mem_w_en_out),
        .pc(id_register_file_0_pc_out),
        .rst(debouncer_0_SIGNAL_O),
        .sel_src1(forward_0_sel_src1),
        .sel_src2(forward_0_sel_src2),
        .shift_operand(id_register_file_0_shift_operand_out),
        .signed_imm_24(id_register_file_0_signed_imm_24_out),
        .status_reg_c(id_register_file_0_status_reg_out),
        .val_rm(id_register_file_0_val_rm_out),
        .val_rm_out(top_ex_0_val_rm_out),
        .val_rn(id_register_file_0_val_rn_out),
        .wb_en_out(top_ex_0_wb_en_out),
        .wb_value(mux2to1_32bit_0_WB_Value),
        .zcvn_out(top_ex_0_zcvn_out));
endmodule

module IF_Stage_imp_1YGY16Y
   (branch_tacken_1,
    clk,
    douta,
    freeze,
    mux_inp_BA,
    rst,
    updated_pc);
  input branch_tacken_1;
  input clk;
  output [31:0]douta;
  input freeze;
  input [31:0]mux_inp_BA;
  input rst;
  output [31:0]updated_pc;

  wire branch_tacken1_1;
  wire clk_0_1;
  wire debouncer_0_SIGNAL_O;
  wire [31:0]dist_mem_gen_0_spo;
  wire [31:0]fetch_instruction_0_memory_in;
  wire [31:0]fetch_instruction_0_updated_pc;
  wire freeze_1;
  wire [31:0]mux_inp_BA_1;
  wire [12:0]xlslice_0_Dout;

  assign branch_tacken1_1 = branch_tacken_1;
  assign clk_0_1 = clk;
  assign debouncer_0_SIGNAL_O = rst;
  assign douta[31:0] = dist_mem_gen_0_spo;
  assign freeze_1 = freeze;
  assign mux_inp_BA_1 = mux_inp_BA[31:0];
  assign updated_pc[31:0] = fetch_instruction_0_updated_pc;
  CA_LAB1_dist_mem_gen_0_1 dist_mem_gen_0
       (.a(xlslice_0_Dout),
        .spo(dist_mem_gen_0_spo));
  CA_LAB1_fetch_instruction_0_0 fetch_instruction_0
       (.branch_tacken(branch_tacken1_1),
        .clk(clk_0_1),
        .freeze(freeze_1),
        .memory_in(fetch_instruction_0_memory_in),
        .mux_inp_BA(mux_inp_BA_1),
        .rst(debouncer_0_SIGNAL_O),
        .updated_pc(fetch_instruction_0_updated_pc));
  CA_LAB1_xlslice_0_0 xlslice_0
       (.Din(fetch_instruction_0_memory_in),
        .Dout(xlslice_0_Dout));
endmodule

module Mem_Stage_imp_1HJZ3ZA
   (Din,
    clk,
    d,
    spo,
    we);
  input [31:0]Din;
  input clk;
  input [31:0]d;
  output [31:0]spo;
  input we;

  wire clk_0_1;
  wire [31:0]dist_mem_gen_0_spo;
  wire [31:0]ex_register_file_0_alu_res_out;
  wire ex_register_file_0_mem_w_en_out;
  wire [31:0]ex_register_file_0_val_rm_out;
  wire [10:0]xlslice_0_Dout;

  assign clk_0_1 = clk;
  assign ex_register_file_0_alu_res_out = Din[31:0];
  assign ex_register_file_0_mem_w_en_out = we;
  assign ex_register_file_0_val_rm_out = d[31:0];
  assign spo[31:0] = dist_mem_gen_0_spo;
  CA_LAB1_dist_mem_gen_0_0 dist_mem_gen_0
       (.a(xlslice_0_Dout),
        .clk(clk_0_1),
        .d(ex_register_file_0_val_rm_out),
        .spo(dist_mem_gen_0_spo),
        .we(ex_register_file_0_mem_w_en_out));
  CA_LAB1_xlslice_0_1 xlslice_0
       (.Din(ex_register_file_0_alu_res_out),
        .Dout(xlslice_0_Dout));
endmodule
