`timescale 1ns / 1ps
module ctr(
    input [5:0] opCode, 
    output reg regDst, 
    output reg aluSrc, 
    output reg memToReg, 
    output reg regWrite, 
    output reg memWrite, 
    output reg branch,
    output reg ExtOp, //������չ��ʽ��1 Ϊ sign-extend��0 Ϊ zero-extend
    output reg load, 
    output reg jmp,
    output reg[4:0] aluop// ���� ALU ����������� ALU ����
);

    always@(opCode) begin
    // ������ı�ʱ�ı�����ź�
        case(opCode)
    // 'R ��' ָ�������: 000000
            6'b000000: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 1;memWrite = 0;
                branch = 0; jmp = 0; load = 0; ExtOp=0;
                aluop = 5'b00000;  
                end
    //'I'��ָ�������
            6'b001000: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0;
                branch = 0; jmp = 0;load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'addi' ָ�������: 001000

            6'b001001:begin 
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0;
                branch = 0; jmp = 0; load = 0; ExtOp = 0;
                aluop = 5'b00011;
                end // 'addiu' ָ�������: 001001 

            6'b001100: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00001; 
                end // 'andi' ָ�������: 001100

            6'b001101: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0;jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00010; 
                end // 'ori' ָ�������: 001101

            6'b001110: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00101; 
                end // 'xori' ָ�������: 001110

            6'b001111: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 0;
                aluop = 5'b10000; 
                end // 'lui' ָ�������: 001111

            6'b100011: begin
                regDst = 0;  aluSrc = 1; memToReg = 1;
                regWrite = 1;  memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'lw' ָ�������: 100011
            6'b100000: begin
                regDst = 0;  aluSrc = 1; memToReg = 1;
                regWrite = 1;  memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'lb' 
            6'b100100: begin
                regDst = 0;  aluSrc = 1; memToReg = 1;
                regWrite = 1;  memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'lbu'
            6'b100001: begin
                regDst = 0;  aluSrc = 1; memToReg = 1;
                regWrite = 1;  memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'lh' 
            6'b100101: begin
                regDst = 0;  aluSrc = 1; memToReg = 1;
                regWrite = 1;  memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011;
                end // 'lhu' 

            6'b101011: begin
                regDst = 0;  aluSrc = 1;  memToReg = 0;
                regWrite = 0; memWrite = 1; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011; 
                end // 'sw' ָ�������: 101011

            6'b101001: begin
                regDst = 0;  aluSrc = 1;  memToReg = 0;
                regWrite = 0; memWrite = 1; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011; 
                end // 'sh' 

            6'b101000: begin
                regDst = 0;  aluSrc = 1;  memToReg = 0;
                regWrite = 0; memWrite = 1; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00011; 
                end // 'sb' 
            

            6'b000100: begin
                aluSrc = 0;  memToReg = 0; memToReg = 0;
                regWrite = 0; memWrite = 0; 
                branch = 1; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00111; 
                end // 'beq' ָ�������: 000100

            6'b000101: begin
                aluSrc = 0;  memToReg = 0; memToReg = 0;
                regWrite = 0; memWrite = 0; 
                branch = 1; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b00100; 
                end // 'bne' ָ�������: 000101

            6'b001010: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b01000; 
                end // 'slti' ָ�������: 001010

            6'b001011: begin
                regDst = 0;  aluSrc = 1; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 0;
                aluop = 5'b01111; 
                end // 'sltiu' ָ�������: 001011

    //'J ��'     
            6'b000010: begin
                regDst = 0;  aluSrc = 0; memToReg = 0;
                regWrite = 0; memWrite = 0; 
                jmp = 1; branch = 0; load = 0; ExtOp=0;
                aluop = 5'b00000;
                end // 'j' ָ�������: 000010������ ALU
                
            6'b000011: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 1; memWrite = 0; 
                jmp = 1; branch = 0; load = 1; ExtOp=0;
                aluop = 5'b00000;
                end// 'jal'ָ������룺000011

    //����ָ��
            6'b011100: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 1; memWrite = 0;
                branch = 0; jmp = 0; load = 0; ExtOp=0;
                aluop = 5'b11010;  
                end //mul clo clz

            6'b000001: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 1;  memWrite = 0; 
                branch = 1;  jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b10001;
                end // bltz bgez bltzal bgezal
            
            6'b000110: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 0;  memWrite = 0; 
                branch = 1;  jmp = 0; load = 0; ExtOp = 1;
                aluop = 5'b10010;
                end // blez

            6'b000111: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 0;  memWrite = 0; 
                branch = 1;  jmp = 0; load = 0;  ExtOp = 1;
                aluop = 5'b10011;
                end // bgtz

            6'b011100: begin
                regDst = 1;  aluSrc = 0; memToReg = 0;
                regWrite = 0; memWrite = 0;
                branch = 0; jmp = 0; load = 0; ExtOp=0;
                aluop = 5'b11010;  
                end //madd msub maddu msubu

            default: begin
                regDst = 0;  aluSrc = 0; memToReg = 0;
                regWrite = 0; memWrite = 0; 
                branch = 0; jmp = 0; load = 0; ExtOp = 0; 
                aluop = 5'b11111;
                end // Ĭ������
        endcase 
    end
endmodule
