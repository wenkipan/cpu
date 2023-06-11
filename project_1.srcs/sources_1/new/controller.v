`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/09 16:58:54
// Design Name:
// Module Name: analysis
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


module controller(input [31:0]I,
                  output rm_imm_s,        //shift_barrel
                  output [1:0]rs_imm_s,
                  output [2:0]Shift_OP,
                  output reg [3:0]ALU_OP,
                  output S,
                  output TTCC);
wire [3:0]cond;
wire [3:0] OP;
//wire [3:0] OP1;
wire [1:0]type;
// wire [3:0]rn = I[19:16];
wire [3:0]rd    = I[15:12];
// wire [3:0]rs = I[11:8];
// wire [3:0]rm = I[3:0];

assign cond   = I[31:28];
// assign OP1 = I[27:15];
assign OP     = I[24:21];
assign S      = I[20];
assign type   = I[6:5];

localparam AND = 4'h0;
localparam EOR = 4'h1;
localparam SUB = 4'h2;
localparam RSB = 4'h3;
localparam ADD = 4'h4;
localparam ADC = 4'h5;
localparam SBC = 4'h6;
localparam RSC = 4'h7;
localparam TST = 4'h8;
localparam TEQ = 4'h9;
localparam CMP = 4'hA;
localparam CMN = 4'hB;
localparam ORR = 4'hC;
localparam MOV = 4'hD;
localparam BIC = 4'hE;
localparam MVN = 4'hF;

wire [2:0]DPx;
wire isf      = rd == 4'hf;
assign DPx[0] = (I[27:25] == 3'b000)&&(I[4] == 1'b0)&& (~isf);
assign DPx[1] = (I[27:25] == 3'b000)&&(I[4] == 1'b1)&&(I[7] == 1'b0)&& (~isf);
assign DPx[2] = (~isf)&&(I[27:25] == 3'b001);


// always @(*) begin
//     if (OP[3:2] == 2'b10&&S)
//         Und_Ins <= 1'b0;
//     else if (rd == 4'hf&&rn == 4'hE&&S == 1'b1&&(OP == MOV||OP == SUB))
//         Und_Ins <= 1'b0;
//     else if (DPx == 3'b100||DPx == 3'b010||DPx == 3'b001)
//         Und_Ins <= 1'b0;
//     else
//         Und_Ins <= 1'b1;
// end

always @(*) begin
    case (OP)
        TST:ALU_OP      <= 4'h0;
        TEQ:ALU_OP      <= 4'h1;
        CMP:ALU_OP      <= 4'h2;
        CMN:ALU_OP      <= 4'h4;
        default :ALU_OP <= OP;
    endcase
end

assign Shift_OP = (DPx[2])?3'b111:{type,DPx[1]};
assign rm_imm_s = DPx[2];
assign rs_imm_s = DPx>>1;
assign TTCC     = (OP == TST||OP == TEQ||OP == CMP||OP == CMN)?1'b1:1'b0;
endmodule
