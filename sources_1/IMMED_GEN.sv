`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2023 05:26:47 PM
// Design Name: 
// Module Name: IMMED_GEN
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


module IMMED_GEN(
    input [31:7] inst,
    output [31:0] uType,
    output [31:0] iType,
    output [31:0] sType,
    output [31:0] jType,
    output [31:0] bType
    );
    
    assign iType = {{21{inst[31]}}, inst[30:25], inst[24:20]};
    assign sType = {{21{inst[31]}}, inst[30:25], inst[11:7]};
    assign bType = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
    assign uType = {inst[31:12], {12{1'b0}}};
    assign jType = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], {1{1'b0}}};
    
endmodule
