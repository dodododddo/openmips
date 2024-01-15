`include "defines.v"

module regfile(
    input clk,
    input rst,

    input we,
    input wire [`RegAddrBus] waddr,
    input wire [`RegBus] wdata, 

    input wire re1,
    input wire [`RegAddrBus] raddr1,
    

    input wire re2,
    input wire [`RegAddrBus] raddr2,

    output reg [`RegBus] rdata1,
    output reg [`RegBus] rdata2
);
    // 寄存器堆
    reg [`RegBus] regs[0:`RegNum - 1];
    
    // 写端口
    always @ (posedge clk) begin
        if(rst == `RstDisable) begin
            if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
                regs[waddr] <= wdata;
            end
        end
        else begin
            for (integer i = 0; i < `RegNum; i = i + 1) begin
                regs[i] <= `ZeroWord;
            end
        end
    end
    
    // 读端口1
    always @ (*) begin
        // 复位置零
        if(rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end 
        
        // 读0寄存器置0
        else if(raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end 
        
        // 读写一致
        else if((re1 == `ReadEnable) && (we == `WriteEnable) && (raddr1 == waddr)) begin
            rdata1 <= wdata; 
        end

        else if(re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
        end
    
        // 其他情况置零
        else begin
            rdata1 <= `ZeroWord;
        end
    end

    // 读端口2
    always @ (*) begin
        // 复位置零
        if(rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end 
        
        // 读0寄存器置0
        else if(raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end 
        
        // 读写一致
        else if((re2 == `ReadEnable) && (we == `WriteEnable) && (raddr2 == waddr)) begin
            rdata2 <= wdata; 
        end

        else if(re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end
    
        // 其他情况置零
        else begin
            rdata2 <= `ZeroWord;
        end
    end
endmodule