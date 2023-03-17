`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2023 04:41:36 PM
// Design Name: 
// Module Name: OTTER_SIM
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


module OTTER_SIM();
    logic CLK;
    logic RST;
    logic IOBUS_WR;
    logic [31:0] IOBUS_IN;
    logic [31:0] IOBUS_OUT;
    logic [31:0] IOBUS_ADDR;
    
    OTTER_TOP UUT (
    .CLK(CLK),
    .RST(RST),
    .IOBUS_IN(IOBUS_IN),
    .IOBUS_WR(IOBUS_WR),
    .IOBUS_OUT(IOBUS_OUT),
    .IOBUS_ADDR(IOBUS_ADDR)
    );
    
    always begin
        #10 CLK = ~CLK;
    end
    
    always begin
    #60 RST = 1'b0;
        IOBUS_IN = 32'h2;
    end
    
    initial begin
        CLK = 1'b0;
    end
    
endmodule
