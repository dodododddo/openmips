`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/24 10:03:46
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
    input clk,
    input rst,
    //写端口
    input we,
    input [`RegBus] hi_i,
    input [`RegBus] lo_i,

    //读端口
    output reg [`RegBus] hi_o,
    output reg [`RegBus] lo_o
);
    
    // 写
    always @(posedge clk) begin
        if(rst == `RstEnable) begin
            hi_o <= `ZeroWord;
            lo_o <= `ZeroWord;
        end
        else if(we == `WriteEnable) begin
            hi_o <= hi_i;
            lo_o <= lo_i;
        end
    end

endmodule
