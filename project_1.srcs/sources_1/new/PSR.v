`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/23 10:39:39
// Design Name:
// Module Name: PSR
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


module PSR(input clk,
           input Rst,
           input W_CPSR_s,
           input W_CPSR,
           input W_SPSR_s,
           input W_SPSR,
           input S,
           input [3:0]NZCV,
           input [31:0]CPSR_New,
           input [31:0]SPSR_New,
           input [3:0]MASK,
           output reg[31:0]CPSR,
           output reg[31:0]SPSR_fiq,
           output reg[31:0]SPSR_irq,
           output reg[31:0]SPSR_svc,
           output reg[31:0]SPSR_mon,
           output reg[31:0]SPSR_abt,
           output reg[31:0]SPSR_hyp,
           output reg[31:0]SPSR_und);
    
    reg [31:0]SPSR;
    wire [31:0]CPSR_D;
    wire [31:0]SPSR_D;
    wire [3:0]NZCV_D;
    //mux_2 m1(CPSR_New,SPSR,W_CPSR_s,CPSR_D);
    assign CPSR_D = (W_CPSR_s == 1)?CPSR_New:SPSR;
    assign SPSR_D = (W_SPSR_s == 1)?CPSR:SPSR_New;
    assign NZCV_D = (S == 1)?NZCV:CPSR_D[31:28];
    
    always @(*) begin
        if (CPSR[4])begin
            case(CPSR[3:0])
                4'b0001:SPSR   <= SPSR_fiq;
                4'b0010:SPSR   <= SPSR_irq;
                4'b0011:SPSR   <= SPSR_svc;
                4'b0110:SPSR   <= SPSR_mon;
                4'b0111:SPSR   <= SPSR_abt;
                4'b1010:SPSR   <= SPSR_hyp;
                4'b1011:SPSR   <= SPSR_und;
                default : SPSR <= 32'b0;
            endcase
        end
        else
            SPSR <= 32'b0;
    end
    
    always @(negedge clk or posedge Rst) begin
        if (Rst == 1)begin
            CPSR     <= 32'h0000_0010;
            SPSR_abt <= 32'h0000_0000;
            SPSR_fiq <= 32'h0000_0000;
            SPSR_irq <= 32'h0000_0000;
            SPSR_svc <= 32'h0000_0000;
            SPSR_mon <= 32'h0000_0000;
            SPSR_hyp <= 32'h0000_0000;
            SPSR_und <= 32'h0000_0000;
        end
        else begin
            if (S||(W_CPSR&&((~W_CPSR_s)||MASK[0])))
                CPSR[31:28] <= NZCV_D;
            
            if (W_CPSR&&((~W_CPSR_s)||MASK[0]))
                CPSR[7:0] <= CPSR_D[7:0];
            
            if (W_CPSR&&((~W_CPSR_s)||MASK[1]))
                CPSR[15:8] <= CPSR_D[15:8];
            
            if (W_CPSR&&((~W_CPSR_s)||MASK[2]))
                CPSR[23:16] <= CPSR_D[23:16];
            
            if (W_CPSR&&((~W_CPSR_s)||MASK[3]))
                CPSR[27:24] <= CPSR_D[27:24];
            
            if (W_SPSR)begin
                if (CPSR[4])begin
                    case(CPSR[3:0])
                        4'b0001:SPSR_fiq <= SPSR_D;
                        4'b0010:SPSR_irq <= SPSR_D;
                        4'b0011:SPSR_svc <= SPSR_D;
                        4'b0110:SPSR_mon <= SPSR_D;
                        4'b0111:SPSR_abt <= SPSR_D;
                        4'b1010:SPSR_hyp <= SPSR_D;
                        4'b1011:SPSR_und <= SPSR_D;
                    endcase
                end
            end
            
        end
    end
endmodule
