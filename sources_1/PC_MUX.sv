`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2023 08:38:54 PM
// Design Name: 
// Module Name: PC_MUX
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


module PC_MUX(
    input [31:0] In0 , //pc4
    input [31:0] In1, //jalr
    input [31:0] In2, //branch
    input [31:0] In3, //jal
    //input [31:0] In4, //mtvec (intr only)
    //input [31:0] In5, //mepc (intr only)
    input [2:0] pcSource,
    output logic [0:31] out
    );
    
    always_comb
        begin 
            case(pcSource)
                3'd0: out = In0;
                3'd1: out = In1;
                3'd2: out = In2;
                3'd3: out = In3;
                //3'd4: out = In4;
                //3'd5: out = In5;
                
                3'd6: out = 32'd0; //default cases for pcSource.
                3'd7: out = 32'd0; //since there are only 6 inputs, pcSource has 2 other cases which have to be represented.
                default: out = 32'd0;
            endcase
        end
endmodule
