`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 12:22:55
// Design Name: 
// Module Name: mem
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

module mem(
    input rst,
    input [`RegAddrBus] wd_i,
    input wreg_i,
    input [`RegBus] wdata_i,
    
    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o
    );  

    always @(*) begin
        if(rst == `RstEnable) begin
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            wdata_o <= `ZeroWord;
        end

        else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;
        end
    end
endmodule
