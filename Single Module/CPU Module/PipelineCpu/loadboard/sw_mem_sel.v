`timescale 1ns / 1ps
module sw_mem_sel(
    input  switch_cs,
	 input [15:0] sw,
	 input [31:0] data,
	 output [31:0] data_sel
    );

    assign data_sel = (switch_cs) ? {16'b0, sw[15:0]} : data;
endmodule
