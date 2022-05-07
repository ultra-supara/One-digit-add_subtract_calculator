module test_addandsub;
reg         sub_sel;
reg[5:0]    a, b;
wire[5:0]   SUM;

addandsub instaddandsub(a, b, sub_sel, SUM );

initial
begin
        sub_sel=1'b0; a=6'h2; b=6'h3;
#100    sub_sel=1'b0; a=6'h4; b=6'h7;
#100    sub_sel=1'b0; a=6'h5; b=6'ha;
#100    sub_sel=1'b0; a=6'h6; b=6'he;
#100    sub_sel=1'b0; a=6'hd; b=6'h9;
#100    sub_sel=1'b1; a=6'h6; b=6'h3;
#100    sub_sel=1'b1; a=6'h4; b=6'h7;
#100    sub_sel=1'b1; a=6'ha; b=6'h5;
#100    sub_sel=1'b1; a=6'h6; b=6'hf;
#100    sub_sel=1'b1; a=6'hd; b=6'h9;
#100    sub_sel=1'b1; a=6'h0; b=6'he;
#100    $finish;

end

initial begin   $monitor("%t %d %d %d %b", $time, a, b, sub_sel, SUM);
end

endmodule
