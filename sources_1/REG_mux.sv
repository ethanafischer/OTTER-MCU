`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 05:52:47 PM
// Design Name: 
// Module Name: REG_mux
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


module REG_mux(
    input [31:0] PC4,
    input [31:0] DOUT2,
    input [31:0] alu_result,
    input [1:0] rf_wr_sel,
    output logic [31:0] wd
    );
    
    always_comb
    begin
        case(rf_wr_sel)
            2'b00: wd = PC4;
            2'b01: wd = 0;
            2'b10: wd = DOUT2;
            2'b11: wd = alu_result;
            default: wd = 0;
        endcase
    end
endmodule
