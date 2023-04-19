`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/03/28 15:38:29
// Design Name:
// Module Name: swich
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


module switch_v1(input [31:0]sw,
                 input [2:0]swb,
                 output reg[31:0]A,
                 output reg[31:0]B,
                 output reg[3:0] ALU_OP,
                 output reg[7:0] Shift_Num,
                 output reg[2:0] SHIFT_OP,
                 output reg CF,
                 output reg VF);

always @(posedge swb[2]) begin
    A <= sw;
end
always @(posedge swb[1]) begin
    B <= sw;
end
always @(posedge swb[0]) begin
    SHIFT_OP  <= sw[31:29];
    Shift_Num <= sw[23:16];
    ALU_OP    <= sw[5:2];
    CF        <= sw[1];
    VF        <= sw[0];
end
endmodule
