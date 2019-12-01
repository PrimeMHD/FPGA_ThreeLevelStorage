`timescale 1ns / 1ps
`include "Defination.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:Mi Haodong 1551867
//
// Create Date: 2018/12/22 00:58:48
// Design Name:
// Module Name: SOPC
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module SOPC (
  input clk100mhz,
  input rst,
  input [3:0]btn,
  input [15:0]sw,
  output [7:0] o_seg,
  output [7:0] o_sel,
  output [15:0]led,
  // output temp_databus_busy,
  // output temp_databus_done,
  /*************************/
  //ddr physical signal
  inout [15:0]            ddr2_dq,
  inout [1:0]             ddr2_dqs_n,
  inout [1:0]             ddr2_dqs_p,
  output [12:0]           ddr2_addr,
  output [2:0]            ddr2_ba,
  output                  ddr2_ras_n,
  output                  ddr2_cas_n,
  output                  ddr2_we_n,
  output [0:0]            ddr2_ck_p,
  output [0:0]            ddr2_ck_n,
  output [0:0]            ddr2_cke,
  output [0:0]            ddr2_cs_n,
  output [1:0]            ddr2_dm,
  output [0:0]            ddr2_odt,
  //sd flash physical signal
  input SD_CD,
  output SD_RESET,
  output SD_SCK,
  output SD_CMD,
  inout [3:0] SD_DAT
);
  
  wire [31:0]seg_data_i;
  wire clk200mhz;
  wire [1:0] rdqs_n;
  reg [31:0]addr_in_ddr;
  reg [31:0]data_to_ddr;
  reg read_write;
  wire [31:0]data_from_DDR;
  wire ddr_busy;
  wire ddr_done;
  wire [31:0]cpu_addr;
  wire cpu_read_write;
  wire [31:0] cpu_data_fromCPU;
  wire [31:0]cpu_data_toCPU;
  wire DataBus_busy;
  wire DataBus_done;
  //interface to cpu
  wire [31:0]cache_data_fromIMEM;
  wire [31:0]cache_addr_toIMEM;
  wire [31:0]cache_data_toIMEM;
  wire cache_read_write;
  //interface to imem
  wire [31:0]ddr_data_fromDDR;
  wire[31:0]ddr_addr_toDDR;
  wire[31:0]ddr_data_toDDR;
  wire ddr_read_write;
  //interface to ddr
  wire sd_mem_read_write;
  wire [31:0]sd_mem_addr;
  wire  [31:0]sd_mem_data_fromSDMEM;
  wire  [31:0]sd_mem_data_toSDMEM;
  wire sd_mem_ready;
  wire ddr_start_ready;
  wire bootdone;
/*****************************************************/
  wire DM_CS,DM_W,DM_R;

  wire seg7_cs,switch_cs;
  wire [31:0]data_fmem;
  wire[`RegBus] mem_data_o;
  wire[3:0] mem_sel_i;
  wire mem_ce_i;
  wire [31:0]rdata;
  wire[`InstAddrBus] inst_addr;
  wire[`InstBus] inst;
  wire rom_ce;
  wire mem_we_i;
  wire[`RegBus] mem_addr_i;
  wire[`RegBus] mem_data_i;
  wire clk_reduced;
  wire [31:0]todmem_addr=mem_addr_i;

 
  assign led[2] = DataBus_busy;
  assign led[1] = DataBus_done;
  assign led[0] = bootdone;
  assign cpu_addr       = {21'b0,inst_addr[12:2]};
  assign cpu_read_write = `READ;
  assign DM_CS          = DM_W|DM_R;
  assign DM_W           = mem_we_i;
  assign DM_R           = mem_ce_i;


  cache cache0(
    .a(cache_addr_toIMEM[8:0]),
    .d(cache_data_toIMEM),
    .clk(clk100mhz),
    .we(cache_read_write),
    .spo(cache_data_fromIMEM)
  );


  sealedDDR sealedDDR_0(
    .clk100mhz(clk100mhz),
    .rst(rst),
    .addr_to_DDR(ddr_addr_toDDR),
    .data_to_DDR(ddr_data_toDDR),
    .read_write(ddr_read_write),
    .data_from_DDR(ddr_data_fromDDR),
    .busy(ddr_busy),
    .done(ddr_done),
    .ddr_start_ready(ddr_start_ready),
    /************************/
    .ddr2_dq(ddr2_dq),
    .ddr2_dqs_n(ddr2_dqs_n),
    .ddr2_dqs_p(ddr2_dqs_p),
    .ddr2_addr(ddr2_addr),
    .ddr2_ba(ddr2_ba),
    .ddr2_ras_n(ddr2_ras_n),
    .ddr2_cas_n(ddr2_cas_n),
    .ddr2_we_n(ddr2_we_n),
    .ddr2_ck_p(ddr2_ck_p),
    .ddr2_ck_n(ddr2_ck_n),
    .ddr2_cke(ddr2_cke),
    .ddr2_cs_n(ddr2_cs_n),
    .ddr2_dm(ddr2_dm),
    .ddr2_odt(ddr2_odt)
  );





  DataBus databus_0(
    .clk100mhz(clk100mhz),
    .rst(rst),
    .cpu_addr(cpu_addr),
    .cpu_read_write(cpu_read_write),
    .bootdone             (bootdone),
    .cpu_data_toCPU(inst),
    .DataBus_busy(DataBus_busy),
    .DataBus_done(DataBus_done),
    //interface to cpu
    .cache_data_fromIMEM(cache_data_fromIMEM),
    .cache_addr_toIMEM(cache_addr_toIMEM),
    .cache_data_toIMEM(cache_data_toIMEM),
    .cache_read_write(cache_read_write),
    //interface to imem
    .ddr_data_fromDDR(ddr_data_fromDDR),
    .ddr_busy(ddr_busy),
    .ddr_done(ddr_done),
    .ddr_addr_toDDR(ddr_addr_toDDR),
    .ddr_data_toDDR(ddr_data_toDDR),
    .ddr_read_write(ddr_read_write),
    .ddr_start_ready(ddr_start_ready),
    //interface to ddr
    .sd_mem_read_write(sd_mem_read_write),
    .sd_mem_addr(sd_mem_addr),
    .sd_mem_data_fromSDMEM(sd_mem_data_fromSDMEM),
    .sd_mem_data_toSDMEM(sd_mem_data_toSDMEM),
    .sd_mem_ready(sd_mem_ready)
    //interface to sd
  );


  SD SD_0(
    .clk100mhz(clk100mhz),
    .rst(rst),
    /************************/
    .sd_mem_read_write(sd_mem_read_write),
    .sd_mem_addr(sd_mem_addr),
    .sd_mem_data_toSDMEM(sd_mem_data_toSDMEM),
    .sd_mem_ready(sd_mem_ready),
    .sd_mem_data_fromSDMEM(sd_mem_data_fromSDMEM),
    /*********************************/
    .SD_CD(SD_CD),
    .SD_RESET(SD_RESET),
    .SD_SCK(SD_SCK),
    .SD_CMD(SD_CMD),
    .SD_DAT(SD_DAT)
  );







  CPU sccpu(
    .clk(clk_reduced),
    .rst(rst),
    .rom_addr_o(inst_addr),
    .rom_data_i(inst),
    .rom_ce_o(rom_ce),
    .DataBus_busy(DataBus_busy),
    .DataBus_done(DataBus_done),



    .ram_we_o(mem_we_i),
    .ram_addr_o(mem_addr_i),
    .ram_sel_o(mem_sel_i),
    .ram_data_o(mem_data_i),
    .ram_data_i(rdata),
    .ram_ce_o(mem_ce_i)
  );


 

  data_ram data_ram0(
    .clk(clk_reduced),
    .ce(mem_ce_i),
    .we(mem_we_i),
    .addr(todmem_addr),
    .sel(mem_sel_i),
    .data_i(mem_data_i),
    .data_o(data_fmem)
  );



  seg7x16 seg7(clk_reduced, rst, seg7_cs, mem_data_i, o_seg, o_sel);
  io_sel io_mem(todmem_addr, DM_CS, DM_W, DM_R, seg7_cs, switch_cs);
  sw_mem_sel sw_mem(switch_cs, sw, data_fmem, rdata);
  clk_wiz_for_cpu clk_divider(.clk_in1(clk100mhz),.clk_out1(clk_reduced));


endmodule
