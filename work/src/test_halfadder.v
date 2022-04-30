module test_halfadder;
reg     a, b;
wire     sum, carry;

halfadder insthalfadder( a, b, sum, carry);

initial begin
    a = 0; b = 0;
#50    a = 1; b = 0;
#50    a = 0; b = 1;
#50    a = 1; b = 1;
#50    $finish;
end

initial begin
    $monitor ("%t %b %b %b %b" , $time, a, b, sum, carry);
end
endmodule