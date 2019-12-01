// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Mon Dec 24 20:24:45 2018
// Host        : DESKTOP-HD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/WeCloudSync/6.MI_PROJECTS/IncredibleVivado/Pipeline_with_ThreeLevelMem/Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/clk_wiz_for_cpu/clk_wiz_for_cpu_stub.v
// Design      : clk_wiz_for_cpu
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_for_cpu(clk_out1, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_in1" */;
  output clk_out1;
  input clk_in1;
endmodule
