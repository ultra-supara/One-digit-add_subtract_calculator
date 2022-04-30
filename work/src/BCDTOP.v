module BCDTOP(X, Y, S, CARRY, dummy);
input   [3:0]   X, Y;
output  [3:0]   S;
output  CARRY, dummy;
wire    f0, f1, f2, f3, c3, cry;

ripple4adder    instripple4adder(X, Y, {f3, f2, f1, f0}, c3);
carrydetect     instcarrydetect(f1, f3, f2, f3, c3, cry);
hosei6          insthosei6(f1, f2, f3, cry, S[3:1], dummy);
assign  S[0] = f0;
assign  CARRY = cry;

endmodule