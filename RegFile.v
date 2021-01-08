`timescale 1ns / 1ps//寄存器堆模块
module RegFile 
    #(parameter ADDR = 5,               //寄存器编码、地址位宽    
    parameter NUMB = 1<<ADDR,           //寄存器个数
    parameter SIZE = 32)                //寄存器数据位宽
(   input Clk,                          //写入时钟信号
    input Clr,                          //清零信号
    input Write_Reg,                    //写控制信号
    input [ADDR-1:0] R_Addr_A,             //A端口读寄存器地址
    input [ADDR-1:0] R_Addr_B,             //B端口读寄存器地址
    input [ADDR-1:0] W_Addr,               //写寄存器地址
    input [SIZE-1:0] W_Data,               //写入数据
    output [SIZE-1:0] R_Data_A,            //A端口读出数据
    output [SIZE-1:0] R_Data_B,             //B端口读出数据
    output [SIZE-1:0] ra
);
    reg [SIZE-1:0]REG_Files[0:NUMB-1];//寄存器堆本体
    integer i;//用于遍历NUMB个寄存器

    initial//初始化NUMB个寄存器，全为0
    for(i=0;i<NUMB;i=i+1) 
        REG_Files[i]<=0;
    
    always@(negedge Clk or posedge Clr)begin//时钟信号或清零信号上升沿
        //清零
        if(Clr)
            for(i=0;i<NUMB;i=i+1) 
                REG_Files[i]<=0;
        //不清零,检测写控制, 高电平则写入寄存器
        else if(Write_Reg) 
            REG_Files[W_Addr]<=W_Data; 
    end        //读操作没有使能或时钟信号控制, 使用数据流建模(组合逻辑电路,读不需要时钟控制)

    assign R_Data_A = REG_Files[R_Addr_A];
    assign R_Data_B = REG_Files[R_Addr_B]; 
    assign ra = REG_Files[SIZE-1];
endmodule
