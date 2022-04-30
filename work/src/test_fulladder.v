module test_fulladder;
wire sum, carry;
reg a, b, cin;

fulladder instfulladder( a, b, cin , sum, carry);
initial
    begin
    a = 0; b = 0; cin = 0;
#50    a = 0; b = 1; cin = 0;
#50    a = 1; b = 0; cin = 0;
#50    a = 1; b = 1; cin = 0;
#50    a = 0; b = 0; cin = 1;
#50    a = 0; b = 1; cin = 1;
#50    a = 1; b = 0; cin = 1;
#50    a = 1; b = 1; cin = 1;
#50    $finish;
end

initial begin
    $monitor ("%t %b %b %b %b %b" , $time, a, b, cin, sum , carry);
end
endmodule