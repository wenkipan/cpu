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


module register_file(input [4:0]M,
                     input [31:0]W_Data,
                     input [3:0]R_Addr_A,
                     input [3:0]R_Addr_B,
                     input [3:0]R_Addr_C,
                     input [3:0]W_Addr,
                     input Write_Reg,
                     input clk,
                     input Rst,
                     output reg[31:0]R_Data_A,
                     output reg[31:0]R_Data_B,
                     output reg[31:0]R_Data_C,
                     output reg Error1,
                     output reg Error2);
reg [31:0]R[0:15];
reg [31:0]R_fiq[8:14];
reg [31:0]R_irq[13:14];
reg [31:0]R_abt[13:14];
reg [31:0]R_svc[13:14];
reg [31:0]R_und[13:14];
reg [31:0]R_mon[13:14];
reg [31:0]R_hyp;
always @(posedge Rst or negedge clk) begin //writein
    if (Rst == 1)begin
        Error1    <= 1;
        R[0]      <= 8'h00000000;
        R[1]      <= 8'h00000000;
        R[2]      <= 8'h00000000;
        R[3]      <= 8'h00000000;
        R[4]      <= 8'h00000000;
        R[5]      <= 8'h00000000;
        R[6]      <= 8'h00000000;
        R[7]      <= 8'h00000000;
        R[8]      <= 8'h00000000;
        R[9]      <= 8'h00000000;
        R[10]     <= 8'h00000000;
        R[11]     <= 8'h00000000;
        R[12]     <= 8'h00000000;
        R[13]     <= 8'h00000000;
        R[14]     <= 8'h00000000;
        R[15]     <= 8'h00000000;
        R_fiq[8]  <= 8'h00000000;
        R_fiq[9]  <= 8'h00000000;
        R_fiq[10] <= 8'h00000000;
        R_fiq[11] <= 8'h00000000;
        R_fiq[12] <= 8'h00000000;
        R_fiq[13] <= 8'h00000000;
        R_fiq[14] <= 8'h00000000;
        R_irq[13] <= 8'h00000000;
        R_irq[14] <= 8'h00000000;
        R_abt[13] <= 8'h00000000;
        R_abt[14] <= 8'h00000000;
        R_svc[13] <= 8'h00000000;
        R_svc[14] <= 8'h00000000;
        R_und[13] <= 8'h00000000;
        R_und[14] <= 8'h00000000;
        R_mon[13] <= 8'h00000000;
        R_mon[14] <= 8'h00000000;
        R_hyp     <= 8'h00000000;
    end
    else begin
        if (M[4] == 0)//error1
            Error1 = 1;
        else begin
            Error1 = 0;
            if (Write_Reg)begin
                case(W_Addr[3:0])
                    4'hF:begin
                        Error1 = 1;
                    end
                    4'h0,4'h1,4'h2,4'h3,4'h4,4'h5,4'h6,4'h7:begin
                        R[W_Addr] <= W_Data;
                    end
                    4'h8,4'h9,4'hA,4'hB,4'hC:begin//fiq
                        if (M[3:0] == 4'b0001)
                            R_fiq[W_Addr] <= W_Data;
                        else
                            R[W_Addr] <= W_Data;
                    end
                    4'hD,4'hE:begin
                        case(M[3:0])
                            4'b0000:R[W_Addr]     <= W_Data;
                            4'b0001:R_fiq[W_Addr] <= W_Data;
                            4'b0010:R_irq[W_Addr] <= W_Data;
                            4'b0011:R_svc[W_Addr] <= W_Data;
                            4'b0110:R_mon[W_Addr] <= W_Data;
                            4'b0111:R_abt[W_Addr] <= W_Data;
                            4'b1010:begin
                                if (W_Addr == 13)
                                    R_hyp <= W_Data;
                                else
                                    Error1 = 1;
                            end
                            4'b1011:R_und[W_Addr] <= W_Data;
                            4'b1111:R[W_Addr]     <= W_Data;
                            default :Error1 = 1;
                        endcase
                    end
                endcase
            end
            
        end
    end
end
wire fiq;
assign fiq = M[3:0] == 4'b0001;

always @(*) begin //read
    Error2 = 1'b0;
    R_Data_A <= 0;
    R_Data_B <= 0;
    R_Data_C <= 0;
    case(R_Addr_A[3:0])
        4'h0,4'h1,4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'hF:begin
            R_Data_A <= R[R_Addr_A];
        end
        4'h8,4'h9,4'hA,4'hB,4'hC:begin
            R_Data_A <= fiq ? R_fiq[R_Addr_A]: R[R_Addr_A];
        end
        4'hD,4'hE:begin
            case(M[3:0])
                4'b0000:R_Data_A <= R[R_Addr_A];
                4'b0001:R_Data_A <= R_fiq[R_Addr_A];
                4'b0010:R_Data_A <= R_irq[R_Addr_A];
                4'b0011:R_Data_A <= R_svc[R_Addr_A];
                4'b0110:R_Data_A <= R_mon[R_Addr_A];
                4'b0111:R_Data_A <= R_abt[R_Addr_A];
                4'b1010:begin
                    if (R_Addr_A == 14)
                        R_Data_A <= R_hyp;
                    else
                        Error2 = 1;
                end
                4'b1011:R_Data_A <= R_und[R_Addr_A];
                4'b1111:R_Data_A <= R[R_Addr_A];
                default :Error2 = 1;
            endcase
        end
    endcase
    case(R_Addr_B[3:0])
        4'h0,4'h1,4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'hF:begin
            R_Data_B <= R[R_Addr_B];
        end
        4'h8,4'h9,4'hA,4'hB,4'hC:begin
            R_Data_B <= fiq ? R_fiq[R_Addr_B]: R[R_Addr_B];
        end
        4'hD,4'hE:begin
            case(M[3:0])
                4'b0000:R_Data_B <= R[R_Addr_B];
                4'b0001:R_Data_B <= R_fiq[R_Addr_B];
                4'b0010:R_Data_B <= R_irq[R_Addr_B];
                4'b0011:R_Data_B <= R_svc[R_Addr_B];
                4'b0110:R_Data_B <= R_mon[R_Addr_B];
                4'b0111:R_Data_B <= R_abt[R_Addr_B];
                4'b1010:begin
                    if (R_Addr_B == 14)
                        R_Data_B <= R_hyp;
                    else
                        Error2 = 1;
                end
                4'b1011:R_Data_B <= R_und[R_Addr_B];
                4'b1111:R_Data_B <= R[R_Addr_B];
                default :Error2 = 1;
            endcase
        end
    endcase
    case(R_Addr_C[3:0])
        4'h0,4'h1,4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'hF:begin
            R_Data_C <= R[R_Addr_C];
        end
        4'h8,4'h9,4'hA,4'hB,4'hC:begin
            R_Data_C <= fiq ? R_fiq[R_Addr_C]: R[R_Addr_C];
        end
        4'hD,4'hE:begin
            case(M[3:0])
                4'b0000:R_Data_C <= R[R_Addr_C];
                4'b0001:R_Data_C <= R_fiq[R_Addr_C];
                4'b0010:R_Data_C <= R_irq[R_Addr_C];
                4'b0011:R_Data_C <= R_svc[R_Addr_C];
                4'b0110:R_Data_C <= R_mon[R_Addr_C];
                4'b0111:R_Data_C <= R_abt[R_Addr_C];
                4'b1010:begin
                    if (R_Addr_C == 14)
                        R_Data_C <= R_hyp;
                    else
                        Error2 = 1;
                end
                4'b1011:R_Data_C <= R_und[R_Addr_C];
                4'b1111:R_Data_C <= R[R_Addr_C];
                default :Error2 = 1;
            endcase
        end
    endcase
end
endmodule

// if (W_Addr<8)
//                 begin //R7 & before
//                     R[W_Addr] <= W_Data;
//                 end
//                 else if (W_Addr<13)
//                 begin //R12(one special case)
//                     if (M[3:0] == 4'b0001)
//                         R_fiq[W_Addr] <= W_Data;//fiq
//                     else
//                         R[W_Addr] <= W_Data;
//                 end
//                 else
//                 begin //left
//                     case(M[3:0])
//                         4'b0000:R[W_Addr]     <= W_Data;
//                         4'b0001:R_fiq[W_Addr] <= W_Data;
//                         4'b0010:R_irq[W_Addr] <= W_Data;
//                         4'b0011:R_svc[W_Addr] <= W_Data;
//                         4'b0110:R_mon[W_Addr] <= W_Data;
//                         4'b0111:R_abt[W_Addr] <= W_Data;
//                         4'b1010:R_hyp         <= W_Data;
//                         4'b1011:R_und[W_Addr] <= W_Data;
//                         4'b1111:R[W_Addr]     <= W_Data;
//                         default :Error1 = 1;
//                     endcase
//                 end

// if (R_Addr_A == 14&&M[3:0] == 4'b1010)begin
//     Error2 = 1;
// end
// else begin
//     if (R_Addr_A == 15||R_Addr_A<8)begin
//         R_Data_A <= R[15];
//     end
//     else if (R_Addr_A<13)begin
//         if (M[3:0] == 4'b0001)begin
//             R_Data_A <= R_fiq[R_Addr_A];
//         end
//         else begin
//             R_Data_A <= R[R_Addr_A];
//         end
//     end
//     else begin
//         case(M[3:0])
//             4'b0000:R_Data_A <= R[R_Addr_A];
//             4'b0001:R_Data_A <= R_fiq[R_Addr_A];
//             4'b0010:R_Data_A <= R_irq[R_Addr_A];
//             4'b0011:R_Data_A <= R_svc[R_Addr_A];
//             4'b0110:R_Data_A <= R_mon[R_Addr_A];
//             4'b0111:R_Data_A <= R_abt[R_Addr_A];
//             4'b1010:R_Data_A <= R_hyp;
//             4'b1011:R_Data_A <= R_und[R_Addr_A];
//             4'b1111:R_Data_A <= R[R_Addr_A];
//             default :Error2 = 1;
//         endcase
//     end
// end
// if (R_Addr_B == 14&&M[3:0] == 4'b1010)begin
//     Error2 = 1;
// end
// else begin
//     if (R_Addr_B == 15||R_Addr_B<8)begin
//         R_Data_B <= R[15];
//     end
//     else if (R_Addr_B<13)begin
//         if (M[3:0] == 4'b0001)begin
//             R_Data_B <= R_fiq[R_Addr_B];
//         end
//         else begin
//             R_Data_B <= R[R_Addr_B];
//         end
//     end
//     else begin
//         case(M[3:0])
//             4'b0000:R_Data_B <= R[R_Addr_B];
//             4'b0001:R_Data_B <= R_fiq[R_Addr_B];
//             4'b0010:R_Data_B <= R_irq[R_Addr_B];
//             4'b0011:R_Data_B <= R_svc[R_Addr_B];
//             4'b0110:R_Data_B <= R_mon[R_Addr_B];
//             4'b0111:R_Data_B <= R_abt[R_Addr_B];
//             4'b1010:R_Data_B <= R_hyp;
//             4'b1011:R_Data_B <= R_und[R_Addr_B];
//             4'b1111:R_Data_B <= R[R_Addr_B];
//             default :Error2 = 1;
//         endcase
//     end
// end
// if (R_Addr_C == 14&&M[3:0] == 4'b1010)begin
//     Error2 = 1;
// end
// else begin
//     if (R_Addr_C == 15||R_Addr_C<8)begin
//         R_Data_C <= R[15];
//     end
//     else if (R_Addr_C<13)begin
//         if (M[3:0] == 4'b0001)begin
//             R_Data_C <= R_fiq[R_Addr_C];
//         end
//         else begin
//             R_Data_C <= R[R_Addr_C];
//         end
//     end
//     else begin
//         case(M[3:0])
//             4'b0000:R_Data_C <= R[R_Addr_C];
//             4'b0001:R_Data_C <= R_fiq[R_Addr_C];
//             4'b0010:R_Data_C <= R_irq[R_Addr_C];
//             4'b0011:R_Data_C <= R_svc[R_Addr_C];
//             4'b0110:R_Data_C <= R_mon[R_Addr_C];
//             4'b0111:R_Data_C <= R_abt[R_Addr_C];
//             4'b1010:R_Data_C <= R_hyp;
//             4'b1011:R_Data_C <= R_und[R_Addr_C];
//             4'b1111:R_Data_C <= R[R_Addr_C];
//             default :Error2 = 1;
//         endcase
//     end
// end

