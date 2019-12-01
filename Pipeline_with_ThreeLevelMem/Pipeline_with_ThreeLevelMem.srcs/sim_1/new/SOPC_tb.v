`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/22 10:05:04
// Design Name: 
// Module Name: SOPC_tb
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


module SOPC_tb;


   reg clk100mhz;
  reg rst;
  reg [3:0]btn;
  reg [15:0]sw;
  wire [7:0] o_seg;
  wire [7:0] o_sel;
  wire [15:0]led;
  /*************************/
  wire [15:0]            ddr2_dq;
  wire [1:0]             ddr2_dqs_n;
  wire [1:0]             ddr2_dqs_p;
  wire [12:0]           ddr2_addr;
  wire [2:0]            ddr2_ba;
  wire                  ddr2_ras_n;
  wire                  ddr2_cas_n;
  wire                  ddr2_we_n;
  wire [0:0]            ddr2_ck_p;
  wire [0:0]            ddr2_ck_n;
  wire [0:0]            ddr2_cke;
  wire [0:0]            ddr2_cs_n;
  wire [1:0]            ddr2_dm;
  wire [0:0]            ddr2_odt;


wire temp_databus_busy;
wire temp_databus_done;
initial begin
    rst=1;
    clk100mhz=0;
    #60 rst=0;
     sw=16'b1000_0000_0000_0001;
    
   // @(posedge temp_databus_done) sw=16'd1;
   // @(posedge temp_databus_done) sw=16'd6;
end
always #5 clk100mhz = ~clk100mhz;

SOPC sopc_0(
  clk100mhz,
   rst,
  btn,
   sw,
  o_seg,
  o_sel,
  led,
 // temp_databus_busy,
  //temp_databus_done,
  /*************************/
  ddr2_dq,
  ddr2_dqs_n,
  ddr2_dqs_p,
  ddr2_addr,
  ddr2_ba,
  ddr2_ras_n,
  ddr2_cas_n,
  ddr2_we_n,
  ddr2_ck_p,
  ddr2_ck_n,
  ddr2_cke,
  ddr2_cs_n,
  ddr2_dm,
  ddr2_odt
);

ddr2_model ddr2_model(
         .ck(ddr2_ck_p),
         .ck_n(ddr2_ck_n),
         .cke(ddr2_cke),
         .cs_n(ddr2_cs_n),
         .ras_n(ddr2_ras_n),
         .cas_n(ddr2_cas_n),
         .we_n(ddr2_we_n),
         .dm_rdqs(ddr2_dm),
         .ba(ddr2_ba),
         .addr(ddr2_addr),
         .dq(ddr2_dq),
         .dqs(ddr2_dqs_p),
         .dqs_n(ddr2_dqs_n),
         .rdqs_n(rdqs_n),
         .odt(ddr2_odt)
     );
endmodule
