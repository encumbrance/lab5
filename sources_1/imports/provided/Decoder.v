//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110550148
//----------------------------------------------
//Date:        05/01
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Branchtype_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	jump_o
);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output   	   ALUSrc_o;
output		   RegDst_o;
output 	 [1:0] Branchtype_o;
output         Branch_o;
output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
output         jump_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg    		   ALUSrc_o; 
reg            RegWrite_o;
reg            RegDst_o; 
reg            Branch_o;
reg	    [1:0]  Branchtype_o;
reg			   MemRead_o;
reg			   MemWrite_o;
reg			   MemtoReg_o;
reg			   jump_o;

//Parameter


//Main function
always@(*)begin
	case(instr_op_i)
		0 :	begin	//R-type
			RegWrite_o <= 1;
			ALU_op_o <= 3'b010;
			ALUSrc_o <= 0;
			RegDst_o <= 1;
			Branch_o <= 0;
			Branchtype_o <= 2'b00;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end
		8 : begin  //addi
			RegWrite_o <= 1;
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Branchtype_o <= 2'b00;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end	
		10 : begin // stli
			RegWrite_o <= 1;
			ALU_op_o <= 3'b101;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Branchtype_o <= 2'b00;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end
		4 : begin // beq
			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
			Branchtype_o <= 2'b00;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end
		5 : begin // bne
			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
			Branchtype_o <= 2'b11;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;	
		end
		1 : begin // bge
			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
			Branchtype_o <= 2'b10;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end
		7 : begin // bgt
			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
			Branchtype_o <= 2'b01;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			jump_o <= 0;	
		end
		35 : begin //lw 
			RegWrite_o <= 1;
			ALU_op_o <= 0;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Branchtype_o <= 2'b00;
			MemRead_o <= 1;
			MemWrite_o <= 0;
			MemtoReg_o <= 1;
			jump_o <= 0;
		end
		43 : begin //sw
			RegWrite_o <= 0;
			ALU_op_o <= 0;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
			Branchtype_o <= 2'b00;
			MemRead_o <= 0;
			MemWrite_o <= 1;
			MemtoReg_o <= 0;
			jump_o <= 0;
		end
		

		
		
		
		
	endcase
end

endmodule





                    
                    