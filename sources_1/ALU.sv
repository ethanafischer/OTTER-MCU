`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2023 04:55:03 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] mux_srcA,
    input [31:0] mux_srcB,
    input [3:0] fun,
    output logic [31:0] result
    );
    
    always_comb
        begin
            case(fun)
            4'b0000: //add
            result = mux_srcA + mux_srcB;
            
            4'b1000: //sub
            result = mux_srcA - mux_srcB;
            
            4'b0110: //or
            result = mux_srcA | mux_srcB;
            
            4'b0111: //and
            result = mux_srcA & mux_srcB;
            
            4'b0100: //xor
            result = mux_srcA ^ mux_srcB;
            
            4'b0101: //srl
            result = mux_srcA >> mux_srcB[4:0];
            
            4'b0001: //sll
            result = mux_srcA << mux_srcB[4:0];
            
            4'b1101: //sra
            result = $signed(mux_srcA) >>> mux_srcB[4:0];
            
            4'b0010: //slt
            result = $signed(mux_srcA) < $signed(mux_srcB);
            
            4'b0011: //sltu
            result = mux_srcA < mux_srcB;
            
            4'b1001: //lui-copy
            result = mux_srcA;
            
            default:
            result = 32'h00000000;
    
        endcase
    end
endmodule
