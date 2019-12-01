`include "Defination.vh"

module ex (
	input clk,
	input wire										rst,
	//送到执行阶段的信息
	input wire[7:0]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,
	input wire[`RegBus]           inst_i,
	//HI、LO寄存器的值
	input wire[`RegBus]           hi_i,
	input wire[`RegBus]           lo_i,
	//回写阶段的指令是否要写HI、LO，用于检测HI、LO的数据相关
	input wire[`RegBus]           wb_hi_i,
	input wire[`RegBus]           wb_lo_i,
	input wire                    wb_whilo_i,
	//访存阶段的指令是否要写HI、LO，用于检测HI、LO的数据相关
	input wire[`RegBus]           mem_hi_i,
	input wire[`RegBus]           mem_lo_i,
	input wire                    mem_whilo_i,
	input wire[`DoubleRegBus]     hilo_temp_i,
	input wire[1:0]               cnt_i,
	
	//是否转移、以及link address
	input wire[`RegBus]           link_address_i,
	input wire                    is_in_delayslot_i,
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]						wdata_o,
	output [`RegBus]           hi_o,
	output [`RegBus]           lo_o,
	output reg                    whilo_o,
	output reg[`DoubleRegBus]     hilo_temp_o,
	output reg[1:0]               cnt_o,
	//下面新增的几个输出是为加载、存储指令准备的
	output wire[7:0]        aluop_o,
	output wire[`RegBus]          mem_addr_o,
	output wire[`RegBus]          reg2_o,
	output 	wire									stallreq
);



	wire[`RegBus] HI;
	wire[`RegBus] LO;
	reg[`RegBus] MovResult;
	reg [31:0]alu_a_toalu;
	reg [31:0]alu_b_toalu;
	reg [3:0]alu_opcode_toalu;
	reg [3:0]output_source;

	wire[`RegBus] m_mux_reg2i;
	wire[`RegBus] m_sum_result;
	wire m_sum_ov;
	wire[`RegBus] opdata1_mult;
	wire[`RegBus] opdata2_mult;
	wire[`DoubleRegBus] m_hilo_temp;
	reg[`DoubleRegBus] m_high_temp1;
	reg[`RegBus] clz_result;
	assign aluop_o    = aluop_i;
	assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
	assign reg2_o     = reg2_i;
	wire [31:0]result_from_alu;
	wire alu_zero,alu_carry,alu_negative,alu_overflow;//暂时没什么用





	alu i_ALU (
		.a(alu_a_toalu),
		.b(alu_b_toalu),
		.aluc(alu_opcode_toalu),
		.r(result_from_alu),
		.zero(alu_zero),
		.carry(alu_carry),
		.negative(alu_negative),
		.overflow(alu_overflow));


	wire [63:0]mul_out_fromMD;
	reg [2:0]mul_div_control;
	wire not_stallreq_for_divide;


	MDU I_MDU(
		.clk(clk),
		.rst(rst),
		.mul_div_control(mul_div_control),//来自ex
		.rdata1(reg1_i),
		.rdata2(reg2_i),
		.mem_whilo_i(mem_whilo_i),
        .wb_whilo_i(wb_whilo_i),
        .mem_hi_i(mem_hi_i),
		.mem_lo_i(mem_lo_i),
        .wb_hi_i(wb_hi_i),
		.wb_lo_i(wb_lo_i),
        .hi_i(hi_i),
		.lo_i(lo_i),


		//////////////////
		.mul_out(mul_out_fromMD),
		.pc_ena(not_stallreq_for_divide),
		.hi(hi_o),
		.lo(lo_o),
		.HI(HI),
		.LO(LO)

		);






	always@(*)begin
		if(rst)begin
			whilo_o <= `WriteDisable;
			MovResult <= `ZeroWord;
			output_source<={1'b0,alusel_i};
			cnt_o <= 2'b00;
			mul_div_control<=`MD_NO;
		end else begin



			output_source<={1'b0,alusel_i};
			MovResult <= `ZeroWord;

			whilo_o <= `WriteDisable;
			mul_div_control<=`MD_NO;

			case(aluop_i)
				`EXE_OR_OP:	begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_OR;
				end
				`EXE_NOR_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_NOR;
				end
				`EXE_XOR_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_XOR;
				end
				`EXE_AND_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_AND;
				end
				//LOGICAL





				`EXE_SLL_OP:begin
					alu_opcode_toalu   <= `_SLL;
					alu_a_toalu<= reg1_i[4:0];
					alu_b_toalu<=reg2_i;
				end
				`EXE_SRL_OP:		begin
					alu_opcode_toalu   <= `_SRL;
					alu_a_toalu<= reg1_i[4:0];
					alu_b_toalu<=reg2_i;
				end
				`EXE_SRA_OP:		begin
					alu_opcode_toalu   <= `_SRA;
					alu_a_toalu<= reg1_i[4:0];
					alu_b_toalu<=reg2_i;
				end
				//SHIFT





				`EXE_SLT_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_SLT;
				end

				`EXE_SLTU_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu<= `_SLTU;
				end
				`EXE_ADD_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_ADD;
				end
				`EXE_ADDU_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_ADDU;
				end
				`EXE_ADDI_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_ADD;
				end
				`EXE_ADDIU_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_ADDU;
				end
				`EXE_SUB_OP:begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_SUB;
				end
				`EXE_SUBU_OP:		begin
					alu_a_toalu<=reg1_i;
					alu_b_toalu<=reg2_i;
					alu_opcode_toalu   <= `_SUBU;
				end
				`EXE_CLZ_OP:begin
					casez(reg1_i)
						32'b1???????????????????????????????:   clz_result  <=       32'h0;
						32'b01??????????????????????????????:   clz_result  <=       32'h1;
						32'b001?????????????????????????????:   clz_result  <=       32'h2;
						32'b0001????????????????????????????:   clz_result  <=       32'h3;
						32'b00001???????????????????????????:   clz_result  <=       32'h4;
						32'b000001??????????????????????????:   clz_result  <=       32'h5;
						32'b0000001?????????????????????????:   clz_result  <=       32'h6;
						32'b00000001????????????????????????:   clz_result  <=       32'h7;
						32'b000000001???????????????????????:   clz_result  <=       32'h8;
						32'b0000000001??????????????????????:   clz_result  <=       32'h9;
						32'b00000000001?????????????????????:   clz_result  <=       32'ha;
						32'b000000000001????????????????????:   clz_result  <=       32'hb;
						32'b0000000000001???????????????????:   clz_result  <=       32'hc;
						32'b00000000000001??????????????????:   clz_result  <=       32'hd;
						32'b000000000000001?????????????????:   clz_result  <=       32'he;
						32'b0000000000000001????????????????:   clz_result  <=       32'hf;
						32'b00000000000000001???????????????:   clz_result  <=       32'h10;
						32'b000000000000000001??????????????:   clz_result  <=       32'h11;
						32'b0000000000000000001?????????????:   clz_result  <=       32'h12;
						32'b00000000000000000001????????????:   clz_result  <=       32'h13;
						32'b000000000000000000001???????????:   clz_result  <=       32'h14;
						32'b0000000000000000000001??????????:   clz_result  <=       32'h15;
						32'b00000000000000000000001?????????:   clz_result  <=       32'h16;
						32'b000000000000000000000001????????:   clz_result  <=       32'h17;
						32'b0000000000000000000000001???????:   clz_result  <=       32'h18;
						32'b00000000000000000000000001??????:   clz_result  <=       32'h19;
						32'b000000000000000000000000001?????:   clz_result  <=       32'h1a;
						32'b0000000000000000000000000001????:   clz_result  <=       32'h1b;
						32'b00000000000000000000000000001???:   clz_result  <=       32'h1c;
						32'b000000000000000000000000000001??:   clz_result  <=       32'h1d;
						32'b0000000000000000000000000000001?:   clz_result  <=       32'h1e;
						32'b00000000000000000000000000000001:   clz_result  <=        32'h1f;
						32'b00000000000000000000000000000000:   clz_result  <=       32'h20;
					endcase
					output_source<=`EX_OUTPUT_SOURCE_CLZ;
				end
				//ARITHMETIC





				//MULDIV
				`EXE_MUL_OP:begin
					mul_div_control        <=    `MD_MUL;
					whilo_o <= `WriteEnable;
				end
				// `EXE_MULT_OP:begin
				// 	mul_div_control        <=    `MD_MULT;
				// end
				`EXE_MULTU_OP: begin
					mul_div_control      <= `MD_MULTU;
					whilo_o <= `WriteEnable;
				end
				`EXE_MTHI_OP:begin
					mul_div_control        <=    `MD_MTHI;
					whilo_o <= `WriteEnable;
				end
				`EXE_MTLO_OP: begin
					mul_div_control        <=    `MD_MTLO;
					whilo_o <= `WriteEnable;
				end
				`EXE_MFHI_OP:begin

					MovResult <= HI;
				end
				`EXE_MFLO_OP:begin
					MovResult <= LO;
				end
				`EXE_DIV_OP:begin
					mul_div_control <= `MD_DIV;
					whilo_o <= `WriteEnable;
				
				end
				`EXE_DIVU_OP:		begin
					mul_div_control <= `MD_DIVU;
					whilo_o <= `WriteEnable;
			
				end
				default:begin

				end
			endcase
		end

	end



	always @ (*) begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		case ( output_source )
			`EX_OUTPUT_SOURCE_CLZ:
			wdata_o <= clz_result;
			{1'b0,`EXE_RES_LOGIC}:begin
				wdata_o <= result_from_alu;
			end
			{1'b0,`EXE_RES_SHIFT}:begin
				wdata_o <= result_from_alu;
			end
			{1'b0,`EXE_RES_ARITHMETIC}:		begin
				wdata_o <= result_from_alu;
			end

			{1'b0,`EXE_RES_MOVE}:		begin
				wdata_o <= MovResult;
			end
			{1'b0,`EXE_RES_MUL}:		begin
				wdata_o <= mul_out_fromMD[31:0];
			end
			{1'b0,`EXE_RES_JUMP_BRANCH}:	begin
				wdata_o <= link_address_i;
			end
			default:					begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end

	assign stallreq = ~not_stallreq_for_divide;

endmodule
