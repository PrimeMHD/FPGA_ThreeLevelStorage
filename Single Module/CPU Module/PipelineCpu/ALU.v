`include "Defination.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: ALU
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU ALU

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu (
    input [31:0] a, //32 Î»ÊäÈë£¬²Ù×÷Êý 1
    input [31:0] b, //32 Î»ÊäÈë£¬²Ù×÷Êý 2
    input [3:0] aluc, //4 Î»ÊäÈë£¬¿ØÖÆ alu µÄ²Ù×÷
    output reg [31:0] r, //32 Î»Êä³ö£¬ÓÉ a¡¢ b ¾­¹ý aluc Ö¸¶¨µÄ²Ù×÷Éú³É
    output reg zero, //0 ±êÖ¾Î»
    output reg carry, // ½øÎ»±êÖ¾Î»
    output reg negative, // ¸ºÊý±êÖ¾Î»
    output reg overflow // Òç³ö±êÖ¾Î»
);
    wire [31:0]answers[0:14];
    wire zeros[0:14];
    wire carrys[0:14];
    wire negatives[0:14];
    wire overflows[0:14];
    reg [31:0]reverse_num;
    reg [3:0]polished_aluc;
    always@(*)begin
        if(aluc[3]==1'b1&&aluc[2]==1'b0&&aluc[1]==1'b0)begin
            polished_aluc=4'b1000;
        end
        else if(aluc[3]==1'b1&&aluc[2]==1'b1&&aluc[1]==1'b1)begin
            polished_aluc=4'b1110;
        end
        else begin
            polished_aluc=aluc;
        end

        r=answers[polished_aluc];
        zero=zeros[polished_aluc];
        negative=negatives[polished_aluc];
        carry=(polished_aluc==0||polished_aluc==1||polished_aluc==10||polished_aluc==12||polished_aluc==13||polished_aluc==14)?carrys[polished_aluc]:carry;
        overflow=(polished_aluc==2||polished_aluc==3)?overflows[polished_aluc]:overflow;
    end

    Adder_32 addu_block(.iSA(1'b0),.iData_a(a),.iData_b(b),.oData_32(answers[0]),.oData_C(carrys[0]),.oData_N(negatives[0]),.oData_O(overflows[0]),.oData_Z(zeros[0]));
    Adder_32 add_block(.iSA(1'b1),.iData_a(a),.iData_b(b),.oData_32(answers[2]),.oData_C(carrys[2]),.oData_N(negatives[2]),.oData_O(overflows[2]),.oData_Z(zeros[2]));
    Subber_32 sbbu_block(.iSA(1'b0),.iData_a(a),.iData_b(b),.oData_32(answers[1]),.oData_C(carrys[1]),.oData_N(negatives[1]),.oData_O(overflows[1]),.oData_Z(zeros[1]));
    Subber_32 sbb_block(.iSA(1'b1),.iData_a(a),.iData_b(b),.oData_32(answers[3]),.oData_C(carrys[3]),.oData_N(negatives[3]),.oData_O(overflows[3]),.oData_Z(zeros[3]));
    barrelshifter32 sra_block(.b(a[4:0]),.a(b),.c(answers[12]),.aluc(2'b00),.oData_C(carrys[12]),.oData_N(negatives[12]),.oData_Z(zeros[12]));
    barrelshifter32 sll_slr_block(.b(a[4:0]),.a(b),.c(answers[14]),.aluc(2'b01),.oData_C(carrys[14]),.oData_N(negatives[14]),.oData_Z(zeros[14]));
    barrelshifter32 srl_block(.b(a[4:0]),.a(b),.c(answers[13]),.aluc(2'b10),.oData_C(carrys[13]),.oData_N(negatives[13]),.oData_Z(zeros[13]));
    BitCal_32 and_block(.iData_a(a),.iData_b(b),.caltype(2'b00),.oData_32(answers[4]),.oData_Z(zeros[4]),.oData_N(negatives[4]));
    BitCal_32 or_block(.iData_a(a),.iData_b(b),.caltype(2'b01),.oData_32(answers[5]),.oData_Z(zeros[5]),.oData_N(negatives[5]));
    BitCal_32 xor_block(.iData_a(a),.iData_b(b),.caltype(2'b10),.oData_32(answers[6]),.oData_Z(zeros[6]),.oData_N(negatives[6]));
    BitCal_32 nor_block(.iData_a(a),.iData_b(b),.caltype(2'b11),.oData_32(answers[7]),.oData_Z(zeros[7]),.oData_N(negatives[7]));
    Lui_32 lui_block(.iData_b(b),.oData(answers[8]),.oData_Z(zeros[8]),.oData_N(negatives[8]));
    Slt_32 slt(.iData_a(a),.iData_b(b),.iSA(1'b1),.oData_32(answers[11]),.oData_Z(zeros[11]),.oData_N(negatives[11]),.oData_C(carrys[11]));
    Slt_32 sltu(.iData_a(a),.iData_b(b),.iSA(1'b0),.oData_32(answers[10]),.oData_Z(zeros[10]),.oData_N(negatives[10]),.oData_C(carrys[10]));
endmodule


module Adder_32 (
    input iSA, //ÊäÈë¿ØÖÆÐÅºÅ£¬ iSA Îª 1 ±íÊ¾ÓÐ·ûºÅÔËËã£¬iSA Îª 0 ±íÊ¾ÎÞ·ûºÅÔËËã
    input [31:0] iData_a, //32 Î»¼ÓÊý a¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    input [31:0] iData_b, //32 Î»¼ÓÊý b¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg [31:0]oData_32, //32 Î»¼ÆËã½á¹û¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg oData_C, //Êä³öµÄ¼ÆËã½á¹û½øÎ»±êÊ¶·û
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N,//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
    output reg oData_O //Êä³ö¼ÆËã½á¹ûµÄÒç³ö±êÖ¾Î»
);
    reg [31:0]iData_a_shot;
    reg [31:0]iData_b_shot;
    reg [32:0]temp_oData;
    reg [32:0]oData;//²»Òç³öµÄÔËËã½á¹û
    integer i;
    always @(*)begin
        iData_a_shot=iData_a;
        iData_b_shot=iData_b;
        oData=0;
        case(iSA)
            1'b1:begin   //signed
                temp_oData={{iData_a_shot[31]},iData_a_shot[31:0]}+{{iData_b_shot[31]},iData_b_shot[31:0]};
                oData=temp_oData;
                oData_32=oData[31:0];
                oData_C='bx;//oData_C=oData[32];//½øÎ»±êÖ¾Î»
                oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
                oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
                oData_O=(iData_a[31]==iData_b[31]&&iData_a[31]!=oData_32[31])?1'b1:1'b0;//Òç³ö±êÖ¾Î»
            end
            1'b0:begin  //unsigned add
                oData={1'b0,iData_a}+{1'b0,iData_b};
                oData_32=oData[31:0];
                oData_C=oData[32];//½øÎ»±êÖ¾Î»
                oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
                oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
                oData_O='bx;//oData_O=oData_C;
            end
        endcase
    end
endmodule

module Subber_32 (
    input iSA, //ÊäÈë¿ØÖÆÐÅºÅ£¬ iSA Îª 1 ±íÊ¾ÓÐ·ûºÅÔËËã£¬iSA Îª 0 ±íÊ¾ÎÞ·ûºÅÔËËã
    input [31:0] iData_a, //32 Î»¼ÓÊý a¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    input [31:0] iData_b, //32 Î»¼ÓÊý b¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg [31:0]oData_32, //32 Î»¼ÆËã½á¹û¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg oData_C, //Êä³öµÄ¼ÆËã½á¹û½øÎ»±êÊ¶·û
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N,//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
    output reg oData_O //Êä³ö¼ÆËã½á¹ûµÄÒç³ö±êÖ¾Î»
);
    reg [31:0]iData_a_shot;
    reg [31:0]iData_b_shot;
    reg [32:0]temp_oData;
    reg [32:0]oData;//²»Òç³öµÄÔËËã½á¹û
    integer i;
    always @(*)begin
        iData_a_shot=iData_a;
        iData_b_shot=iData_b;
        oData=0;
        case(iSA)
            1'b1:begin   //signed sub
                temp_oData={{iData_a_shot[31]},iData_a_shot[31:0]}-{{iData_b_shot[31]},iData_b_shot[31:0]};
                oData=temp_oData;
                oData_32=oData[31:0];
                oData_C=oData[32];//½øÎ»±êÖ¾Î»£¬ÕâÀïÎÞÒâÒå
                oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
                oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
                oData_O=(iData_a[31]!=iData_b[31]&&iData_a[31]!=oData_32[31])?1'b1:1'b0;//Òç³ö±êÖ¾Î»
            end
            1'b0:begin  //unsigned add
                oData={1'b0,iData_a}-{1'b0,iData_b};
                oData_32=oData[31:0];
                oData_C=oData[32];//½øÎ»±êÖ¾Î»
                oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
                oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
                oData_O=oData_C;
            end
        endcase
    end
endmodule

module barrelshifter32 (
    input [31:0] a, //32 Î»Ô­Ê¼ÊäÈëÊý¾Ý
    input [4:0] b, //5 Î»ÊäÈëÐÅºÅ£¬¿ØÖÆÒÆÎ»µÄÎ»Êý
    input [1:0] aluc, //2 Î»ÊäÈëÐÅºÅ£¬¿ØÖÆÒÆÎ»µÄ·½Ê½
    output reg [31:0] c, //32 Î»ÒÆÎ»ºóµÄÊä³öÊý¾Ý
    output reg oData_C, //Êä³öµÄ¼ÆËã½á¹û½øÎ»±êÊ¶·û
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
);
    reg [31:0] temp;
    always@(a or b or aluc)begin

        case(aluc)
            2'b00:begin
                temp=b[0]?{{a[31]},a[31:1]}:a;
                temp=b[1]?{{2{temp[31]}},temp[31:2]}:temp;
                temp=b[2]?{{4{temp[31]}},temp[31:4]}:temp;
                temp=b[3]?{{8{temp[31]}},temp[31:8]}:temp;
                temp=b[4]?{{16{temp[31]}},temp[31:16]}:temp;
                oData_C=a[b-1];
            end        //ËãÊýÓÒÒÆ
            2'b01,2'b11:begin
                temp=b[0]?{a[30:0],1'b0}:a;
                temp=b[1]?{temp[29:0],2'b0}:temp;
                temp=b[2]?{temp[27:0],4'b0}:temp;
                temp=b[3]?{temp[23:0],8'b0}:temp;
                temp=b[4]?{temp[15:0],16'b0}:temp;
                oData_C=a[31-b+1];
            end         //ËãÊý×óÒÆ,Âß¼­×óÒÆ
            2'b10:begin
                temp=b[0]?{1'b0,a[31:1]}:a;
                temp=b[1]?{2'b0,temp[31:2]}:temp;
                temp=b[2]?{4'b0,temp[31:4]}:temp;
                temp=b[3]?{8'b0,temp[31:8]}:temp;
                temp=b[4]?{16'b0,temp[31:16]}:temp;
                oData_C=a[b-1];
            end         //Âß¼­ÓÒÒÆ
        endcase
        c=temp;
        oData_Z=((c==0)?1:0);//Áã±êÖ¾Î»
        oData_N=c[31]; //¸ºÊý±êÖ¾Î»

    end
endmodule

module BitCal_32 (
    input [31:0] iData_a, //32 Î»¼ÓÊý a¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    input [31:0] iData_b, //32 Î»¼ÓÊý b¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    input [1:0] caltype,//¿ØÖÆÐÅºÅ£¬¿ØÖÆÎ»ÔËËãµÄÀàÐÍ
    output reg [31:0]oData_32, //32 Î»¼ÆËã½á¹û¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
);
    always@(*) begin
        case(caltype)
            2'b00:begin oData_32=iData_a&iData_b; end
            2'b01:begin oData_32=iData_a|iData_b; end
            2'b10:begin oData_32=iData_a^iData_b; end
            2'b11:begin oData_32=~(iData_a|iData_b); end
        endcase
        oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
        oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
    end
endmodule

module Lui_32 (
    input [31:0]iData_b,
    output reg [31:0]oData,
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
);
    always@(*)begin
        oData={iData_b[15:0],16'b0};
        oData_N=oData[31]; //¸ºÊý±êÖ¾Î»
        oData_Z=((oData==0)?1'b1:1'b0);//Áã±êÖ¾Î»
    end
endmodule


module Slt_32 (
    input [31:0]iData_a,
    input [31:0]iData_b,
    input iSA,
    output reg [31:0]oData_32, //32 Î»¼ÆËã½á¹û¡£ iSA Îª 1 Ê±£¬×î¸ßÎ»Îª·ûºÅÎ»
    output reg oData_Z,//Êä³ö¼ÆËã½á¹ûµÄÁã±êÖ¾Î»
    output reg oData_N,//Êä³ö¼ÆËã½á¹û¸ºÊý±êÖ¾Î»
    output reg oData_C
);
    reg [31:0]reva;
    reg [31:0]revb;
    integer i;
    always@(*)begin
        case(iSA)
            1'b1:begin
                case({iData_a[31],iData_b[31]})
                    2'b00:begin//¶¼ÊÇÕýÊý
                        oData_32=(iData_a<iData_b)?1:0;
                    end
                    2'b01:begin//aÕý£¬b¸º
                        oData_32=0;
                    end
                    2'b10:begin
                        oData_32=1;
                    end
                    2'b11:begin//¶¼ÊÇ¸ºÊý,ÎÒÃÇÀ´±È½ÏËûÃÇ¾ø¶ÔÖµµÄ´óÐ¡
                        reva[31]=iData_a[31];
                        for(i=30;i>=0;i=i-1)begin
                            reva[i]=~iData_a[i];
                        end
                        reva=reva+32'b00000000000000000000000000000001;
                        revb[31]=iData_b[31];
                        for(i=30;i>=0;i=i-1)begin
                            revb[i]=~iData_b[i];
                        end
                        revb=revb+32'b00000000000000000000000000000001;
                        //ÕâÀïÈ¡¾Í¾ø¶ÔÖµµÄ·½·¨¶Ô²»¶ÔÄØ£¿
                        oData_32=(reva>revb)?1:0;
                    end
                endcase
            end//ÓÐ·ûºÅµÄ±È½Ï
            1'b0:begin
                oData_32=(iData_a<iData_b)?1:0;
                oData_C=(iData_a<iData_b)?1'b1:1'b0;
            end//ÎÞ·ûºÅµÄ±È½Ï
        endcase
        oData_N=oData_32[31]; //¸ºÊý±êÖ¾Î»
        oData_Z=((oData_32==0)?1:0);//Áã±êÖ¾Î»
    end
endmodule
