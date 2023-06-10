
module forward_unit(
    EX_MEM_RegWrite_i,
    EX_MEM_Write_Reg_i,
    ID_EX_RS_i,
    ID_EX_RT_i,
    MEM_WB_RegWrite_i,
    MEM_WB_Write_Reg_i,
    forward1_o,
    forward2_o
);

input EX_MEM_RegWrite_i;
input [4:0] EX_MEM_Write_Reg_i;
input [4:0] ID_EX_RS_i;
input [4:0] ID_EX_RT_i;
input MEM_WB_RegWrite_i;
input [4:0] MEM_WB_Write_Reg_i;
output  [1:0] forward1_o;
output  [1:0] forward2_o;

reg [1:0] forward1_o, forward2_o;



always @(*) begin
    if(EX_MEM_RegWrite_i && (EX_MEM_Write_Reg_i != 0) && (EX_MEM_Write_Reg_i == ID_EX_RS_i))
        forward1_o = 2'b10;
    else if(MEM_WB_RegWrite_i && (MEM_WB_Write_Reg_i != 0) && (MEM_WB_Write_Reg_i == ID_EX_RS_i))
        forward1_o = 2'b01;
    else
        forward1_o = 2'b00;

    if(EX_MEM_RegWrite_i && (EX_MEM_Write_Reg_i != 0) && (EX_MEM_Write_Reg_i == ID_EX_RT_i))
        forward2_o = 2'b10;
    else if(MEM_WB_RegWrite_i && (MEM_WB_Write_Reg_i != 0) && (MEM_WB_Write_Reg_i == ID_EX_RT_i))
        forward2_o = 2'b01;
    else
        forward2_o = 2'b00;
end

endmodule