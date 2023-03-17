`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 05:59:30 PM
// Design Name: 
// Module Name: BAG
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


module BAG(
    input [31:0] PC,
    input [31:0] bType,
    input [31:0] iType,
    input [31:0] jType,
    input [31:0] rs1,
    output [31:0] jalr,
    output [31:0] branch,
    output [31:0] jal
    );
    
    assign branch = PC + bType;
    assign jal = PC + jType;
    assign jalr = rs1 + iType;
endmodule
