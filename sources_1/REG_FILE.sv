`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2023 04:24:26 PM
// Design Name: 
// Module Name: REG_FILE
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


module REG_FILE(
    input clk,
    input [31:0] rf_wd,
    input rf_en,
    input [19:15] rf_adr1,
    input [24:20] rf_adr2,
    input [11:7] rf_wa,
    output [31:0] rf_rs1,
    output [31:0] rf_rs2
    );
    
    logic [31:0] ram[31:0]; //create array
    
    //initialize memory to '0's.
    initial begin
    int i;
    for(i=0; i<32; i++)
        begin
        ram[i] = 0;
        end
    end
    
    assign rf_rs1 = ram[rf_adr1];
    assign rf_rs2 = ram[rf_adr2];
    
    always_ff @(posedge clk) 
    begin
        if(rf_en)
            begin
            if((rf_en == 1) && (rf_wa != 0)) begin
                ram[rf_wa] <= rf_wd;
                end
            end
    end
endmodule
