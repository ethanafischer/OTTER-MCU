`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2023 12:31:30 PM
// Design Name: 
// Module Name: PC_REG
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


module PC_REG(
    input pc_write,
    input pc_rst,
    input [31:0] pc_din,
    input clk,
    output logic [31:0] pc_count
    );
    
    always_ff @ (posedge clk, posedge pc_rst)
        begin
            if(pc_rst) begin
                pc_count <= 32'h0; end  //the counter will set to 0 when reset is 1.
            else if(pc_write) begin
                pc_count <= pc_din; end //the count will equal unsigned 32-bit value when pc_write is high.
        end
        
endmodule
