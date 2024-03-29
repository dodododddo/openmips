`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 12:32:57
// Design Name: 
// Module Name: openmips
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

module openmips(
    input clk,
    input rst,
    input [`InstBus] rom_data_i,
    output [`InstAddrBus] rom_addr_o,
    output wire rom_ce_o
);
    
    //IF-ID & ID
    wire [`InstAddrBus] pc;
    wire [`InstAddrBus] id_pc_i;
    wire [`InstBus] id_inst_i;

    //ID & ID-EX
    wire [`AluOpBus] id_aluop_o;
    wire [`AluSelBus] id_alusel_o;
    wire [`RegBus] id_reg1_o;
    wire [`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire [`RegAddrBus] id_wd_o;

    //ID-EX & EX
    wire [`AluOpBus] ex_aluop_i;
    wire [`AluSelBus] ex_alusel_i;
    wire [`RegBus] ex_reg1_i;
    wire [`RegBus] ex_reg2_i;
    wire ex_wreg_i;
    wire [`RegAddrBus] ex_wd_i;
    wire [`RegBus] ex_hi_i;
    wire [`RegBus] ex_lo_i;
    wire ex_whilo_i;

    //EX & EX-MEM
    wire [`AluOpBus] ex_aluop_o;
    wire [`AluSelBus] ex_alusel_o;
    wire [`RegBus] ex_reg1_o;
    wire [`RegBus] ex_reg2_o;
    wire ex_wreg_o;
    wire [`RegAddrBus] ex_wd_o;
    wire [`RegBus] ex_wdata_o;
    wire [`RegBus] ex_hi_o;
    wire [`RegBus] ex_lo_o;
    wire ex_whilo_o;


    //EX & EX-MEM

    wire [`RegBus] mem_wdata_i;
    wire mem_reg_i;
    wire [`RegAddrBus] mem_wd_i;
    wire [`RegBus] mem_hi_i;
    wire [`RegBus] mem_lo_i;
    wire mem_whilo_i;

    wire [`DoubleRegBus] hilo_temp_i;
    wire [`CntBus] cnt_i;
    wire [`DoubleRegBus] hilo_temp_o;
    wire [`CntBus] cnt_o;

    //MEM & MEM-WB
    wire [`RegBus] mem_wdata_o;
    wire mem_reg_o;
    wire [`RegAddrBus] mem_wd_o;
    wire [`RegBus] mem_hi_o;
    wire [`RegBus] mem_lo_o;
    wire mem_whilo_o;

    //MEM-WB & WB
    wire [`RegBus] wb_wdata_i;
    wire wb_wreg_i;
    wire [`RegAddrBus] wb_wd_i;
    wire [`RegBus] wb_hi_i;
    wire [`RegBus] wb_lo_i;
    wire wb_whilo_i;

    //ID & Regfile
    wire reg1_read;
    wire reg2_read;
    wire [`RegBus] reg1_data;
    wire [`RegBus] reg2_data;
    wire [`RegAddrBus] reg1_addr;
    wire [`RegAddrBus] reg2_addr;

    // HILO
    wire [`RegBus] hi_i;
    wire [`RegBus] lo_i;
    wire hilo_we;

    wire [`RegBus] hi_o;
    wire [`RegBus] lo_o;
    
    // ctrl
    wire [`CtrlBus] stall;
    wire stallreq_from_ex;
    wire stallreq_from_id;

    
    pc_reg pc_reg0(
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .pc(pc),
        .ce(rom_ce_o)
    );

    assign rom_addr_o = pc;

    if_id if_id0(
        .clk(clk),
        .rst(rst),
        .if_pc(pc),
        .if_inst(rom_data_i),
        .stall(stall),
        .id_pc(id_pc_i),
        .id_inst(id_inst_i)
    );

    id id0(
        .rst(rst),
        .pc_i(id_pc_i),
        .inst_i(id_inst_i),
        .ex_wd_i(ex_wd_o),
        .ex_wreg_i(ex_wreg_o),
        .ex_wdata_i(ex_wdata_o),
        .mem_wd_i(mem_wd_o),
        .mem_wreg_i(mem_reg_o),
        .mem_wdata_i(mem_wdata_o),
        .stallreq(stallreq_from_id),
        .aluop_o(id_aluop_o),
        .alusel_o(id_alusel_o),
        .reg1_data_i(reg1_data),
        .reg2_data_i(reg2_data),
        .reg1_read_o(reg1_read),
        .reg2_read_o(reg2_read),
        .reg1_addr_o(reg1_addr),
        .reg2_addr_o(reg2_addr),
        .reg1_o(id_reg1_o),
        .reg2_o(id_reg2_o),
        .wreg_o(id_wreg_o),
        .wd_o(id_wd_o)
    );

    regfile regfile0(
        .clk(clk),
        .rst(rst),
        .we(wb_wreg_i),
        .waddr(wb_wd_i),
        .wdata(wb_wdata_i),
        .re1(reg1_read),
        .re2(reg2_read),
        .raddr1(reg1_addr),
        .raddr2(reg2_addr),
        .rdata1(reg1_data),
        .rdata2(reg2_data)
    );

    hilo_reg hilo_reg0(
        .clk(clk),
        .rst(rst),
        .we(wb_whilo_i),
        .hi_i(wb_hi_i),
        .lo_i(wb_lo_i),
        .hi_o(ex_hi_i),
        .lo_o(ex_lo_i)
    );

    id_ex id_ex0(
        .clk(clk),
        .rst(rst),
        .id_aluop(id_aluop_o),
        .id_alusel(id_alusel_o),
        .id_reg1(id_reg1_o),
        .id_reg2(id_reg2_o),
        .id_wreg(id_wreg_o),
        .id_wd(id_wd_o),
        .stall(stall),
        .ex_aluop(ex_aluop_i),
        .ex_alusel(ex_alusel_i),
        .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i),
        .ex_wreg(ex_wreg_i),
        .ex_wd(ex_wd_i)
    );

    ex ex0(
        .rst(rst),

        .aluop_i(ex_aluop_i),
        .alusel_i(ex_alusel_i),

        .reg1_i(ex_reg1_i),
        .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i),
        .wreg_i(ex_wreg_i),

        .hi_i(ex_hi_i),
        .lo_i(ex_hi_i),

        .wb_hi_i(wb_hi_i),
        .wb_lo_i(wb_lo_i),
        .wb_whilo_i(wb_whilo_i),

        .mem_hi_i(mem_hi_o),
        .mem_lo_i(mem_lo_o),
        .mem_whilo_i(mem_whilo_o),

        .hilo_temp_i(hilo_temp_i),
        .cnt_i(cnt_i),

        .wd_o(ex_wd_o),
        .wreg_o(ex_wreg_o),
        .wdata_o(ex_wdata_o),

        .hi_o(ex_hi_o),
        .lo_o(ex_lo_o),
        .whilo_o(ex_whilo_o),

        .hilo_temp_o(hilo_temp_o),
        .cnt_o(cnt_o),

        .stallreq(stallreq_from_ex)
    );
    
    ex_mem ex_mem0(
        .clk(clk),
        .rst(rst),

        .ex_wdata(ex_wdata_o),
        .ex_wreg(ex_wreg_o),
        .ex_wd(ex_wd_o),

        .ex_hi(ex_hi_o),
        .ex_lo(ex_lo_o),
        .ex_whilo(ex_whilo_o),

        .hilo_i(hilo_temp_o),
        .cnt_i(cnt_o),

        .stall(stall),

        .mem_wdata(mem_wdata_i),
        .mem_wreg(mem_reg_i),
        .mem_wd(mem_wd_i),

        .mem_hi(mem_hi_i),
        .mem_lo(mem_lo_i),
        .mem_whilo(mem_whilo_i),

        .hilo_o(hilo_temp_i),
        .cnt_o(cnt_i)
    );

    mem mem0(
        .rst(rst),

        .wdata_i(mem_wdata_i),
        .wreg_i(mem_reg_i),
        .wd_i(mem_wd_i),

        .hi_i(mem_hi_i),
        .lo_i(mem_lo_i),
        .whilo_i(mem_whilo_i),

        .wdata_o(mem_wdata_o),
        .wreg_o(mem_reg_o),
        .wd_o(mem_wd_o),

        .hi_o(mem_hi_o),
        .lo_o(mem_lo_o),
        .whilo_o(mem_whilo_o)
    );

    mem_wb mem_wb0(
        .clk(clk),
        .rst(rst),

        .mem_wdata(mem_wdata_o),
        .mem_wreg(mem_reg_o),
        .mem_wd(mem_wd_o),

        .mem_hi(mem_hi_o),
        .mem_lo(mem_lo_o),
        .mem_whilo(mem_whilo_o),

        .stall(stall),

        .wb_wdata(wb_wdata_i),
        .wb_wreg(wb_wreg_i),
        .wb_wd(wb_wd_i),

        .wb_hi(wb_hi_i),
        .wb_lo(wb_lo_i),
        .wb_whilo(wb_whilo_i)
    );

    ctrl ctrl0(
        .rst(rst),
        .stallreq_from_ex(stallreq_from_ex),
        .stallreq_from_id(stallreq_from_id),
        .stall(stall)
    );

endmodule
