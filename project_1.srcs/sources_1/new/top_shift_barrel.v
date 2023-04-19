`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/03/28 16:09:26
// Design Name:
// Module Name: top_shift_barrel
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


module top_shift_barrel(input [31:0]sw,
                        input [2:0]swb,
                        input clk,
                        output enable,
                        output [2:0]which,
                        output [7:0]seg,
                        output Shift_Carry_Out);
wire [31:0]s_d;
wire[7:0]s_n;
wire c_f;
wire [2:0]s_op;
wire [31:0]s_o;
wire s_c_o;
//reg enable = 1;
swich m_swich(sw,swb,s_d,s_n,c_f,s_op);
Shift_barrel m_Shift_barrel(s_o,s_c_o,s_d,s_n,c_f,s_op);
Display m_display(clk,s_o,which,seg);
assign Shift_Carry_Out = s_c_o;
endmodule
