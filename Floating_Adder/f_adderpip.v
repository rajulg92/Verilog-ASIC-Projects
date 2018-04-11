/* Note That first clock cycle is kept reseved for no operation */
/* Also the operation starts from the second cycle */

module f_adderpip(sum18,a_original18,b_original18,clk18);
  
  input [31:0] a_original18, b_original18;
  input clk18;
  output [31:0] sum18;
  reg           sumneg18,sumneg_18;
  reg [7:0]     sumexp18,sumexp_18;
  reg [25:0]    sumsig18,sumsig_18,sumsig2_18,sumsig3_18,sumsig4_18,sumsig5_18,sumsig6_18;

  reg [31:0]    a18, b18;
  reg [25:0]    asig18,asig1_18,bsig18,bsig1_18,asig_18,asig2_18,asig3_18;
  reg [25:0]    asig4_18,bsig_18,asig2_18,bsig2_18,bsig3_18,bsig4_18;
  reg [7:0]     aexp18, bexp18;
  reg           aneg18, bneg18;
  reg [7:0]     diff18,diff_18;
  reg [7:0]     Ea_18, Eb_18,Ea2_18,Eb2_18,Ea3_18,Ea4_18,Ea5_18;
  reg shift;

  integer pos18, adj18, i18;

  assign        sum18[31]    = sumneg_18;
  assign        sum18[30:23] = sumexp_18;
  assign        sum18[22:0]  = sumsig4_18;


  always @( a_original18 or b_original18 )
    begin
     
      // Copy inputs to a and b so that a's exponent not smaller than b's.
        
      if ( a_original18[30:23] < b_original18[30:23] ) begin

         a18 = b_original18;  
         b18 = a_original18;
      end else begin

         a18 = a_original18;
         b18 = b_original18;

      end
    // Break operand into sign (neg), exponent, and significand
        
    aneg18 = a18[31];     bneg18 = b18[31];
    aexp18 = a18[30:23];  bexp18 = b18[30:23];
    // Put a 0 in bits 25 and 24 (later used for sign).
    // Put a 1 in bit 23 of significand if exponent is non-zero.
    // Copy significand into remaining bits.
    asig18 = { 2'b0, aexp18 ? 1'b1 : 1'b0, a18[22:0] };
    bsig18 = { 2'b0, bexp18 ? 1'b1 : 1'b0, b18[22:0] };
    
  end
  
  
  always @(posedge clk18) begin
    
    /******************Pipelining Stage 1**************************/
    diff_18 <= aexp18 - bexp18; //Checking Difference in Exponents of a & b
    
    /******************Pipelining Stage 2**************************/
    asig2_18 <= asig18; //Buffer Variable for Stage 2
    bsig2_18 <= bsig18 >> diff_18; // Shifting the smaller significand
    
    /******************Pipelining Stage 3**************************/    
    //Negating -ve significands and assign to Buffer Variables for Stage 3
    if ( aneg18 ) asig3_18 <= -asig2_18;
    else asig3_18 <= asig2_18;
    if ( bneg18 ) bsig3_18 <= -bsig2_18;
    else bsig3_18 <= bsig2_18;
    
    /******************Pipelining Stage 4**************************/
    sumsig2_18 <= asig3_18 + bsig3_18; // Adding Significands (Comuting Sum)
   // Buffer Variable assignment for stage 4
    
    sumneg18 <= sumsig2_18[25];

    /******************Pipelining Stage 5**************************/
    //Shifting and Normalisation occurs in this stage

    if ( sumneg18 ) sumsig3_18 <= -sumsig2_18;
    else sumsig3_18 <= sumsig2_18;
    
    //  Normalize 1 sum.
    if ( sumsig3_18[24] ) begin
    //  Sum overflow.
    //  Right shift significand and increment exponent.
     
    sumexp_18 <= aexp18 + 1;
    sumsig4_18 <= sumsig3_18 >> 1;
    sumneg_18 <= sumsig3_18[25];
    
    end else if ( sumsig3_18 ) begin
    //  Sum is nonzero and did not overflow.
    //  Normalize 2. 
     //Finding position of first non-zero digit.
      pos18 = 0;
      for (i18 = 22; i18 >= 0; i18 = i18 - 1 ) begin
        if ( !pos18 && sumsig3_18[i18] ) pos18 = i18;
      end
      // Compute amount to shift significand and reduce exponent.
      adj18 = 22 - pos18;
      if ( aexp18 < adj18 ) begin
      //   Exponent too small, floating point underflow, set to zero.
      sumexp_18 <= 0;
      sumsig4_18 <= 0;
      sumneg_18 <= 0;
      end else begin
       //Adjust significand and exponent.
      sumneg_18 <= sumsig3_18[25];
      sumexp_18 <= aexp18 - adj18;
      sumsig4_18 <= sumsig3_18 << adj18;
      end
    end else begin
      //  Sum is zero.
      sumexp_18 <= 0;
      sumsig4_18 <= 0;
    end
    
  end

endmodule 
