//`include "adder.v"
`include "adder4.v"

module adder16(output [15:0] sum16,
              output carry16, 
              input [15:0] a16,
              input [15:0] b16,
              input cin16);
  wire c1,c2,c3;
  adder4 fa0(sum16[3:0], c1 , a16[3:0] , b16[3:0] , cin16),
         fa1(sum16[7:4], c2 , a16[7:4] , b16[7:4] , c1),
         fa2(sum16[11:8], c3 , a16[11:8] , b16[11:8] , c2),
         fa3(sum16[15:12], carry16 , a16[15:12] , b16[15:12] , c3);
endmodule
