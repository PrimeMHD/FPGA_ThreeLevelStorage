`define DivResultReady 1'b1
`define DivFree 2'b00
`define InstBus 31:0
`define DataAddrBus 31:0
`define RegBus 31:0
`define RegWidth 32
`define DivEnd 2'b11
`define DivStart 1'b1
`define DivResultNotReady 1'b0
`define DivStop 1'b0
`define InstAddrBus 31:0
`define DoubleRegBus 63:0
`define RegNum 32
`define DataMemNum 1024
`define DivOn 2'b10
`define DataMemNumLog2 10
`define RegAddrBus 4:0
`define DataBus 31:0
`define InstMemNum 131071
`define ByteWidth 7:0
`define InstMemNumLog2 17
`define RegNumLog2 5
`define NOPRegAddr 5'b00000
`define DivByZero 2'b01
`define DoubleRegWidth 64
`define RstEnable 1'b1
`define ReadDisable 1'b0
`define NoStop 1'b0
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define ChipEnable 1'b1
`define TrapNotAssert 1'b0
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define NotBranch 1'b0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define AluOpBus 7:0
`define True_v 1'b1
`define False_v 1'b0
`define ChipDisable 1'b0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define InterruptAssert 1'b1







//指令
`define EXE_AND  6'b100100
`define EXE_OR   6'b100101
`define EXE_XOR 6'b100110
`define EXE_ORI  6'b001101
`define EXE_XORI 6'b001110
`define EXE_LUI 6'b001111
`define EXE_SLL  6'b000000
`define EXE_SLLV  6'b000100
`define EXE_NOR 6'b100111
`define EXE_MOVN  6'b001011
`define EXE_MFHI  6'b010000
`define EXE_MTHI  6'b010001
`define EXE_ANDI 6'b001100
`define EXE_SRL  6'b000010
`define EXE_SRLV  6'b000110
`define EXE_SRA  6'b000011
`define EXE_SRAV  6'b000111
`define EXE_SUBU  6'b100011
`define EXE_ADDI  6'b001000
`define EXE_BGTZ  6'b000111
`define EXE_BLEZ  6'b000110
`define EXE_SB  6'b101000
`define EXE_SUB  6'b100010
`define EXE_SC  6'b111000
`define EXE_SH  6'b101001
`define EXE_J  6'b000010
`define EXE_JAL  6'b000011
`define EXE_JALR  6'b001001
`define EXE_MTLO  6'b010011
`define EXE_MULTU  6'b011001
`define EXE_MUL  6'b000010
`define EXE_MFLO  6'b010010
`define EXE_SLTI  6'b001010
`define EXE_SLTIU  6'b001011   
`define EXE_SYNC  6'b001111
`define EXE_PREF  6'b110011
`define EXE_MOVZ  6'b001010
`define EXE_ADDU  6'b100001
`define EXE_BGEZAL  5'b10001
`define EXE_CLZ  6'b100000
`define EXE_CLO  6'b100001
`define EXE_LH  6'b100001
`define EXE_LHU  6'b100101
`define EXE_JR  6'b001000
`define EXE_BEQ  6'b000100
`define EXE_MADD  6'b000000
`define EXE_SLT  6'b101010
`define EXE_SLTU  6'b101011
`define EXE_ADD  6'b100000
`define EXE_ADDIU  6'b001001
`define EXE_MSUBU  6'b000101
`define EXE_BNE  6'b000101
`define EXE_DIVU  6'b011011
`define EXE_LB  6'b100000
`define EXE_SWR  6'b101110
`define EXE_DIV  6'b011010
`define EXE_LBU  6'b100100
`define EXE_BGEZ  5'b00001
`define EXE_LL  6'b110000
`define EXE_LW  6'b100011
`define EXE_LWL  6'b100010
`define EXE_LWR  6'b100110
`define EXE_MULT  6'b011000
`define EXE_NOP 6'b000000
`define EXE_SPECIAL_INST 6'b000000
`define EXE_REGIMM_INST 6'b000001
`define EXE_SPECIAL2_INST 6'b011100
`define EXE_SW  6'b101011
`define EXE_SWL  6'b101010
`define EXE_BLTZ  5'b00000
`define EXE_BLTZAL  5'b10000
`define EXE_MADDU  6'b000001
`define EXE_MSUB  6'b000100
`define SSNOP 32'b00000000000000000000000001000000



//AluOp
`define EXE_AND_OP   8'b00100100
`define EXE_OR_OP    8'b00100101
`define EXE_XOR_OP  8'b00100110
`define EXE_NOR_OP  8'b00100111
`define EXE_ANDI_OP  8'b01011001
`define EXE_BLTZ_OP  8'b01000000
`define EXE_SLL_OP  8'b01111100
`define EXE_SLLV_OP  8'b00000100
`define EXE_ADDU_OP  8'b00100001
`define EXE_SLT_OP  8'b00101010
`define EXE_MUL_OP  8'b10101001
`define EXE_MADD_OP  8'b10100110
`define EXE_BLEZ_OP  8'b01010011
`define EXE_BLTZAL_OP  8'b01001010
`define EXE_BNE_OP  8'b01010010
`define EXE_SLTU_OP  8'b00101011
`define EXE_SRL_OP  8'b00000010
`define EXE_SUB_OP  8'b00100010
`define EXE_SUBU_OP  8'b00100011
`define EXE_MULT_OP  8'b00011000
`define EXE_MULTU_OP  8'b00011001
`define EXE_SRLV_OP  8'b00000110
`define EXE_SRA_OP  8'b00000011
`define EXE_ADDIU_OP  8'b01010110
`define EXE_CLZ_OP  8'b10110000
`define EXE_SRAV_OP  8'b00000111
`define EXE_LBU_OP  8'b11100100
`define EXE_LH_OP  8'b11100001
`define EXE_CLO_OP  8'b10110001
`define EXE_MTLO_OP  8'b00010011
`define EXE_ADDI_OP  8'b01010101
`define EXE_SH_OP  8'b11101001
`define EXE_SWL_OP  8'b11101010
`define EXE_LHU_OP  8'b11100101
`define EXE_SLTI_OP  8'b01010111
`define EXE_SLTIU_OP  8'b01011000   
`define EXE_JAL_OP  8'b01010000
`define EXE_JALR_OP  8'b00001001
`define EXE_JR_OP  8'b00001000
`define EXE_BEQ_OP  8'b01010001
`define EXE_BGEZ_OP  8'b01000001
`define EXE_BGTZ_OP  8'b01010100
`define EXE_MADDU_OP  8'b10101000
`define EXE_LUI_OP  8'b01011100   
`define EXE_SC_OP  8'b11111000
`define EXE_LL_OP  8'b11110000
`define EXE_MSUB_OP  8'b10101010
`define EXE_MOVN_OP  8'b00001011
`define EXE_MFHI_OP  8'b00010000
`define EXE_MTHI_OP  8'b00010001
`define EXE_BGEZAL_OP  8'b01001011
`define EXE_ADD_OP  8'b00100000
`define EXE_MOVZ_OP  8'b00001010
`define EXE_SWR_OP  8'b11101110
`define EXE_XORI_OP  8'b01011011
`define EXE_LWL_OP  8'b11100010
`define EXE_LWR_OP  8'b11100110
`define EXE_PREF_OP  8'b11110011
`define EXE_SB_OP  8'b11101000
`define EXE_MSUBU_OP  8'b10101011
`define EXE_DIV_OP  8'b00011010
`define EXE_DIVU_OP  8'b00011011
`define EXE_SYNC_OP  8'b00001111
`define EXE_ORI_OP  8'b01011010
`define EXE_MFLO_OP  8'b00010010
`define EXE_LB_OP  8'b11100000
`define EXE_SW_OP  8'b11101011
`define EXE_NOP_OP    8'b00000000
`define EXE_J_OP  8'b01001111
`define EXE_LW_OP  8'b11100011


//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_SHIFT 3'b010
`define EXE_RES_LOAD_STORE 3'b111	
`define EXE_RES_NOP 3'b000
`define EXE_RES_ARITHMETIC 3'b100	
`define EXE_RES_MOVE 3'b011	
`define EXE_RES_MUL 3'b101
`define EXE_RES_JUMP_BRANCH 3'b110
















//////////////////////////////////////////////////////////////////////////////////
// Company:Tongji University
// Engineer:Mi HD
//
// Create Date: 2018/04/25 16:11:18
// Module Name: DEFINITION
// Project Name: MIPS VERILOG CPU
// Target Devices:DIGILENT NEXYS 4 DDR
// Tool Versions:Vivado 2016.2
// Description:MIPS CPU 宏定义常量

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//******MIPS-55*********//
//SPECIAL FUNC CODE(instr[5:0])
`define  ADDU       6'b100001
`define  SUBU       6'b100011
`define  ADD        6'b100000
`define  SUB        6'b100010
`define  AND        6'b100100
`define  OR         6'b100101
`define  XOR        6'b100110
`define  NOR        6'b100111
`define  SLT        6'b101010
`define  SLTU       6'b101011
`define  SRL        6'b000010
`define  SRA        6'b000011
`define  SLL        6'b000000
`define  SLLV       6'b000100
`define  SRLV       6'b000110
`define  SRAV       6'b000111
`define  JR         6'b001000

//mul_div_contorl_signal
`define 	MD_MUL       3'h1
`define 	MD_MULTU     3'h2
`define 	MD_DIV		 3'h3
`define 	MD_DIVU	     3'h4
`define 	MD_MTHI		 3'h5
`define     MD_MTLO		 3'h6
`define 	MD_MULT     3'h7
`define 	MD_NO	     3'h0

//R-TYPE OPCODE FILED
`define SPECIAL    6'b000000
//I-TYPE & J-TYPE OPCODE FIELD  (instr[31:26])
`define ADDI       6'b001000
`define ADDIU      6'b001001
`define ANDI       6'b001100
`define ORI        6'b001101
`define XORI       6'b001110
`define LW         6'b100011
`define SW         6'b101011
`define BEQ        6'b000100
`define BNE        6'b000101
`define SLTI       6'b001010
`define SLTIU      6'b001011
`define LUI        6'b001111
`define J          6'b000010
`define JAL        6'b000011







//ALU OPCODE
`define   _ADDU      4'b0000    //r=a+b unsigned
`define   _ADD       4'b0010    //r=a+b signed
`define   _SUBU      4'b0001    //r=a-b unsigned
`define   _SUB       4'b0011    //r=a-b signed
`define   _AND       4'b0100    //r=a&b
`define   _OR        4'b0101    //r=a|b
`define   _XOR       4'b0110    //r=a^b
`define   _NOR       4'b0111    //r=~(a|b)
`define   _LUI       4'b1000    //r={b[15:0],16'b0}
`define   _SLT       4'b1011    //r=(a-b<0)?1:0 signed
`define   _SLTU      4'b1010    //r=(a-b<0)?1:0 unsigned
`define   _SRA       4'b1100    //r=b>>>a
`define   _SLL       4'b1110    //r=b<<a
`define   _SRL       4'b1101    //r=b>>a

//OTHER DEFINITION
`define   SIGN       1'b1
`define   UNSIGN     1'b0
`define   DISABLED	 1'b0
`define   ENABLED	 1'b1
`define   YES		 1'b1
`define   NO         1'b0
`define   UNUSED32   32'b0










/*NOT USED IN 31 INSTRUCTIONS*/

//REGIMM OP LIST 20-16
`define  BLTZ       5'b00000
`define  BGEZ       5'b00001
//COP0 OP LIST
`define ERET       6'b011000  //5-0&&25TH=1
`define MFC0       5'b00000   //20-16
`define MTC0       5'b00100
//SPECIAL FUNC CODE(instr[5:0])
`define  MULT       6'b011000
`define  MULTU      6'b011001
`define  DIV        6'b011010
`define  DIVU       6'b011011
`define  MFHI       6'b010000
`define  MFLO       6'b010010
`define  MTHI       6'b010001
`define  MTLO       6'b010011
`define  BREAK      6'b001101
`define  SYSCALL    6'b001100
`define  TEQ        6'b110100
`define  JALR       6'b001001
//SPECIAL 2 FUNC CODE(instr[5:0])
`define  CLZ        6'b100000
`define  MUL        6'b000010
//I-TYPE & J-TYPE OPCODE FIELD  (instr[31:26])
`define LB         6'b100000//    Load Byte Function=6'h24
`define LBU        6'b100100//    1Load Byte Unsigned
`define LH         6'b100001//    Load high
`define LHU        6'b100101//    Load High Unsigned
`define SB         6'b101000//    Send Byte
`define SH         6'b101001//    Send High
`define BLEZ       6'b000110
`define BGTZ       6'b000111
`define SPECIAL2    6'b011100
`define REGIMM     6'b000001
`define COP0       6'b010000
/*NOT USED IN 31 INSTRUCTIONS*/




`define EX_OUTPUT_SOURCE_CLZ  4'b1001



`define READ 1'b0
`define WRITE 1'b1
`define NoBusy 1'b0
`define Busy 1'b1
`define DONE 1'b1
`define UNDONE 1'b0


