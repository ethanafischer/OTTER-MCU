`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2023 12:39:23 PM
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input [31:0] jalr,
    input [31:0] branch,
    input [31:0] jal,
    //input [31:0] mtvec, (intr only)
    //input [31:0] mepc, (intr only)
    input [2:0] pc_source,
    input pc_write,
    input pc_rst,
    output [31:0] pc_address
    );
    
    logic [31:0] t1, pc4;
    
    PC_MUX pc_mux(
    .In0(pc4), 
    .In1(jalr), 
    .In2(branch), 
    .In3(jal), 
    //.In4(mtvec), (intr only)
    //.In5(mepc),  (intr only)
    .pcSource(pc_source), 
    .out(t1));
    
    PC_REG pc_reg(
    .pc_write(pc_write), 
    .pc_rst(pc_rst), 
    .pc_din(t1), 
    .clk(clk), 
    .pc_count(pc_address));
    
    assign pc4 = pc_address + 4;
    
endmodule
