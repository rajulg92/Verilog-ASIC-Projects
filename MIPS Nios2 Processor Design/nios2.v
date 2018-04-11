module nios2(instruction18, clk18);
  input clk18;
  input [31:0] instruction18;
  reg [31:0] out_dp18;
  reg [31:0] pc18,ir18,ALUout18,target18,pc18_inc,memory18,pc_wb18;
  reg [4:0] source_a18,source_b18,destination_18;
  reg [5:0] opcode18;
  reg [31:0] r0_18 ,r1_18,r4_18,r5_18,four18,one18,pc_loop18;
  reg [31:0] N_18;
  reg[31:0] r2_18[0:31],r6_18;
  reg[31:0] r3_18[0:31],r7_18;
  reg[31:0] r8_18;
  reg rtype18;
  reg jtype18;
  reg itype18;
  reg [7:0] r2_addr18,r3_addr18,r6_addr18,r7_addr18,r8_addr18;
  initial begin
    pc18 = 0;
    pc18_inc = 4;
    pc_loop18 = 8;// loop at pc=12 
    four18 = 4;
    one18 = 1;
    ir18 = 0;
    out_dp18 = 0;
    rtype18 = 0;
    jtype18 = 0;
    itype18 = 0;
    r0_18 = 0;
    r2_18[0] = 5;
    r2_18[4] = 3;
    r2_18[8] = -6;
    r2_18[12] = 19;
    r2_18[16] = 8;
    r2_18[20] = 12;
    r3_18[0] = 2;
    r3_18[4] = 14;
    r3_18[8] = -3;
    r3_18[12] = 2;
    r3_18[16] = -5;
    r3_18[20] = 36;
    N_18 = 6;  //no. of iterations
    r2_addr18 = 0;
    r3_addr18 = 0;
    r6_addr18 = 0;
    r7_addr18 = 0;
    r8_addr18 = 0;
    r4_18 = 1;
  end
  always @(instruction18) begin
    //fetch nf(instruction18, pc18, ir18,clk18);
    //decode nd(source_a18,source_b18,ir18,opcode18,clk18); 
    /**************** Fetch Stage*********************/ 
    ir18 = instruction18;
    pc18 = pc18 + pc18_inc;
    pc_wb18 = pc18;
    /*****************Decode Stage*********************/
    // checking the Op-code and identifying the instruction as i-type,
    // r-type and j-type 
    opcode18 = ir18[5:0];
    if (opcode18 == 6'b111010) begin
       rtype18 = 1;
       source_a18 = ir18[31:27];
       source_b18 = ir18[26:22];
       destination_18 = ir18[21:17];
     end else begin
       itype18 = 1;
       source_a18 = ir18[31:27];
       source_b18 = ir18[26:22];
       destination_18 = ir18[31:27];
     end
     /*********************Execute Stage********************/
    case(pc18)
      4: begin
        ALUout18 = N_18;         // Executing ldw r4,0(r4)
         end
      8: begin
          ALUout18 = r0_18 + r0_18;// Executing add r5,r0,r0
         end
      12: begin
           ALUout18 = r2_18[r2_addr18];// Executing ldw r6,0(r2)
          end
      16: begin
           ALUout18 = r3_18[r3_addr18];// Executing ldw r7,0(r3)
          end
      20: begin
           ALUout18 = r6_18 * r7_18;// Executing mul r8,r6,r7
           //r6_addr18 = r6_addr18 + four18;
           //r7_addr18 = r7_addr18 + four18;
          end
      24: begin
           ALUout18 = r5_18 + r8_18;// Executing add r5,r5,r8
           //r8_addr18 = r8_addr18 + four18;
          end
      28: begin
           ALUout18 = r2_addr18 + four18;// Executing addi r2,r2,4
          end
      32: begin
           ALUout18 = r3_addr18 + four18;// Executing addi r3,r3,4
          end
      36: begin
           ALUout18 = r4_18 - one18;// Executing subi r4,r4,1
          end
      40: begin
           ALUout18 = r4_18 - r0_18;
          end        
      44: begin
          if (ir18[15] == 1) begin// Executing stw r5,DOT_PRODUCT(r0)
            ALUout18 = r5_18 + {16'hFFFF,ir18[15:0]};
          end else begin
            ALUout18 = r5_18 + {16'h0000,ir18[15:0]};
          end
        end
      default: ;//do nothing
    endcase
    /*********************Memory Stage***********************/
    //Catagorising according to instruction type(R-type,Load,Store,Branch on equal,etc)
    if (opcode18 == 6'b010111) begin //load instructions
      memory18 = ALUout18;
    end
    else if (opcode18 == 6'b111010) begin //R-type instructions
      memory18 = ALUout18;
    end
    else if (opcode18 == 6'b010101) begin//store instructions
      memory18 = ALUout18;
    end
    else begin//I-type instructions
      memory18 = ALUout18;
    end
    /*********************WriteBack Stage********************/
    case(pc_wb18)
      4: begin
          r4_18 = memory18;         // WriteBack ldw r4,0(r4)
         end
      8: begin
          r5_18 = memory18;         // WriteBack add r5,r0,r0
         end
      12: begin
           r6_18 = memory18;// WriteBack ldw r6,0(r2)
           //r6_addr18 = r6_addr18 + four18;
        end
      16: begin
           r7_18 = memory18;// WriteBack ldw r7,0(r3)
           //r7_addr18 = r7_addr18 + four18;
          end
      20: begin
           r8_18 = memory18;// WriteBack mul r8,r6,r7
           //r8_addr18 = r8_addr18 + four18;
          end
      24: begin
           r5_18 = memory18;// WriteBack add r5,r5,r8
          end
      28: begin
           r2_addr18 = memory18;// WriteBack addi r2,r2,4
          end
      32: begin
           r3_addr18 = memory18;// WriteBack addi r3,r3,4
          end
      36: begin
           r4_18 = memory18;// WriteBack subi r4,r4,1
          end
      40: begin
           if (ALUout18 != 0) begin    // WriteBack bgt r4,r0,loop(pc18 = 12)
             pc18 = pc_loop18;
           end else begin
             pc18 = pc18;
           end
          end         
      44: begin
            r5_18 = memory18;
          end
      default: ;//do nothing
    endcase
  end
endmodule

