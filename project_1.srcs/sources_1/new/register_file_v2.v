`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/16 13:53:14
// Design Name:
// Module Name: register_file
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


module register_file_v2(input [4:0]M,
                        input [31:0]W_Data,
                        input [3:0]R_Addr_A,
                        input [3:0]R_Addr_B,
                        input [3:0]R_Addr_C,
                        input [3:0]W_Addr,
                        input Write_Reg,
                        input Write_PC,
                        input [31:0]PC_New,
                        input clk,
                        input Rst,
                        output [31:0]R_Data_A,
                        output reg[31:0]R_Data_B,
                        output reg[31:0]R_Data_C,
                        output reg Error1,
                        output reg Error2);
// reg [31:0]R[0:15];
// reg [31:0]R_fiq[8:14];
// reg [31:0]R_irq[13:14];
// reg [31:0]R_abt[13:14];
// reg [31:0]R_svc[13:14];
// reg [31:0]R_und[13:14];
// reg [31:0]R_mon[13:14];
// reg [31:0]R_hyp;
reg [31:0]R[33:0];
wire[15:0]decode4_16;
wire en_fiq;
wire [7:0]Ren0_7;
wire [12:8]Ren8_12;
wire [12:8]Rfiqen8_12;
wire [7:0]R13en;
wire [7:0]R14en;
reg  [7:0]decodeR13;
reg  [7:0]decodeR14;
wire [33:0]Renable;
assign decode4_16 = 16'b1<<W_Addr;
assign en_fiq     = M[3:0] == 4'b0001;
assign Ren0_7     = decode4_16[7:0] & {8{Write_Reg & M[4]}};
assign Ren8_12    = decode4_16[12:8]&{5{Write_Reg & M[4]}}&{5{~en_fiq}};
assign Rfiqen8_12 = decode4_16[12:8]&{5{Write_Reg & M[4]}}&{5{en_fiq}};
assign R13en      = decodeR13&{8{decode4_16[13]}}&{8{Write_Reg & M[4]}};
assign R14en      = decodeR14&{8{decode4_16[14]}}&{8{Write_Reg & M[4]}};
assign Renable    = {Ren0_7,Ren8_12,Rfiqen8_12,R13en,R14en[7:2],R14en[0],Write_PC};


always @(*) begin
    decodeR13 = 8'b0;
    if (decode4_16[13])begin
        case(M[3:0])
            4'b0000,4'b1111:decodeR13 <= 8'h80;
            4'b0001:decodeR13         <= 8'h40;
            4'b0010:decodeR13         <= 8'h20;
            4'b0011:decodeR13         <= 8'h10;
            4'b0110:decodeR13         <= 8'h08;
            4'b0111:decodeR13         <= 8'h04;
            4'b1010:decodeR13         <= 8'h02;
            4'b1011:decodeR13         <= 8'h01;
            default :decodeR13        <= 8'b0;
        endcase
    end
    
end

always @(*) begin
    decodeR14 = 8'b0;
    if (decode4_16[14])begin
        case(M[3:0])
            4'b0000,4'b1111:decodeR14 <= 8'h80;
            4'b0001:decodeR14         <= 8'h40;
            4'b0010:decodeR14         <= 8'h20;
            4'b0011:decodeR14         <= 8'h10;
            4'b0110:decodeR14         <= 8'h08;
            4'b0111:decodeR14         <= 8'h04;
            4'b1011:decodeR14         <= 8'h01;
            default :decodeR14        <= 8'b0;
        endcase
    end
    
end

always @(posedge Rst or negedge clk) begin //writein
    if (Rst == 1)begin
        Error1 <= 0;
        R[0]   <= 8'h00000000;
        R[1]   <= 8'h00000000;
        R[2]   <= 8'h00000000;
        R[3]   <= 8'h00000000;
        R[4]   <= 8'h00000000;
        R[5]   <= 8'h00000000;
        R[6]   <= 8'h00000000;
        R[7]   <= 8'h00000000;
        R[8]   <= 8'h00000000;
        R[9]   <= 8'h00000000;
        R[10]  <= 8'h00000000;
        R[11]  <= 8'h00000000;
        R[12]  <= 8'h00000000;
        R[13]  <= 8'h00000000;
        R[14]  <= 8'h00000000;
        R[15]  <= 8'h00000000;
        R[16]  <= 8'h00000000;
        R[17]  <= 8'h00000000;
        R[18]  <= 8'h00000000;
        R[19]  <= 8'h00000000;
        R[20]  <= 8'h00000000;
        R[21]  <= 8'h00000000;
        R[22]  <= 8'h00000000;
        R[23]  <= 8'h00000000;
        R[24]  <= 8'h00000000;
        R[25]  <= 8'h00000000;
        R[26]  <= 8'h00000000;
        R[27]  <= 8'h00000000;
        R[28]  <= 8'h00000000;
        R[29]  <= 8'h00000000;
        R[30]  <= 8'h00000000;
        R[31]  <= 8'h00000000;
        R[32]  <= 8'h00000000;
        R[33]  <= 8'h00000000;
    end
    else
        R[Renable] <= W_Data;
end

wire[15:0]adecode4_16;
wire aen_fiq;
wire [7:0]aRen0_7;
wire [12:8]Ren8_12a;
wire [12:8]Rfiqen8_12a;
wire [7:0]R13ena;
wire [7:0]R14ena;
reg  [7:0]decodeR13a;
reg  [7:0]decodeR14a;
wire [33:0]Renablea;
assign adecode4_16 = 16'b1<<R_Addr_A;
assign aen_fiq     = M[3:0] == 4'b0001;
assign aRen0_7     = adecode4_16[7:0] ;
assign Ren8_12a    = adecode4_16[12:8]&{5{~aen_fiq}};
assign Rfiqen8_12a = adecode4_16[12:8]&{5{aen_fiq}};
assign R13ena      = decodeR13a&{8{adecode4_16[13]}};
assign R14ena      = decodeR14a&{8{adecode4_16[14]}};
assign Renablea    = {aRen0_7,Ren8_12a,Rfiqen8_12a,R13ena,R14ena[7:2],R14ena[0],Write_PC};
assign R_Data_A    = R[Renablea];

endmodule


