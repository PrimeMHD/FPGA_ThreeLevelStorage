`define UNINITIALIZED 3'd0
`define BOOTING 3'd1
`define READIMEM 3'd2
`define DDRTOIMEM 3'd3
`include "Defination.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/12/22 00:42:43
// Design Name:
// Module Name: DataBus
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


module DataBus (
	input clk100mhz,
	input rst,
	input [31:0]cpu_addr,
	input cpu_read_write,
	output reg bootdone,
	//input [31:0] cpu_data_fromCPU,
	output  [31:0]cpu_data_toCPU,
	output reg DataBus_busy,
	output reg DataBus_done,
	//interface to cpu
	input [31:0]cache_data_fromIMEM,
	output  [31:0]cache_addr_toIMEM,
	output  [31:0]cache_data_toIMEM,
	output reg cache_read_write,
	//interface to imem
	input [31:0]ddr_data_fromDDR,
	input ddr_busy,
	input ddr_done,
	output [31:0]ddr_addr_toDDR,
	output [31:0]ddr_data_toDDR,
	output reg ddr_read_write,
	input ddr_start_ready,
	//interface to ddr
	output reg sd_mem_read_write,
	output  [31:0]sd_mem_addr,
	input  [31:0]sd_mem_data_fromSDMEM,
	output reg [31:0]sd_mem_data_toSDMEM,
	input sd_mem_ready
	//interface to sd
);
	reg ready_toBoot;
	reg loadData_ddrToImemDone;
	reg [31:0]ddr_to_imem_count; //0~127
	reg [31:0]ddr_boot_block_count;  //0~19
	reg [31:0]ddr_boot_inblock_count;


	reg [23:0]cache_status[3:0];//Highest bit is validBit
//Cache Block Status Regs


	reg [2:0]cur_state;
//`UNINITIALIZED, `BOOTING, `READIMEM, `DDRTOIMEM
	reg is_first_to_imem_count;
	reg is_first_to_ddr_count;
	reg [31:0]bootdonoe_idle_count;
	reg [31:0]ddr_to_imem_firstcell_count;



	localparam BLOCK_SIZE=128;
	localparam DDR_BLOCK_IN_USE=16;
	localparam WAIT_IDEL_LOOP_AFTER_BOOTDONE=256;
	localparam DDR_TO_IMEM_FIRSTCELL_INSISTLOOP=256;



	always @(posedge clk100mhz or posedge rst) begin
		if(rst) begin
			cur_state<= `UNINITIALIZED;
			cache_read_write<=`READ;
			ddr_read_write<=`READ;
			sd_mem_read_write<=`READ;
			ddr_to_imem_count<=0;
			ddr_boot_block_count<=0;
			ddr_boot_inblock_count<=0;
			ready_toBoot<=1'b0;
			bootdone<=1'b0;
			loadData_ddrToImemDone<=1'b0;
			cache_status[0][23]<=1'b0;
			cache_status[1][23]<=1'b0;
			cache_status[2][23]<=1'b0;
			cache_status[3][23]<=1'b0;
			is_first_to_imem_count<=1'b1;
			is_first_to_ddr_count<=1'b1;
			bootdonoe_idle_count<=0;
			ddr_to_imem_firstcell_count<=0;
			DataBus_done<=`UNDONE;
			DataBus_busy<=`Busy;
		end else begin
			case(cur_state)
				`UNINITIALIZED:begin
					if(ready_toBoot)begin

						ddr_boot_block_count<=0;
						ddr_boot_inblock_count<=0;
						cur_state<=`BOOTING;
					end
					else if(sd_mem_ready&ddr_start_ready)begin
						ready_toBoot<=1'b1;
					end
				end
				`BOOTING:begin
					//move data from sd to ddr
					DataBus_busy<=`Busy;
					DataBus_done<=`UNDONE;
					if(bootdone)begin

						cur_state<=`READIMEM;
					end
					else begin
						sd_mem_read_write<=`READ;

						is_first_to_ddr_count<=1'b0;
						if(ddr_boot_block_count<DDR_BLOCK_IN_USE&~is_first_to_ddr_count)begin
							ddr_read_write<=`WRITE;
							if(ddr_boot_inblock_count<=BLOCK_SIZE-1)begin
								if(ddr_done&~ddr_busy)begin
									if(ddr_boot_inblock_count==BLOCK_SIZE-1)begin
										ddr_boot_inblock_count<=0;
										ddr_boot_block_count<=ddr_boot_block_count+1;

									end
									else begin
										ddr_boot_inblock_count<=ddr_boot_inblock_count+1;
									end


								end
							end

						end
						else begin
							if(bootdonoe_idle_count<WAIT_IDEL_LOOP_AFTER_BOOTDONE)begin
								bootdonoe_idle_count<=bootdonoe_idle_count+1;
								ddr_read_write<=`READ;
							end
							else begin
								bootdone<=`DONE;
							end

						end
					end
				end
				`READIMEM:begin
					//attempt to read cache
					cache_read_write<=`READ;
					if(cache_status[cpu_addr[8:7]][22:0]==cpu_addr[31:9]&cache_status[cpu_addr[8:7]][23]==1'b1)begin
						//cache hit
						DataBus_busy<=`NoBusy;
						DataBus_done<=`DONE;
						cur_state<=`READIMEM;

					end
					else begin
						//cache not hit
						cur_state<=`DDRTOIMEM;
						DataBus_busy<=`Busy;
						DataBus_done<=`UNDONE;
					end
				end
				`DDRTOIMEM:begin
					DataBus_busy<=`Busy;
					DataBus_done<=`UNDONE;
					if(loadData_ddrToImemDone)begin
						loadData_ddrToImemDone<=`UNDONE;
						cache_status[cpu_addr[8:7]][22:0]<=cpu_addr[31:9];
						cache_status[cpu_addr[8:7]][23]<=1'b1;
						cache_read_write<=`READ;
						cur_state<=`READIMEM;
						is_first_to_imem_count<=1'b1;
						ddr_to_imem_firstcell_count<=0;
						ddr_to_imem_count<=0;
					end
					else begin
						//move data from ddr to imem
						cache_read_write<=`WRITE;
						ddr_read_write<=`READ;
						if(ddr_to_imem_count<=BLOCK_SIZE-1)begin
							if(ddr_to_imem_firstcell_count<DDR_TO_IMEM_FIRSTCELL_INSISTLOOP)begin
								ddr_to_imem_firstcell_count<=ddr_to_imem_firstcell_count+1;
							end
							else begin
								is_first_to_imem_count<=1'b0;
							end
							if(ddr_done&~is_first_to_imem_count&~ddr_busy)begin
								if(ddr_to_imem_count==BLOCK_SIZE-1)begin
									loadData_ddrToImemDone<=`DONE;
								end
								else begin
									ddr_to_imem_count<=ddr_to_imem_count+1;
								end

							end
						end

					end
				end
			endcase // cur_state


		end
	end


	assign ddr_addr_toDDR    = (cur_state==`BOOTING)?ddr_boot_block_count*BLOCK_SIZE+ddr_boot_inblock_count:{cpu_addr[31:7],ddr_to_imem_count[6:0]};
	assign sd_mem_addr       = ddr_boot_block_count*BLOCK_SIZE+ddr_boot_inblock_count;
	assign cache_addr_toIMEM = (cur_state==`DDRTOIMEM)?cpu_addr[8:7]*BLOCK_SIZE+ddr_to_imem_count:cpu_addr[8:0];
	assign cache_data_toIMEM = ddr_data_fromDDR;
	assign cpu_data_toCPU    = cache_data_fromIMEM;
	assign ddr_data_toDDR    = sd_mem_data_fromSDMEM;

endmodule // DataBus