module f_adder(sum18,a_original18,b_original18,clk18);
  input [31:0] a_original18, b_original18;
  input clk18;
  output [31:0] sum18;
  reg           sumneg18,sumneg_18;
  reg [7:0]    sumexp18;
  reg [25:0]    sumsig18,sumsig_18,sumsig2_18,sumsig3_18,sumsig4_18,sumsig5_18,sumsig6_18;

  reg [31:0]    a18, b18;
  reg [25:0]   asig18,asig1_18,bsig18,bsig1_18,asig_18,asig2_18,asig3_18,asig4_18,bsig_18,asig2_18,bsig2_18,bsig3_18,bsig4_18;
  reg [7:0]    aexp18, bexp18;
  reg           aneg18, bneg18;
  reg [7:0]    diff18,diff_18;
  reg [7:0]    Ea_18, Eb_18,Ea2_18,Eb2_18,Ea3_18,Ea4_18,Ea5_18;
  reg shift;

  integer pos18, adj18, i18;

  assign        sum18[31]    = sumneg18;
  assign        sum18[30:23] = sumexp18;
  assign        sum18[22:0]  = sumsig18;


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
  
  /******************Pipelining Stage 1**************************/
  always @(a_original18 or b_original18) begin
    diff18 = aexp18 - bexp18;
    
    
    bsig18 = bsig18 >> diff18;
    
    
    if ( aneg18 ) asig18 = -asig18;
    else asig18 = asig18;
    if ( bneg18 ) bsig18 = -bsig18;
    else bsig18 = bsig18;
    
    sumsig18 = asig18 + bsig18;
   
    sumneg18 = sumsig18[25];
    //sumneg_18 <= sumsig_18[25];
    if ( sumneg18 ) sumsig18 = -sumsig18;
    //  Normalize 1 sum.
    if ( sumsig18[24] ) begin
    //  Sum overflow.
    //  Right shift significand and increment exponent.
     
    sumexp18 = aexp18 + 1;
    sumsig18 = sumsig18 >> 1;

  end else if ( sumsig18 ) begin
    //  Sum is nonzero and did not overflow.
    //  Normalize 2. 
     //Finding position of first non-zero digit.
    pos18 = 0;
    for (i18 = 23; i18 >= 0; i18 = i18 - 1 ) begin
      if ( !pos18 && sumsig18[i18] ) pos18 = i18;
    end
    // Compute amount to shift significand and reduce exponent.
    adj18 = 23 - pos18;
      if ( aexp18 < adj18 ) begin
      //   Exponent too small, floating point underflow, set to zero.
      sumexp18 = 0;
      sumsig18 = 0;
      sumneg18 = 0;
    end else begin
       //Adjust significand and exponent.
      sumexp18 = aexp18 - adj18;
      sumsig18 = sumsig18 << adj18;
     end
    end else begin
      // Case 3: Sum is zero.
      sumexp18 = 0;
      sumsig18 = 0;
    end
    //sumsig5_18 <= sumsig6_18;
    //sumsig6_18 <= sumsig5_18;
    //sumneg_18 <= sumneg18;

  
  end

  //always @(*) begin
   
    //sumsig6_18 <= sumsig_18;
    
  //end
  /******************Pipelining Stage 2**************************/
  //always @(posedge clk) begin
    // end

  /******************Pipelining Stage 3**************************/
  //always @(posedge clk) begin
   
 // end
  
  /******************Pipelining Stage 4**************************/
  //always @(posedge clk) begin
    // end
  
  /******************Pipelining Stage 5**************************/
  //always @(posedge clk) begin
    //  end

endmodule 
