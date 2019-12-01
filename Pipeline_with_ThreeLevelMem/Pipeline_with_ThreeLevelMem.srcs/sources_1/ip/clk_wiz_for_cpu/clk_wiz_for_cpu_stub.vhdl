-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Mon Dec 24 20:24:45 2018
-- Host        : DESKTOP-HD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/WeCloudSync/6.MI_PROJECTS/IncredibleVivado/Pipeline_with_ThreeLevelMem/Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/clk_wiz_for_cpu/clk_wiz_for_cpu_stub.vhdl
-- Design      : clk_wiz_for_cpu
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_for_cpu is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_wiz_for_cpu;

architecture stub of clk_wiz_for_cpu is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
