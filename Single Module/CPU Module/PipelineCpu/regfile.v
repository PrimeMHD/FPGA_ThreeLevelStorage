`include "Defination.vh"

module regfile (
	input	wire										clk,
	input wire										rst,
	input wire										we,
	input wire[`RegAddrBus]				waddr,
	input wire[`RegBus]						wdata,
	input wire										re1,
	input wire[`RegAddrBus]			  raddr1,
	output [`RegBus]           rdata1,
	input wire										re2,
	input wire[`RegAddrBus]			  raddr2,
	output [`RegBus]           rdata2
);
reg [31:0] regs [0:31];
	integer i;

	always@(posedge  clk ) begin
		if(rst)  for(i=0;i<32;i=i+1) begin
			regs[i]<=32'b0;
		end
		else begin
			if(we&&waddr!=5'b0) regs[waddr]<=wdata;
		end
	end

	assign rdata1 = (rst==`ENABLED)?`ZeroWord:(raddr1 == `RegNumLog2'h0)?`ZeroWord:(re1 &&(raddr1 == waddr) &&we)?wdata:re1?regs[raddr1]:`ZeroWord;
	assign rdata2 = (rst==`ENABLED)?`ZeroWord:(raddr2 == `RegNumLog2'h0)?`ZeroWord:(re2 &&(raddr2 == waddr) &&we)?wdata:re2?regs[raddr2]:`ZeroWord;

endmodule
