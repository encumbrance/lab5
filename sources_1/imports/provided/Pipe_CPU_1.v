`timescale 1ns / 1ps
// TA
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/




/**** IF stage ****/
wire [31:0] Mux_PC_Source_o, pc_out_o, sum1_o, instr_o;
wire [63:0] IF_ID_o;


/**** ID stage ****/
wire [31:0] RSdata_o, RTdata_o, SE_o,  Shifter1_o;
wire [4:0] Mux_Write_Reg_o;
wire [2:0] ALU_op_o;
wire [1:0] Branchtype_o;
wire  RegWrite_o, Branch_o, RegDst_o, ALUSrc_o, MemWrite_o, MemRead_o, MemtoReg_o, jump_o;
wire  PC_Write_o, IF_ID_Write_o, IF_flush_o, ID_flush_o, EX_flush_o;
wire [154:0] ID_EX_o;

/**** EX stage ****/
wire [31:0] Shifter2_o, Mux_ALUSrc_o, result_o, sum2_o, forward_src1_o, forward_src2_o;
wire [3 : 0] ALU_Ctrl_o;
wire [1:0]  forward1_o, forward2_o;
wire  zero_o;
wire [141:0] EX_MEM_o;

/**** MEM stage ****/
wire [31:0] Data_Memory_o;
wire [70:0] MEM_WB_o;
wire zero_result_o, branch_result_o;

/**** WB stage ****/
wire [31:0]Mux_WriteData_Source_o;



/*==================================================================*/
/*                              design                              */
/*==================================================================*/

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux_PC_Source( // Modify N, which is the total length of input/output
    .data0_i(sum1_o),
    .data1_i(EX_MEM_o[109:78]),
    .select_i(branch_result_o),
    .data_o(Mux_PC_Source_o)
);

ProgramCounter PC(
    .clk_i(clk_i),      
	.rst_i (rst_i),     
    .pc_write(PC_Write_o),
	.pc_in_i(Mux_PC_Source_o),   
	.pc_out_o(pc_out_o) 
);

Instruction_Memory IM(
    .addr_i(pc_out_o),  
	.instr_o(instr_o)    
);
			
Adder Add_pc(
    .src1_i(pc_out_o),     
	.src2_i(4),     
	.sum_o(sum1_o)       
);
		
Pipe_Reg #(.size(64)) IF_ID(    // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IF_flush_o),
    .write(IF_ID_Write_o),
    .data_i({sum1_o, instr_o}),
    .data_o(IF_ID_o)
);

//Instantiate the components in ID stage

Shift_Left_Two_32 Shifter1(
    .data_i({6'b000000, IF_ID_o[25 : 0]}),
    .data_o(Shifter1_o)
);


Decoder Control(
    .instr_op_i(IF_ID_o[31:26]), 
	.RegWrite_o(RegWrite_o), 
	.ALU_op_o(ALU_op_o),   
	.ALUSrc_o(ALUSrc_o),   
	.RegDst_o(RegDst_o),   
    .Branch_o(Branch_o),
	.Branchtype_o(Branchtype_o),
    .MemRead_o(MemRead_o),
	.MemWrite_o(MemWrite_o),
	.MemtoReg_o(MemtoReg_o),
	.jump_o(jump_o)   
);

hazard_detection_unit HDU(
    .ID_EX_MEMRead_i(ID_EX_o[107]),
    .Branch_i(branch_result_o),
    .ID_EX_RT_i(ID_EX_o[36:32]),
    .IF_ID_RS_i(IF_ID_o[25:21]),
    .IF_ID_RT_i(IF_ID_o[20:16]),
    .PC_Write_o(PC_Write_o),
    .IF_ID_Write_o(IF_ID_Write_o),
    .IF_flush_o(IF_flush_o),
    .ID_flush_o(ID_flush_o),
    .EX_flush_o(EX_flush_o)
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(     //dangerous, use ctrl signal immediately
    .data0_i(IF_ID_o[20:16]),
    .data1_i(IF_ID_o[15:11]),
    .select_i(RegDst_o),
    .data_o(Mux_Write_Reg_o)            
);

Reg_File RF(
    .clk_i(clk_i),      
	.rst_i(rst_i),     
    .RSaddr_i(IF_ID_o[25:21]),  
    .RTaddr_i(IF_ID_o[20:16]),  
    .RDaddr_i(MEM_WB_o[4:0]),     
    .RDdata_i(Mux_WriteData_Source_o), 
    .RegWrite_i(MEM_WB_o[69]),           
    .RSdata_o(RSdata_o) ,  
    .RTdata_o(RTdata_o) 
);

Sign_Extend SE(
    .data_i(IF_ID_o[15:0]),
    .data_o(SE_o)                       
);

Pipe_Reg #(.size(155)) ID_EX( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(ID_flush_o),
    .write(1'b1),
    .data_i({
        IF_ID_o[25:21],     //5   RS 154~150
        IF_ID_o[20:16],     //5   RT 149~145
        IF_ID_o[63:32],     //32  sum1_o 144~113
        Branch_o,           //1   112
        Branchtype_o,       //2   111~110
        MemtoReg_o,         //1   109
        jump_o,             //1   108
        MemRead_o,          //1   107
        MemWrite_o,         //1   106
        ALU_op_o,           //3   105~103
        ALUSrc_o,           //1   102
        RegWrite_o,         //1   101
        RSdata_o,           //32  100~69
        RTdata_o,           //32  68~37
        Mux_Write_Reg_o,    //5   36~32
        SE_o                //32   31~0
        }),
    .data_o(ID_EX_o)
);


//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter2(
    .data_i(ID_EX_o[31 : 0]),
    .data_o(Shifter2_o)
);

Adder Add_pc_branch(
    .src1_i(ID_EX_o[144:113]),     
	.src2_i(Shifter2_o),     
	.sum_o(sum2_o)   
);

ALU_Ctrl ALU_Control(
    .funct_i(ID_EX_o[5:0]),   
    .ALUOp_i(ID_EX_o[105:103]),   
    .ALUCtrl_o(ALU_Ctrl_o)
);

forward_unit forward(
    .EX_MEM_RegWrite_i(EX_MEM_o[69]),
    .EX_MEM_Write_Reg_i(EX_MEM_o[4:0]),
    .ID_EX_RS_i(ID_EX_o[154:150]),
    .ID_EX_RT_i(ID_EX_o[149:145]),
    .MEM_WB_RegWrite_i(MEM_WB_o[69]),
    .MEM_WB_Write_Reg_i(MEM_WB_o[4:0]),
    .forward1_o(forward1_o),
    .forward2_o(forward2_o)
);

MUX_3to1 #(.size(32)) forward_src1(
    .data0_i(ID_EX_o[100:69]),
    .data1_i(Mux_WriteData_Source_o),
    .data2_i(EX_MEM_o[68:37]),
    .select_i(forward1_o),
    .data_o(forward_src1_o)
);

MUX_3to1 #(.size(32)) forward_src2(
    .data0_i(ID_EX_o[68:37]),
    .data1_i(Mux_WriteData_Source_o),
    .data2_i(EX_MEM_o[68:37]),
    .select_i(forward2_o),
    .data_o(forward_src2_o)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(forward_src2_o),
    .data1_i(ID_EX_o[31:0]),
    .select_i(ID_EX_o[102]),
    .data_o(Mux_ALUSrc_o)
 );

ALU ALU(
    .src1_i(forward_src1_o),
	.src2_i(Mux_ALUSrc_o),
	.ctrl_i(ALU_Ctrl_o),
	.result_o(result_o),
	.zero_o(zero_o)
);

Pipe_Reg #(.size(142)) EX_MEM( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(EX_flush_o),
    .write(1'b1),
    .data_i({
        ID_EX_o[144:113],   //32    sum1_o      141~110
        sum2_o,             //32                109~78
        ID_EX_o[112],       //1     Branch_o    77
        ID_EX_o[111:110],   //2     Branchtype_o 76~75
        zero_o,             //1     zero_o      74
        ID_EX_o[109],       //1     MemtoReg_o  73
        ID_EX_o[108],       //1     jump_o      72
        ID_EX_o[107],       //1     MemRead_o   71
        ID_EX_o[106],       //1     MemWrite_o  70 
        ID_EX_o[101],       //1     RegWrite_o  69
        result_o,           //32    68~37
        ID_EX_o[68:37],     //32    RTdata_o   36~5
        ID_EX_o[36:32]      //5     RD         4~0
    }),
    .data_o(EX_MEM_o)
);

//Instantiate the components in MEM stage

MUX_4to1 #(.size(1)) branchtype (
    .data0_i(EX_MEM_o[74]),
    .data1_i(~(EX_MEM_o[68] | EX_MEM_o[74])),
    .data2_i(~EX_MEM_o[68]),
    .data3_i(~EX_MEM_o[74]),
    .select_i(EX_MEM_o[76:75]),
    .data_o(zero_result_o)
);

assign branch_result_o = (EX_MEM_o[77] & zero_result_o); 

Data_Memory DM(
    .clk_i(clk_i),
	.addr_i(EX_MEM_o[68:37]),
	.data_i(EX_MEM_o[36:5]),
	.MemRead_i(EX_MEM_o[71]),
	.MemWrite_i(EX_MEM_o[70]),
	.data_o(Data_Memory_o)
);

Pipe_Reg #(.size(71)) MEM_WB( // Modify N, which is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({
        EX_MEM_o[73],      //1     MemtoReg_o  70
        EX_MEM_o[69],      //1     RegWrite_o  69
        Data_Memory_o,     //32    68~37
        EX_MEM_o[68:37],   //32    reslut_o 36~5
        EX_MEM_o[4:0]      //5     RD  4~0
    }),
    .data_o(MEM_WB_o)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3( // Modify N, which is the total length of input/output
    .data0_i(MEM_WB_o[36:5]),
    .data1_i(MEM_WB_o[68:37]),
    .select_i(MEM_WB_o[70]),
    .data_o(Mux_WriteData_Source_o)    
);


endmodule