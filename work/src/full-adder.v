module fulladder (A, B , CIN, SUM, COUT);
input    A, B, CIN;
output    SUM, COUT;
wire    c1, c2, s1;
halfadder HA1 ( A, B, s1, c1);
halfadder HA2 ( s1, CIN, SUM, c2);
assign COUT = c1 | c2;

endmodule