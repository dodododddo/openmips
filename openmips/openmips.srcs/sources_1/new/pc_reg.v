`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/10 21:25:48
// Design Name: 
// Module Name: pc_reg
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

module pc_reg(
    input clk,
    input rst,
    
    output reg [`InstAddrBus] pc,
    output reg ce
);

    // 判断是否复位
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
        end 

        else begin
            ce <= `ChipEnable;
        end
    end
    
    // 判断是否继续向前读指令
    always @(posedge clk) begin
        if(ce == `ChipDisable) begin
            pc <= `ZeroWord;
        end
        
        else begin
            pc <= pc + 4'h4;
        end
    end
endmodule

