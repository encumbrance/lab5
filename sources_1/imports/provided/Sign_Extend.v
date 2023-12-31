//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      110550148
//----------------------------------------------
//Date:        05/01
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
wire     [32-1:0] data_o;

//Sign extended
assign data_o = {{16{data_i[15]}} , data_i};            
endmodule      
     