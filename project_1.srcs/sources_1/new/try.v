`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/25 13:26:20
// Design Name: 
// Module Name: try
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


module try(  
output reg [31:0] Shift_out,
output reg Shift_carry_out,
input  [31:0] Shift_Data,
input  [8:0]Shift_Num,
input  [2:0]SHIFT_OP,
input  Carry_flag

    );
always@(*)
begin
    case(SHIFT_OP[2:1])
        2'b00:
        begin
            if(Shift_Num==0)
            begin
                Shift_out<=Shift_Data[31:0];
                // Shift_carry_out<= z; 
            end

            if(Shift_Num>=1&&Shift_Num<=32)
            begin
                Shift_out<=Shift_Data[31:0]<<Shift_Num;
                Shift_carry_out<= Shift_Data[32-Shift_Num]; 
            end
            
            if(Shift_Num>32)
            begin
                Shift_out<=0;
                Shift_carry_out<=0;
            end
        end
        2'b01:
        begin
            if(SHIFT_OP[0]==0&&Shift_Num==0)
            begin
                Shift_out<=0;
                Shift_carry_out<=Shift_Data[31];
            end
            if(SHIFT_OP[0]==1&&Shift_Num==0)
            begin
                Shift_out<=Shift_Data;
                // Shift_carry_out<=z;
            end
            if(Shift_Num>=1&&Shift_Num<=32)
            begin
               begin
                Shift_out<=Shift_Data>>Shift_Num;
                Shift_carry_out<=Shift_Data[Shift_Num-1];
                end 
            end
            if(Shift_Num>32)
            begin
                Shift_out<=0;
                Shift_carry_out<=0;
            end
        end
        2'b10:
        begin
            if(SHIFT_OP[0]==0&&Shift_Num==0)
            begin
                Shift_out<={32{Shift_Data[31]}};
                Shift_carry_out<=Shift_Data[31];
            end
            if(SHIFT_OP[0]==1&&Shift_Num==0)
            begin
                Shift_out<=Shift_Data;
                // Shift_carry_out<=z;
            end
            if(Shift_Num>=1&&Shift_Num<=31)
            begin
               begin
                Shift_out<=Shift_Data>>{{32{Shift_Data[31]}},Shift_Data}>>Shift_Num;
                Shift_carry_out<=Shift_Data[Shift_Num-1];
                end 
            end
            if(Shift_Num>32)
            begin
                Shift_out<={32{Shift_Data[31]}};
                Shift_carry_out<=Shift_Data[31];
            end
        end
        2'b11:
        begin
            if(SHIFT_OP[0]==0&&Shift_Num==0)
            begin
                Shift_out<={Carry_flag,Shift_Data[31:1]};
                Shift_carry_out<=Shift_Data[0];
            end
            if(SHIFT_OP[0]==1&&Shift_Num==0) Shift_out<=Shift_Data;
            if(Shift_Num>=1&&Shift_Num<=32)
            begin
                Shift_out<={Shift_Data,Shift_Data}>>Shift_Num;
                Shift_carry_out<=Shift_Data[Shift_Num-1];
            end
            if(Shift_Num>32)
            begin
                Shift_out<={Shift_Data,Shift_Data}>>Shift_Num[4:0];
                Shift_carry_out<=Shift_Data[Shift_Num[4:0]-1];
            end
        end
    endcase

end
endmodule

