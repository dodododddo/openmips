`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/10 21:38:32
// Design Name: 
// Module Name: id
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
`include "defines.v"

module id(
    input rst,

    // 从regfile读
    input wire [`InstAddrBus] pc_i,
    input wire [`InstBus] inst_i,
    input wire [`RegBus] reg1_data_i,
    input wire [`RegBus] reg2_data_i,

    input wire ex_wreg_i,
    input wire [`RegAddrBus] ex_wd_i,
    input wire [`RegBus] ex_wdata_i,

    input wire mem_wreg_i,
    input wire [`RegAddrBus] mem_wd_i,
    input wire [`RegBus] mem_wdata_i,
    
    // 输出到regfile
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg [`RegAddrBus] reg1_addr_o,
    output reg [`RegAddrBus] reg2_addr_o,
    
    // 操作类型与子类型
    output reg [`AluOpBus] aluop_o,
    output reg [`AluSelBus] alusel_o,

    // 源操作数1, 2
    output reg [`RegBus] reg1_o,
    output reg [`RegBus] reg2_o,

    // 目的寄存器地址
    output reg [`RegAddrBus] wd_o,

    // 目的寄存器写使能
    output reg wreg_o
    );

    wire [5:0] op = inst_i[31:26];
    wire [4:0] op2 = inst_i[10:6];
    wire [5:0] op3 = inst_i[5:0];
    wire [4:0] op4 = inst_i[20:16];
    
    // 立即数
    reg [`RegBus] imm;

    // 指令是否有效
    reg instvalid;
    
    always @ (*) begin
        if(rst == `RstEnable) begin
            instvalid <= `InstValid;
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            reg1_read_o <= `ReadDisable;
            reg2_read_o <= `ReadDisable;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            imm <= `ZeroWord;
        end

        else begin
            instvalid <= `InstValid;
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            reg1_read_o <= `ReadDisable;
            reg2_read_o <= `ReadDisable;
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            wd_o <= inst_i[15:11];
            wreg_o <= `WriteEnable;
            imm <= `ZeroWord;
        
            case (op)
                `EXE_ORI: begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadDisable;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instvalid <= `InstValid;
                end

                `EXE_ADDI: begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_ADD_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadDisable;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instvalid <= `InstValid;
                end

                `EXE_XORI: begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_XOR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadDisable;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instvalid <= `InstValid;
                end

                `EXE_LUI: begin
                    wreg_o <= `WriteEnable;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadDisable;
                    imm <= {inst_i[15:0], 16'h0};
                    wd_o <= inst_i[20:16];
                    instvalid <= `InstValid;
                end

                `EXE_PREF: begin
                    wreg_o <= `WriteDisable;
                    aluop_o <= `EXE_NOP_OP;
                    alusel_o <= `EXE_RES_NOP;
                    reg1_read_o <= `ReadDisable;
                    reg2_read_o <= `ReadDisable;
                    imm <= `ZeroWord;
                    wd_o <= `NOPRegAddr;
                    instvalid <= `InstValid;
                end

                `EXE_SPECIAL_INST: begin
                    case (op2)
                        5'b00000: begin
                            case (op3)
                                `EXE_OR: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_OR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_AND: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_AND_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_XOR: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_XOR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_NOR: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_NOR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_SLLV: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SLL_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_SRLV: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SRL_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_SRAV: begin
                                    wreg_o <= `WriteEnable;
                                    aluop_o <= `EXE_SRA_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    reg1_read_o <= `ReadEnable;
                                    reg2_read_o <= `ReadEnable;
                                    instvalid <= `InstValid;
                                end

                                `EXE_SYNC: begin
                                    wreg_o <= `WriteDisable;
                                    aluop_o <= `EXE_NOP_OP;
                                    alusel_o <= `EXE_RES_NOP;
                                    reg1_read_o <= `ReadDisable;
                                    reg2_read_o <= `ReadDisable;
                                    instvalid <= `InstValid;
                                end

                                default: begin
                                end
                        

                            endcase
                        end

                        default: begin
                        end
                    endcase


                end

                default: begin
                end
            endcase

            if(inst_i[31:21] == 11'b00000000000) begin
                case(op3) 
                    `EXE_SLL: begin
                        wreg_o <= `WriteEnable;
                        aluop_o <= `EXE_SLL_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadDisable;
                        reg2_read_o <= `ReadEnable;
                        imm[4:0] <= inst_i[10: 6];
                        wd_o <= inst_i[15:11];
                        instvalid <= `InstValid;
                    end

                    `EXE_SRL: begin
                        wreg_o <= `WriteEnable;
                        aluop_o <= `EXE_SRL_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadDisable;
                        reg2_read_o <= `ReadEnable;
                        imm[4:0] <= inst_i[10: 6];
                        wd_o <= inst_i[15:11];
                        instvalid <= `InstValid;
                    end

                    `EXE_SRA: begin
                        wreg_o <= `WriteEnable;
                        aluop_o <= `EXE_SRA_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadDisable;
                        reg2_read_o <= `ReadEnable;
                        imm[4:0] <= inst_i[10: 6];
                        wd_o <= inst_i[15:11];
                        instvalid <= `InstValid;
                    end

                    default: begin
                    end
                endcase
            end
        end
    end
    
    // 确定源操作数1
    always @ (*) begin
        if(rst == `RstEnable) begin
            reg1_o <= `ZeroWord;
        end

        else if((reg1_read_o == `ReadEnable) && (ex_wreg_i == `WriteEnable) && (ex_wd_i == reg1_addr_o)) begin
            reg1_o <= ex_wdata_i;
        end

        else if((reg1_read_o == `ReadEnable) && (mem_wreg_i == `WriteEnable) && (mem_wd_i == reg1_addr_o)) begin
            reg1_o <= mem_wdata_i;
        end

        else if(reg1_read_o == `ReadEnable) begin
            reg1_o <= reg1_data_i;
        end

        else if(reg1_read_o == `ReadDisable) begin
            reg1_o <= imm;
        end

        else begin
            reg1_o <= `ZeroWord;
        end
    end

    // 确定源操作数2
    always @ (*) begin
        if(rst == `RstEnable) begin
            reg2_o <= `ZeroWord;
        end
        
        else if((reg2_read_o == `ReadEnable) && (ex_wreg_i == `WriteEnable) && (ex_wd_i == reg2_addr_o)) begin
            reg2_o <= ex_wdata_i;
        end

        else if((reg2_read_o == `ReadEnable) && (mem_wreg_i == `WriteEnable) && (mem_wd_i == reg2_addr_o)) begin
            reg2_o <= mem_wdata_i;
        end

        else if(reg2_read_o == `ReadEnable) begin
            reg2_o <= reg2_data_i;
        end

        else if(reg2_read_o == `ReadDisable) begin
            reg2_o <= imm;
        end

        else begin
            reg2_o <= `ZeroWord;
        end
    end


endmodule
