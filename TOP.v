`timescale 1ns / 1ps
    module top(
    input clk,                  //clk for display
    input clkin,                //clkin for PC
    input reset,                //resetʱ�Ĵ����ѡ�PC���洢��MEM���ó�ֵ 
    input [3:0]SW,                //select the data
    input up,                     //show upper bits
    output [6:0] seg,           //����
    output [3:0] sm_wei         //�ĸ������ 
    // output [31:0] PC,
    // output [31:0] aluRes,
    // output [31:0] instruction,
    // output [31:0] next_pc,hi,lo,ra,input1, input2
);
    
    reg [15:0] data;
    ///*
    wire [31:0] PC;
    wire  [31:0] aluRes;
    wire  [31:0] instruction;
    wire  [31:0] next_pc,hi,lo,ra;
    //*/
    
    reg [31:0] pc_Add4;
    always@(PC) begin
        pc_Add4=PC+4;      //pc_Add4 stores the PC+4
    end

    // CPU �����ź���
    wire reg_dst, alu_src, memtoreg, regwrite, regwrite2, memWrite, branch, ExtOp, jmp, jr,ld, nRW, load, load2;
    wire [4:0] aluop, aluCtr;
    wire[31:0] memReadData;
    wire [31:0] expand; 
    wire [4:0] regWriteAddr, regWriteAddr2;
    wire [31:0] regWriteData, regWriteData2;
    wire [31:0] RsData, RtData;
    wire ZF,OF,CF; //alu�����־λ 
    wire [31:0] oprand2;
    
//    assign input1=RsData;
//    assign input2=oprand2;

    initial data<=0;
        always@(*)begin
        casex({up,SW})
            5'b0_0000: data <= PC[15:0];
            5'b1_0000: data <= PC[31:16];
            5'b0_0001: data <= next_pc[15:0];
            5'b1_0001: data <= next_pc[31:16];
            5'b0_0010: data <= ra[15:0];
            5'b1_0010: data <= ra[31:16];
            5'b0_0100: data <= instruction[15:0];
            5'b1_0100: data <= instruction[31:16];
            5'b0_1000: data <= {3'b0,instruction[25:21],3'b0, instruction[20:16] };
            5'b0_1010: data <= RsData[15:0];
            5'b1_1010: data <= RsData[31:16];
            5'b0_1001: data <= oprand2[15:0];
            5'b1_1001: data <= oprand2[31:16];
            5'b0_1100: data <= aluRes[15:0];
            5'b1_1100: data <= aluRes[31:16];
            5'b0_0011: data <= lo[15:0];
            5'b1_0011: data <= lo[31:16];
            5'b0_0110: data <= hi[15:0];
            5'b1_0110: data <= hi[31:16];
            default: data<=16'b0;
        endcase
    end
    
    assign ld = (load | load2);
    assign regwrite= regwrite2 & (!nRW); 
    assign regWriteAddr2 = reg_dst ? instruction[15:11] : instruction[20:16];   //д�Ĵ�����Ŀ��Ĵ�������rt��rd
    assign regWriteAddr = regWriteAddr2 | {5{ld}};                               //
    assign regWriteData2 = memtoreg ? memReadData : aluRes;        //д��Ĵ�������������ALU�����ݼĴ��� 
    assign regWriteData = ld? pc_Add4 : regWriteData2;             //
    assign oprand2 = alu_src ? expand : RtData; //ALU�ĵڶ������������ԼĴ����������ָ���16λ�ķ�����չ

//
    pc_count pcCount(
        .next_pc(next_pc),  //input
        .clk(clkin),        //input
        .reset(reset),      //input 
        .pc(PC)             //output
    );
//
    next_pc nextPC(
        .reset(reset),                  //input
        .branch(branch),                //input
        .zero(ZF),                      //input
        .jmp(jmp),                       //input
        .jr(jr),                        //input
        .pc_Add4(pc_Add4),              //input
        .expand(expand),                //input
        .rs(RsData),                    //input
        .instruction(instruction),      //input
        .next_pc(next_pc)               //output
    );



// ����ָ��洢��
    IM_unit IM(
        .Addr(PC[9:2]),                 //input
        .instruction(instruction)       //output
    );
// ʵ����������ģ��
    ctr mainctr(
        .opCode(instruction[31:26]),//input
        .regDst(reg_dst),           //output
        .aluSrc(alu_src),           //output
        .memToReg(memtoreg),        //output
        .regWrite(regwrite2),        //output
        .memWrite(memWrite),        //output
        .branch(branch),            //output
        .ExtOp(ExtOp),              //output
        .load(load),                  //output
        .jmp(jmp),                  //output
        .aluop(aluop)               //output
    );
    
// ʵ����������չģ��
    signext signext1(
        .inst(instruction[15:0]),   //input
        .ExtOp(ExtOp),              //input �����ź�
        .data(expand)               //output
    );

//ʵ�����Ĵ���ģ��
    RegFile regfile(
        .Clr(reset),                    //input
        .Clk(clkin),                   //input
        .R_Addr_A(instruction[25:21]),  //input
        .R_Addr_B(instruction[20:16]),  //input
        .W_Addr(regWriteAddr),          //input
        .W_Data(regWriteData),          //input
        .Write_Reg(regwrite),           //input �����ź�
        .R_Data_A(RsData),              //output
        .R_Data_B(RtData),               //output
        .ra(ra)
    );

//ʵ���� ALU ����ģ��
    aluctr aluctr1(
        .ALUOp(aluop),              //input
        .funct(instruction[5:0]),   //input
        .rt(instruction[20:16]),    //input
        .ALUCtr(aluCtr),            //output
        .jr(jr),                     //output 
        .load2(load2),                 //output
        .nRW(nRW)
    );



// ʵ����ALUģ��
    alu alu_hilo(
        .reset(reset),
        .clk(!clkin),
        .sub(instruction[2]),
        .shamt(instruction[10:6]),          //input
        .input1(RsData),        //input
        .input2(oprand2),        //input
        .aluCtr(aluCtr),        //input
        .ZF(ZF),                //output
        .OF(OF),                //output
        .CF(CF),                //output
        .aluRes(aluRes),         //output
        .hi(hi),
        .lo(lo)
    );

//ʵ�������ݴ洢��
    DM_unit dm(
        .clk(!clkin),
        .Wr(memWrite),
        .reset(reset),           
        .DMAdr(aluRes[7:0]), 
        .mode(instruction[27:26]),
        .sign(!instruction[28]),
        .wd(RtData),
        .rd(memReadData)
    );
//ʵ�����������ʾģ��
     display_0 Smg(
        .clk(clk),                  //input
        .sm_wei(sm_wei),             //out
        .data(data),                    //in
        .sm_duan(seg)               //out
    ); 

endmodule
