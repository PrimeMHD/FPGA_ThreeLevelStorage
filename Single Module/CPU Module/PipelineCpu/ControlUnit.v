`timescale 1ns / 1ps
`include "Defination.vh"

module id (
	input wire										rst,
	input wire[31:0]			pc_i,
	input wire[31:0]          inst_i,
	input wire[7:0]					ex_aluop_i,
	input wire										ex_wreg_i,
	input wire[31:0]						ex_wdata_i,
	input wire[4:0]       ex_wd_i,
	input wire										mem_wreg_i,
	input wire[31:0]						mem_wdata_i,
	input wire[4:0]       mem_wd_i,
	input wire[31:0]           reg1_data_i,
	input wire[31:0]           reg2_data_i,
	input wire                    is_in_delayslot_i,
	output reg                    m_reg1_read_o,
	output reg                    m_reg2_read_o,
	output reg[4:0]       reg1_addr_o,
	output reg[4:0]       reg2_addr_o,
	output reg[7:0]         aluop_o,
	output reg[2:0]        alusel_o,
	output reg[31:0]           reg1_o,
	output reg[31:0]           reg2_o,
	output reg[4:0]       wd_o,
	output reg                    wreg_o,
	output wire[31:0]          inst_o,
	output reg                    next_inst_in_delayslot_o,
	output reg                    branch_flag_o,
	output reg[31:0]           branch_target_address_o,
	output reg[31:0]           link_addr_o,
	output reg                    is_in_delayslot_o,
	output wire                   stallreq
);
	reg[31:0]	imm;
	reg InstrIsValid;
	reg StallreqLoadrelated_Register1;
	reg StallreqLoadrelated_Register2;
	reg preInstr_isLoad;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire[5:0] op = inst_i[31:26];
	wire[31:0] pc_add_8;
	wire[31:0] pc_add_4;
	wire [ 4:0] shamt = inst_i[10:6];
	wire [ 5:0] func  = inst_i[5:0];
	wire [31:0] shamt_ext = {27'b0,shamt};
	wire[31:0] m_imm_signedExtern;

	assign rs                 = inst_i[25:21];
	assign rt                 = inst_i[20:16];
	assign rd                 = inst_i[15:11];
	assign inst_o             = inst_i;
	assign pc_add_8           = pc_i + 8;
	assign pc_add_4           = pc_i +4;
	assign m_imm_signedExtern = {{14{inst_i[15]}}, inst_i[15:0], 2'b00 };
	assign stallreq           = StallreqLoadrelated_Register1 | StallreqLoadrelated_Register2;





	always @(*)begin
		case(ex_aluop_i)
			`EXE_LW_OP:
			preInstr_isLoad= 1'b1;
			`EXE_LB_OP:
			preInstr_isLoad= 1'b1;
			`EXE_LBU_OP:
			preInstr_isLoad= 1'b1;
			`EXE_LH_OP:
			preInstr_isLoad= 1'b1;
			`EXE_LHU_OP:
			preInstr_isLoad= 1'b1;
			default:
				preInstr_isLoad= 1'b0;
		endcase
	end

	always @ (*) begin
		if(rst) begin
			is_in_delayslot_o <= `NotInDelaySlot;
		end else begin
			is_in_delayslot_o <= is_in_delayslot_i;
		end
	end


	always @(*) begin
		if(rst==`RstEnable)begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			branch_target_address_o <= 32'h00000000;
			InstrIsValid <= `InstValid;
			imm <= 32'h0;
			m_reg1_read_o <= 1'b0;
			m_reg2_read_o <= 1'b0;
			link_addr_o <= 32'h00000000;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			branch_flag_o <= `NotBranch;
			next_inst_in_delayslot_o <= `NotInDelaySlot;
			wd_o <= `NOPRegAddr;
			wreg_o <= `DISABLED;
		end
		else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `DISABLED;
			InstrIsValid <= `InstInvalid;
			m_reg1_read_o <= 1'b0;
			m_reg2_read_o <= 1'b0;
			imm <= 32'h00000000;
			link_addr_o <= 32'h00000000;
			branch_target_address_o <= 32'h00000000;
			branch_flag_o <= `NotBranch;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];
			next_inst_in_delayslot_o <= `NotInDelaySlot;
			case (op)
				`SPECIAL:
				case (func)
					`ADDU:begin
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_ADDU_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						
					end
					`SUBU:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SUBU_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;
					end
					`ADD:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_ADD_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;
					end
					`SUB:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SUB_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`AND:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_AND_OP;
						alusel_o <= `EXE_RES_LOGIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`OR:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_OR_OP;
						alusel_o <= `EXE_RES_LOGIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;
					end
					`XOR:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_XOR_OP;
						alusel_o <= `EXE_RES_LOGIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;


					end
					`NOR:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_NOR_OP;
						alusel_o <= `EXE_RES_LOGIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`SLT:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SLT_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`SLTU:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SLTU_OP;
						alusel_o <= `EXE_RES_ARITHMETIC;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`SRL:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SRL_OP;
						alusel_o <= `EXE_RES_SHIFT;
						m_reg1_read_o <= 1'b0;
						m_reg2_read_o <= 1'b1;
						imm[4:0] <= inst_i[10:6];
						wd_o <= inst_i[15:11];
						InstrIsValid <= `InstValid;

					end
					`SRA:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SRA_OP;
						alusel_o <= `EXE_RES_SHIFT;
						m_reg1_read_o <= 1'b0;
						m_reg2_read_o <= 1'b1;
						imm[4:0] <= inst_i[10:6];
						wd_o <= inst_i[15:11];
						InstrIsValid <= `InstValid;

					end
					`SLL:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SLL_OP;
						alusel_o <= `EXE_RES_SHIFT;
						m_reg1_read_o <= 1'b0;
						m_reg2_read_o <= 1'b1;
						imm[4:0] <= inst_i[10:6];
						wd_o <= inst_i[15:11];
						InstrIsValid <= `InstValid;

					end
					`SLLV:begin
						wreg_o <= `ENABLED;
						aluop_o <= `EXE_SLL_OP;
						alusel_o <= `EXE_RES_SHIFT;
						m_reg1_read_o <= 1'b1;
						m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`SRLV:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_SRL_OP;
						alusel_o <= `EXE_RES_SHIFT;		m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`SRAV:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_SRA_OP;
						alusel_o <= `EXE_RES_SHIFT;		m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
					`JR:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_JR_OP;
						alusel_o <= `EXE_RES_JUMP_BRANCH;   m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
						link_addr_o <= 32'h00000000;

						branch_target_address_o <= reg1_o;
						branch_flag_o <= `Branch;

						next_inst_in_delayslot_o <= `InDelaySlot;
						InstrIsValid <= `InstValid;

					end
					`MULTU:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_MULTU_OP;
						m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					end
					`DIV:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_DIV_OP;
						m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					end
					`DIVU:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_DIVU_OP;
						m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					end
					`MFHI:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_MFHI_OP;
						alusel_o <= `EXE_RES_MOVE;   m_reg1_read_o <= 1'b0;	m_reg2_read_o <= 1'b0;
						InstrIsValid <= `InstValid;
					end
					`MFLO:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_MFLO_OP;
						alusel_o <= `EXE_RES_MOVE;   m_reg1_read_o <= 1'b0;	m_reg2_read_o <= 1'b0;
						InstrIsValid <= `InstValid;
					end
					`MTHI:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_MTHI_OP;
						m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0; InstrIsValid <= `InstValid;

					end
					`MTLO:begin
						wreg_o <= `DISABLED;		aluop_o <= `EXE_MTLO_OP;
						m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0; InstrIsValid <= `InstValid;

					end
					`BREAK:begin


					end
					`SYSCALL:begin


					end
					`TEQ:begin


					end
					`JALR:begin
						branch_target_address_o <= reg1_o;
						branch_flag_o <= `Branch;
						wreg_o <= `ENABLED;		aluop_o <= `EXE_JALR_OP;
						alusel_o <= `EXE_RES_JUMP_BRANCH;   m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
						wd_o <= inst_i[15:11];
						link_addr_o <= pc_add_8;



						next_inst_in_delayslot_o <= `InDelaySlot;
						InstrIsValid <= `InstValid;

					end
				endcase //endcase of SPECIAL




				`SPECIAL2:
				case(func)
					`CLZ:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_CLZ_OP;
						alusel_o <= `EXE_RES_ARITHMETIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
						InstrIsValid <= `InstValid;

					end
					`MUL:begin
						wreg_o <= `ENABLED;		aluop_o <= `EXE_MUL_OP;
						alusel_o <= `EXE_RES_MUL; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1;
						InstrIsValid <= `InstValid;

					end
				endcase // func



				`COP0:
				case (rs)
					`MFC0:begin

					end
					`MTC0:begin


					end
					`ERET:begin


					end
				endcase


				`BGEZ:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_BGEZ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					InstrIsValid <= `InstValid;
					if(reg1_o[31] == 1'b0) begin
						branch_target_address_o <= pc_add_4 + m_imm_signedExtern;
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
					end
				end
				`LB:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_LB_OP;
					alusel_o <= `EXE_RES_LOAD_STORE; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					wd_o <= inst_i[20:16]; InstrIsValid <= `InstValid;
				end
				`LBU:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_LBU_OP;
					alusel_o <= `EXE_RES_LOAD_STORE; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					wd_o <= inst_i[20:16]; InstrIsValid <= `InstValid;


				end
				`LH:begin

					wreg_o <= `ENABLED;		aluop_o <= `EXE_LH_OP;
					alusel_o <= `EXE_RES_LOAD_STORE; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					wd_o <= inst_i[20:16]; InstrIsValid <= `InstValid;


				end
				`LHU:begin

					wreg_o <= `ENABLED;		aluop_o <= `EXE_LHU_OP;
					alusel_o <= `EXE_RES_LOAD_STORE; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					wd_o <= inst_i[20:16]; InstrIsValid <= `InstValid;


				end
				`SB:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_SB_OP;
					m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					alusel_o <= `EXE_RES_LOAD_STORE;


				end
				`SH:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_SH_OP;
					m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					alusel_o <= `EXE_RES_LOAD_STORE;

				end




				`ADDI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_ADDI_OP;
					alusel_o <= `EXE_RES_ARITHMETIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`ADDIU:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_ADDIU_OP;
					alusel_o <= `EXE_RES_ARITHMETIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`ANDI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_AND_OP;
					alusel_o <= `EXE_RES_LOGIC;	m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {16'h0, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`ORI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {16'h0, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;
				end
				`XORI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_XOR_OP;
					alusel_o <= `EXE_RES_LOGIC;	m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {16'h0, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`LW:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_LW_OP;
					alusel_o <= `EXE_RES_LOAD_STORE; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					wd_o <= inst_i[20:16]; InstrIsValid <= `InstValid;

				end
				`SW:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_SW_OP;
					m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1; InstrIsValid <= `InstValid;
					alusel_o <= `EXE_RES_LOAD_STORE;

				end
				`BEQ:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_BEQ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1;
					InstrIsValid <= `InstValid;
					if(reg1_o == reg2_o) begin
						branch_target_address_o <= pc_add_4 + m_imm_signedExtern;
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
					end

				end
				`BNE:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_BLEZ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b1;
					InstrIsValid <= `InstValid;
					if(reg1_o != reg2_o) begin
						branch_target_address_o <= pc_add_4 + m_imm_signedExtern;
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
					end
				end
				`SLTI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_SLT_OP;
					alusel_o <= `EXE_RES_ARITHMETIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`SLTIU:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_SLTU_OP;
					alusel_o <= `EXE_RES_ARITHMETIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`LUI:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC; m_reg1_read_o <= 1'b1;	m_reg2_read_o <= 1'b0;
					imm <= {inst_i[15:0], 16'h0};
					wd_o <= inst_i[20:16];
					InstrIsValid <= `InstValid;

				end
				`J:begin
					wreg_o <= `DISABLED;		aluop_o <= `EXE_J_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH; m_reg1_read_o <= 1'b0;	m_reg2_read_o <= 1'b0;
					link_addr_o <= 32'h00000000;
					branch_target_address_o <= {pc_add_4[31:28], inst_i[25:0], 2'b00};
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
					InstrIsValid <= `InstValid;
				end
				`JAL:begin
					wreg_o <= `ENABLED;		aluop_o <= `EXE_JAL_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH; m_reg1_read_o <= 1'b0;	m_reg2_read_o <= 1'b0;
					wd_o <= 5'b11111;
					link_addr_o <= pc_add_8 ;
					branch_target_address_o <= {pc_add_4[31:28], inst_i[25:0], 2'b00};
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
					InstrIsValid <= `InstValid;

				end
			endcase
		end
	end
	always @ (*) begin
		StallreqLoadrelated_Register1 <= `NoStop;
		if(rst == `RstEnable) begin
			reg1_o <= 32'h00000000;
		end else if(preInstr_isLoad == 1'b1 && ex_wd_i == reg1_addr_o
			&& m_reg1_read_o == 1'b1 ) begin
			StallreqLoadrelated_Register1 <= `Stop;
		end else if((m_reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1)
			&& (ex_wd_i == reg1_addr_o)) begin
			reg1_o <= ex_wdata_i;
		end else if((m_reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1)
			&& (mem_wd_i == reg1_addr_o)) begin
			reg1_o <= mem_wdata_i;
		end else if(m_reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;
		end else if(m_reg1_read_o == 1'b0) begin
			reg1_o <= imm;
		end else begin
			reg1_o <=32'h00000000;
		end
	end

	always @ (*) begin
		StallreqLoadrelated_Register2 <= `NoStop;
		if(rst == `RstEnable) begin
			reg2_o <= 32'h00000000;
		end else if(preInstr_isLoad == 1'b1 && ex_wd_i == reg2_addr_o
			&& m_reg2_read_o == 1'b1 ) begin
			StallreqLoadrelated_Register2 <= `Stop;
		end else if((m_reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1)
			&& (ex_wd_i == reg2_addr_o)) begin
			reg2_o <= ex_wdata_i;
		end else if((m_reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1)
			&& (mem_wd_i == reg2_addr_o)) begin
			reg2_o <= mem_wdata_i;
		end else if(m_reg2_read_o == 1'b1) begin
			reg2_o <= reg2_data_i;
		end else if(m_reg2_read_o == 1'b0) begin
			reg2_o <= imm;
		end else begin
			reg2_o <= 32'h00000000;
		end
	end


endmodule

