module carrydetect (k1, k2, k3, k4, k5, detect);
input   k1, k2, k3, k4, k5;
output  detect;
wire    an1, an2;
assign an1 = k1 & k2;
assign an2 = k3 & k4;
assign detect = (an1 || an2) || k5;

endmodule