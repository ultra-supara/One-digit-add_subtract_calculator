module ripple4adder (A, B, SUM, CRY3);
input[3:0]  A, B;
output[3:0] SUM;
output      CRY3;
wire        CRY0, CRY1, CRY2;

halfadder HA0(A[0], B[0], SUM[0], CRY0);
fulladder FA1(A[1], B[1], CRY0, SUM[1], CRY1);
fulladder FA2(A[2], B[2], CRY1, SUM[2], CRY2);
fulladder FA3(A[3], B[3], CRY2, SUM[3], CRY3);

endmodule