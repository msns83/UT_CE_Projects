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


// IP VLNV: xilinx.com:module_ref:id_top_module:1.0
// IP Revision: 1

(* X_CORE_INFO = "id_top_module,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "CA_LAB1_id_top_module_0_0,id_top_module,{}" *)
(* CORE_GENERATION_INFO = "CA_LAB1_id_top_module_0_0,id_top_module,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=id_top_module,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module CA_LAB1_id_top_module_0_0 (
  clk,
  rst,
  instr,
  zcvn,
  hazard,
  w_en,
  w_dest,
  w_val,
  val_rn,
  val_rm,
  addr_rm,
  addr_rn,
  two_src,
  imm,
  shift_operand,
  cuoo,
  signed_imm_24,
  dest,
  r0,
  r1,
  r2,
  r3,
  r4,
  r5,
  r6
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN CA_LAB1_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire [31 : 0] instr;
input wire [3 : 0] zcvn;
input wire hazard;
input wire w_en;
input wire [3 : 0] w_dest;
input wire [31 : 0] w_val;
output wire [31 : 0] val_rn;
output wire [31 : 0] val_rm;
output wire [3 : 0] addr_rm;
output wire [3 : 0] addr_rn;
output wire two_src;
output wire imm;
output wire [11 : 0] shift_operand;
output wire [8 : 0] cuoo;
output wire [23 : 0] signed_imm_24;
output wire [3 : 0] dest;
output wire [31 : 0] r0;
output wire [31 : 0] r1;
output wire [31 : 0] r2;
output wire [31 : 0] r3;
output wire [31 : 0] r4;
output wire [31 : 0] r5;
output wire [31 : 0] r6;

  id_top_module inst (
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .zcvn(zcvn),
    .hazard(hazard),
    .w_en(w_en),
    .w_dest(w_dest),
    .w_val(w_val),
    .val_rn(val_rn),
    .val_rm(val_rm),
    .addr_rm(addr_rm),
    .addr_rn(addr_rn),
    .two_src(two_src),
    .imm(imm),
    .shift_operand(shift_operand),
    .cuoo(cuoo),
    .signed_imm_24(signed_imm_24),
    .dest(dest),
    .r0(r0),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4),
    .r5(r5),
    .r6(r6)
  );
endmodule
