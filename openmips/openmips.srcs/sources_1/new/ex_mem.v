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

    output reg [`RegAddrBus] mem_wd,
    output reg [`RegBus] mem_wdata,
    output reg mem_wreg,
    
    output reg  mem_whilo,
    output reg [`RegBus] mem_hi,
    output reg [`RegBus] mem_lo

    );

    always @ (posedge clk) begin
        if(rst == `RstEnable) begin
            mem_wd <= `NOPRegAddr;
            mem_wdata <= `ZeroWord;
            mem_wreg <= `WriteDisable;

            mem_whilo <= `WriteDisable;
            mem_hi <= `ZeroWord;
            mem_lo <= `ZeroWord;
        end
        else begin
            mem_wd <= ex_wd;
            mem_wdata <= ex_wdata;
            mem_wreg <= ex_wreg;

            mem_whilo <= ex_whilo;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
        end
    end
endmodule

 
