// (c) Copyright 1995-2025 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:id_register_file:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module CA_LAB1_id_register_file_0_0 (
  clk,
  rst,
  flush,
  pc,
  val_rn,
  val_rm,
  imm,
  shift_operand,
  control_unit_out,
  signed_imm_24,
  dest,
  status_reg,
  addr_rm,
  addr_rn,
  pc_out,
  val_rn_out,
  val_rm_out,
  imm_out,
  shift_operand_out,
  control_unit_out_out,
  signed_imm_24_out,
  dest_out,
  status_reg_out,
  addr_rm_out,
  addr_rn_out
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN CA_LAB1_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire flush;
input wire [31 : 0] pc;
input wire [31 : 0] val_rn;
input wire [31 : 0] val_rm;
input wire imm;
input wire [11 : 0] shift_operand;
input wire [8 : 0] control_unit_out;
input wire [23 : 0] signed_imm_24;
input wire [3 : 0] dest;
input wire status_reg;
input wire [3 : 0] addr_rm;
input wire [3 : 0] addr_rn;
output wire [31 : 0] pc_out;
output wire [31 : 0] val_rn_out;
output wire [31 : 0] val_rm_out;
output wire imm_out;
output wire [11 : 0] shift_operand_out;
output wire [8 : 0] control_unit_out_out;
output wire [23 : 0] signed_imm_24_out;
output wire [3 : 0] dest_out;
output wire status_reg_out;
output wire [3 : 0] addr_rm_out;
output wire [3 : 0] addr_rn_out;

  id_register_file inst (
    .clk(clk),
    .rst(rst),
    .flush(flush),
    .pc(pc),
    .val_rn(val_rn),
    .val_rm(val_rm),
    .imm(imm),
    .shift_operand(shift_operand),
    .control_unit_out(control_unit_out),
    .signed_imm_24(signed_imm_24),
    .dest(dest),
    .status_reg(status_reg),
    .addr_rm(addr_rm),
    .addr_rn(addr_rn),
    .pc_out(pc_out),
    .val_rn_out(val_rn_out),
    .val_rm_out(val_rm_out),
    .imm_out(imm_out),
    .shift_operand_out(shift_operand_out),
    .control_unit_out_out(control_unit_out_out),
    .signed_imm_24_out(signed_imm_24_out),
    .dest_out(dest_out),
    .status_reg_out(status_reg_out),
    .addr_rm_out(addr_rm_out),
    .addr_rn_out(addr_rn_out)
  );
endmodule
