`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 12:22:55
// Design Name: 
// Module Name: ex_mem
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

module ex_mem(
    input clk,
    input rst,

    input wire [`RegAddrBus] ex_wd,
    input wire [`RegBus] ex_wdata,
    input wire ex_wreg,

    input wire ex_whilo,
    input wire [`RegBus] ex_hi,
    input wire [`RegBus] ex_lo,

    input wire [`DoubleRegBus] hilo_i,
    input wire [`CntBus] cnt_i,

    input wire [`CtrlBus] stall,

    output reg [`RegAddrBus] mem_wd,
    output reg [`RegBus] mem_wdata,
    output reg mem_wreg,
    
    output reg  mem_whilo,
    output reg [`RegBus] mem_hi,
    output reg [`RegBus] mem_lo,

    output reg [`DoubleRegBus] hilo_o,
    output reg [`CntBus] cnt_o
    );

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            mem_wd <= `NOPRegAddr;
            mem_wdata <= `ZeroWord;
            mem_wreg <= `WriteDisable;

            mem_whilo <= `WriteDisable;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;

            hilo_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
        end
        
        else if(stall[3] == `Stop && stall[4] == `NoStop) begin
            mem_wd <= `NOPRegAddr;
            mem_wdata <= `ZeroWord;
            mem_wreg <= `WriteDisable;

            mem_whilo <= `WriteDisable;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;

            hilo_o <= hilo_i;
            cnt_o <= cnt_i;
        end

        else if(stall[3] == `NoStop) begin
            mem_wd <= ex_wd;
            mem_wdata <= ex_wdata;
            mem_wreg <= ex_wreg;

            mem_whilo <= ex_whilo;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;

            hilo_o <= {`ZeroWord, `ZeroWord};
            cnt_o <= 2'b00;
        end

        else begin
            hilo_o <= hilo_i;
            cnt_o <= cnt_i;
        end
    end
endmodule

 
