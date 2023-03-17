`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 05:52:47 PM
// Design Name: 
// Module Name: ALU_muxB
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


module ALU_muxB(
    input [31:0] rs2,
    input [31:0] iType,
    input [31:0] sType,
    input [31:0] PCOut, //output from PC
    input [1:0] alu_srcB, //Output from CD
    output logic [31:0] srcB //output to ALU
    );

    always_comb 
    begin 
        case(alu_srcB)        
            2'b00: srcB = rs2; 
            2'b01: srcB = iType; 
            2'b10: srcB = sType; 
            2'b11: srcB = PCOut;
            default: begin ; end
        endcase
    end
endmodule
