`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/03/26 15:57:29
// Design Name:
// Module Name: try2
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


module try2();
    wire [31:0] Shift_Out;
    wire Shift_Carry_Out;
    reg [31:0] Shift_Data;
    reg [7:0] Shift_Num;
    reg  Carry_Flag;
    reg  [2:0] SHIFT_OP;
    integer  count;
    Shift_barrel uut(
    .Shift_Out(Shift_Out),
    .Shift_Carry_Out(Shift_Carry_Out),
    .Shift_Data(Shift_Data),
    .Shift_Num(Shift_Num),
    .Carry_Flag(Carry_Flag),
    .SHIFT_OP(SHIFT_OP)
    );
    initial begin
        SHIFT_OP   = 3'b000;
        Shift_Num  = 8'b0;
        Carry_Flag = 1;
        Shift_Data = 32'h8000_0001;
        count      = 0;
        repeat(7)begin
            repeat(40)begin
                #2;
                Shift_Num = Shift_Num+8'b1;
            end
            SHIFT_OP  = SHIFT_OP+3'b1;
            Shift_Num = 8'b0;
        end
        repeat(40)begin
            #2;
            Shift_Num = Shift_Num+8'b1;
        end
    end
    
    
    
    
    
endmodule
