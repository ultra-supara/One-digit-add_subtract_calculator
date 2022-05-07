module addandsub(A, B, SUB_SEL, SUM);
input [5:0] A, B;
input       SUB_SEL;
output[5:0] SUM;
wire  [5:0] bm;

check b1( B[0], SUB_SEL, bm[0]);
check b2( B[1], SUB_SEL, bm[1]);
check b3( B[2], SUB_SEL, bm[2]);
check b4( B[3], SUB_SEL, bm[3]);
check b5( B[4], SUB_SEL, bm[4]);
check b6( B[5], SUB_SEL, bm[5]);

add instadd(A, bm, SUB_SEL, SUM);

endmodule;
