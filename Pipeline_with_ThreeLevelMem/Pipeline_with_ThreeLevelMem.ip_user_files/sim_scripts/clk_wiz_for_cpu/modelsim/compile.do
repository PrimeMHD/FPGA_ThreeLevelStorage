vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/clk_wiz_for_cpu" "+incdir+../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/clk_wiz_for_cpu" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/clk_wiz_for_cpu/clk_wiz_for_cpu_sim_netlist.v" \


vlog -work xil_defaultlib \
"glbl.v"

