`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 05:28:31 PM
// Design Name: 
// Module Name: BCG
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


module BCG(
    input [31:0] a,
    input [31:0] b,
    output logic br_eq,
    output logic br_lt,
    output logic br_ltu
    );
    
    always @(a or b) begin
    if($signed(a) < $signed(b)) begin
        br_lt = 1;
        end
    else
        begin
        br_lt = 0;
        end
    
    if($unsigned(a) < $unsigned(b)) begin
        br_ltu = 1;
        end
    else
        begin
        br_ltu = 0;
        end
        
    if(a == b) begin
        br_eq = 1;
        end
    else
        begin
        br_eq = 0;
        end
    
    end
endmodule
