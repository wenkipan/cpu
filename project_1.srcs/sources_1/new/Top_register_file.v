`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/17 11:42:33
// Design Name:
// Module Name: Top_register_file
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Top_register_file(input [31:0]sw,
                         input [5:0]swb,
                         input clk,
                         output enable,
                         output [2:0]which,
                         output [7:0]seg,
                         output [4:0]M,
                         output Error1,
                         output Error2);
// wire [4:0]M;
wire [31:0]W_Data;
wire [3:0]R_Addr_A;
wire [3:0]R_Addr_B;
wire [3:0]R_Addr_C;
wire [3:0]W_Addr;
wire Write_Reg;
wire Write_PC;
wire [31:0]PC_New;
wire Rst;
wire[31:0]R_Data_A;
wire[31:0]R_Data_B;
wire[31:0]R_Data_C;
// wire Error1;
// wire Error2;
reg [31:0]Data;
switch_register_file m_switch(sw,swb,M,W_Data,R_Addr_A,R_Addr_B,R_Addr_C,W_Addr,Write_Reg,Write_PC,PC_New,Rst);
register_file m_register_file(M,W_Data,R_Addr_A,R_Addr_B,R_Addr_C,W_Addr,Write_Reg,clk,Rst,R_Data_A,R_Data_B,R_Data_C,Error1,Error2);
always @(swb)begin
    if (swb[5] == 1)
        Data <= R_Data_A;
    
    if (swb[4] == 1)
        Data <= R_Data_B;
    
    if (swb[3] == 1)
        Data <= R_Data_C;
    
end

Display m_display(clk,Data,which,seg);
endmodule
