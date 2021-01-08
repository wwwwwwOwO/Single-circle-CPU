`timescale 1ns / 1ps


module next_pc(
input reset,
input branch, 
input zero, 
input jmp, 
input jr,
input [31:0] pc_Add4,
input [31:0] expand,
input [31:0] rs,
input [31:0] instruction,
output reg[31:0] next_pc
); 
    
    wire PCSrc1, PCSrc2;
    wire [31:0]  J_Addr,branch_Addr;

    assign branch_Addr = pc_Add4 + (expand << 2);
    assign J_Addr =jr? rs:{pc_Add4[31:28], instruction[25:0], 2'b00}; 

    //PCµÄ¶àÑ¡Æ÷
    assign PCSrc1 = (branch & zero)? 1'b1:1'b0;
    assign PCSrc2 = (jmp | jr)? 1'b1:1'b0;

    always@(*)begin
        casex({PCSrc2, PCSrc1})
            2'b00:next_pc<=pc_Add4;
            2'b01:next_pc<=branch_Addr;
            2'b1x:next_pc<=J_Addr;
            default:next_pc<=pc_Add4;
        endcase
    end

endmodule
