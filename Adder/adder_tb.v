module adder_tb();
  wire [15:0] sum;
  wire carry16;
  reg [15:0] a;
  reg [15:0] b;
  reg cin16;
  adder16 test (sum,carry16,a,b,cin16);
  initial begin
    a=16'h00A0;
    b=16'hFF21;
    cin16=0;
    #2 
    a=16'hF100;
    b=16'hFFFF; 
    cin16=1;
    #2
    $finish; 
  end 
  initial begin
    $dumpfile("adder.vcd");
    $dumpvars(0,adder_tb);
  end
endmodule
