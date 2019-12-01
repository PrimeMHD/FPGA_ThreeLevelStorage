`include "Defination.vh"

module data_ram (
	input	wire										clk,
	input wire										ce,
	input wire										we,
	input wire[31:0]			addr,
	input wire[3:0]								sel,
	input wire[31:0]						data_i,
	output reg[31:0]					data_o
);

	reg[7:0]  m_data_block_0[0:1023];
	reg[7:0]  m_data_block_1[0:1023];
	reg[7:0]  m_data_block_2[0:1023];
	reg[7:0]  m_data_block_3[0:1023];



	always @ (posedge clk) begin
		 if(ce&&we) begin
			  if (sel[3] == 1'b1) begin
		      m_data_block_3[addr[11:2]] <= data_i[31:24];
		    end
			  if (sel[2] == 1'b1) begin
		      m_data_block_2[addr[11:2]] <= data_i[23:16];
		    end
		    if (sel[1] == 1'b1) begin
		      m_data_block_1[addr[11:2]] <= data_i[15:8];
		    end
			  if (sel[0] == 1'b1) begin
		      m_data_block_0[addr[11:2]] <= data_i[7:0];
		    end			   	    
		end
	end
	
	always @ (*) begin
		if (~ce) begin
			data_o <= 32'h00000000;
	  end 
	  else if(~we) begin
		    data_o <= {m_data_block_3[addr[11:2]],
		               m_data_block_2[addr[11:2]],
		               m_data_block_1[addr[11:2]],
		               m_data_block_0[addr[11:2]]};
		end 
		else begin
				data_o <= 32'h00000000;
		end
	end		

endmodule