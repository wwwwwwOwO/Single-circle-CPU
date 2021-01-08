`timescale 1ns / 1ps//�Ĵ�����ģ��
module RegFile 
    #(parameter ADDR = 5,               //�Ĵ������롢��ַλ��    
    parameter NUMB = 1<<ADDR,           //�Ĵ�������
    parameter SIZE = 32)                //�Ĵ�������λ��
(   input Clk,                          //д��ʱ���ź�
    input Clr,                          //�����ź�
    input Write_Reg,                    //д�����ź�
    input [ADDR-1:0] R_Addr_A,             //A�˿ڶ��Ĵ�����ַ
    input [ADDR-1:0] R_Addr_B,             //B�˿ڶ��Ĵ�����ַ
    input [ADDR-1:0] W_Addr,               //д�Ĵ�����ַ
    input [SIZE-1:0] W_Data,               //д������
    output [SIZE-1:0] R_Data_A,            //A�˿ڶ�������
    output [SIZE-1:0] R_Data_B,             //B�˿ڶ�������
    output [SIZE-1:0] ra
);
    reg [SIZE-1:0]REG_Files[0:NUMB-1];//�Ĵ����ѱ���
    integer i;//���ڱ���NUMB���Ĵ���

    initial//��ʼ��NUMB���Ĵ�����ȫΪ0
    for(i=0;i<NUMB;i=i+1) 
        REG_Files[i]<=0;
    
    always@(negedge Clk or posedge Clr)begin//ʱ���źŻ������ź�������
        //����
        if(Clr)
            for(i=0;i<NUMB;i=i+1) 
                REG_Files[i]<=0;
        //������,���д����, �ߵ�ƽ��д��Ĵ���
        else if(Write_Reg) 
            REG_Files[W_Addr]<=W_Data; 
    end        //������û��ʹ�ܻ�ʱ���źſ���, ʹ����������ģ(����߼���·,������Ҫʱ�ӿ���)

    assign R_Data_A = REG_Files[R_Addr_A];
    assign R_Data_B = REG_Files[R_Addr_B]; 
    assign ra = REG_Files[SIZE-1];
endmodule
