module calc_one_top(CLK, RST_X, PSW, SEG_1_OUT, SEG_SEL_1, SEG_2_OUT, SEG_SEL_2);
input       CLK;
input       RST_X;
input[13:0] PSW;
output[7:0] SEG_1_OUT;
output[3:0] SEG_SEL_1;
output[7:0] SEG_2_OUT;
output[3:0] SEG_SEL_2;

wire[3:0]   A_DATA;
wire[3:0]   B_DATA;
wire[5:0]   SUM_DATA;
wire[5:0]   SUB_DATA;

controller controller_ins( .CLK(CLK), .RST_X(RST_X), .PSW(PSW), .SUM_DATA(SUM_DATA),
                            .SUB_DATA(SUB_DATA), .A_DATA(A_DATA), .B_DATA(B_DATA),
                            .SEG_1_OUT(SEG_1_OUT), .SEG_SEL_1(SEG_SEL_1),
                            .SEG_2_OUT(SEG_2_OUT), .SEG_SEL_2(SEG_SEL_2) );

sub SUB(A_DATA, B_DATA, SUB_DATA);
add ADD(A_DATA, B_DATA, SUM_DATA);

endmodule
