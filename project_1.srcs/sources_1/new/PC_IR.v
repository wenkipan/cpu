`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/26 10:01:00
// Design Name:
// Module Name: PC_IR
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


module PC_IR(input clk,
             input Rst,
             input [31:0]PC,
             input Write_IR,
             input [3:0]NZCV,
             output reg[31:0]IR,
             output [31:0]IR_buf,
             output reg cond);
    //reg[31:0] PC;
    //wire[31:0]IR_buf;
    instROM instROMi(
    .clka(clk),
    .addra(PC[7:2]),
    .douta(IR_buf)
    );
    
    //reg cond;
    wire [3:0]CondBits = IR_buf[31:28];
    //assign CondBits = IR_buf[31:28];
    
    localparam EQ = 4'h0,NE = 4'h1,CS = 4'h2,CC = 4'h3;
    localparam MI = 4'h4,PL = 4'h5,VS = 4'h6,VC = 4'h7;
    localparam HI = 4'h8,LS = 4'h9,GE = 4'hA,LT = 4'hB;
    localparam GT = 4'hC,LE = 4'hD,AL = 4'hE,NV = 4'hF;
    localparam Nb = 3,Zb = 2,Cb = 1,Vb = 0;

    always @(*) begin
        case (CondBits)
            EQ:cond <= NZCV[Zb];
            NE:cond <= ~NZCV[Zb];
            CS:cond <= NZCV[Cb];
            CC:cond <= ~NZCV[Cb];
            MI:cond <= NZCV[Nb];
            PL:cond <= ~NZCV[Nb];
            VS:cond <= NZCV[Vb];
            VC:cond <= ~NZCV[Vb];
            HI:cond <= (NZCV[Cb]&~NZCV[Zb]);
            LS:cond <= (~NZCV[Cb]||NZCV[Zb]);
            GE:cond <= (~NZCV[Nb]^NZCV[Vb]);
            LT:cond <= (NZCV[Nb]^NZCV[Vb]);
            GT:cond <= (~NZCV[Zb]&(~NZCV[Nb]^NZCV[Vb]));
            LE:cond <= (NZCV[Zb]||(NZCV[Nb]^NZCV[Vb]));
            AL:cond <= 1'b1;
            NV:cond <= 1'b1;
        endcase
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst)IR             <= 32'h0;
        else if (W_IR_valid)IR <= IR_buf;
        
    end
    wire W_IR_valid = cond&Write_IR;
endmodule
