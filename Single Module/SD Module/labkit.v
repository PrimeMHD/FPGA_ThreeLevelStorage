`timescale 1ns / 1ps
module labkit (
    input CLK100MHZ,
    input SD_CD,
    output SD_RESET,
    output SD_SCK,
    output SD_CMD,
    inout [3:0] SD_DAT,
    output [15:0] LED,
    input BTNC,
    input [31:0] sdmem_adr,
    output [31:0] data_out,
    input sd_init,
    output sd_ready
);
    parameter STATE_INIT = 0;
    parameter STATE_START = 1;
    parameter STATE_WRITE = 2;
    parameter STATE_READ = 3;
    parameter STATE_START_READ = 4;
    parameter STATE_WAIT = 5;

    wire clk_100mhz = CLK100MHZ;
    wire clk_50mhz;
    wire clk_25mhz;
    wire rst = BTNC;
    wire spiClk;
    wire spiMiso;
    wire spiMosi;
    wire spiCS;
    reg rd = 0;
    reg wr = 0;
    reg [7:0] din = 0;
    wire [7:0] dout;
    wire byte_available;
    wire ready;
    wire ready_for_next_byte;
    reg [31:0] adr; //02_00是第二个扇区
    reg [31:0] bytes = 0;
    reg [1:0] bytes_read = 0;
    wire [4:0] state;
    reg [2:0] test_state = STATE_INIT;
    reg next_byte;
    reg read_bytes_ready;//读出4字节
    reg write_bytes_next;//需要下一个4字节
    wire [31:0]write_bytes;//外界送进来的4字节
    reg [1:0]byte_cnt;
    reg [4:0]sector_cnt;//16个
    reg [4:0]sector_cnt_rd_sd;//16个
    reg [31:0]addr_sdmem;
    reg we;
    reg we_first;
    reg sd_write_nxt_first;
    reg only_one;
    reg flag_wr_adr_ready;
    reg flag_rd_adr_ready;
    reg flag_srd_adr_ready;
    wire seg7_cs = (test_state == STATE_INIT||test_state == STATE_READ)?1:0;
    wire [31:0]seg_data = (test_state == STATE_INIT)?write_bytes:bytes;
    wire [31:0]addr_sdmem_in;

    clock_divider div1(clk_100mhz, clk_50mhz);
    clock_divider div2(clk_50mhz, clk_25mhz);
    sd_controller sdcont(.cs(spiCS), .mosi(spiMosi), .miso(spiMiso),
        .sclk(spiClk), .rd(rd), .wr(wr), .reset(rst),
        .din(din), .dout(dout), .byte_available(byte_available),
        .ready(ready), .address(adr),
        .ready_for_next_byte(ready_for_next_byte), .clk(clk_25mhz),
        .status(state));

    /*SD缓存*/
    SDTrans SDMEM (
        .a(addr_sdmem_in[12:2]),
        .d(bytes),
        .clk(clk_100mhz),
        .we(we),
        .spo(write_bytes)
    );
    assign SD_DAT[2]     = 1;
    assign SD_DAT[3]     = spiCS;
    assign SD_CMD        = spiMosi;
    assign SD_RESET      = 0;
    assign SD_SCK        = spiClk;
    assign spiMiso       = SD_DAT[0];
    assign SD_DAT[1]     = 1;
    assign LED           = {state, ready, test_state, bytes[15:9]};
    assign addr_sdmem_in = (test_state == STATE_WAIT)?sdmem_adr:addr_sdmem;
    assign data_out      = write_bytes;
    assign sd_ready      = (test_state == STATE_WAIT)?1:0;







    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            we <= 0;
            we_first <= 1;
        end
        else if (read_bytes_ready && we_first) begin
            we <= 1;
            we_first <= 0;
        end
        else if (read_bytes_ready == 0)begin
            we_first <= 1;
            we <= 0;
        end
        else begin
            we <= 0;
        end
    end

    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            sd_write_nxt_first <= 1;
        end
        else if (write_bytes_next && sd_write_nxt_first) begin
            sd_write_nxt_first <= 0;
        end
        else if (write_bytes_next == 0) begin
            sd_write_nxt_first <= 1;
        end
    end

    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            addr_sdmem <= 4;
        end
        else if (rd && sector_cnt_rd_sd == 0) begin//sd取出，存入mem
            addr_sdmem <= 0 - 4;
        end
        else if (read_bytes_ready && we_first) begin
            addr_sdmem <= addr_sdmem + 4;
        end
        else if (wr && sector_cnt == 0) begin//mem取出，存入sd
            // addr_sdmem <= 32'h02_04;
            addr_sdmem <= 32'h00_00;
        end
        else if (write_bytes_next && sd_write_nxt_first) begin
            addr_sdmem <= addr_sdmem + 4;
        end
        else if (test_state == STATE_WAIT)begin//处于读sdmem阶段
            addr_sdmem <= sdmem_adr;
        end
    end






    always @(posedge clk_25mhz or posedge rst) begin
        if(rst) begin
            bytes <= 32'h12_34_56_78;
            bytes_read <= 0;
            din <= 0;
            wr <= 0;
            rd <= 0;
            next_byte <= 0;
            read_bytes_ready <= 0;
            write_bytes_next <= 0;
            byte_cnt <=0;
            test_state <= STATE_INIT;
            only_one <= 1;
            sector_cnt <= 0;
            adr = 32'h00_00_00_00;
            flag_wr_adr_ready <= 0;
            flag_rd_adr_ready <= 0;
            flag_srd_adr_ready <= 0;
            sector_cnt_rd_sd <= 0;
        end
        else begin
            case (test_state)
                STATE_INIT: begin
                    adr <= 32'h00_00_00_00;
                    if(ready && sd_init ) begin
                        test_state <= STATE_START_READ;
                        rd <= 1;
                        only_one <= 0;
                    end
                end
                STATE_START_READ: begin
                    if(ready == 0) begin
                        test_state <= STATE_READ;
                    end
                end

                STATE_READ: begin
                    if(ready) begin
                        if (sector_cnt_rd_sd == 15) begin
                            test_state <= STATE_WAIT;
                            sector_cnt_rd_sd <= 0;
                        end
                        else begin
                            if (flag_srd_adr_ready == 0) begin
                                adr <= adr + 32'h00_00_02_00;
                                flag_srd_adr_ready <= 1;
                            end
                            begin
                                rd <= 1;
                                test_state <= STATE_START_READ;
                                sector_cnt_rd_sd <= sector_cnt_rd_sd + 1;
                                flag_srd_adr_ready <= 0;
                            end

                        end

                    end
                    if(byte_available) begin
                        rd <= 0;
                        if(bytes_read == 0) begin
                            bytes_read <= 1;
                            bytes[31:24] <= dout;
                        end
                        else if(bytes_read == 1) begin
                            bytes_read <= 2;
                            bytes[23:16] <= dout;
                        end
                        else if(bytes_read == 2) begin
                            bytes_read <= 3;
                            bytes[15:8] <= dout;
                        end
                        else if(bytes_read == 3) begin
                            bytes_read <= 4;
                            bytes[7:0] <= dout;
                            read_bytes_ready <= 1; //集齐4字节，向ddr发出信号，告之可读
                        end
                        else begin
                            read_bytes_ready <= 0;
                        end
                    end
                    else begin
                        read_bytes_ready <= 0;
                    end
                end

                STATE_WAIT:begin
                    test_state <= STATE_WAIT;
                end
            endcase
        end
    end
endmodule


module clock_divider (
    input clk_in,
    output reg clk_out = 0
);
    always @(posedge clk_in) begin
        clk_out <= ~clk_out;
    end
endmodule