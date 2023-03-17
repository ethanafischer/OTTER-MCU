`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 04:07:59 PM
// Design Name: 
// Module Name: OTTER_TOP
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


module OTTER_TOP(
    input RST,
    input [31:0] IOBUS_IN,
    input CLK,
    output IOBUS_WR,
    output [31:0] IOBUS_OUT,
    output [31:0] IOBUS_ADDR
    );
    
    logic [31:0] ir; //mem to FSM, DCDR, memory, RF, immedGen
    logic br_eq; //BCG -> DCDR
    logic br_lt; //BCG -> DCDR
    logic br_ltu; //BCG -> DCDR
    
    logic pcWrite; //FSM -> PC
    logic regWrite; //FSM -> RF
    logic memWE2; //FSM -> mem
    logic memRDEN1; //FSM -> mem
    logic memRDEN2; //FSM -> mem
    logic PC_reset; //FSM -> PC
    
    logic [3:0] alu_fun; //DCDR -> ALU
    logic alu_srcA; //DCDR -> muxA
    logic [1:0] alu_srcB; //DCDR -> muxB
    logic [2:0] pcSource; //DCDR -> PC
    logic [1:0] rf_wr_sel; //DCDR -> MR
    
    logic [31:0] mux_srcA;
    logic [31:0] mux_srcB;
    
    logic [31:0] jalr; //BAG -> PC
    logic [31:0] branch; //BAG -> PC
    logic [31:0] jal; //BAG -> PC
    //logic [31:0] mtvec; //BAG -> PC (intr only)
    //logic [31:0] mepc; //BAG -> PC (intr only)
    
    logic [31:0] PCOut; //PC -> mem, BAG, muxB
    logic [31:0] wd; //muxR -> RF
    logic [31:0] DOUT2; //mem -> muxR
    logic [31:0] rs1; //RF -> BCG, BAG, muxA
    logic [31:0] rs2; //RF -> BCG, mem, muxB, IOBUS_OUT
    
    logic [31:0] uType; //immedGen -> muxA
    logic [31:0] iType; //immedGen -> muxB, BAG
    logic [31:0] sType; //immedGen -> muxB
    logic [31:0] bType; //immedGen -> BAG
    logic [31:0] jType; //immedGen -> BAG
    
    logic [31:0] alu_result; //ALU -> muxR, mem, IOBUS_ADDR
    
    ALU_muxA muxA (
    .rs1(rs1), //input from RF
    .uType(uType), //input from immedGen
    .alu_srcA(alu_srcA), //input from DCDR
    .srcA(mux_srcA) //output to ALU
    );
    
    ALU_muxB muxB (
    .rs2(rs2), //input from RF
    .iType(iType), //input from immedGen
    .sType(sType), //input from immedGen
    .PCOut(PCOut), //input from PC
    .alu_srcB(alu_srcB), //input from DCDR
    .srcB(mux_srcB) //output to ALU
    );
    
    REG_mux muxR (
    .PC4(PCOut + 4), //input from PC
    .DOUT2(DOUT2), //input from mem
    .alu_result(alu_result), //input from ALU
    .rf_wr_sel(rf_wr_sel), //input from DCDR
    .wd(wd) //output to RF
    );
    
    CU_FSM FSM (
    .RST(RST),
    .opcode(ir[6:0]), //input from DOUT1
    .CLK(CLK),
    .PCWRITE(PCWrite), //output to PC
    .REGWRITE(regWrite), //output to RF
    .memWE2(memWE2), //output to mem
    .memRDEN1(memRDEN1), //output to mem
    .memRDEN2(memRDEN2), //output to mem
    .PC_reset(PC_reset) //output to PC
    );
    
    CU_DCDR DCDR (
    .br_eq(br_eq), //input from BCG
    .br_lt(br_lt), //input from BCG
    .br_ltu(br_ltu), //input from BCG
    .opcode(ir[6:0]), //input from DOUT1
    .ir30(ir[30]), //input from DOUT1
    .funct3(ir[14:12]), //input from DOUT1
    .alu_fun(alu_fun), //output to ALU
    .alu_srcA(alu_srcA), //output to muxA
    .alu_srcB(alu_srcB), //output to muxB
    .pcSource(pcSource), //output to PC
    .rf_wr_sel(rf_wr_sel) //output to muxR
    );
    
    PC PC (
    .clk(CLK),
    .jalr(jalr), //input from BAG
    .branch(branch), //input from BAG
    .jal(jal), //input from BAG
    //.mtvec(mtvec), //input from BAG (intr only)
    //.mepc(mepc), //input from BAG (intr only)
    .pc_source(pcSource), //input from DCDR
    .pc_write(PCWrite), //input from FSM
    .pc_rst(PC_reset), //input from FSM
    .pc_address(PCOut[31:0]) //output to mem, BAG, muxB
    );
    
    Memory mem (
    .MEM_CLK(CLK),
    .MEM_RDEN1(memRDEN1), //input from FSM
    .MEM_RDEN2(memRDEN2), //input from FSM
    .MEM_WE2(memWE2), //input from FSM
    .MEM_ADDR1(PCOut[15:2]), //input from RF
    .MEM_ADDR2(alu_result), //input from ALU
    .MEM_DIN2(rs2), //input from RF
    .MEM_SIZE(ir[13:12]), //input from DOUT1
    .MEM_SIGN(ir[14]), //input from DOUT1
    .IO_IN(IOBUS_IN), //input from IOBUS_IN
    .IO_WR(IOBUS_WR), //output to IOBUS_WR
    .MEM_DOUT1(ir), //output to mem, RF, DCDR, FSM, immedGen
    .MEM_DOUT2(DOUT2) //output to muxR
    );
    
    REG_FILE RF (
    .clk(CLK),
    .rf_wd(wd), //input from muxR
    .rf_en(regWrite), //input from FSM
    .rf_adr1(ir[19:15]), //input from DOUT1
    .rf_adr2(ir[24:20]), //input from DOUT1
    .rf_wa(ir[11:7]), //input from DOUT1
    .rf_rs1(rs1), //output to BCG, BAG, muxA
    .rf_rs2(rs2) //output to BCG, mem, muxB, IOBUS_OUT
    );
    
    IMMED_GEN immedGen (
    .inst(ir[31:7]), //input from DOUT1
    .uType(uType), //output to muxA
    .iType(iType), //output to muxB, BAG
    .sType(sType), //output to muxB
    .jType(jType), //output to BAG
    .bType(bType) //output to BAG
    );
    
    ALU ALU (
    .mux_srcA(mux_srcA), //input from muxA
    .mux_srcB(mux_srcB), //input from muxB
    .fun(alu_fun), //input from DCDR
    .result(alu_result) //output to IOBUS_ADDR, muxR, mem
    );
    
    BAG BAG (
    .PC(PCOut), //input from PC
    .bType(bType), //input from immedGen
    .iType(iType), //input from immedGen
    .jType(jType), //input from immedGen
    .rs1(rs1), //input from RF
    .jal(jal), //output to PC
    .branch(branch), //output to PC
    .jalr(jalr) //output to PC
    );
    
    BCG BCG (
    .a(rs1), //input from RF
    .b(rs2), //input from RF
    .br_eq(br_eq), //output to DCDR
    .br_lt(br_lt), //output to DCDR
    .br_ltu(br_ltu) //output to DCDR
    );
    
    assign IOBUS_OUT = rs2;
    assign IOBUS_ADDR = alu_result;
    
endmodule
