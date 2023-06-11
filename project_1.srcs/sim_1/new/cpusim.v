`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/22 17:43:55
// Design Name:
// Module Name: cpusim
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


module cpusim();
    reg Rst;
    reg clk;
    wire [3:0]NZCV;
    wire Write_PC;
    wire Write_IR;
    wire Write_Reg;
    wire LA;
    wire LB;
    wire LC;
    wire LF;
    wire S;
    wire rm_imm_s;
    wire [1:0]rs_imm_s;
    wire [3:0]ALU_OP;
    wire [2:0]Shift_OP;
    wire  [31:0]A;
    wire [31:0]B;
    wire [31:0]F;
    wire [31:0]IR;
    wire [31:0]PC;
    wire [31:0]M_R_Data;
    wire Mem_Write,Mem_W_s;
    CPU si(clk,Rst,
    NZCV,Write_PC,Write_IR,Write_Reg,LA,LB,LC,LF,S,
    rm_imm_s,rs_imm_s,ALU_OP,Shift_OP,A,B,F,PC,IR,Mem_Write,Mem_W_s,M_R_Data);
    
    initial begin
        clk = 1;
        Rst = 0;
        #10
        clk = 1;
        Rst = 1;
        #10
        clk = ~clk;
        Rst = 0;
        #10
        clk = ~clk;
        
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
        #10
        clk = ~clk;
    end
endmodule
