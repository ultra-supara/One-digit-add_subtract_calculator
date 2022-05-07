module add (A_DATA, B_DATA, SUB_SEL, SUM_DATA);
input[5:0]  A_DATA, B_DATA;
input       SUB_SEL;
output[5:0] SUM_DATA;
wire        C0, C1, C2, C3, C4, C5;

fulladder FA0(A_DATA[0], B_DATA[0], SUB_SEL, SUM_DATA[0], C0);
fulladder FA1(A_DATA[1], B_DATA[1], C0, SUM_DATA[1], C1);
fulladder FA2(A_DATA[2], B_DATA[2], C1, SUM_DATA[2], C2);
fulladder FA3(A_DATA[3], B_DATA[3], C2, SUM_DATA[3], C3);
fulladder FA4(A_DATA[4], B_DATA[4], C3, SUM_DATA[4], C4);
fulladder FA5(A_DATA[5], B_DATA[5], C4, SUM_DATA[5], C5);

endmodule
