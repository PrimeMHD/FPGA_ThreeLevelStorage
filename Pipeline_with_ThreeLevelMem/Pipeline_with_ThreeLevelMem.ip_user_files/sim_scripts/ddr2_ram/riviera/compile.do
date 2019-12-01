vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"D:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93 \
"D:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/clocking/mig_7series_v4_1_clk_ibuf.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/clocking/mig_7series_v4_1_infrastructure.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/clocking/mig_7series_v4_1_iodelay_ctrl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/clocking/mig_7series_v4_1_tempmon.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_arb_mux.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_arb_row_col.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_arb_select.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_cntrl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_common.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_compare.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_mach.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_queue.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_bank_state.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_col_mach.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_mc.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_rank_cntrl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_rank_common.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_rank_mach.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/controller/mig_7series_v4_1_round_robin_arb.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ecc/mig_7series_v4_1_ecc_buf.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ecc/mig_7series_v4_1_ecc_dec_fix.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ecc/mig_7series_v4_1_ecc_gen.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ecc/mig_7series_v4_1_ecc_merge_enc.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ecc/mig_7series_v4_1_fi_xor.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ip_top/mig_7series_v4_1_memc_ui_top_std.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ip_top/mig_7series_v4_1_mem_intfc.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_byte_group_io.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_byte_lane.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_calib_top.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_if_post_fifo.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_mc_phy.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_mc_phy_wrapper.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_of_pre_fifo.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_4lanes.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_dqs_found_cal.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_dqs_found_cal_hr.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_init.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_cntlr.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_data.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_edge.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_lim.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_mux.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_po_cntlr.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_ocd_samp.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_oclkdelay_cal.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_prbs_rdlvl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_rdlvl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_tempmon.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_top.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_wrcal.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_wrlvl.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_phy_wrlvl_off_delay.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_ddr_prbs_gen.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_cc.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_edge_store.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_meta.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_pd.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_tap_base.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/phy/mig_7series_v4_1_poc_top.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ui/mig_7series_v4_1_ui_cmd.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ui/mig_7series_v4_1_ui_rd_data.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ui/mig_7series_v4_1_ui_top.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ui/mig_7series_v4_1_ui_wr_data.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ddr2_ram_mig_sim.v" \
"../../../../Pipeline_with_ThreeLevelMem.srcs/sources_1/ip/ddr2_ram/ddr2_ram/user_design/rtl/ddr2_ram.v" \

vlog -work xil_defaultlib \
"glbl.v"

