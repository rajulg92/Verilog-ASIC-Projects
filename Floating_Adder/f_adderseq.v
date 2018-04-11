module f_adderseq(sum18,ready18,a_original18,b_original18,start18,clk18);
   input [31:0] a_original18, b_original18;
   input        start18, clk18;
   output [31:0] sum18;
   output        ready18;

   reg           sumneg18;
   reg [7:0]    sumexp18;
   reg [25:0]    sumsig18;
   assign        sum18[31]    = sumneg18;
   assign        sum18[30:23] = sumexp18;
   assign        sum18[22:0]  = sumsig18;

   reg [31:0]    a18, b18;
   reg [25:0]    asig18, bsig18;
   reg [7:0]    aexp18, bexp18;
   reg           aneg18, bneg18;
   reg [7:0]    diff18;

   parameter     st_idle18  = 0;
   parameter     st_cyc_118 = 1;
   parameter     st_cyc_218 = 2;
   parameter     st_cyc_318 = 3;
   
   integer pos18, adj18, i18;
   reg [1:0]     state18;

   initial state18 = 0;

   assign        ready18 = state18;

   always @( posedge clk18 )
     case( state18 )
       2'b00:
          begin

            /// Step 1: Copy inputs to a and b so that a's exponent >= b's.
            //
            if ( a_original18[30:23] < b_original18[30:23] ) begin

               a18 = b_original18;  b18 = a_original18;

            end else begin

               a18 = a_original18;  b18 = b_original18;

            end
            state18 = 2'b01;

         end

       2'b01:
         begin

            /// Step 2: Break operand into sign (neg), exponent, and significand.
            //
            aneg18 = a18[31];     bneg18 = b18[31];
            aexp18 = a18[30:23];  bexp18 = b18[30:23];
            // Put a 0 in bits 53 and 54 (later used for sign).
            // Put a 1 in bit 52 of significand if exponent is non-zero.
            // Copy significand into remaining bits.
            asig18 = { 2'b0, aexp18 ? 1'b1 : 1'b0, a18[22:0] };
            bsig18 = { 2'b0, bexp18 ? 1'b1 : 1'b0, b18[22:0] };

            /// Step 3: Un-normalize b so that aexp == bexp.
            //
            diff18 = aexp18 - bexp18;
            bsig18 = bsig18 >> diff18;
            //
            // Note: bexp no longer used.
            //       If it were would need to set bexp = aexp;

            state18 = 2'b10;

         end

        2'b10:
         begin

            /// Step 4: If necessary, negate significands.
            //
            if ( aneg18 ) asig18 = -asig18;
            if ( bneg18 ) bsig18 = -bsig18;

            /// Step 5: Compute sum.
            //
            sumsig18 = asig18 + bsig18;

            state18 = 2'b11;

         end

       2'b11:
         begin

            /// Step 6: Take absolute value of sum.
            //
            sumneg18 = sumsig18[25];
            if ( sumneg18 ) sumsig18 = -sumsig18;

            /// Step 7: Normalize sum. (Three cases.)
            //
            if ( sumsig18[24] ) begin
               //
               // Case 1: Sum overflow.
               //         Right shift significand and increment exponent.

               sumexp18 = aexp18 + 1;
               sumsig18 = sumsig18 >> 1;

            end else if ( sumsig18 ) begin:A
               //
               // Case 2: Sum is nonzero and did not overflow.
               //         Normalize. (See cases 2a and 2b.)

               
               // Find position of first non-zero digit.
               pos18 = 0;
               for (i18 = 23; i18 >= 0; i18 = i18 - 1 )
                 if ( !pos18 && sumsig18[i18] ) pos18 = i18;

               // Compute amount to shift significand and reduce exponent.
               adj18 = 23 - pos18;
               if ( aexp18 < adj18 ) begin
                  //
                  // Case 2a:
                  //   Exponent too small, floating point underflow, set to zero.

                  sumexp18 = 0;
                  sumsig18 = 0;
                  sumneg18 = 0;

               end else begin
                  //
                  // Case 2b: Adjust significand and exponent.

                  sumexp18 = aexp18 - adj18;
                  sumsig18 = sumsig18 << adj18;

               end

            end else begin
               //
               // Case 3: Sum is zero.

               sumexp18 = 0;
               sumsig18 = 0;

            end

            state18 = 2'b00;

         end

     endcase

endmodule
