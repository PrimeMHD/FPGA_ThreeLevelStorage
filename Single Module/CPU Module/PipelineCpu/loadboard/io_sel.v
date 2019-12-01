`timescale 1ns / 1ps

module io_sel(
    input [31:0] addr,
	 input cs,
	 input sig_w,
	 input sig_r,
	 output seg7_cs,
	 output switch_cs
    );

assign seg7_cs = (addr == 32'h10010000 && cs == 1 && sig_w == 1) ? 1 : 0;
assign switch_cs = (addr == 32'h10010010 && cs == 1 && sig_r == 1) ? 1 : 0;

endmodule