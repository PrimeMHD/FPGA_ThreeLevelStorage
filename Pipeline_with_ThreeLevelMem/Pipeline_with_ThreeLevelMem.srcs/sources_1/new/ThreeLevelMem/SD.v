`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2018/12/22 02:03:14
// Design Name:
// Module Name: SD
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


module SD (
    input clk100mhz,
    input rst,
    /************************/
    input  sd_mem_read_write,//useless
    input  [31:0]sd_mem_addr,
    input  [31:0]sd_mem_data_toSDMEM,//useless
    output reg sd_mem_ready,
    output  [31:0]sd_mem_data_fromSDMEM,
    /*******************/
    input SD_CD,
    output SD_RESET,
    output SD_SCK,
    output SD_CMD,
    inout [3:0] SD_DAT
);

    wire [31:0]sdmem_adr;
    wire [31:0]data_out;
    reg sd_init;
    wire sd_ready;
    always@(posedge clk100mhz or posedge rst)begin
        if(rst)begin
            sd_mem_ready<=1'b0;
            sd_init<=1'b0;

        end
        else begin
            if(~sd_mem_ready)begin
                sd_init<=1'b1;
                if(sd_ready)begin
                    sd_mem_ready<=1'b1;
                    sd_init<=1'b0;
                end
            end
        end
    end




    assign sdmem_adr={18'b0,sd_mem_addr[11:0],2'b00};
    assign sd_mem_data_fromSDMEM=data_out;

    labkit SD_PHY_Controller(
        .CLK100MHZ(clk100mhz),
        .SD_CD    (SD_CD),
        .SD_RESET (SD_RESET),
        .SD_SCK   (SD_SCK),
        .SD_CMD   (SD_CMD),
        .SD_DAT   (SD_DAT),
        .BTNC     (rst),
        .sdmem_adr(sdmem_adr),
        .data_out (data_out),
        .sd_init  (sd_init),
        .sd_ready (sd_ready)
    );


// reg [16:0]counter=0;
//     always@(posedge clk100mhz or posedge rst)begin
//         if(rst)begin
//             sd_mem_ready<=1'b0;
//             counter<=17'b0;
//         end
//         else begin
//             if(counter[3]==1'b1)begin
//                 counter<=counter;
//                 sd_mem_ready<=1'b1;
//             end
//             else begin
//                 counter<=counter+1;
//             end
//         end
//     end
//     sd_mem sd_mem_0(
//         .a(sd_mem_addr[11:0]),
//         .d(sd_mem_data_toSDMEM),
//         .clk(clk100mhz),
//         .we(sd_mem_read_write),
//         .spo(sd_mem_data_fromSDMEM));
endmodule
