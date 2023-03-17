`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 05:52:47 PM
// Design Name: 
// Module Name: ALU_muxA
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


module ALU_muxA(
    input [31:0] rs1,
    input [31:0] uType,
    input alu_srcA,
    output logic [31:0] srcA
    );
    
    always_comb
    begin
        case(alu_srcA)
            1'b0: srcA = rs1;
            1'b1: srcA = uType;
            default: srcA = 1;
        endcase
    end
endmodule
