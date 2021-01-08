module pc_count(
    input [31:0] next_pc,
    input clk,
    input reset,
    output reg [31:0] pc
);
initial pc=0;
    always@(posedge clk or posedge reset)begin
        if(reset)
        pc=32'h00000000;
        else
        pc=next_pc;
    end
endmodule
