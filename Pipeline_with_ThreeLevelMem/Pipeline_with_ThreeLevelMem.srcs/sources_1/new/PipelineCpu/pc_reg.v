`include "Defination.vh"

module pc_reg (
	input clk,
	input rst,
	input [5:0]stall,
	input branch_flag_i,
	input [31:0] branch_target_address_i,
	output reg[31:0] pc,
	output reg ce
);

	wire [31:0]npc=pc+4;
	always @ (posedge clk) begin

		if (rst) begin
			ce <= `DISABLED;
		end else begin
			ce <= `ENABLED;
		end

		if (~ce) begin
			pc <= 32'h00000000;
		end else if(stall[0] == `NoStop) begin
			if(branch_flag_i == `Branch) begin
				pc <= branch_target_address_i;
			end else begin
				pc <= npc;
			end
		end
	end
endmodule