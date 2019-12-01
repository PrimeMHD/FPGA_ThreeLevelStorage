`timescale 1ns / 1ps
/*1551867 �׺ƶ�*/
module MULTU(
input unsigned[31:0] a, // ���� a(������)
input unsigned[31:0] b, // ���� b(����)
output unsigned[63:0] z // �˻���� z
) ;
assign z=a*b;

endmodule
