`timescale 1ns / 1ps
module alu(
    input reset,
    input clk,
    input sub,
    input [4:0] shamt,
    input [31:0] input1,
    input [31:0] input2,
    input [4:0] aluCtr, 
    output reg [31:0] aluRes, 
    output reg ZF, CF,OF,
    output reg [31:0] hi,lo
);
    reg hlWE;
    reg [31:0] HI,LO;
    initial begin
        HI <= 0;
        LO <= 0;
        hi <= 0;
        lo <= 0;
        hlWE <= 0;
        ZF <= 0;
        CF <= 0;
        OF <= 0;
        aluRes <= 0;
    end
    
    always@(posedge reset or posedge clk)begin
        if(reset)begin
            hi <= 0;
            lo <= 0;
        end
        else if(hlWE)begin
            hi <= HI;
            lo <= LO;
        end 
    end
    wire [31:0] yushu,shang;
    div_0 div(
        .a(input1),
        .b(input2),
        .yshang(shang),
        .yyushu(yushu)
    );
    integer i;
    always @(aluCtr or input1 or input2 or shamt ) // 运算数或控制码变化时操作
    #1
    begin
        case(aluCtr) 
            5'b00000: // and andi 
                begin
                    hlWE = 0; 
                    aluRes = input1 & input2; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;    
                end
            5'b00001: // or ori
                begin
                    hlWE = 0; 
                    aluRes = input1 | input2; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b00010: // addi add lw sw 
                begin
                    hlWE = 0; 
                    {CF,aluRes} = input1 + input2; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    OF = input1[31]^input2[31]^aluRes[31]^CF;//溢出标志公式
                    
                end
            5'b00011://bne 
                begin
                    hlWE = 0; 
                    aluRes = input1 - input2;
                    if(aluRes==0) ZF=0; //这里的zero是指不为0，不相等,不跳转
                    else ZF=1;
                    CF <= 0;
                    OF <= 0;   
                end
            5'b00100://xor xori
                begin
                    hlWE = 0; 
                    aluRes=(~input1&input2)|(input1&~input2); 
                    if(aluRes==0) ZF=1;
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end 
            5'b00101: // nor 
                begin
                    hlWE = 0; 
                    aluRes = ~(input1 | input2); 
                    if(aluRes==0) ZF=1;       
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b00110: // sub subu beq
                begin
                    hlWE = 0; 
                    {CF,aluRes} = input1 - input2; 
                    if(aluRes == 0) ZF = 1;
                    else  ZF = 0;     
                    OF = input1[31]^input2[31]^aluRes[31]^CF;//溢出标志公式
                     
                end
            5'b00111: // 小于设置slt
                begin
                    hlWE = 0; 
                    if(($signed(input1))<($signed(input2))) aluRes = 1;
                    else aluRes=0;
                    
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01000://sll 
                begin
                    hlWE = 0; 
                    aluRes = input2 << shamt;
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01001://srl 
                begin
                    hlWE = 0; 
                    aluRes = input2 >> shamt; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01010://sra 
                begin
                    hlWE = 0; 
                    aluRes =($signed(input2))>>> shamt; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01011://sllv 
                begin
                    hlWE = 0; 
                    aluRes = input2 << (input1[4:0]);
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01100://srlv 
                begin
                    hlWE = 0; 
                    aluRes = input2 >> (input1[4:0]); 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end
            5'b01101://srav 
                begin
                    hlWE = 0; 
                    aluRes = ($signed(input2))>>>($signed(input1[4:0]));
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end

            5'b01110: // 小于设置sltu 
                begin
                    hlWE = 0; 
                    if(($unsigned(input1))<($unsigned(input2))) aluRes = 1;
                    else aluRes=0; 
                    if(aluRes==0) ZF=1; 
                    else ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end

            5'b01111://lui 
                begin
                    hlWE = 0; 
                    aluRes={input2[15:0],16'b0000_0000_0000_0000};
                    CF <= 0;
                    OF <= 0;   
                end 

            5'b10000://bltz bltzal
                begin
                    hlWE = 0; 
                    if(($signed(input1))<0)
                    ZF=1;
                    else
                    ZF=0; 
                    CF <= 0;
                    OF <= 0;   
                end

            5'b10001://blez
                begin
                    hlWE = 0; 
                    if(($signed(input1))>0)
                    ZF=0; 
                    else
                    ZF=1;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b10010://bgtz
                begin
                    hlWE = 0; 
                    if(($signed(input1))>0)
                    ZF=1;
                    else
                    ZF=0;
                    CF <= 0;
                    OF <= 0;                
                end

            5'b10011://bgez bgezal
                begin
                    hlWE = 0; 
                    if(($signed(input1))<0)
                    ZF=0; 
                    else
                    ZF=1;
                    CF <= 0;
                    OF <= 0;   
                end
            5'b10100://mult
                begin
                    hlWE = 1; 
                    {HI,LO}= ($signed(input1)) * ($signed(input2));
                    aluRes=LO;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end
            5'b10101://multu
                begin
                    hlWE = 1; 
                    {HI,LO}= ($unsigned(input1)) * ($unsigned(input2));
                    aluRes=LO;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b10110://div divu
                begin
                    hlWE = 1; 
                    HI=yushu;
                    LO=shang;
                    aluRes=LO;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b10111://mfhi
                begin
                    hlWE = 0; 
                    aluRes=hi;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b11000://mflo
                begin
                    hlWE = 0; 
                    aluRes=lo;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b11001://madd msub
                begin
                    hlWE = 1;
                    if(sub)
                    {HI,LO}= ($signed({HI,LO})) - ($signed(input1)) * ($signed(input2));
                    else
                    {HI,LO}= ($signed({HI,LO})) + ($signed(input1)) * ($signed(input2));

                    aluRes=LO;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b11010://clo
                begin
                    hlWE = 0; 
                    for(i=0;i<32&&input1[31-i];i=i+1)begin
                    end
                    aluRes=i;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            5'b11011://clz
                begin
                    hlWE = 0; 
                    for(i=0;i<32&&!input1[31-i];i=i+1)begin
                    end
                    aluRes=i;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;    
                end
            
            5'b11100://mthi
                begin
                    hlWE = 1;
                    HI = input1; 
                    aluRes = input1;                    
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end
            5'b11101://mtlo
                begin
                    hlWE = 1;
                    LO = input1; 
                    aluRes = input1;  
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end
            5'b11110://maddu msubu
                begin
                    hlWE = 1;
                    if(sub)
                    {HI,LO}= ($unsigned({HI,LO})) - ($unsigned(input1)) * ($unsigned(input2));
                    else
                    {HI,LO}= ($unsigned({HI,LO})) + ($unsigned(input1)) * ($unsigned(input2));
                    
                    aluRes=LO;
                    if(aluRes==0) ZF=1; 
                    else ZF=0;
                    CF <= 0;
                    OF <= 0;   
                end

            default: 
            begin
                aluRes <= 0; 
                ZF<=0; 
                OF<=0; 
                CF<=0; 
                hlWE <= 0;
            end 
        endcase

    end

    
endmodule
