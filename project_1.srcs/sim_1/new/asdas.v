`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/23 18:35:06
// Design Name:
// Module Name: asdas
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


module asdas();
    reg [3:0]imm;
    wire [15:0]ikk;
    testv asd(imm,ikk);
    initial begin
        #10
        imm = 4'b0100;
        #10
        imm = 4'b1000;
    end
endmodule
