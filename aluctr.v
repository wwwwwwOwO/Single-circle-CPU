
`timescale 1ns / 1ps
module aluctr(
input [4:0] ALUOp, 
input [5:0] funct, 
input [4:0] rt,
output reg [4:0]  ALUCtr,
output reg  jr,load2, nRW
);
    initial begin
        ALUCtr = 5'b00000;
        jr = 0;
        load2 = 0;
        nRW = 0;
    end
    always @(ALUOp or funct or rt) begin//  如果操作码或者功能码变化执行操作
        casex({ALUOp, funct, rt}) // 拼接操作码和功能码便于下一步的判断
            //I型 12条

                16'b00011xxxxxxxxxxx: begin  ALUCtr = 5'b00010; jr = 0; load2 = 0; nRW = 0; end// lw,sw,addi,addiu
                16'b00001xxxxxxxxxxx: begin  ALUCtr = 5'b00000; jr = 0; load2 = 0; nRW = 0; end// andi
                16'b00010xxxxxxxxxxx: begin  ALUCtr = 5'b00001; jr = 0; load2 = 0; nRW = 0; end// ori
                16'b00101xxxxxxxxxxx: begin  ALUCtr = 5'b00100; jr = 0; load2 = 0; nRW = 0; end// xori

                16'b10000xxxxxxxxxxx: begin  ALUCtr = 5'b01111; jr = 0; load2 = 0; nRW = 0; end// lui

                16'b00111xxxxxxxxxxx: begin  ALUCtr = 5'b00110; jr = 0; load2 = 0; nRW = 1; end// beq
                16'b00100xxxxxxxxxxx: begin  ALUCtr = 5'b00011; jr = 0; load2 = 0; nRW = 1; end// bne

                16'b01000xxxxxxxxxxx: begin  ALUCtr = 5'b00111; jr = 0; load2 = 0; nRW = 0; end// slti
                16'b01111xxxxxxxxxxx: begin  ALUCtr = 5'b01110; jr = 0; load2 = 0; nRW = 0; end// sltiu
            //其他指令
                16'b10001xxxxxx00000: begin  ALUCtr = 5'b10000; jr = 0; load2 = 0; nRW = 1; end// bltz
                16'b10001xxxxxx10000: begin  ALUCtr = 5'b10000; jr = 0; load2 = 1; nRW = 0; end// bltzal
                16'b10001xxxxxx00001: begin  ALUCtr = 5'b10011; jr = 0; load2 = 0; nRW = 1; end// bgez
                16'b10001xxxxxx10001: begin  ALUCtr = 5'b10011; jr = 0; load2 = 1; nRW = 0; end// bgezal

                16'b10010xxxxxx00000: begin  ALUCtr = 5'b10001; jr = 0; load2 = 0; nRW = 1; end// blez
                16'b10011xxxxxx00000: begin  ALUCtr = 5'b10010; jr = 0; load2 = 0; nRW = 1; end// bgtz


            //R型 除了jr共16条

                16'b00000100100xxxxx: begin  ALUCtr = 5'b00000; jr = 0; load2 = 0; nRW = 0; end// and 
                16'b00000100101xxxxx: begin  ALUCtr = 5'b00001; jr = 0; load2 = 0; nRW = 0; end// or 
                16'b00000100000xxxxx: begin  ALUCtr = 5'b00010; jr = 0; load2 = 0; nRW = 0; end// add 
                16'b00000100001xxxxx: begin  ALUCtr = 5'b00010; jr = 0; load2 = 0; nRW = 0; end// addu 
                16'b00000100110xxxxx: begin  ALUCtr = 5'b00100; jr = 0; load2 = 0; nRW = 0; end// xor  
                16'b00000100111xxxxx: begin  ALUCtr = 5'b00101; jr = 0; load2 = 0; nRW = 0; end// nor
                16'b00000100010xxxxx: begin  ALUCtr = 5'b00110; jr = 0; load2 = 0; nRW = 0; end// sub 
                16'b00000100011xxxxx: begin  ALUCtr = 5'b00110; jr = 0; load2 = 0; nRW = 0; end// subu

                16'b00000101010xxxxx: begin  ALUCtr = 5'b00111; jr = 0; load2 = 0; nRW = 0; end// slt
                16'b00000101011xxxxx: begin  ALUCtr = 5'b01110; jr = 0; load2 = 0; nRW = 0; end// sltu  

                16'b00000000000xxxxx: begin  ALUCtr = 5'b01000; jr = 0; load2 = 0; nRW = 0; end//sll   
                16'b00000000010xxxxx: begin  ALUCtr = 5'b01001; jr = 0; load2 = 0; nRW = 0; end//srl
                16'b00000000011xxxxx: begin  ALUCtr = 5'b01010; jr = 0; load2 = 0; nRW = 0; end//sra
                16'b00000000100xxxxx: begin  ALUCtr = 5'b01011; jr = 0; load2 = 0; nRW = 0; end//sllv
                16'b00000000110xxxxx: begin  ALUCtr = 5'b01100; jr = 0; load2 = 0; nRW = 0; end//srlv
                16'b00000000111xxxxx: begin  ALUCtr = 5'b01101; jr = 0; load2 = 0; nRW = 0; end//srav
            //寄存器跳转指令
                16'b00000001000xxxxx: begin  ALUCtr = 5'b00000; jr = 1; load2 = 0; nRW = 1; end //jr           
                16'b00000001001xxxxx: begin  ALUCtr = 5'b00000; jr = 1; load2 = 1; nRW = 0;end //jalr
            //其他指令
                16'b11010000010xxxxx: begin  ALUCtr = 5'b10100; jr = 0; load2 = 0; nRW = 0; end//mul
                16'b00000011000xxxxx: begin  ALUCtr = 5'b10100; jr = 0; load2 = 0; nRW = 1; end//mult
                16'b00000011001xxxxx: begin  ALUCtr = 5'b10101; jr = 0; load2 = 0; nRW = 1; end//multu
                16'b00000011010xxxxx: begin  ALUCtr = 5'b10110; jr = 0; load2 = 0; nRW = 1; end//div
                16'b00000011011xxxxx: begin  ALUCtr = 5'b10110; jr = 0; load2 = 0; nRW = 1; end//divu
                16'b00000010000xxxxx: begin  ALUCtr = 5'b10111; jr = 0; load2 = 0; nRW = 0; end//mfhi
                16'b00000010010xxxxx: begin  ALUCtr = 5'b11000; jr = 0; load2 = 0; nRW = 0; end//mflo
                16'b11010000x00xxxxx: begin  ALUCtr = 5'b11001; jr = 0; load2 = 0; nRW = 1; end//madd msub
                16'b1101010000100000: begin  ALUCtr = 5'b11010; jr = 0; load2 = 0; nRW = 0; end//clo
                16'b1101010000000000: begin  ALUCtr = 5'b11011; jr = 0; load2 = 0; nRW = 0; end//clz
                16'b00000010001xxxxx: begin  ALUCtr = 5'b11100; jr = 0; load2 = 0; nRW = 1; end//mthi
                16'b00000010011xxxxx: begin  ALUCtr = 5'b11101; jr = 0; load2 = 0; nRW = 1; end//mtlo
                16'b11010000x01xxxxx: begin  ALUCtr = 5'b11110; jr = 0; load2 = 0; nRW = 1; end//maddu msubu
                

                default: begin  ALUCtr = 5'b11111; jr = 0; load2 = 0; nRW = 0; end
        endcase
    end
endmodule