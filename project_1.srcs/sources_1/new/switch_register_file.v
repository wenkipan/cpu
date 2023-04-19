`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/17 11:43:44
// Design Name:
// Module Name: switch_register_file
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


module switch_register_file(input [31:0]sw,
                            input [5:0]swb,
                            output reg [4:0]M,
                            output reg [31:0]W_Data,
                            output reg [3:0]R_Addr_A,
                            output reg [3:0]R_Addr_B,
                            output reg [3:0]R_Addr_C,
                            output reg [3:0]W_Addr,
                            output reg Write_Reg,
                            output reg Write_PC,
                            output reg [31:0]PC_New,
                            output reg Rst);
always @(posedge swb[2]) begin
    W_Data <= sw;
end
always @(posedge swb[1]) begin
    M         <= sw[4:0];
    R_Addr_A  <= sw[27:24];
    R_Addr_B  <= sw[23:20];
    R_Addr_C  <= sw[19:16];
    W_Addr    <= sw[31:28];
    Write_Reg <= sw[7];
    Write_PC  <= sw[6];
    Rst       <= sw[5];
end
always @(posedge swb[0]) begin
    PC_New <= sw;
end
endmodule
