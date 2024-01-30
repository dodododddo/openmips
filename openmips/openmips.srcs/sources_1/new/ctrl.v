`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/29 22:17:49
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input rst,
    input wire stallreq_from_id,
    input wire stallreq_from_ex,
    output reg [`CtrlBus] stall
);

    always @(*) begin
        if (rst == `RstEnable) begin
            stall <= 6'b000000;
        end

        else if (stallreq_from_ex == `Stop) begin
            stall <= 6'b001111;
        end

        else if(stallreq_from_id == `Stop) begin
            stall <= 6'b000111;
        end

        else begin
            stall <= 6'b000000;
        end
    end

endmodule
