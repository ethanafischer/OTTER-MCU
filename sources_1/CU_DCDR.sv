`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2023 01:59:21 PM
// Design Name: 
// Module Name: CU_DCDR
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


module CU_DCDR(
    input [6:0] opcode,
    input [2:0] funct3,
    input ir30,
    input br_eq, //branch if equal
    input br_lt, //branch if less than
    input br_ltu, //branch is less than unsigned
    
    output logic [3:0] alu_fun,
    output logic alu_srcA, 
    output logic [1:0] alu_srcB, 
    output logic [2:0] pcSource, 
    output logic [1:0] rf_wr_sel 
    );
    
    logic x = 0;
    
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
    //- datatype for funct3 Symbols tied to values
    typedef enum logic [2:0] {
    //BRANCH labels
        BEQ = 3'b000,
        BNE = 3'b001,
        BLT = 3'b100,
        BGE = 3'b101,
        BLTU = 3'b110,
        BGEU = 3'b111
    } funct3_t;
    funct3_t FUNCT3; //- define variable of new opcode type
    assign FUNCT3 = funct3_t'(funct3); //- cast input enum
    
    always_comb begin  
        alu_fun = 4'b0; //Set everything equal to zero to start 
        alu_srcA = 1'b0;
        alu_srcB = 2'b00;
        pcSource = 3'b000;
        rf_wr_sel = 2'b00;
        case(OPCODE)
            LUI: begin    
                alu_srcA = 1'b1;
                alu_fun = 4'b1001; 
                rf_wr_sel = 2'b11; 
            end
            AUIPC: begin
                alu_srcA = 1'b1;
                alu_srcB = 2'b11;
                rf_wr_sel = 2'b11; 
            end
            JAL: begin
                pcSource = 3'b011;
            end
            JALR: begin
                pcSource = 3'b1;
            end
            BRANCH: begin
                case(FUNCT3)
                    BEQ: begin
                        if (br_eq == 1)
                            begin pcSource = 3'b010; end
                    end 
                    BNE: begin
                        if (br_eq == 0)
                            begin pcSource = 3'b010; end
                    end
                    BLT: begin
                        if (br_lt == 1)
                            begin pcSource = 3'b010; end
                    end
                    BGE: begin
                        if (br_lt == 0)
                            begin pcSource = 3'b010; end
                    end 
                    BLTU: begin
                        if (br_ltu == 1) 
                            begin pcSource = 3'b010; end
                    end
                    BGEU: begin
                        if (br_ltu == 0)
                            begin pcSource = 3'b010; end
                    end
                endcase
            end
            LOAD: begin
                alu_srcB = 2'b1;
                rf_wr_sel = 2'b10;
            end
            STORE: begin
                alu_srcB = 2'b10;
            end
            IMMED: begin
                alu_srcB = 2'b1;
                rf_wr_sel = 2'b11;
                if (funct3 == 3'b101)
                begin
                    alu_fun = {ir30, funct3[2:0]};
                end
                else
                begin
                    alu_fun = {x, funct3[2:0]};
                end
            end
            RTYPE: begin
                rf_wr_sel = 2'b11;
                alu_fun = {ir30, funct3[2:0]}; 
            end
            default: begin end
        endcase
    end
endmodule
