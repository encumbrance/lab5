
module hazard_detection_unit(
    ID_EX_MEMRead_i,
    Branch_i,
    ID_EX_RT_i,
    IF_ID_RS_i,
    IF_ID_RT_i,
    PC_Write_o,
    IF_ID_Write_o,
    IF_flush_o,
    ID_flush_o,
    EX_flush_o,
);

input ID_EX_MEMRead_i;
input Branch_i;
input [4:0] ID_EX_RT_i;
input [4:0] IF_ID_RS_i;
input [4:0] IF_ID_RT_i;
output reg PC_Write_o;
output reg IF_ID_Write_o;
output reg IF_flush_o;
output reg ID_flush_o;
output reg EX_flush_o;

always @(*) begin
    if(ID_EX_MEMRead_i && ((ID_EX_RT_i == IF_ID_RS_i) || (ID_EX_RT_i == IF_ID_RT_i))) begin
        PC_Write_o = 0;
        IF_ID_Write_o = 0;
        IF_flush_o = 0;
        ID_flush_o = 1;
        EX_flush_o = 0;
    end
    else if(Branch_i) begin
        PC_Write_o = 1;
        IF_ID_Write_o = 0;
        IF_flush_o = 1;
        ID_flush_o = 1;
        EX_flush_o = 1;
    end
    else begin
        PC_Write_o = 1;
        IF_ID_Write_o = 1;
        IF_flush_o = 0;
        ID_flush_o = 0;
        EX_flush_o = 0;
    end
    
end

endmodule