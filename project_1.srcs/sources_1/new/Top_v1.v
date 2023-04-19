`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/11 10:13:24
// Design Name:
// Module Name: Top_ALU
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


module Top_v1(input [31:0]sw,
              input [2:0]swb,
              input clk,
              output enable,
              output [2:0]which,
              output [7:0]seg,
              output [3:0]NZCV);
wire [31:0]A;
wire [31:0]B;
wire [31:0]Shift_out;
wire [3:0]ALU_OP;
wire [7:0]Shift_Num;
wire [2:0]SHIFT_OP;
wire CF;
wire VF;
wire shiftCout;
wire [31:0]F;
reg [31:0]Data;
assign enable = 1;
switch_v1 m_switch(sw,swb,A,B,ALU_OP,Shift_Num,SHIFT_OP,CF,VF);
Shift_barrel m_barrel(Shift_out,shiftCout,B,Shift_Num,CF,SHIFT_OP);
ALU m_alu(A,Shift_out,ALU_OP,CF,VF,shiftCout,F,NZCV);
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
