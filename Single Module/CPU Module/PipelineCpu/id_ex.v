`include "Defination.vh"

module id_ex(

	input	wire										clk,
	input wire										rst,
	input wire[5:0]							 stall,
	input wire[7:0]         id_aluop,
	input wire[2:0]        id_alusel,
	input wire[31:0]           id_reg1,
	input wire[31:0]           id_reg2,
	input wire[4:0]       id_wd,
	input wire                    id_wreg,
	input wire[31:0]           id_link_address,
	input wire                    id_is_in_delayslot,
	input wire                    next_inst_in_delayslot_i,		
	input wire[31:0]           id_inst,		
	output reg[7:0]         ex_aluop,
	output reg[2:0]        ex_alusel,
	output reg[31:0]           ex_reg1,
	output reg[31:0]           ex_reg2,
	output reg[4:0]       ex_wd,
	output reg                    ex_wreg,
	output reg[31:0]           ex_link_address,
  output reg                    ex_is_in_delayslot,
	output reg                    is_in_delayslot_o,
	output reg[31:0]           ex_inst	
	
);

	always @ (posedge clk) begin
		if (rst) begin
			ex_alusel <= `EXE_RES_NOP;
			ex_aluop <= `EXE_NOP_OP;
			ex_reg2 <= 32'h00000000;
			ex_reg1 <= 32'h00000000;
			ex_wreg <= `WriteDisable;
			is_in_delayslot_o <= `NotInDelaySlot;	
			ex_wd <= `NOPRegAddr;
			ex_is_in_delayslot <= `NotInDelaySlot;
			ex_link_address <= 32'h00000000;
			ex_inst <= 32'h00000000;	
		end else if(stall[2] == `Stop && stall[3] == `NoStop) begin
			ex_reg2 <= 32'h00000000;
			ex_alusel <= `EXE_RES_NOP;
			ex_aluop <= `EXE_NOP_OP;
			ex_reg1 <= 32'h00000000;
			ex_link_address <= 32'h00000000;
			ex_wd <= `NOPRegAddr;
			ex_inst <= 32'h00000000;	
			ex_wreg <= `WriteDisable;	
	   		ex_is_in_delayslot <= `NotInDelaySlot;	
		end else if(stall[2] == `NoStop) begin		
			ex_link_address <= id_link_address;
			ex_alusel <= id_alusel;
			ex_wreg <= id_wreg;	
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_inst <= id_inst;		
			is_in_delayslot_o <= next_inst_in_delayslot_i;
			ex_aluop <= id_aluop;
			ex_wd <= id_wd;
			ex_is_in_delayslot <= id_is_in_delayslot;	
		end
	end
	
endmodule