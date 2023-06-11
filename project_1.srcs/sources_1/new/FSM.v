`timescale 1ns / 1ps

module FSM(input clk,
           input Rst,
           input [31:0]IR,
           input isCondSatisfy,
           output reg Write_PC,
           output reg Write_IR,
           output reg Write_Reg,
           output reg LA,
           output reg LB,
           output reg LC,
           output reg LF,
           output reg ALU_A_s,
           output reg [2:0]ALU_B_s,
           output reg Mem_W_s,
           output reg Mem_Write,
           output reg W_Rdata_s,
           output reg [1:0]PC_s,
           output reg [1:0]rd_s,
           output reg Reg_C_s,
           output reg S_ctrl,
           output reg rm_imm_s_ctrl,
           output reg [1:0]rs_imm_s_ctrl,
           output reg [2:0]shift_OP_ctrl,
           output reg [3:0]ALU_OP_ctrl);
    wire rm_imm_s;
    wire S;
    wire TTCC;
    wire [1:0]rs_imm_s;
    wire [2:0]Shift_OP;
    wire [3:0]ALU_OP;
    
    controller ctrl(IR,rm_imm_s,rs_imm_s,Shift_OP,ALU_OP,S,TTCC);
    
    
    reg [5:0]Next_ST,ST;
    localparam Idle = 6'b0;
    localparam S0   = 6'b1;
    localparam S1   = 6'd2;
    localparam S2   = 6'd3;
    localparam S3   = 6'd4;
    localparam S7   = 6'd8;
    localparam S8   = 6'd7;
    localparam S9   = 6'd10;
    localparam S10  = 6'd11;
    localparam S11  = 6'd12;
    localparam S12  = 6'd13;
    localparam S13  = 6'd14;
    localparam S14  = 6'd15;
    localparam S15  = 6'd16;
    always @(posedge clk or posedge Rst) begin
        if (Rst)
            ST <= Idle;
        else
            ST <= Next_ST;
    end
    //wire isCondSatisfy = IR[27:25] == 3'b000;
    
    wire isB  = IR[27:24] == 4'b1010;
    wire isBL = IR[27:24] == 4'b1011;
    wire isBX = IR[27:4] == 24'b0010_0010_1111_1111_1111_0001;
    
    wire LDR0   = (IR[27:25] == 3'b010)&&(IR[22] == 0)&&(IR[20] == 1);
    wire STR0   = (IR[27:25] == 3'b010)&&(IR[22] == 0)&&(IR[20] == 0);
    wire LDR1   = (IR[27:25] == 3'b011)&&(IR[22] == 0)&&(IR[20] == 1)&&(IR[4] == 0);
    wire STR1   = (IR[27:25] == 3'b011)&&(IR[22] == 0)&&(IR[20] == 0)&&(IR[4] == 0);
    wire LDRSTR = LDR0||LDR1||STR0||STR1;
    wire P      = IR[24];
    wire U      = IR[23];
    wire W      = IR[21];
    //isCondSatisfy?(isB?S8:(isBL?S10:S1)):S0
    always @(*) begin
        case (ST)
            Idle:Next_ST     = S0;
            S0:Next_ST       = isCondSatisfy?(isB?S8:(isBL?S10:S1)):S0;
            S1:Next_ST       = isBX?S7:(LDRSTR?S12:S2);
            S2:Next_ST       = TTCC?S0:S3;
            S3:Next_ST       = S0;
            S7:Next_ST       = S0;
            S8:Next_ST       = S9;
            S9:Next_ST       = S0;
            S10:Next_ST      = S11;
            S11:Next_ST      = S9;
            S12:Next_ST      = (LDR0||LDR1)?S13:S15;
            S13:Next_ST      = S14;
            S15:Next_ST      = S14;
            S14:Next_ST      = S0;
            default :Next_ST = S0;
        endcase
    end
    
    
    always @(posedge clk or posedge Rst) begin
        Write_PC      <= 1'b0;
        Write_IR      <= 1'b0;
        Write_Reg     <= 1'b0;
        LA            <= 1'b0;
        LB            <= 1'b0;
        LC            <= 1'b0;
        LF            <= 1'b0;
        S_ctrl        <= 1'b0;
        ALU_A_s       <= 0;
        ALU_B_s       <= 0;
        PC_s          <= 0;
        rd_s          <= 0;
        rm_imm_s_ctrl <= 0;
        rs_imm_s_ctrl <= 0;
        Reg_C_s       <= 0;
        Mem_W_s       <= 0;
        Mem_Write     <= 0;
        if (Rst)begin
            Write_PC      <= 1'b0;
            Write_IR      <= 1'b0;
            Write_Reg     <= 1'b0;
            LA            <= 1'b0;
            LB            <= 1'b0;
            LC            <= 1'b0;
            LF            <= 1'b0;
            S_ctrl        <= 1'b0;
            ALU_A_s       <= 0;
            ALU_B_s       <= 0;
            PC_s          <= 0;
            rd_s          <= 0;
            rm_imm_s_ctrl <= 0;
            rs_imm_s_ctrl <= 0;
            Reg_C_s       <= 0;
            Mem_W_s       <= 0;
            Mem_Write     <= 0;
        end
        else begin
            case (Next_ST)
                S0:begin
                    Write_PC <= 1'b1;
                    Write_IR <= 1'b1;
                    PC_s     <= 2'b0;
                end
                S1:begin
                    LA <= 1'b1;
                    LB <= 1'b1;
                    LC <= 1'b1;
                    if (STR0||STR1)begin
                        Reg_C_s <= 1'b1;
                    end
                end
                S2:begin
                    LF            <= 1'b1;
                    rm_imm_s_ctrl <= rm_imm_s;
                    rs_imm_s_ctrl <= rs_imm_s;
                    shift_OP_ctrl <= Shift_OP;
                    ALU_OP_ctrl   <= ALU_OP;
                    S_ctrl        <= S;
                end
                S3:begin
                    Write_Reg <= 1'b1;
                end
                S7:begin
                    Write_PC <= 1'b1;
                    PC_s     <= 2'b01;
                end
                S8:begin
                    ALU_A_s     <= 1'b1;
                    ALU_B_s     <= 3'b1;
                    ALU_OP_ctrl <= 4'b0100;
                    S_ctrl      <= 1'b0;
                    LF          <= 1'b1;
                end
                S9:begin
                    Write_PC <= 1'b1;
                    PC_s     <= 2'b10;
                end
                S10:begin
                    ALU_A_s     <= 1'b1;
                    ALU_OP_ctrl <= 4'b1000;
                    S_ctrl      <= 0;
                    LF          <= 1;
                end
                S11:begin
                    ALU_A_s     <= 1'b1;
                    ALU_B_s     <= 3'b1;
                    ALU_OP_ctrl <= 4'b0100;
                    S_ctrl      <= 1'b0;
                    LF          <= 1'b1;
                    rd_s        <= 1'b1;
                    Write_Reg   <= 1'b1;
                end
                S12:begin
                    ALU_A_s <= 0;
                    S_ctrl  <= 0;
                    LF      <= 1'b1;
                    if (~P)begin
                        ALU_OP_ctrl <= 4'b1000;
                    end
                    else begin
                        ALU_B_s     <= 3'b10;
                        ALU_OP_ctrl <= U?4'b0100:4'b0010;
                        if (LDR1||STR1)begin
                            shift_OP_ctrl <= {IR[6:5],1'b0};
                            rm_imm_s_ctrl <= 0;
                            rs_imm_s_ctrl <= 0;
                        end
                    end
                end
                S13:begin
                    if (~P)begin
                        if (LDR0)begin
                            ALU_A_s     <= 0;
                            ALU_B_s     <= 3'b010;
                            ALU_OP_ctrl <= U?4'b0100:4'b0010;
                            S_ctrl      <= 0;
                            LF          <= 1'b1;
                            W_Rdata_s   <= 2'b10;
                            rd_s        <= 2'b00;
                            Write_Reg   <= 1'b1;
                        end
                        else begin
                            rm_imm_s_ctrl <= 0;
                            rs_imm_s_ctrl <= 0;
                            shift_OP_ctrl <= {IR[6:5],1'b0};
                            ALU_A_s       <= 0;
                            ALU_B_s       <= 3'b0;
                            ALU_OP_ctrl   <= U?4'b0100:4'b0010;
                            S_ctrl        <= 0;
                            LF            <= 1;
                            W_Rdata_s     <= 2'b10;
                            rd_s          <= 2'b00;
                            Write_Reg     <= 1'b1;
                        end
                    end
                    else begin
                        W_Rdata_s <= 2'b10;
                        rd_s      <= 2'b00;
                        Write_Reg <= 1'b1;
                    end
                end
                S14:begin
                    if (W||~P)begin
                        W_Rdata_s <= 2'b00;
                        rd_s      <= 2'b10;
                        Write_Reg <= 1'b1;
                    end
                end
                S15:begin
                    if (~P)begin
                        if (STR0)begin
                            ALU_A_s     <= 0;
                            ALU_B_s     <= 3'b010;
                            ALU_OP_ctrl <= 4'b0100;
                            S_ctrl      <= 0;
                            LF          <= 1;
                            Mem_W_s     <= 1;
                            Mem_Write   <= 1;
                        end
                        else begin
                            rm_imm_s_ctrl <= 0;
                            rs_imm_s_ctrl <= 0;
                            shift_OP_ctrl <= {IR[6:5],1'b0};
                            ALU_A_s       <= 0;
                            ALU_B_s       <= 3'b000;
                            ALU_OP_ctrl   <= 4'b0100;
                            S_ctrl        <= 0;
                            LF            <= 1;
                            Mem_W_s       <= 1;
                            Mem_Write     <= 1;
                        end
                    end
                    else begin
                        Mem_W_s   <= 1;
                        Mem_Write <= 1;
                    end
                end
            endcase
        end
    end
    
    
    
endmodule
