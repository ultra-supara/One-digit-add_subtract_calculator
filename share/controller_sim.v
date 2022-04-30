/*--------------------------------------------------*/
/*                                                  */
/*                   Main Controller                */
/*                                                  */
/*                   File Name : controller         */
/*                   Date      : 2005.12            */
/*                   Version   : 1.0                */
/*                                                  */
/*--------------------------------------------------*/
module 	controller(
			CLK,
			RST_X,
			PSW,
			SUM_DATA,
			SUB_DATA,
			A_DATA,
			B_DATA,

/* for 500RX
			SEG_C_OUT,
			SEG_E_OUT,
			SEG_G_OUT,
			SEG_H_OUT
*/

//for 500RX
			SEG_1_OUT,	//A,B,C,D
			SEG_SEL_1,	//
			SEG_2_OUT,	//E,F,G,H
			SEG_SEL_2	//

				);




/*======  INPUT, OUTPUT  ======*/
input				CLK;
input				RST_X;
input	[13:0]	PSW;
input	[5:0]			SUM_DATA;
input	[5:0]			SUB_DATA;
output	[3:0]			A_DATA;
output	[3:0]			B_DATA;


//MMS for 500RX
//output	[7:0]			SEG_C_OUT;	/*LED a*/
//output	[7:0]			SEG_E_OUT;	/*LED b*/
//output	[7:0]			SEG_G_OUT;	/*10 digit*/
//output	[7:0]			SEG_H_OUT;	/* 1 digit*/

//for 500RX
output	[7:0] SEG_1_OUT;
output	[3:0] SEG_SEL_1;
output	[7:0] SEG_2_OUT;
output	[3:0] SEG_SEL_2;


/*======  REG, WIRE  ======*/
wire		seg_a_ena, seg_b_ena, seg_result_ena;
wire				data_a_ena;
wire				data_b_ena;
wire	[5:0]			mux_out;
wire				mux_sel;
wire				chata_ena;
wire				chata_sel;
wire	[3:0]	devide_out_1;
wire	[3:0]	devide_out_2;
wire	[13:0]	syn_psw;
wire	[3:0]	dec_data;

//MMS for 500RX
wire	[7:0]			SEG_C_OUT;	/*LED a*/
wire	[7:0]			SEG_E_OUT;	/*LED b*/
wire	[7:0]			SEG_G_OUT;	/*10 digit*/
wire	[7:0]			SEG_H_OUT;	/* 1 digit*/

/*======  INSTANCE  ======*/
syncro		syncro(.CLK(CLK),
			.RST_X(RST_X),
			.PSW(PSW),
			.SYN_PSW(syn_psw)
					);
					
decord		decord(.SYN_PSW(syn_psw[9:0]),
			.DEC_ENA(chata_ena),
			.DEC_DATA(dec_data)
					);
					
register	register_a(.CLK(CLK),
				.RST_X(RST_X),
				.INPUT_ENA(data_a_ena),
				.REG_IN(dec_data),
				.REG_OUT(A_DATA)
					);
						
register	register_b(.CLK(CLK),
				.RST_X(RST_X),
				.INPUT_ENA(data_b_ena),
				.REG_IN(dec_data),
				.REG_OUT(B_DATA)
					);
						
devide		devide_bcd(.CLK(CLK),
				.RST_X(RST_X),
				.DATA_IN(mux_out),
				.DATA_OUT_1(devide_out_1),
				.DATA_OUT_2(devide_out_2)
					);
					
seg_convert	segment_c(.SEG_IN(A_DATA),
				.SEG_ENA(seg_a_ena),
				.SEG_OUT(SEG_C_OUT)
					);
							
seg_convert	segment_e(.SEG_IN(B_DATA),
				.SEG_ENA(seg_b_ena),
				.SEG_OUT(SEG_E_OUT)
					);
							
seg_convert_2	segment_g(.SEG_IN(devide_out_1),
				.SEG_ENA(seg_result_ena),
				.SEG_OUT(SEG_G_OUT)
					);
							
seg_convert	segment_h(.SEG_IN(devide_out_2),
				.SEG_ENA(seg_result_ena),
				.SEG_OUT(SEG_H_OUT)
					);
							
controller_2	controller_2(.CLK(CLK),
				.RST_X(RST_X),
				.CHATA_ENA(chata_ena),
				.SUM_SIG(syn_psw[13]),
				.SUB_SIG(syn_psw[12]),
				.CLEAR_SIG(syn_psw[11]),
				.EQUAL_SIG(syn_psw[10]),
				.CHATA_SEL(chata_sel),
				.SEG_A_ENA(seg_a_ena),
				.SEG_B_ENA(seg_b_ena),
				.SEG_RESULT_ENA(seg_result_ena),
				.MUX_SEL(mux_sel)
						);

//for 500RX
dynamic_display	dynamic_display_A(
		//input
			.CLK(CLK),
			.RST_X(RST_X),
			.SEG_0(8'b0000_0000),	//A
			.SEG_1(8'b0000_0000),	//B
			.SEG_2(SEG_C_OUT),		//C
			.SEG_3(8'b0000_0000),	//D
		//output
			.SEG_OUT(SEG_1_OUT),
			.SEG_SEL(SEG_SEL_1)
			);

//for 500RX
dynamic_display	dynamic_display_B(
		//input
			.CLK(CLK),
			.RST_X(RST_X),
			.SEG_0(SEG_E_OUT),		//E
			.SEG_1(8'b0000_0000),	//F
			.SEG_2(SEG_G_OUT),		//G
			.SEG_3(SEG_H_OUT),		//H
		//output
			.SEG_OUT(SEG_2_OUT),
			.SEG_SEL(SEG_SEL_2)
			);




/*======  LOGIC  ======*/	
assign mux_out  = (mux_sel == 1) ? SUB_DATA : SUM_DATA;	/*MUX*/

//assign data_a_ena = (chata_sel == 0) ? chata_ena : 0;	/*Selector*/
//assign data_b_ena = (chata_sel == 1) ? chata_ena : 0;

//for 500RX Quartus2_V10.1
assign data_a_ena = (chata_sel == 1'b0) ? chata_ena : 1'b0;	/*Selector*/
assign data_b_ena = (chata_sel == 1'b1) ? chata_ena : 1'b0;

/*
always@(chata_sel)begin	
	if(chata_sel == 0)begin
		data_a_ena <= chata_ena;
		data_b_ena <= 0;
		end

	else if(chata_sel == 1)begin
		data_a_ena <= 0;
		data_b_ena <= chata_ena;
		end

	else begin
		data_a_ena <= 0;
		data_b_ena <= 0;
		end
end
*/

endmodule	



/*-----------------------------------------------------*/
/*                                                     */
/*                   Key Synchronizing                 */
/*                                                     */
/*                   File Name : syncro                */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/

module syncro	(
			CLK,
			RST_X,
			PSW,
			SYN_PSW
				);




/*======  INPUT, OUTPUT  ======*/
input			CLK;		/*Clock*/
input			RST_X;		/*Reset*/
input	 [13:0]	PSW;		/*PSW data*/
output	 [13:0]	SYN_PSW;	/*PSW synchronized data*/


/*======  REG, WIRE  ======*/
reg	[13:0] q0,q1,q2;


/*======  LOGIC  ======*/	
always@(posedge CLK or negedge RST_X)begin
	if(!RST_X) begin
		q0 <= 0;
		q1 <= 0;
		q2 <= 0;
			end 
	else begin
		q0 <= ~PSW;
		q1 <= q0;
		q2 <= q1;
			end
end

assign SYN_PSW =q1&(~q2);

endmodule


/*-----------------------------------------------------*/
/*                                                     */
/*                   Key Decode                        */
/*                                                     */
/*                   File Name : decord                */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/

module decord	(
			SYN_PSW,
			DEC_ENA,
			DEC_DATA
				);



/*======  INPUT, OUTPUT  ======*/
input	[9:0]	SYN_PSW;	
output			DEC_ENA;	
output	[3:0]		DEC_DATA;	


/*======  LOGIC  ======*/
assign	DEC_DATA = change_data(SYN_PSW[9:0]);
assign	DEC_ENA  = |SYN_PSW;


/*======  FUNCTION  ======*/
function [3:0] change_data;

input [9:0] in;

	if(in[9])begin
		change_data = 4'b1001;
		end

	else if(in[8])begin
		change_data = 4'b1000;
		end

	else if(in[7])begin
		change_data = 4'b0111;
		end

	else if(in[6])begin
		change_data = 4'b0110;
		end

	else if(in[5])begin
		change_data = 4'b0101;
		end

	else if(in[4])begin
		change_data = 4'b0100;
		end

	else if(in[3])begin
		change_data = 4'b0011;
		end

	else if(in[2])begin
		change_data = 4'b0010;
		end

	else if(in[1])begin
		change_data = 4'b0001;
		end

	else if(in[0])begin
		change_data = 4'b0000;
		end

    	else begin
		change_data = 4'b1111;
		end
endfunction


endmodule

/*-----------------------------------------------------*/
/*                                                     */
/*                   Register                          */
/*                                                     */
/*                   File Name : register              */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/

module register(
			CLK,
			RST_X,
			INPUT_ENA,
			REG_IN,
			REG_OUT
				);



/*======  INPUT, OUTPUT  ======*/
input				CLK;		/*Clock*/
input				RST_X;		/*Reset*/
input				INPUT_ENA;	/*Enable*/
input	[3:0]	REG_IN;		/*Input data*/
output	[3:0]	REG_OUT;	/*Output data*/


/*======  REG, WIRE  ======*/
reg	[3:0]	REG_OUT;


/*======  LOGIC  ======*/	
always @(posedge CLK or negedge RST_X) begin	
	if (!RST_X) begin
		REG_OUT <= 0;
		end

	else begin
		if(INPUT_ENA == 1'b1)
			REG_OUT <= REG_IN;
		else 
			REG_OUT <= REG_OUT;
		end
	end	


endmodule	



/*-----------------------------------------------------*/
/*                                                     */
/*                   Result Deviding                   */
/*                                                     */
/*                   File Name : devide                */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/
module devide(CLK,
		RST_X,
		DATA_IN,
		DATA_OUT_1,
		DATA_OUT_2
			);
				
				


/*======  INPUT, OUTPUT  ======*/

input		CLK;
input		RST_X;
input		[5:0]	DATA_IN;
output		[3:0]	DATA_OUT_1;
output		[3:0]	DATA_OUT_2;

wire	[5:0]	DATA_IN;
reg [3:0]	DATA_OUT_1;
reg [3:0]	DATA_OUT_2;

/*======  Internal signals  ======*/
wire	an1, an2, cry ;
wire	inv0, inv1, inv2, inv3 ;
wire	c0, c1, c2, c3, d0, d1, d2 ;
wire	m0, m1, m2, m3, p0, p1, p2, p3 ;
wire[7:0]	DATA_BUF ;

/*======  LOGIC  ======*/

assign	an1= DATA_IN[1] & DATA_IN[3] ;
assign	an2= DATA_IN[2] & DATA_IN[3] ;
assign	cry= an1 | an2 | DATA_IN[4] ;
assign	inv0=~DATA_IN[0] ;
assign	inv1=~DATA_IN[1] ;
assign	inv2=~DATA_IN[2] ;
assign	inv3=~DATA_IN[3] ;
assign	p0=DATA_IN[0] ;
//
halfadder HA0(.A(inv0), .B(DATA_IN[5]), .Y(m0), .CO(c0));
halfadder HA1(.A(inv1), .B(c0), .Y(m1), .CO(c1));
halfadder HA2(.A(inv2), .B(c1), .Y(m2), .CO(c2));
halfadder HA3(.A(inv3), .B(c2), .Y(m3), .CO(c3));
//
halfadder HA4(.A(cry), .B(DATA_IN[1]), .Y(p1), .CO(d0));
fulladder FA0(.A(cry), .B(DATA_IN[2]), .CIN(d0),.SUM(p2), .COUT(d1));
halfadder HA5(.A(DATA_IN[3]), .B(d1), .Y(p3), .CO(d2));



	assign	DATA_BUF[7] = DATA_IN[5];
	assign	DATA_BUF[6] = DATA_IN[5];
 	assign	DATA_BUF[5] = DATA_IN[5];
	
 	assign	DATA_BUF[4] =  (DATA_IN[5] == 1) ?  DATA_IN[5] : cry ;
	assign	DATA_BUF[3] =  (DATA_IN[5] == 1) ?  m3 :  p3;
 	assign	DATA_BUF[2] =  (DATA_IN[5] == 1) ?  m2 :  p2;
 	assign	DATA_BUF[1] =  (DATA_IN[5] == 1) ?  m1 :  p1;
 	assign	DATA_BUF[0] =  (DATA_IN[5] == 1) ?  m0 :  p0;



	
always@(posedge CLK or negedge RST_X)
begin
	if(!RST_X)begin
			DATA_OUT_1 <= 4'b0000;
			DATA_OUT_2 <= 4'b0000;
			end

	else begin
			DATA_OUT_1[3] <= DATA_BUF[7];
			DATA_OUT_1[2] <= DATA_BUF[6];
			DATA_OUT_1[1] <= DATA_BUF[5];
			DATA_OUT_1[0] <= DATA_BUF[4];
//
			DATA_OUT_2[3] <= DATA_BUF[3];
			DATA_OUT_2[2] <= DATA_BUF[2];
			DATA_OUT_2[1] <= DATA_BUF[1];
			DATA_OUT_2[0] <= DATA_BUF[0];
			end
end
endmodule	



/*-----------------------------------------------------*/
/*                                                     */
/*                   7 Segment Display                 */
/*                                                     */
/*                   File Name : seg_convert           */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/
module seg_convert(
			SEG_IN,
			SEG_ENA,
			SEG_OUT
				);


/*======  PARAMETER  ======*/
parameter	P_SEG_OUT_0 = 8'b1111_1100;
parameter	P_SEG_OUT_1 = 8'b0110_0000;
parameter	P_SEG_OUT_2 = 8'b1101_1010;
parameter	P_SEG_OUT_3 = 8'b1111_0010;
parameter	P_SEG_OUT_4 = 8'b0110_0110;
parameter	P_SEG_OUT_5 = 8'b1011_0110;
parameter	P_SEG_OUT_6 = 8'b1011_1110;
parameter	P_SEG_OUT_7 = 8'b1110_0000;
parameter	P_SEG_OUT_8 = 8'b1111_1110;
parameter	P_SEG_OUT_9 = 8'b1111_0110;
parameter	P_SEG_OUT_E = 8'b1001_1111;
parameter	P_SEG_OUT_M = 8'b0000_0010;
parameter	P_SEG_NON   = 8'b0000_0000;


/*======  INPUT, OUTPUT  ======*/
input	[3:0]	SEG_IN;		/*In Data*/
input		SEG_ENA;	/*enable*/
output	[7:0]	SEG_OUT;	/*segment decode*/


/*======  LOGIC  ======*/
assign	SEG_OUT = convert({SEG_ENA,SEG_IN});


/*======  FUNCTION  ======*/
function [7:0] convert;
input [4:0] in;

	casex (in)
		5'b0_xxxx : convert = P_SEG_NON;
		5'b1_0000 : convert = P_SEG_OUT_0;
		5'b1_0001 : convert = P_SEG_OUT_1;
		5'b1_0010 : convert = P_SEG_OUT_2;
		5'b1_0011 : convert = P_SEG_OUT_3;
		5'b1_0100 : convert = P_SEG_OUT_4;
		5'b1_0101 : convert = P_SEG_OUT_5;
		5'b1_0110 : convert = P_SEG_OUT_6;
		5'b1_0111 : convert = P_SEG_OUT_7;
		5'b1_1000 : convert = P_SEG_OUT_8;
		5'b1_1001 : convert = P_SEG_OUT_9;
		5'b1_1111 : convert = P_SEG_OUT_M;
		default   : convert = P_SEG_OUT_E;
	endcase
endfunction


endmodule	



/*---- ------------------------------------------------*/
/*                                                     */
/*                   7 Segment Display_2               */
/*                                                     */
/*                   File Name : seg_convert_2         */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/
module seg_convert_2(
			SEG_IN,
			SEG_ENA,
			SEG_OUT
				);


/*======  PARAMETER  ======*/
parameter	P_SEG_OUT_0 = 8'b1111_1100;
parameter	P_SEG_OUT_1 = 8'b0110_0000;
parameter	P_SEG_OUT_2 = 8'b1101_1010;
parameter	P_SEG_OUT_3 = 8'b1111_0010;
parameter	P_SEG_OUT_4 = 8'b0110_0110;
parameter	P_SEG_OUT_5 = 8'b1011_0110;
parameter	P_SEG_OUT_6 = 8'b1011_1110;
parameter	P_SEG_OUT_7 = 8'b1110_0000;
parameter	P_SEG_OUT_8 = 8'b1111_1110;
parameter	P_SEG_OUT_9 = 8'b1111_0110;
parameter	P_SEG_OUT_E = 8'b1001_1111;
parameter	P_SEG_OUT_M = 8'b0000_0010;
parameter	P_SEG_NON   = 8'b0000_0000;


/*======  INPUT, OUTPUT  ======*/
input	[3:0]	SEG_IN;		/*In data*/
input		SEG_ENA;	/*enable*/
output	[7:0]	SEG_OUT;	/*segment decode*/


/*======  LOGIC  ======*/
assign	SEG_OUT = convert({SEG_ENA,SEG_IN});


/*======  FUNCTION  ======*/
function [7:0] convert;
input [4:0] in;

	casex (in)
		5'b0_xxxx : convert = P_SEG_NON;
		5'b1_0000 : convert = P_SEG_NON;
		5'b1_0001 : convert = P_SEG_OUT_1;
		5'b1_0010 : convert = P_SEG_OUT_2;
		5'b1_0011 : convert = P_SEG_OUT_3;
		5'b1_0100 : convert = P_SEG_OUT_4;
		5'b1_0101 : convert = P_SEG_OUT_5;
		5'b1_0110 : convert = P_SEG_OUT_6;
		5'b1_0111 : convert = P_SEG_OUT_7;
		5'b1_1000 : convert = P_SEG_OUT_8;
		5'b1_1001 : convert = P_SEG_OUT_9;
		5'b1_1111 : convert = P_SEG_OUT_M;
		default   : convert = P_SEG_OUT_E;
	endcase
endfunction


endmodule	



/*-----------------------------------------------------*/
/*                                                     */
/*                     Controller                      */
/*                                                     */
/*                   File Name : controller_2          */
/*                   Date      : 2005.12               */
/*                   Version   : 1.0                   */
/*                                                     */
/*-----------------------------------------------------*/
module controller_2(	CLK,
			RST_X,
			CHATA_ENA,
			SUM_SIG,
			SUB_SIG,
			CLEAR_SIG,
			EQUAL_SIG,
			CHATA_SEL,
			SEG_A_ENA,
			SEG_B_ENA,
			SEG_RESULT_ENA,
			MUX_SEL
				);
				
/*======  PARAMETER  ======*/		
parameter	P_IDLE 		=	0;
parameter	P_STEP_1	=	1;
parameter	P_SUM_1		=	2;
parameter	P_SUM_2		=	3;
parameter	P_SUB_1		=	4;
parameter	P_SUB_2		=	5;
parameter	P_SUM_FINISH	=	6;
parameter	P_SUB_FINISH	=	7;

/*======  INPUT, OUTPUT  ======*/		
input   	CLK;				
input		RST_X;				
input		CHATA_ENA;		/*enable from decord*/
input		SUM_SIG;		/*PSW add signal*/
input		SUB_SIG;		/*PSW sub signal*/
input		CLEAR_SIG;		/*PSW clear signal*/
input		EQUAL_SIG;		/*PSW = signal*/

output		CHATA_SEL;		/*decord enable selector*/
output		SEG_A_ENA;		/*A_Data LED enable*/
output		SEG_B_ENA;		/*B_Data LED enable*/
output		SEG_RESULT_ENA;		/*Result LED enable*/
output		MUX_SEL;		/*MUX selector*/


/*======  REG, WIRE  ======*/
reg	[2:0]	state;
reg		SEG_A_ENA;
reg		SEG_B_ENA;
reg		SEG_RESULT_ENA;
reg		MUX_SEL;
reg		CHATA_SEL;
wire		CHATA_ENA;


/*======  LOGIC  ======*/	
always @(posedge CLK or negedge RST_X) begin	
	if (!RST_X) begin
		state		<=	P_IDLE;
		CHATA_SEL	<=	0;
		SEG_A_ENA	<=	0;
		SEG_B_ENA	<=	0;
		SEG_RESULT_ENA	<=	0;
		MUX_SEL		<= 	0;
			end

	else begin
	case(state)
		P_IDLE : begin
			if(CHATA_ENA == 1)begin
				state		<=	P_STEP_1;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			end

		P_STEP_1 : begin
			if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(SUM_SIG == 1)begin
				state		<=	P_SUM_1;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(SUB_SIG == 1)begin
				state		<=	P_SUB_1;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	1;
					end

			else begin
				state		<=	P_STEP_1;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end
			end

		P_SUM_1	: begin
			if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(CHATA_ENA == 1)begin
				state		<=	P_SUM_2;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else begin
				state		<=	P_SUM_1;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			end

		P_SUM_2	: begin
			if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(EQUAL_SIG == 1)begin
				state		<=	P_SUM_FINISH;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	1;
				MUX_SEL		<= 	0;
					end

			else begin
				state		<=	P_SUM_2;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			end

		P_SUB_1	: begin
			if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(CHATA_ENA == 1)begin
				state		<=	P_SUB_2;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else begin
				state		<=	P_SUB_1;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			end

		P_SUB_2	: begin
			if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

			else if(EQUAL_SIG == 1)begin
				state		<=	P_SUB_FINISH;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	1;
				MUX_SEL		<= 	1;
					end

			else begin
				state		<=	P_SUB_2;
				CHATA_SEL	<=	1;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	1;
					end

			end

		P_SUM_FINISH : begin
				if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

				else if(CHATA_ENA == 1)begin
				state		<=	P_STEP_1;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

				else begin
				state		<=	P_SUM_FINISH;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	1;
				MUX_SEL		<= 	0;
					end
			end

		P_SUB_FINISH : begin
				if(CLEAR_SIG == 1)begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

				else if(CHATA_ENA == 1)begin
				state		<=	P_STEP_1;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
					end

				else begin
				state		<=	P_SUB_FINISH;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	1;
				SEG_B_ENA	<=	1;
				SEG_RESULT_ENA	<=	1;
				MUX_SEL		<= 	1;
					end
			end

		default	: begin
				state		<=	P_IDLE;
				CHATA_SEL	<=	0;
				SEG_A_ENA	<=	0;
				SEG_B_ENA	<=	0;
				SEG_RESULT_ENA	<=	0;
				MUX_SEL		<= 	0;
				end
	endcase
	end
end	


endmodule
//
//
/*-----------------------------------------------------*/
/*                                                     */
/*                   7SEG dynamic Dispaly              */
/*                                                     */
/*                   File Name : dynamic_display.v     */
/*                   Date      : 2014.11               */
/*                   Version   : 1.0                   */
/*                   (MMS)                             */
/*-----------------------------------------------------*/
module	dynamic_display(
		// input
		CLK,
		RST_X,
		SEG_0,
		SEG_1,
		SEG_2,
		SEG_3,

		// output
		SEG_OUT,
		SEG_SEL
	);


//parameter DEF_COUNT   = 28'h3000;

// for 500RX  Model-Sim USE
parameter DEF_COUNT   = 28'h2;

// ------ input --------------------------------------------
input	CLK;					// System Clock
input	RST_X;				// System Reset
input	[7:0] SEG_0,SEG_1,SEG_2,SEG_3;	// 7SEG Value

// ------ output -------------------------------------------
output	[7:0] SEG_OUT;				// 7SEG Display
output	[3:0] SEG_SEL;				//


//--- reg ----------------------------------------------------------------------
reg	[7:0] SEG_OUT;
reg	[27:0] SEC_COUNT;
reg	[3:0]  GATE;
reg	SEC_SIG;

// ------ wire ----------------------------------------------
wire	[3:0] SEG_SEL;

	always@( posedge CLK or negedge RST_X) begin
		if( !RST_X )begin
			SEC_COUNT <= 28'd0;
		end
		else if( SEC_COUNT >= DEF_COUNT - 28'd1)begin
			SEC_COUNT <= 28'd0;
		end
 		else begin
			SEC_COUNT <= SEC_COUNT + 28'd1;
		end
	end

	always@( posedge CLK or negedge RST_X) begin
		if( !RST_X )begin
			SEC_SIG <= 1'b0;
		end
		else if( SEC_COUNT >= DEF_COUNT - 28'd1 )begin
			SEC_SIG <= 1'b1;
		end
		else begin
			SEC_SIG <= 1'b0;
		end
	end

	always@( posedge CLK or negedge RST_X) begin
		if( !RST_X )begin
			GATE <= 4'b0001;
		end
		else if( SEC_SIG == 1'b1 )begin
			GATE[0] <= GATE[3];
			GATE[1] <= GATE[0];
			GATE[2] <= GATE[1];
			GATE[3] <= GATE[2];
		end
		else begin
			GATE <= GATE;
		end
	end

	always@( posedge CLK or negedge RST_X ) begin
		if( !RST_X )begin
			SEG_OUT <= 8'd0;
		end
		else begin
			case( GATE )
				4'd1: begin
					SEG_OUT <= SEG_0;
				end
				4'd2: begin
					SEG_OUT <= SEG_1;
				end
				4'd4: begin
					SEG_OUT <= SEG_2;
				end
				4'd8: begin
					SEG_OUT <= SEG_3;
				end
				default: begin
					SEG_OUT <= 8'd0;
				end
			endcase
		end
	end

assign	SEG_SEL = ~GATE;

endmodule

