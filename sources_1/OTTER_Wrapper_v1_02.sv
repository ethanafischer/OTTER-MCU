`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 
//
// Create Date: 01/20/2019 10:36:50 AM
// Module Name: OTTER_Wrapper
// Target Devices: OTTER on Basys3
// Description: OTTER_WRAPPER with Switches, LEDs, and 7-segment display
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Updated MMIO Addresses, signal names
/////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper(
   input CLK,
   //input BTNL,
   input BTNC,
   input [15:0] SWITCHES,
   output logic [15:0] LEDS,
   output [7:0] CATHODES,
   output [3:0] ANODES
   );
       
    // INPUT PORT IDS ///////////////////////////////////////////////////////
    localparam SWITCHES_AD = 32'h11000000;
           
    // OUTPUT PORT IDS //////////////////////////////////////////////////////
    localparam LEDS_AD    = 32'h11000020; //32'h11000020
    localparam SSEG_AD    = 32'h11000040; //32'h11000040
    
   // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////
   logic clk_50 = 0;
    
   logic [31:0] IOBUS_out, IOBUS_in, IOBUS_addr;
   logic s_reset, IOBUS_wr;
   
   // Registers for buffering outputs  /////////////////////////////////////
   logic [15:0] r_SSEG;
    
   // Declare OTTER_CPU ////////////////////////////////////////////////////
   OTTER_TOP CPU (.RST(s_reset), .IOBUS_IN(IOBUS_in), .CLK(clk_50), 
   .IOBUS_WR(IOBUS_wr), .IOBUS_OUT(IOBUS_out), .IOBUS_ADDR(IOBUS_addr));

   // Declare Seven Segment Display /////////////////////////////////////////
   SevSegDisp SSG_DISP (.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                       .CATHODES(CATHODES), .ANODES(ANODES));
   
                           
   // Clock Divider to create 50 MHz Clock //////////////////////////////////
   always_ff @(posedge CLK) begin
       clk_50 <= ~clk_50;
   end
   
   // Connect Signals ///////////////////////////////////////////////////////
   assign s_reset = BTNC;
   
   
   // Connect Board input peripherals (Memory Mapped IO devices) to IOBUS
   always_comb begin
        case(IOBUS_addr)
            SWITCHES_AD: IOBUS_in = {16'b0,SWITCHES};
            default:     IOBUS_in = 32'b0;    // default bus input to 0
        endcase
    end
   
   
   // Connect Board output peripherals (Memory Mapped IO devices) to IOBUS
    always_ff @ (posedge clk_50) begin
        if(IOBUS_wr)
            case(IOBUS_addr)
                LEDS_AD: LEDS   <= IOBUS_out[15:0];
                SSEG_AD: r_SSEG <= IOBUS_out[15:0];
            endcase
    end
   
   endmodule
