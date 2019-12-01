`include "Defination.vh"

module hilo_reg(

	input	wire										clk,
	input wire										rst,
	input wire										we,
	input wire[31:0]				    hi_i,
	input wire[31:0]						lo_i,
	output reg[31:0]           hi_o,
	output reg[31:0]           lo_o
	
);

	always @ (posedge clk) begin
		if (rst) begin
		lo_o <= 32'h00000000;
					hi_o <= 32'h00000000;
					
		end else if(we) begin
		lo_o <= lo_i;
					hi_o <= hi_i;
					
		end
	end

endmodule