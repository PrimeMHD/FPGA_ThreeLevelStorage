`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 20:34:45
// Design Name: 
// Module Name: ddr2_read_control
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


module ddr2_read_control(
    input clk_in,
    input rst_n,
    input enable,

    input [26:0]addr_read,


    //ddr2 mig signals
    output reg app_en,
    output reg [2:0] app_cmd,
    output reg [26:0] app_addr,
    input [127:0] app_rd_data,
    input app_rdy,
    input app_rd_data_end,
    input app_rd_data_valid
    );

   

    reg [26:0] app_addr_tmp;

    //读取FSM
    reg [4:0] cstate;
    
    localparam IDLE = 5'b0_0001;
    localparam READ = 5'b0_0010;
    localparam WAIT = 5'b0_0100;
    localparam ADDR_ACCUMULATE = 5'b0_1000;
    localparam WAIT_FOR_CONFIG = 5'b1_0000;

    always @(posedge clk_in)
    begin
        if(rst_n) begin
            app_en <= 0;
            app_addr<=0;
            cstate <= IDLE;
        end
        else if(enable) begin
            case(cstate)
            IDLE:begin
                app_en <= 1;
                app_addr<=addr_read;
                app_cmd <= 3'b001;
                cstate <= READ;
            end
            READ:begin
                if(app_rdy) begin
                    app_en <= 1'b0;
                    app_addr<=addr_read;
                    cstate <= IDLE;
                end
            end
            default:cstate <= IDLE;
            endcase
        end 
        else begin
            app_en <= 1'b0;
            cstate <= IDLE;
        end 
    end

endmodule
