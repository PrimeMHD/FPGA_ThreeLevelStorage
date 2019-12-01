`include "Defination.vh"

module mem_wb(

	input	wire										clk,
	input wire										rst,
	input wire[5:0]               stall,	
	input wire[4:0]       mem_wd,
	input wire                    mem_wreg,
	input wire[31:0]					 mem_wdata,
	input wire[31:0]           mem_hi,
	input wire[31:0]           mem_lo,
	input wire                    mem_whilo,	
	output reg[4:0]      wb_wd,
	output reg                   wb_wreg,
	output reg[31:0]					 wb_wdata,
	output reg[31:0]          wb_hi,
	output reg[31:0]          wb_lo,
	output reg                   wb_whilo
		       
	
);


	always @ (posedge clk) begin
		if(rst) begin
			wb_wd <= 5'b00000;
			wb_wreg <= `DISABLED;
			wb_lo <= 32'h00000000;
		  wb_wdata <= 32'h00000000;	
		  wb_hi <= 32'h00000000;
		  
		  wb_whilo <= `DISABLED;		  	
		end else if(stall[4] == 1'b1 && stall[5] == 1'b0) begin
			wb_wd <= 5'b00000;
			wb_wreg <= `DISABLED;
		  wb_wdata <= 32'h00000000;
		  wb_hi <= 32'h00000000;
		  wb_lo <= 32'h00000000;
		  wb_whilo <= `DISABLED;	
		  	  	  
		end else if(stall[4] == 1'b0) begin
			wb_wdata <= mem_wdata;
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			
			wb_lo <= mem_lo;
			wb_hi <= mem_hi;
			
			wb_whilo <= mem_whilo;				
		end   
	end      
			

endmodule