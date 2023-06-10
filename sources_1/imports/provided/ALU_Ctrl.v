//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110550148
//----------------------------------------------
//Date:        05/01
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*) begin
    case(ALUOp_i)
        0 : ALUCtrl_o <= 2;             //lw/sw
        3'b001 : ALUCtrl_o <= 6;        //beq
        3'b010 : case(funct_i)   //R-type
            6'b100000 : ALUCtrl_o <= 2;   //add
            6'b100010 : ALUCtrl_o <= 6;   //sub
            6'b100100 : ALUCtrl_o <= 0;   //and
            6'b100101 : ALUCtrl_o <= 1;   //or
            6'b101010 : ALUCtrl_o <= 7;   //slt
            6'b001000 : ALUCtrl_o <= 2;   //jr
            6'b011000 : ALUCtrl_o <= 3; //mul
            6'b100110 : ALUCtrl_o <= 4; //xor
        endcase
        3'b100 : ALUCtrl_o <= 2;         //addi
        3'b101 : ALUCtrl_o <= 7;         //slti
    endcase
end

endmodule     





                    
                    