`timescale 1ns / 1ps

module CPU(input clk,
           input Rst,
           output reg [3:0]NZCV,
           output Write_PC,
           output Write_IR,
           output Write_Reg,
           output LA,
           output LB,
           output LC,
           output LF,
           output S,
           output rm_imm_s,
           output [1:0]rs_imm_s,
           output [3:0]ALU_OP,
           output [2:0]Shift_OP,
           output reg [31:0]A,
           output reg [31:0]B,
           output reg [31:0]F,
           output reg [31:0]PC,
           output [31:0]IR,
           output Mem_Write,
           output Mem_W_s,
           output [31:0]M_R_Data);
    //reg [31:0]A;
    //reg [31:0]B;
    //reg [31:0]F;
    //wire Mem_W_s,Mem_Write;
    wire [31:0]IR_BUF;
    reg [31:0]C;
    //reg [31:0]PC;
    //wire [31:0]IR;
    wire Cond;
    //wire [5:0]ST;
    wire [4:0]imm5   = IR[11:7];
    wire [11:0]imm12 = IR[11:0];
    wire [23:0]imm24 = IR[23:0];
    
    wire [3:0]rn = IR[19:16];
    wire [3:0]rd = IR[15:12];
    wire [3:0]rs = IR[11:8];
    wire [3:0]rm = IR[3:0];
    
    wire [3:0]NZCVout;
    wire [31:0]R_Data_A;
    wire [31:0]R_Data_B;
    wire [31:0]R_Data_C;
    wire [31:0]Shift_Out;
    wire [31:0]Fout;
    wire [4:0]M = 5'b10000;
    wire Error1;
    wire Error2;
    wire Shift_Carry_Out;
    wire ALU_A_s;
    wire [2:0]ALU_B_s;
    wire [1:0]PC_s;
    wire [1:0]rd_s;
    wire W_Rdata_s;
    wire Reg_C_s;
    always @(negedge clk or posedge Rst) begin
        if (Rst) A     <= 32'b0;
        else if (LA) A <= R_Data_A;
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst) B     <= 32'b0;
        else if (LB) B <= R_Data_B;
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst) C     <= 32'b0;
        else if (LC) C <= R_Data_C;
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst) F     <= 32'b0;
        else if (LF) F <= Fout;
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst) NZCV    <= 4'b0;
        else if (S) NZCV <= NZCVout[3:0];
    end
    always @(negedge clk or posedge Rst) begin
        if (Rst)
            PC <= 32'h0;
        else if (Write_PC)
            case (PC_s)
                2'b00:PC <= PC+32'h4;
                2'b01:PC <= B;
                2'b10:PC <= W_Data;
            endcase
        
    end
    
    FSM fsm(clk,Rst,IR,Cond,
    Write_PC,Write_IR,Write_Reg,LA,LB,LC,LF,ALU_A_s,ALU_B_s,
    Mem_W_s,Mem_Write,W_Rdata_s,PC_s,rd_s,Reg_C_s,S,rm_imm_s,rs_imm_s,Shift_OP,ALU_OP);
    
    PC_IR pcir(clk,Rst,PC,Write_IR,NZCV,IR,IR_BUF,Cond);
    
    
    reg [3:0]W_Addr;
    always @(*) begin
        case (rd_s)
            2'b00:W_Addr <= rd;
            2'b01:W_Addr <= 4'hE;
            2'b10:W_Addr <= rn;
        endcase
    end
    //wire [31:0]M_R_Data;
    reg [31:0]W_Data;
    always @(*) begin
        case(W_Rdata_s) //改为3-1数据选择
            2'b00:W_Data <= F;
            2'b10:W_Data <= M_R_Data;
        endcase
    end
    
    reg [3:0]R_Addr_C;
    always @(*) begin
        case(Reg_C_s) //LDR/STR/SWP 指令中rt和rd位置相同
            2'b00:R_Addr_C <= rs;
            2'b10:R_Addr_C <= rd;
        endcase
    end
    register_file rf(M,W_Data,rn,rm,R_Addr_C,W_Addr,Write_Reg,clk,Rst,
    R_Data_A,R_Data_B,R_Data_C,Error1,Error2);
    
    wire [31:0]Shift_Data = (rm_imm_s)?{24'b0,imm12[7:0]}:B;
    wire [7:0]Shift_Num   = (rs_imm_s == 2'b0)?{3'b0,imm5}:gen1;
    wire [5:0]imm121      = imm12[11:8]<<1;
    wire [7:0]gen1        = (rs_imm_s == 2'b1)?C[7:0]:{{3{1'b0}},imm121};
    Shift_barrel SB(Shift_Out,Shift_Carry_Out,Shift_Data,Shift_Num,NZCV[1],Shift_OP);
    
    wire [31:0]Ain    = ALU_A_s?PC:A;
    wire [25:0]imm242 = imm24<<2;
    reg [31:0]Bin;
    always @(*) begin //ALUb操作数三选一数据选择
        case (ALU_B_s)
            3'b000:Bin <= Shift_Out;
            3'b001:Bin <= imm24[23]?{{6{1'b1}},imm242}:{6'b0,imm242};
            3'b010:Bin <= {20'b0,imm12};
        endcase
    end
    ALU alu(Ain,Bin,ALU_OP,NZCV[1],NZCV[0],Shift_Carry_Out,Fout,NZCVout);
    
    wire [31:0]M_W_Data = Mem_W_s?C:B;//swp str 两种数据来源
    RAM_B ram(~clk,Mem_Write,F,M_W_Data,M_R_Data);
    
endmodule
