`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2023 04:09:12 PM
// Design Name: 
// Module Name: CU_FSM
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


module CU_FSM(
    input RST,
    input [6:0] opcode, //ir[6:0]
    input CLK, 

    output logic PCWRITE,
    output logic REGWRITE,
    output logic memWE2,
    output logic memRDEN1,
    output logic memRDEN2,
    output logic PC_reset
    );
    
    //- datatypes for RISC-V opcode types
    typedef enum logic [6:0] {
        LUI = 7'b0110111,
        AUIPC = 7'b0010111,
        JAL = 7'b1101111,
        JALR = 7'b1100111,
        BRANCH = 7'b1100011,
        LOAD = 7'b0000011,
        STORE = 7'b0100011,
        IMMED = 7'b0010011, //immediate instrs
        RTYPE = 7'b0110011 //r-type
    } opcode_t;
    opcode_t OPCODE; //- define variable of new opcode type
    assign OPCODE = opcode_t'(opcode); //- Cast input enum
    
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_WB} STATES;
    STATES PS, NS;

    always_ff @(posedge CLK) begin 
        if (RST == 1'b1)
            PS <= ST_INIT; 
        else 
            PS <= NS ; end

    always_comb begin 
        //set all output to 0 to prevent latch
        PCWRITE  = 1'b0; 
        REGWRITE = 1'b0; 
        memWE2   = 1'b0;
        memRDEN1 = 1'b0; 
        memRDEN2 = 1'b0; 
        PC_reset = 1'b0;
        case(PS)
            // initial state 
            ST_INIT : begin 
                PC_reset = 1'b1; //Resets the PC first
                NS = ST_FETCH; end 

            // fetch state 
            ST_FETCH : begin 
                memRDEN1 = 1'b1; 
                NS = ST_EXEC; end
                
            // decode + execute state
            ST_EXEC : begin
                NS = ST_FETCH;
                case(OPCODE)
                    LUI: begin    
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b1;
                    end
                    AUIPC: begin    
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b1;
                    end
                    JAL: begin    
                        PCWRITE = 1'b1; 
                        REGWRITE = 1'b1;
                    end 
                    JALR: begin
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b1;
                    end
                    BRANCH: begin    
                        PCWRITE = 1'b1;
                    end 
                    LOAD: begin
                        memRDEN2 = 1'b1;
                        NS = ST_WB;
                    end
                    STORE: begin
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b0; 
                        memWE2 = 1'b1;
                    end
                    IMMED: begin
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b1;
                    end
                    RTYPE: begin
                        PCWRITE = 1'b1;
                        REGWRITE = 1'b1;
                    end
                    default: begin end
                endcase
            end
            
            default begin
            NS = ST_FETCH ; 
            end
            
            ST_WB:  begin
                PCWRITE = 1'b1;
                REGWRITE = 1'b1;
                memRDEN2 = 1'b0;
                NS = ST_FETCH;
            end
        endcase
    end
endmodule