`timescale  1ns / 1ps

module sim_alu();
    
    // ALU Parameters
    //parameter PERIOD = 10;
    // ALU Inputs
    reg   [31:0]  A     = 0 ;
    reg   [31:0]  B     = 0 ;
    reg   [3:0]  ALU_OP = 0 ;
    reg   CF            = 0 ;
    reg   VF            = 0 ;
    reg   shiftCout     = 0 ;
    // ALU Outputs
    wire  [31:0]  F                            ;
    wire  [3:0]  NZCV                          ;
    ALU  u_ALU (
    .A                       (A          [31:0]),
    .B                       (B          [31:0]),
    .ALU_OP                  (ALU_OP     [3:0]),
    .CF                      (CF),
    .VF                      (VF),
    .shiftCout               (shiftCout),
    
    .F                       (F          [31:0]),
    .NZCV                    (NZCV       [3:0])
    );
    
    
    initial
    begin
        
    end
    
endmodule
