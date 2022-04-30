module test_ripple4adder;
reg[3:0]    a, b;
wire[3:0]   sum;
wire        carry;

ripple4adder instripple4adder(a, b, sum, carry);
initial
    begin
    a=4'h2; b=4'h3;
#50 a=4'h4; b=4'h7;
#50 a=4'h5; b=4'ha;
#50 a=4'h6; b=4'he;
#50 a=4'hd; b=4'h9;
#50 $finish;
end

initial begin   $monitor("%t %d %d %d %b", $time, a, b, sum, carry);
end
endmodule