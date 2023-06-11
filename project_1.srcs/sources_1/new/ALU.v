`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/10 14:59:08
// Design Name:
// Module Name: ALU
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
// `timescale 1ns / 1ps

module ALU(input [31:0] A,
           input [31:0] B,
           input [3:0] ALU_OP,
           input CF,
           input VF,
           input shiftCout,
           output reg [31:0] F,
           output reg [3:0] NZCV);
reg Cout;
always@(*) begin
    case(ALU_OP)
        4'h0: F        <= A&B;
        4'h1: F        <= A^B;
        4'h2: {Cout,F} <= A-B;
        4'h3: {Cout,F} <= B-A;
        4'h4: {Cout,F} <= A+B;
        4'h5: {Cout,F} <= A+B+CF;
        4'h6: {Cout,F} <= A-B+CF-1;
        4'h7: {Cout,F} <= B-A+CF-1;
        4'h8: F        <= A;
        4'hA: {Cout,F} <= A-B+32'h4;
        4'hC: F        <= A|B;
        4'hD: F        <= B;
        4'hE: F        <= A&(~B);
        4'hF: F        <= ~B;
    endcase
end
always@(*) begin
    case(ALU_OP)
        4'h0,4'h1,4'hC,4'hE,4'hF,4'h8,4'hD:
        begin
            NZCV[1] <= shiftCout;
            NZCV[0] <= VF;
        end
        4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'hA:
        begin
            NZCV[1] <= ALU_OP[1]^Cout;
            NZCV[0] <= A[31]^B[31]^F[31]^Cout;
        end
    endcase
end
always@(*) begin
    NZCV[3] <= F[31];
    NZCV[2]  <= (F == 32'h0)?1'b1:1'b0;
end
endmodule

