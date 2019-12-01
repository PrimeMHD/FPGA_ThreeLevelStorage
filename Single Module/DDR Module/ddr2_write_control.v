`timescale 1ns / 1ps

module ddr2_write_control(
    clk_in,
    rst_n,
    ADDR_I,
    DATA_I,
    STB_I,
    ACK_O,
    read_en,
    //ddr_ signals
    app_en,
    app_wdf_wren,
    app_wdf_end,
    app_cmd,
    app_addr,
    app_wdf_data,
    app_rdy,
    app_wdf_rdy
    );

    parameter DQ_WIDTH          = 16;
    parameter ECC_TEST          = "OFF";
    parameter ADDR_WIDTH        = 27;
    parameter nCK_PER_CLK       = 4;

    localparam DATA_WIDTH       = 16;
    localparam PAYLOAD_WIDTH    = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
    localparam APP_DATA_WIDTH   = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;  //突发长度为8
    localparam APP_MASK_WIDTH   = APP_DATA_WIDTH / 8;

    input clk_in;
    input rst_n;  
    input [26:0] ADDR_I;    //读取地址、偏移
    input [127:0] DATA_I;  //需要写入的数据
    input STB_I;    //选通信号
    output reg ACK_O;    //可以接收数据标志位，高有效
    output reg read_en;

    // Wire declarations
    output reg app_en, app_wdf_wren, app_wdf_end;
    output reg [2:0] app_cmd;
    output reg [ADDR_WIDTH-1:0] app_addr;
    output reg [APP_DATA_WIDTH-1:0] app_wdf_data;
    input app_rdy, app_wdf_rdy;

    //生成写入数据的信号值
    //----------FSM--------
    reg [2:0] cstate;

    parameter IDLE = 3'b001;
    parameter WRITE = 3'b010;

    reg [3:0] write_count;


    always @(posedge clk_in)
    begin
        if(rst_n) begin
            app_cmd <= 3'b1;
            app_en <= 1'b0;
            app_wdf_data <= 128'h0;
            app_addr <= 27'h0;
            app_wdf_end <= 1'b0;
            app_wdf_wren <= 1'b0;
            write_count <= 0;
            read_en <= 0;
            ACK_O <= 0;
            cstate <= IDLE;
        end
        else if(STB_I) begin
            case(cstate)
                IDLE:begin
                    if(app_rdy & app_wdf_rdy) begin
                        app_wdf_data <= DATA_I;
                        app_cmd <= 3'b0;
                        app_addr <= ADDR_I;
                        app_wdf_wren <= 1'b1;
                        app_wdf_end <= 1'b1;
                        app_en <= 1'b1;
                        ACK_O <= 0;  //可以接收数据
                        write_count <= write_count + 1;
                        cstate <= WRITE;
                    end
                    else cstate <= IDLE; 
                end
                WRITE:begin
                    app_en <= 1'b0;
                    app_cmd <= 3'b1;
                    ACK_O <= 1;
                    app_wdf_wren <= 1'b0;
                    app_wdf_end <= 0;
                    if(write_count == 3)
                        read_en <= 1;
                    cstate <= IDLE;
                end
                default:cstate <= IDLE;
            endcase
        end
        else begin
            app_en <= 0;
            app_wdf_wren <= 0;
            app_wdf_end <= 0;
            ACK_O <= 0;
            cstate <= IDLE;
        end
    end


endmodule
