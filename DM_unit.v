module DM_unit(
    input clk,
    input Wr,
    input reset,
    input sign,
    input [1:0] mode,
    input [7:0] DMAdr, 
    input [31:0] wd,
    output reg [31:0] rd
    );
			 
	reg [31:0] RAM[0:255]; 
    wire [31:0] target;

    //read
    assign target = RAM[DMAdr];

    always@(*)begin
        casex(mode)
            2'b00: begin rd={{24{sign}}, target[7:0]};  end
            2'b01: begin rd={{16{sign}}, target[15:0]};  end
            2'b1x: begin rd=target; end
            default: begin rd=target; end
        endcase
    end


    //write
    integer i;
    always @ (posedge clk or posedge reset)begin
        if(reset)begin
            for(i = 0; i < 256; i = i + 1) 
                RAM[i] = 0;       
        end	
        else if(Wr) begin
            casex(mode)
                2'b00: RAM[DMAdr][7:0] = wd[7:0];
                2'b01: RAM[DMAdr][15:0] = wd[15:0];
                2'b1x: RAM[DMAdr] = wd;
                default: RAM[DMAdr] = wd;
            endcase
        end           
    end  
 endmodule
