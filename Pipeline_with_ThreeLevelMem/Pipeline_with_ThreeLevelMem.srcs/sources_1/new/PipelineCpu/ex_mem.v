`include "Defination.vh"

module ex_mem(

	input	wire										clk,
	input wire										rst,
	input wire[5:0]							 stall,		
	input wire[4:0]       ex_wd,
	input wire                    ex_wreg,
	input wire[31:0]					 ex_wdata, 	
	input wire[31:0]           ex_hi,
	input wire[31:0]           ex_lo,
	input wire                    ex_whilo, 	
  input wire[7:0]        ex_aluop,
	input wire[31:0]          ex_mem_addr,
	input wire[31:0]          ex_reg2,

	input wire[63:0]     hilo_i,	
	input wire[1:0]               cnt_i,	
	output reg[4:0]      mem_wd,
	output reg                   mem_wreg,
	output reg[31:0]					 mem_wdata,
	output reg[31:0]          mem_hi,
	output reg[31:0]          mem_lo,
	output reg                   mem_whilo,
  output reg[7:0]        mem_aluop,
	output reg[31:0]          mem_mem_addr,
	output reg[31:0]          mem_reg2,
		
	output reg[63:0]    hilo_o,
	output reg[1:0]              cnt_o	
	
	
);


	always @ (posedge clk) begin
		if(rst) begin
			mem_wd <= 5'b00000;
		 mem_wdata <= 32'h00000000;
			
			mem_wreg <= 1'b0;
		 	 mem_lo <= 32'h00000000;
		  mem_hi <= 32'h00000000;
		 cnt_o <= 2'b00;	
		  mem_whilo <= 1'b0;		
	    hilo_o <= {32'h00000000, 32'h00000000};
			mem_mem_addr <= 32'h00000000;
  		mem_aluop <= `EXE_NOP_OP;
			mem_reg2 <= 32'h00000000;			
		end else if(stall[3] == 1'b1 && stall[4] == 1'b0) begin
			mem_wreg <= 1'b0;
			mem_lo <= 32'h00000000;
			mem_wd <= 5'b00000;
		  mem_wdata <= 32'h00000000;
		  mem_hi <= 32'h00000000;
		  cnt_o <= cnt_i;	
		  mem_whilo <= 1'b0;
	    	hilo_o <= hilo_i;
			mem_mem_addr <= 32'h00000000;
  			mem_aluop <= `EXE_NOP_OP;
			mem_reg2 <= 32'h00000000;						  				    
		end else if(stall[3] == 1'b0) begin
			mem_wdata <= ex_wdata;
			mem_wd <= ex_wd;
			mem_lo <= ex_lo;
			mem_wreg <= ex_wreg;
			mem_whilo <= ex_whilo;	
			mem_hi <= ex_hi;
			
			cnt_o <= 2'b00;	
	    hilo_o <= {32'h00000000, 32'h00000000};
			mem_mem_addr <= ex_mem_addr;
  		mem_aluop <= ex_aluop;
			
			mem_reg2 <= ex_reg2;			
		end else begin
		cnt_o <= cnt_i;	
	    hilo_o <= hilo_i;
													
		end    
	end      
			

endmodule