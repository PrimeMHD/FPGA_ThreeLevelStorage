`include "Defination.vh"

module mem(

	input wire										rst,
	input wire[4:0]       wd_i,
	input wire                    wreg_i,
	input wire[31:0]					  wdata_i,
	input wire[31:0]           hi_i,
	input wire[31:0]           lo_i,
	input wire                    whilo_i,	

  input wire[7:0]        aluop_i,
	input wire[31:0]          mem_addr_i,
	input wire[31:0]          reg2_i,

	input wire[31:0]          m_mem_data_i,
	output reg[4:0]      wd_o,
	output reg                   wreg_o,
	output reg[31:0]					 wdata_o,
	output reg[31:0]          hi_o,
	output reg[31:0]          lo_o,
	output reg                   whilo_o,
	output reg[31:0]          mem_addr_o,
	output wire									 mem_we_o,
	output reg[3:0]              m_mem_sel_o,
	output reg[31:0]          mem_data_o,
	output reg                   mem_ce_o	
	
);

 
	wire[31:0] ZERO_32b;
	reg                   m_mem_we;

	assign mem_we_o = m_mem_we ;
	assign ZERO_32b = 32'h00000000;

  
	
	always @ (*) begin
		if(rst) begin
		 wdata_o <= 32'h00000000;
			wd_o <= 5'b00000;
			wreg_o <= `DISABLED;
		 m_mem_we <= `DISABLED;
		  hi_o <= 32'h00000000;
		  whilo_o <= `DISABLED;	
		  lo_o <= 32'h00000000;
		  mem_ce_o <= `DISABLED;	
		  mem_addr_o <= 32'h00000000;
		  mem_data_o <= 32'h00000000;
		  m_mem_sel_o <= 4'b0000;    
		end else begin
		wdata_o <= wdata_i;
		  wd_o <= wd_i;
		  whilo_o <= whilo_i;	
			wreg_o <= wreg_i;
			mem_ce_o <= `DISABLED;
			hi_o <= hi_i;
			lo_o <= lo_i;
				mem_addr_o <= 32'h00000000;
			m_mem_we <= `DISABLED;
			
			m_mem_sel_o <= 4'b1111;
					
			case (aluop_i)
				`EXE_LB_OP:		begin
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `DISABLED;
					mem_ce_o <= `ENABLED;
					case (mem_addr_i[1:0])
						2'b00:	begin
						m_mem_sel_o <= 4'b1000;
							wdata_o <= {{24{m_mem_data_i[31]}},m_mem_data_i[31:24]};
							
						end
						2'b01:	begin
						m_mem_sel_o <= 4'b0100;
							wdata_o <= {{24{m_mem_data_i[23]}},m_mem_data_i[23:16]};
							
						end
						2'b10:	begin
						m_mem_sel_o <= 4'b0010;
							wdata_o <= {{24{m_mem_data_i[15]}},m_mem_data_i[15:8]};
							
						end
						2'b11:	begin
						m_mem_sel_o <= 4'b0001;
							wdata_o <= {{24{m_mem_data_i[7]}},m_mem_data_i[7:0]};
							
						end
						default:	begin
							wdata_o <= 32'h00000000;
						end
					endcase
				end
				`EXE_LBU_OP:		begin
				mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `DISABLED;
					
					case (mem_addr_i[1:0])
						2'b00:	begin
						m_mem_sel_o <= 4'b1000;
							wdata_o <= {{24{1'b0}},m_mem_data_i[31:24]};
							
						end
						2'b01:	begin
							wdata_o <= {{24{1'b0}},m_mem_data_i[23:16]};
							m_mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
						m_mem_sel_o <= 4'b0010;
							wdata_o <= {{24{1'b0}},m_mem_data_i[15:8]};
							
						end
						2'b11:	begin
							wdata_o <= {{24{1'b0}},m_mem_data_i[7:0]};
							m_mem_sel_o <= 4'b0001;
						end
						default:	begin
							wdata_o <= 32'h00000000;
						end
					endcase				
				end
				`EXE_LH_OP:		begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ENABLED;
					m_mem_we <= `DISABLED;
					
					case (mem_addr_i[1:0])
						2'b00:	begin
						m_mem_sel_o <= 4'b1100;
							wdata_o <= {{16{m_mem_data_i[31]}},m_mem_data_i[31:16]};
							
						end
						2'b10:	begin
						m_mem_sel_o <= 4'b0011;
							wdata_o <= {{16{m_mem_data_i[15]}},m_mem_data_i[15:0]};
							
						end
						default:	begin
							wdata_o <= 32'h00000000;
						end
					endcase					
				end
				`EXE_LHU_OP:		begin
				mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `DISABLED;
					
					case (mem_addr_i[1:0])
						2'b00:	begin
						m_mem_sel_o <= 4'b1100;
							wdata_o <= {{16{1'b0}},m_mem_data_i[31:16]};
							
						end
						2'b10:	begin
						m_mem_sel_o <= 4'b0011;
							wdata_o <= {{16{1'b0}},m_mem_data_i[15:0]};
							
						end
						default:	begin
							wdata_o <= 32'h00000000;
						end
					endcase				
				end
				`EXE_LW_OP:		begin
				m_mem_sel_o <= 4'b1111;		
					mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `DISABLED;
					wdata_o <= m_mem_data_i;
					
				end
				
							
				`EXE_SB_OP:		begin
				mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `ENABLED;
					mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
					
					case (mem_addr_i[1:0])
						2'b00:	begin
							m_mem_sel_o <= 4'b1000;
						end
						2'b01:	begin
							m_mem_sel_o <= 4'b0100;
						end
						2'b10:	begin
							m_mem_sel_o <= 4'b0010;
						end
						2'b11:	begin
							m_mem_sel_o <= 4'b0001;	
						end
						default:	begin
							m_mem_sel_o <= 4'b0000;
						end
					endcase				
				end
				`EXE_SH_OP:		begin
				mem_data_o <= {reg2_i[15:0],reg2_i[15:0]};
					mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `ENABLED;
					
					case (mem_addr_i[1:0])
						2'b00:	begin
							m_mem_sel_o <= 4'b1100;
						end
						2'b10:	begin
							m_mem_sel_o <= 4'b0011;
						end
						default:	begin
							m_mem_sel_o <= 4'b0000;
						end
					endcase						
				end
				`EXE_SW_OP:		begin
				mem_data_o <= reg2_i;
					m_mem_sel_o <= 4'b1111;			
					mem_ce_o <= `ENABLED;
					mem_addr_o <= mem_addr_i;
					m_mem_we <= `ENABLED;
					
				end
				default:		begin
         
				end
			endcase							
		end    
	end      
			

endmodule