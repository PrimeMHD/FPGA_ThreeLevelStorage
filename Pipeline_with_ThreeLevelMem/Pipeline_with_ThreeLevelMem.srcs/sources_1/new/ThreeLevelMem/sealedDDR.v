`include "Defination.vh"
module sealedDDR (
	input clk100mhz,    // Clock
	input rst,
	input [31:0]addr_to_DDR,
	input [31:0]data_to_DDR,
	input read_write,
	output  [31:0]data_from_DDR,
	output reg busy,
	output reg done,
	output  ddr_start_ready,
	/************************/
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
	output [0:0]            ddr2_odt
/************tempLook********/

);

	wire [31:0] reg_addr_in;
	wire [127:0] reg_data_to_DDR;
	wire reg_read_write;

 	



	wire clk200mhz;
	wire [1:0] rdqs_n;
	//reg [31:0]data_in;
	wire ack;

	wire [127:0] app_rd_data;
	wire app_rd_data_valid;
	wire app_rdy;
	assign ddr_start_ready=ddr_is_ready;
	clk_wiz_0 clk_divider(.clk_in1(clk100mhz),.clk_out1(clk200mhz));

	ddr2_wr ddr2_wr_ins(
		.clk_in(clk100mhz),
		.rst(rst),
		//ddr2 parameter
		.ddr2_ck_p(ddr2_ck_p),
		.ddr2_ck_n(ddr2_ck_n),
		.ddr2_cke(ddr2_cke),
		.ddr2_cs_n(ddr2_cs_n),
		.ddr2_ras_n(ddr2_ras_n),
		.ddr2_cas_n(ddr2_cas_n),
		.ddr2_we_n(ddr2_we_n),
		.ddr2_dm(ddr2_dm),
		.ddr2_ba(ddr2_ba),
		.ddr2_addr(ddr2_addr),
		.ddr2_dq(ddr2_dq),
		.ddr2_dqs_p(ddr2_dqs_p),
		.ddr2_dqs_n(ddr2_dqs_n),
		.rdqs_n(rdqs_n),
		.ddr2_odt(ddr2_odt),
		.clk_ref_i(clk200mhz), 
		.addr_i_32(reg_addr_in),
		.data_i(reg_data_to_DDR),
		.stb_i(reg_read_write),
		.ack_o(ack),
		.app_rd_data(app_rd_data),
		.app_rd_data_valid(app_rd_data_valid),
		.app_rdy(app_rdy)
	);
	parameter readInsistLoop=256;
	parameter writeInsistLoop=256;
	parameter ddr_startLoop=256;
	reg [63:0]write_insist_count;
	reg [63:0]read_insist_count;
	reg [64:0]wake_count;
	reg [63:0]before_rdy_count;
	reg ddr_is_ready;
	always @(posedge clk100mhz or posedge rst) begin
		if(rst) begin
		    wake_count<=0;
			busy<=`Busy;
			done<=`UNDONE;
			read_insist_count<=0;
			write_insist_count<=0;
			before_rdy_count<=0;
			ddr_is_ready<=1'b0;
		end
		else if(~ddr_is_ready)begin
			if(before_rdy_count<ddr_startLoop&app_rdy)begin
				before_rdy_count<=before_rdy_count+1;
			end
			else if(app_rdy)begin
				ddr_is_ready<=1'b1;
				busy=`NoBusy;
			end
		end
		else if(busy==`NoBusy&app_rdy&ddr_is_ready|done) begin
			//Only allow accept req when notbusy
			busy<=`Busy;
			done<=`UNDONE;
			read_insist_count<=0;
			write_insist_count<=0;
		end
		else if(busy==`Busy&ddr_is_ready)begin
			if(reg_read_write==`WRITE)begin
				if(write_insist_count>=writeInsistLoop)begin
					done<=`DONE;
					busy<=`NoBusy;
				end
				else begin
				    write_insist_count<=write_insist_count+1;
				end
			end
			else if(reg_read_write==`READ)begin
				if(read_insist_count>=readInsistLoop&app_rd_data_valid)begin
					done<=`DONE;
					busy<=`NoBusy;
				end
				else begin
				    read_insist_count<=read_insist_count+1;
				end
			end
		end
		else begin 
			done<=`UNDONE;
		end
	end

assign data_from_DDR=app_rd_data[31:0];
assign reg_addr_in=addr_to_DDR;
assign reg_read_write=read_write;
assign reg_data_to_DDR={96'b0,data_to_DDR};

endmodule