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


module swich(input [31:0]sw,
             input [2:0]swb,
             output reg[31:0]Shift_Data,
             output reg[7:0] Shift_Num,
             output reg Carry_Flag,
             output reg [2:0] SHIFT_OP);
// always @(*) begin
//     if (swb[0] == 1&&swb[1] == 0)begin
//         Shift_Data <= sw;
//         Carry_Flag <= swb[2];
//     end

//     if (swb[0] == 1&&swb[1] == 0)begin
//         SHIFT_OP   <= sw[31:29];
//         Shift_Num  <= sw[23:16];
//         Carry_Flag <= swb[2];
//     end
// end
always @(posedge swb[0]) begin
    Shift_Data <= sw[31:0];
end
always @(posedge swb[1]) begin
    SHIFT_OP  <= sw[31:29];
    Shift_Num <= sw[23:16];
end
always @(swb[2]) begin
    Carry_Flag <= swb[2];
end
endmodule
