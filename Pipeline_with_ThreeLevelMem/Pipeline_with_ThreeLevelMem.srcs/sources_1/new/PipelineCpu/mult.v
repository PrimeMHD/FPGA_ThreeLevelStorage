`timescale 1ns / 1ps

module MULT (
  input [31:0] a,
  input [31:0] b,
  output [63:0] z
);

  assign z=a*b;
 
endmodule