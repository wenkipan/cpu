`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/23 18:33:49
// Design Name:
// Module Name: testv
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


module testv(input [3:0]imm,
             output [15:0]ikk);
wire [5:0]c = imm<<2;
assign ikk  = {{10'b1111111111},c};
endmodule
