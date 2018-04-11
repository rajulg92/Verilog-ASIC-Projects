

module adder(output sum, output carry, input a, input b, input cin);
  reg y1,y2,y3;
  
  always @(*) begin
    y1 = a ^ b;
    y2 = y1 & cin;
    y3 = a & b;
  end
  assign sum = y1 ^ cin;
  assign carry = y2 | y3;
endmodule
