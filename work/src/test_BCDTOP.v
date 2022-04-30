module test_BCDTOP;
reg     [3:0]   X, Y;
wire    [3:0]   S;
wire    CARRY, dummy;
parameter STEP = 50;

BCDTOP inst_BCDTOP (X, Y, S, CARRY, dummy) ;

initial begin
        X = 4'h0; Y = 4'h0;
#STEP   X = 4'h3; Y = 4'h5;
#STEP   X = 4'h4; Y = 4'h6;
#STEP   X = 4'h9; Y = 4'h9;
#STEP   X = 4'h7; Y = 4'h6;
#STEP   X = 4'h1; Y = 4'h8;
#STEP   $finish;
end
initial $monitor( "%t %d %d %d %b", $stime, X, Y, S, CARRY);
endmodule