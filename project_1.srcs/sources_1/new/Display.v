`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/03/28 16:27:33
// Design Name:
// Module Name: digit
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


module Display(clk,
               Data,
               which,
               seg);
    input clk;
    input [31:0]Data;
    output reg [2:0]which = 0;
    output reg [7:0]seg;
    reg [3:0]digit;
    reg [14:0]count = 0;
    always @(posedge clk)count <= count+1'b1;
    
    always @(negedge clk)if (&count) which <= which+1'b1;
    
    always @(*)
        case(which)
            0:digit <= Data[31:28];
            1:digit <= Data[27:24];
            2:digit <= Data[23:20];
            3:digit <= Data[19:16];
            4:digit <= Data[15:12];
            5:digit <= Data[11:8];
            6:digit <= Data[7:4];
            7:digit <= Data[3:0];
        endcase
    
    always @(*)
        case(digit)
            4'h0:seg <= 8'b00000011;
            4'h1:seg <= 8'b10011111;
            4'h2:seg <= 8'b00100101;
            4'h3:seg <= 8'b00001101;
            4'h4:seg <= 8'b10011001;
            4'h5:seg <= 8'b01001001;
            4'h6:seg <= 8'b01000001;
            4'h7:seg <= 8'b00011111;
            4'h8:seg <= 8'b00000001;
            4'h9:seg <= 8'b00001001;
            4'hA:seg <= 8'b00010001;
            4'hB:seg <= 8'b11000001;
            4'hC:seg <= 8'b01100011;
            4'hD:seg <= 8'b10000101;
            4'hE:seg <= 8'b01100001;
            4'hF:seg <= 8'b01110001;
        endcase
endmodule
