`include "Defination.vh"

module CPU (
	input	wire										clk,
	input wire										rst,
	input wire[31:0]           rom_data_i,
	input DataBus_busy,
    input DataBus_done,

	output wire[31:0]           rom_addr_o,
	output wire                    rom_ce_o,
	input wire[31:0]           ram_data_i,
	output wire[31:0]           ram_addr_o,
	output wire[31:0]           ram_data_o,
	output wire                    ram_we_o,
	output wire[3:0]               ram_sel_o,
	output wire               ram_ce_o
);


	wire[31:0] pc;
	wire[31:0] connector_id_pc_i;
	wire[31:0] connector_id_inst_i;

	wire[7:0] connector_id_aluop_o;
	wire[2:0] connector_id_alusel_o;
	wire[31:0] connector_id_reg1_o;
	wire[31:0] connector_id_reg2_o;
	wire connector_id_wreg_o;
	wire[4:0] connector_id_wd_o;
	wire connector_id_is_in_delayslot_o;
	wire[31:0] id_link_address_o;
	wire[31:0] id_inst_o;


	wire[7:0] ex_aluop_i;
	wire[2:0] ex_alusel_i;
	wire[31:0] ex_reg1_i;
	wire[31:0] ex_reg2_i;
	wire ex_wreg_i;
	wire[4:0] ex_wd_i;
	wire ex_is_in_delayslot_i;
	wire[31:0] ex_link_address_i;
	wire[31:0] ex_inst_i;
	wire[7:0] ex_aluop_o;
	wire[4:0] ex_wd_o;
	wire[31:0] ex_wdata_o;
	wire[31:0] ex_hi_o;
	wire[31:0] ex_lo_o;
	wire ex_whilo_o;
	wire[31:0] ex_mem_addr_o;
	wire[31:0] connector_ex_reg1_o;
	wire[31:0] connector_ex_reg2_o;
	wire ex_wreg_o;

	wire[7:0] connector_mem_aluop_i;
	wire[31:0] mem_mem_addr_i;
	wire[31:0] mem_reg1_i;
	wire[31:0] mem_reg2_i;

	wire mem_wreg_i;
	wire[4:0] mem_wd_i;
	wire[31:0] mem_wdata_i;

	wire[31:0] mem_hi_i;
	wire[31:0] mem_lo_i;
	wire mem_whilo_i;
	wire[4:0] mem_wd_o;
	wire[31:0] mem_wdata_o;
	wire[31:0] mem_hi_o;
	wire[31:0] mem_lo_o;
	wire mem_wreg_o;


	wire wb_wreg_i;
	wire[31:0] wb_hi_i;
	wire[31:0] wb_lo_i;
	wire[31:0] reg1_data;
	wire[31:0] reg2_data;
	wire[4:0] reg1_addr;
	wire[4:0] reg2_addr;
	wire mem_whilo_o;
	wire mem_LLbit_value_o;
	wire mem_LLbit_we_o;
	wire[4:0] wb_wd_i;
	wire[31:0] wb_wdata_i;
	wire wb_whilo_i;
	wire wb_LLbit_value_i;
	wire wb_LLbit_we_i;

	wire reg1_read;
	wire reg2_read;

	wire[31:0] 	hi;
	wire[31:0]   lo;
	wire[63:0] hilo_temp_o;
	wire[1:0] cnt_o;

	wire[63:0] hilo_temp_i;
	wire[1:0] cnt_i;
	wire[31:0] connector_div_opdata1;
	wire[31:0] connector_div_opdata2;
	wire[63:0] div_result;
	wire div_ready;
	wire next_inst_in_delayslot_o;
	wire connector_id_branch_flag_o;
	wire[31:0] connector_branch_target_address;
	wire connector_div_start;
	wire connector_div_annul;
	wire connector_signed_div;
	wire[5:0] stall;
	wire stallreq_from_id;
	wire stallreq_from_ex;
	wire is_in_delayslot_i;
	wire is_in_delayslot_o;






	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.branch_flag_i(connector_id_branch_flag_o),
		.branch_target_address_i(connector_branch_target_address),
		.pc(pc),
		.ce(rom_ce_o)

	);

	assign rom_addr_o = pc;

	if_id if_id0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(connector_id_pc_i),
		.id_inst(connector_id_inst_i)
	);

	id id0(
		.rst(rst),
		.pc_i(connector_id_pc_i),
		.inst_i(connector_id_inst_i),

		.ex_aluop_i(ex_aluop_o),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),
		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),

		.is_in_delayslot_i(is_in_delayslot_i),

		.m_reg1_read_o(reg1_read),
		.m_reg2_read_o(reg2_read),

		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr),

		.aluop_o(connector_id_aluop_o),
		.alusel_o(connector_id_alusel_o),
		.reg1_o(connector_id_reg1_o),
		.reg2_o(connector_id_reg2_o),
		.wd_o(connector_id_wd_o),
		.wreg_o(connector_id_wreg_o),
		.inst_o(id_inst_o),

		.next_inst_in_delayslot_o(next_inst_in_delayslot_o),
		.branch_flag_o(connector_id_branch_flag_o),
		.branch_target_address_o(connector_branch_target_address),
		.link_addr_o(id_link_address_o),

		.is_in_delayslot_o(connector_id_is_in_delayslot_o),

		.stallreq(stallreq_from_id)
	);



	id_ex id_ex0(
		.clk(clk),
		.rst(rst),

		.stall(stall),

		.id_aluop(connector_id_aluop_o),
		.id_alusel(connector_id_alusel_o),
		.id_reg1(connector_id_reg1_o),
		.id_reg2(connector_id_reg2_o),
		.id_wd(connector_id_wd_o),
		.id_wreg(connector_id_wreg_o),
		.id_link_address(id_link_address_o),
		.id_is_in_delayslot(connector_id_is_in_delayslot_o),
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),
		.id_inst(id_inst_o),
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_wreg(ex_wreg_i),
		.ex_link_address(ex_link_address_i),
		.ex_is_in_delayslot(ex_is_in_delayslot_i),
		.is_in_delayslot_o(is_in_delayslot_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),

		.ex_inst(ex_inst_i)
	);
	regfile regfile1(
		.clk (clk),
		.rst (rst),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data)
	);
	//EXÄ£¿é
	ex ex0(
		.clk(clk),
		.rst(rst),
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.hi_i(hi),
		.lo_i(lo),
		.inst_i(ex_inst_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),


		.wb_hi_i(wb_hi_i),
		.wb_lo_i(wb_lo_i),
		.wb_whilo_i(wb_whilo_i),
		.mem_hi_i(mem_hi_o),
		.mem_lo_i(mem_lo_o),
		.mem_whilo_i(mem_whilo_o),

		.hilo_temp_i(hilo_temp_i),
		.cnt_i(cnt_i),

		.link_address_i(ex_link_address_i),
		.is_in_delayslot_i(ex_is_in_delayslot_i),

		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),

		.hi_o(ex_hi_o),
		.lo_o(ex_lo_o),
		.whilo_o(ex_whilo_o),

		.hilo_temp_o(hilo_temp_o),
		.cnt_o(cnt_o),



		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(connector_ex_reg2_o),

		.stallreq(stallreq_from_ex)

	);

	//EX/MEMÄ£¿é
	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),

		.stall(stall),
		.ex_wdata(ex_wdata_o),
		.ex_hi(ex_hi_o),
		.ex_lo(ex_lo_o),
		.ex_whilo(ex_whilo_o),
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),


		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(connector_ex_reg2_o),
		.hilo_o(hilo_temp_i),
		.cnt_o(cnt_i),
		.hilo_i(hilo_temp_o),
		.cnt_i(cnt_o),
		.mem_aluop(connector_mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i),
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_hi(mem_hi_i),
		.mem_lo(mem_lo_i),
		.mem_whilo(mem_whilo_i),
		.mem_wdata(mem_wdata_i)






	);

	mem mem0(
		.rst(rst),
		.wd_i(mem_wd_i),
		.hi_i(mem_hi_i),
		.lo_i(mem_lo_i),
		.whilo_i(mem_whilo_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),


		.aluop_i(connector_mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),

		.m_mem_data_i(ram_data_i),
		.wd_o(mem_wd_o),
		.whilo_o(mem_whilo_o),
		.mem_addr_o(ram_addr_o),
		.mem_we_o(ram_we_o),
		.m_mem_sel_o(ram_sel_o),
		.mem_data_o(ram_data_o),
		.mem_ce_o(ram_ce_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.hi_o(mem_hi_o),
		.lo_o(mem_lo_o)

	);

	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		.stall(stall),

		.mem_wdata(mem_wdata_o),
		.mem_hi(mem_hi_o),
		.mem_lo(mem_lo_o),
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),

		.wb_wdata(wb_wdata_i),
		.wb_hi(wb_hi_i),
		.wb_lo(wb_lo_i),
		.wb_whilo(wb_whilo_i),
		.mem_whilo(mem_whilo_o),
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i)

	);

	hilo_reg hilo_reg0(
		.clk(clk),
		.rst(rst),
		.hi_o(hi),
		.lo_o(lo),
		.we(wb_whilo_i),
		.hi_i(wb_hi_i),
		.lo_i(wb_lo_i)

	);

	ctrl ctrl0(
		.rst(rst),
		.stallreq_from_id(stallreq_from_id),
		.stallreq_from_ex(stallreq_from_ex),
		.Databus_busy    (DataBus_busy),
		.Databus_done    (DataBus_done),
		.stall(stall)
	);



endmodule