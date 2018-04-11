`timescale 1ns/10ps

`include "f_adder.v"

module floating_adder_tb();
  wire [31:0] sum18;
  reg [31:0] a_original18,b_original18;
  reg clk18;
  f_adder ft_tb(sum18,a_original18,b_original18,clk18);
   
  initial begin
    clk18=0;
    repeat(23) begin
      #5 
      clk18 = ~clk18;
    end  
  end

  initial begin
    a_original18 = 32'h42C80000;
    b_original18 = 32'h43480000;
    
    #5; 
    a_original18 = 32'h42C80000;
    b_original18 = 32'h43480000;
    #10;
    a_original18 = 32'h42C80000;
    b_original18 = 32'hC2480000;
    #10;
     a_original18 = 32'hC2540000;
     b_original18 = 32'h420C0000;
    #10;
     a_original18 = 32'hC3960000;
     b_original18 = 32'hC2C60000;
    #10;
     a_original18 = 32'h00000000;
     b_original18 = 32'h00000000;
    #10;
     a_original18 = 32'h00000000;
     b_original18 = 32'hC32B0000;
    #10;
  end

  initial begin
    $dumpfile("f_adder.vcd");
    $dumpvars(0,floating_adder_tb);
  end
endmodule
