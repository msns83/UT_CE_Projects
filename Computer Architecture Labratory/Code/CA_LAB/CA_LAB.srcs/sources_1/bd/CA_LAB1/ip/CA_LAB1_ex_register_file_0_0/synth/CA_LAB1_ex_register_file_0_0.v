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


// IP VLNV: xilinx.com:module_ref:ex_register_file:1.0
// IP Revision: 1

(* X_CORE_INFO = "ex_register_file,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "CA_LAB1_ex_register_file_0_0,ex_register_file,{}" *)
(* CORE_GENERATION_INFO = "CA_LAB1_ex_register_file_0_0,ex_register_file,{x_ipProduct=Vivado 2018.3,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=ex_register_file,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module CA_LAB1_ex_register_file_0_0 (
  clk,
  rst,
  wb_en,
  mem_r_en,
  mem_w_en,
  alu_res,
  val_rm,
  dest,
  wb_en_out,
  mem_r_en_out,
  mem_w_en_out,
  alu_res_out,
  val_rm_out,
  dest_out
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, ASSOCIATED_RESET rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN CA_LAB1_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire wb_en;
input wire mem_r_en;
input wire mem_w_en;
input wire [31 : 0] alu_res;
input wire [31 : 0] val_rm;
input wire [3 : 0] dest;
output wire wb_en_out;
output wire mem_r_en_out;
output wire mem_w_en_out;
output wire [31 : 0] alu_res_out;
output wire [31 : 0] val_rm_out;
output wire [3 : 0] dest_out;

  ex_register_file inst (
    .clk(clk),
    .rst(rst),
    .wb_en(wb_en),
    .mem_r_en(mem_r_en),
    .mem_w_en(mem_w_en),
    .alu_res(alu_res),
    .val_rm(val_rm),
    .dest(dest),
    .wb_en_out(wb_en_out),
    .mem_r_en_out(mem_r_en_out),
    .mem_w_en_out(mem_w_en_out),
    .alu_res_out(alu_res_out),
    .val_rm_out(val_rm_out),
    .dest_out(dest_out)
  );
endmodule
