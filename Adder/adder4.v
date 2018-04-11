`include "adder.v"
module adder4(output [3:0] sum4,
              output carry4, 
              input [3:0] a4,
              input [3:0] b4,
              input cin4);
  wire c1,c2,c3;
  adder fa0(sum4[0], c1 , a4[0] , b4[0] , cin4);

  adder fa1(sum4[1], c2 , a4[1] , b4[1] , c1);
  adder fa2(sum4[2], c3 , a4[2] , b4[2] , c2);
  adder fa3(sum4[3], carry4 , a4[3] , b4[3] , c3);
endmodule
