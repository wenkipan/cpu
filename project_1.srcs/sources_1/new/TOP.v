`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/17 21:32:47
// Design Name:
// Module Name: TOP
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


module TOP(input clk,
           input Rst,
           input [2:0]swb,
           output [3:0]NZCV,
           output Write_PC,
           output Write_IR,
           output W_Reg,
           output LA,
           output LB,
           output LC,
           output LF,
           output S,
           output rm_imm_s_ctrl,
           output [1:0]rs_imm_s_ctrl,
           output [3:0]ALU_OP_ctrl,
           output [2:0]Shift_OP_ctrl,
           output [2:0]which,
           output [7:0]seg,
           output enable);
    
    wire[31:0]A,B,F;
    CPU cc(clk,Rst,NZCV,Write_PC,Write_IR,W_Reg,LA,LB,LC,LF,S,rm_imm_s_ctrl,rs_imm_s_ctrl,ALU_OP_ctrl,Shift_OP_ctrl,A,B,F);
    
    reg [31:0]Data;
    always @(swb) begin
        if (swb[2] == 1)begin
            Data <= A;
        end
        
        if (swb[1] == 1)begin
            Data <= B;
        end
        
        if (swb[0] == 1)begin
            Data <= F;
        end
    end
    Display m_display(clk,Data,which,seg);
endmodule
