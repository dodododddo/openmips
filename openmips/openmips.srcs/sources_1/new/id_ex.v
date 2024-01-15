`include "defines.v"

module id_ex(
    input clk,
    input rst,
    
    input [`AluSelBus] id_alusel,
    input [`AluOpBus] id_aluop,
    input [`RegBus] id_reg1,
    input [`RegBus] id_reg2,
    input [`RegAddrBus] id_wd,
    input id_wreg, 
    
    output reg [`AluSelBus] ex_alusel,
    output reg [`AluOpBus] ex_aluop,
    output reg [`RegBus] ex_reg1,
    output reg [`RegBus] ex_reg2,
    output reg [`RegAddrBus] ex_wd,
    output reg ex_wreg
    );

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            ex_alusel <= `EXE_RES_NOP;
            ex_aluop <= `EXE_NOP_OP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
        end

        else begin
            ex_alusel <= id_alusel;
            ex_aluop <= id_aluop;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
        end
    end

endmodule