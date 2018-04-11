`timescale 1ms/10us

`include "nios2.v"

module nios2_tb();
  wire [31:0] sum18;
  reg [31:0] instruction18;
  reg clk18;
  nios2 ft_tb(instruction18,clk18);
   
  initial begin
    clk18=0;
    repeat(50) begin
      #5 
      clk18 = ~clk18;
    end  
  end

  initial begin
    
    #5;
    
    instruction18 = 32'h21000017; //ldw r4,0(r4)
    #10;
    instruction18 = 32'h000A0C7A; //add r5,r0,r0
    #10;
    repeat(6) begin 
      instruction18 = 32'h118000173;//ldw r6,0(r4)(loop)
      #10;
      instruction18 = 32'h19C00017;//ldw r7,0(r3)
      #10;
      instruction18 = 32'h31D009FA;//mul r8,r6,r7
      #10;
      instruction18 = 32'h2A0A0C7A;//add r5,r5,r8
      #10;
      instruction18 = 32'h10800104;//addi r2,r2,4
      #10;
      instruction18 = 32'h18C00104;//addi r3,r3,4
      #10;
      instruction18 = 32'h213FFFC4;//subi r4,r4,1
      #10;
      instruction18 = 32'h20000016;//bgt r4,r0,Loop
      #10;
    end
    instruction18 = 32'h01400015;//stw r5,0(r0)
    #10;
    instruction18 = 32'h00000006;//br Stop(Stop)
    #10;
  end

  initial begin
    $dumpfile("nios2.vcd");
    $dumpvars(0,nios2_tb);
  end
endmodule
