`timescale 1ns / 1ps
`include "Defination.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 01:39:59
// Design Name: 
// Module Name: MDU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MDU(
        input clk,rst,
        input [2:0] mul_div_control,
        input [31:0] rdata1,rdata2,
        input mem_whilo_i,
        input wb_whilo_i,
        input [31:0]mem_hi_i,mem_lo_i,
        input [31:0]wb_hi_i,wb_lo_i,
        input [31:0]hi_i,lo_i,
        output [63:0] mul_out,
        output reg pc_ena,
        output reg [31:0] hi,lo,
        output  reg[`RegBus] HI,
        output  reg[`RegBus] LO
        );
  
    wire div_start,divu_start,div_busy,divu_busy,div_over,divu_over;
    wire [63:0] mult_out,multu_out,div_out,divu_out;
    
    assign    mul_out    =    mult_out;
    always@(*)begin
        case(mul_div_control)
            `MD_DIV:    pc_ena    =    div_over ||mul_div_control!=`MD_DIV;
            `MD_DIVU:    pc_ena    =    divu_over||mul_div_control!=`MD_DIVU;
            default:pc_ena    =    `ENABLED;
        endcase
    end
    
    assign    div_start    =    mul_div_control==`MD_DIV&&!div_busy;
    assign    divu_start    =    mul_div_control==`MD_DIVU&&!divu_busy;
    
    always@(*)begin
        if(rst) begin
            hi<=32'b0;
            lo<=32'b0;
        end
        else begin
            
            case(mul_div_control)
               `MD_MUL:    {hi,lo}    <=    mult_out;
               `MD_MULTU:    {hi,lo}    <=    multu_out;
               `MD_DIV:    {lo,hi}    <=    div_out;
               `MD_DIVU:    {lo,hi}    <=    divu_out;
               `MD_MTHI:    {hi,lo}         <=    {rdata1,LO};
               `MD_MTLO:    {hi,lo}        <=   {HI, rdata1};
               default:{hi,lo}<=64'b0;
            endcase
        end 
    end
    
    always @ (*) begin
             if(rst) begin
                 {HI,LO} <= {`ZeroWord,`ZeroWord};
             end else if(mem_whilo_i == `WriteEnable) begin
                 {HI,LO} <= {mem_hi_i,mem_lo_i};
             end else if(wb_whilo_i == `WriteEnable) begin
                 {HI,LO} <= {wb_hi_i,wb_lo_i};
             end else begin
                 {HI,LO} <= {hi_i,lo_i};
             end
         end
    MULT multiplier(
        .a(rdata1),
        .b(rdata2),
        .z(mult_out));
    
    MULTU multiplier_unsigned(
        .a(rdata1),
        .b(rdata2),
        .z(multu_out));
    
    DIV DIV(
        .dividend(rdata1),
        .divisor(rdata2),
        .clock(clk),
        .reset(mul_div_control!=`MD_DIV),
        .start(div_start),
        .q(div_out[63:32]),
        .r(div_out[31:0]),
        .over(div_over),
        .busy(div_busy));
    
    DIVU DIVU(
        .dividend(rdata1),
        .divisor(rdata2),
        .clock(clk),
        .reset(mul_div_control!=`MD_DIVU),
        .start(divu_start),
        .q(divu_out[63:32]),
        .r(divu_out[31:0]),
        .over(divu_over),
        .busy(divu_busy));
endmodule
