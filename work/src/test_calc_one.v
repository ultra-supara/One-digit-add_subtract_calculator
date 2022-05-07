module test_calc_one;
reg         CLK;
reg         RST_X;
reg[13:0]   PSW;
wire[7:0]    SEG_1_OUT;
wire[3:0]    SEG_SEL_1;
wire[7:0]    SEG_2_OUT;
wire[3:0]    SEG_SEL_2;

calc_one_top inst_calc_one_top(CLK, RST_X, PSW, SEG_1_OUT, SEG_SEL_1, SEG_2_OUT, SEG_SEL_2);

always#5    CLK = ~CLK;
initial
begin
    RST_X <= 0;
    CLK <= 1;
    PSW <= 14'b11_1111_1111_1111;
#50 RST_X <= 1;

#50     PSW     <=      14'b11_1111_1111_1101;
#100    PSW     <=      14'b01_1111_1111_1111;
#100    PSW     <=      14'b11_1111_1111_1011;
#100    PSW     <=      14'b11_1011_1111_1111;

#500    PSW     <=      14'b11_1111_1101_1111;
#100    PSW     <=      14'b01_1111_1111_1111;
#100    PSW     <=      14'b11_1101_1111_1111;
#100    PSW     <=      14'b11_1011_1111_1111;

#500    PSW     <=      14'b11_1101_1111_1111;
#100    PSW     <=      14'b01_1111_1111_1111;
#100    PSW     <=      14'b11_1110_1111_1111;
#100    PSW     <=      14'b11_1011_1111_1111;

#500    PSW     <=      14'b11_1111_1011_1111;
#100    PSW     <=      14'b10_1111_1111_1111;
#100    PSW     <=      14'b11_1111_1011_1111;
#100    PSW     <=      14'b11_1011_1111_1111;

#500 $finish;

end
endmodule
