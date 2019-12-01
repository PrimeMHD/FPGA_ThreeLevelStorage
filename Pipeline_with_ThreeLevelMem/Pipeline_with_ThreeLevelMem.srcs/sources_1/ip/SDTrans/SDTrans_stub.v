// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sun Dec 23 10:39:09 2018
// Host        : DESKTOP-HD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/WeCloudSync/6.MI_PROJECTS/IncredibleVivado/ThreeLevelMem_v1/ThreeLevelMem_v1.srcs/sources_1/ip/SDTrans/SDTrans_stub.v
// Design      : SDTrans
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.2" *)
module SDTrans(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[10:0],d[31:0],clk,we,spo[31:0]" */;
  input [10:0]a;
  input [31:0]d;
  input clk;
  input we;
  output [31:0]spo;
endmodule
