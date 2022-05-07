module sub ( A_DATA, B_DATA, SUB_DATA );
input [3:0] A_DATA; //被減数4bit
input [3:0] B_DATA; //減数4bit
output [5:0] SUB_DATA; //計算結果6bit
wire c0, c1, c2, c3, c4, c5;
wire d0, d1, d2, d3, d4, d5;
wire [5:0] binv;
wire [5:0] bm;
//2の補数生成
assign binv = ~B_DATA; //ビット反転
halfadder HA_0( .A(binv[0]), .B(1'b1), .Y(bm[0]), .CO(c0) );
halfadder HA_1( .A(binv[1]), .B(c0), .Y(bm[1]), .CO(c1) );
halfadder HA_2( .A(binv[2]), .B(c1), .Y(bm[2]), .CO(c2) );
halfadder HA_3( .A(binv[3]), .B(c2), .Y(bm[3]), .CO(c3) );
halfadder HA_4( .A(1'b1), .B(c3), .Y(bm[4]), .CO(c4) );
halfadder HA_5( .A(1'b1), .B(c4), .Y(bm[5]), .CO(c5) );
//加算回路
halfadder HA0( .A(bm[0]), .B(A_DATA[0]), .Y(SUB_DATA[0]), .CO(d0) );
fulladder FA0( .A(bm[1]), .B(A_DATA[1]), .SUM(SUB_DATA[1]), .CIN(d0), .COUT(d1) );
fulladder FA1( .A(bm[2]), .B(A_DATA[2]), .SUM(SUB_DATA[2]), .CIN(d1), .COUT(d2) );

endmodule
