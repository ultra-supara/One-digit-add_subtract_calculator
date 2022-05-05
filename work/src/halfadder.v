module halfadder( A, B, Y, CO );
input     A, B;
output    Y, CO;
assign Y = A ^ B;
assign CO = A & B;
endmodule
