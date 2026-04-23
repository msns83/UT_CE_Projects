//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Tue Jul 22 14:14:07 2025
//Host        : Ali_Laptop running 64-bit major release  (build 9200)
//Command     : generate_target CA_LAB1_wrapper.bd
//Design      : CA_LAB1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module CA_LAB1_wrapper
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
  input clk;
  input fwd_en_0;
  output [31:0]r0_0;
  output [31:0]r1_0;
  output [31:0]r2_0;
  output [31:0]r3_0;
  output [31:0]r4_0;
  output [31:0]r5_0;
  output [31:0]r6_0;
  input rst;

  wire clk;
  wire fwd_en_0;
  wire [31:0]r0_0;
  wire [31:0]r1_0;
  wire [31:0]r2_0;
  wire [31:0]r3_0;
  wire [31:0]r4_0;
  wire [31:0]r5_0;
  wire [31:0]r6_0;
  wire rst;

  CA_LAB1 CA_LAB1_i
       (.clk(clk),
        .fwd_en_0(fwd_en_0),
        .r0_0(r0_0),
        .r1_0(r1_0),
        .r2_0(r2_0),
        .r3_0(r3_0),
        .r4_0(r4_0),
        .r5_0(r5_0),
        .r6_0(r6_0),
        .rst(rst));
endmodule
