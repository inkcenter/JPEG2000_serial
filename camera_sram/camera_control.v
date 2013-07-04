//==================================================================================================
//  Filename      : camera_control.v
//  Created On    : 2013-04-04 19:32:51
//  Last Modified : 2013-06-22 17:03:43
//  Revision      : re
//  Author        : Tian Changsong
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns/1ps	
module camera_control(/*autoport*/
//inout
			sda,
//output
			scl,
			output_test_camera,
			configure_over,
//input
			clk_25,
			rst,
			cam_href,
			cam_pclk,
			cam_vsyn,
			start_button);
input clk_25;
input rst;
input cam_href;
input cam_pclk;
input cam_vsyn;
input start_button;
inout sda;
output scl;
//output [12:0]col_counter;
output output_test_camera;
output configure_over;

parameter IDLE            =0,
CONFIGURE_REGISTERS_BEGIN =1,
READ_ID                   =2,
CONFIGURE_REGISTERS_OVER  =3,
READ_DATA_BEGIN           =4,
READ_DATA                 =5,
READ_DATA_OVER            =6,
CONFIGURE_REGISTERS=7;
// COM7                   =2,
// VSTART                 =7,
// VSTOP                  =8,
// VREF                   =11,
// HSTART                 =9,
// HSTOP                  =10,
// HREF                      =12,

parameter SCCB_IDLE =0,
SCCB_START          =1,
DEVICE_ADDRESS      =2,
SUB_ADDRESS         =3,
WRITE_DATA          =4,
READING             =6,
READ_OVER           =7,
SCCB_END            =5;



/* reg */
reg [7:0]register_counter;
reg configure_over;
reg read_over;
reg read_phase2;
reg sda_response;
reg scl;
reg sda_reg;
reg sccb_valid;
reg [6:0]time_counter;
reg [12:0]col_counter;
reg [7:0]state;
reg [7:0]nextstate;
reg [2:0]state_sccb;
reg [2:0]nextstate_sccb;
reg [4:0]sccb_counter;
reg start_reg;
reg [7:0]sub_address;
reg [7:0]register;
reg sccb_end_reg1;
reg [2:0]state_identifier;
reg [7:0]device_address;
/* wire */
wire sccb_end;
wire sda;
wire clk_sccb;
wire sda_input_en;
wire output_test_camera;
/* wire internal */
assign output_test_camera=sda_response&&(&col_counter)&&(&state_identifier)&&cam_vsyn;
assign sccb_end=(state_sccb==SCCB_END);
assign sda=sda_input_en?1'bz:sda_reg;
assign clk_sccb=time_counter[6];
assign sda_input_en=sccb_counter==16||sccb_counter==17||(state_sccb==READING);
//assign sda_response=(sccb_counter==16||sccb_counter==17)?sda:1'b0;
/* reg internal */
always @(posedge clk_25 or negedge rst)
begin
	if (!rst) 
	begin
		register_counter<=0;
	end
	else  if(!sccb_end&&sccb_end_reg1)
	begin
		register_counter<=register_counter+1;
	end
end
always@(posedge clk_sccb or negedge rst)
begin
	if(!rst)
		read_over<=0;
	else if(state_sccb==READING&&sccb_counter==15)
		read_over<=1;
end

always@(*)
begin
    if(read_phase2)
		device_address=8'h61;
	else device_address=8'h60;
end
always@(posedge clk_sccb or negedge rst)
begin
	if(!rst)
		read_phase2<=0;
	else if(state_sccb==SCCB_END&&sccb_counter==1&&read_over)
		read_phase2<=0;
	else if(state==READ_ID&&state_sccb==SUB_ADDRESS)
		read_phase2<=1;
end

always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		state_identifier<=0;
	else 
	begin
		case(state)
			READ_ID:
			begin
				case(state_sccb)
					DEVICE_ADDRESS:
					begin
						if(read_phase2)
							state_identifier<=3;
						else state_identifier<=1;
					end 
					SUB_ADDRESS:state_identifier<=2;
					READING:state_identifier<=4;
				endcase
			end 
			CONFIGURE_REGISTERS:
			begin
				case(state_sccb)
					DEVICE_ADDRESS:state_identifier<=5;
					SUB_ADDRESS:state_identifier<=6;
					WRITE_DATA:state_identifier<=7;
				endcase
			end 
		endcase
	end 
end

always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		sda_response<=0;
	else sda_response<=sda;
end


always@(posedge cam_pclk or negedge rst)
begin
	if(!rst)
		col_counter<=0;
	else if(!cam_href)
		col_counter<=0;
	else 
		col_counter<=col_counter+1;
end


always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		sccb_end_reg1<=0;
	else sccb_end_reg1<=sccb_end;
end

always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		time_counter<=0;
	else time_counter<=time_counter+1;
end

always@(*)
begin
    case(state)
		CONFIGURE_REGISTERS,READ_ID:sccb_valid=1;
		default:sccb_valid=0;
	endcase
end
always@(posedge clk_sccb or negedge rst)
begin
	if(!rst)
		sccb_counter<=0;
	else
	begin
		case(state_sccb)
			SCCB_START:
			begin
				if(sccb_counter==1)
					sccb_counter<=0;
				else sccb_counter<=sccb_counter+1;
			end 
			DEVICE_ADDRESS,SUB_ADDRESS,WRITE_DATA,READING:
			begin
				if(sccb_counter==17)
					sccb_counter<=0;
				else sccb_counter<=sccb_counter+1;
			end 
			SCCB_END:
			begin
				if(sccb_counter==1)
					sccb_counter<=0;
				else sccb_counter<=sccb_counter+1;
			end 
		endcase
	end 
end

always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		sub_address<=0;
	else
	begin
		case(state)
			// READ_ID:sub_address<=8'h0b;
			READ_ID:sub_address <=8'h18;
			CONFIGURE_REGISTERS:
			begin
				case(register_counter)
					0  :sub_address<=8'h12;
					1  :sub_address<=8'h11;
					2  :sub_address<=8'h6a;
					3  :sub_address<=8'h3b;
					4  :sub_address<=8'h13;
					5  :sub_address<=8'h01;
					6  :sub_address<=8'h02;
					7  :sub_address<=8'h00;
					8  :sub_address<=8'h10;
					9  :sub_address<=8'h13;
					10 :sub_address<=8'h39;
					11 :sub_address<=8'h38;
					12 :sub_address<=8'h37;
					13 :sub_address<=8'h35;
					14 :sub_address<=8'h0e;
					15 :sub_address<=8'h1e;
					16 :sub_address<=8'hA8;
					17 :sub_address<=8'h14;
					18 :sub_address<=8'h04;
					19 :sub_address<=8'h0c;
					20 :sub_address<=8'h0d;
					21 :sub_address<=8'h18;
					22 :sub_address<=8'h17;
					23 :sub_address<=8'h32;
					24 :sub_address<=8'h03;
					25 :sub_address<=8'h1a;
					26 :sub_address<=8'h19;
					27 :sub_address<=8'h3f;
					28 :sub_address<=8'h14;
					29 :sub_address<=8'h15;
					30 :sub_address<=8'h41;
					31 :sub_address<=8'h42;
					32 :sub_address<=8'h1b;
					33 :sub_address<=8'h16;
					34 :sub_address<=8'h33;
					35 :sub_address<=8'h34;
					36 :sub_address<=8'h96;
					37 :sub_address<=8'h3a;
					38 :sub_address<=8'h8e;
					39 :sub_address<=8'h3c;
					40 :sub_address<=8'h8B;
					41 :sub_address<=8'h94;
					42 :sub_address<=8'h95;
					43 :sub_address<=8'h40;
					44 :sub_address<=8'h29;
					45 :sub_address<=8'h0f;
					46 :sub_address<=8'h3d;
					47 :sub_address<=8'h69;
					48 :sub_address<=8'h5C;
					49 :sub_address<=8'h5D;
					50 :sub_address<=8'h5E;
					51 :sub_address<=8'h59;
					52 :sub_address<=8'h5A;
					53 :sub_address<=8'h5B;
					54 :sub_address<=8'h43;
					55 :sub_address<=8'h44;
					56 :sub_address<=8'h45;
					57 :sub_address<=8'h46;
					58 :sub_address<=8'h47;
					59 :sub_address<=8'h48;
					60 :sub_address<=8'h5F;
					61 :sub_address<=8'h60;
					62 :sub_address<=8'h61;
					63 :sub_address<=8'ha5;
					64 :sub_address<=8'ha4;
					65 :sub_address<=8'h8d;
					66 :sub_address<=8'h13;
					67 :sub_address<=8'h4f;
					68 :sub_address<=8'h50;
					69 :sub_address<=8'h51;
					70 :sub_address<=8'h52;
					71 :sub_address<=8'h53;
					72 :sub_address<=8'h54;
					73 :sub_address<=8'h55;
					74 :sub_address<=8'h56;
					75 :sub_address<=8'h57;
					76 :sub_address<=8'h58;
					77 :sub_address<=8'h8C;
					78 :sub_address<=8'h3E;
					79 :sub_address<=8'ha9;
					80 :sub_address<=8'haa;
					81 :sub_address<=8'hab;
					82 :sub_address<=8'h8f;
					83 :sub_address<=8'h90;
					84 :sub_address<=8'h91;
					85 :sub_address<=8'h9f;
					86 :sub_address<=8'ha0;
					87 :sub_address<=8'h3A;
					88 :sub_address<=8'h24;
					89 :sub_address<=8'h25;
					90 :sub_address<=8'h26;
					91 :sub_address<=8'h2a;
					92 :sub_address<=8'h2b;
					93 :sub_address<=8'h6c;
					94 :sub_address<=8'h6d;
					95 :sub_address<=8'h6e;
					96 :sub_address<=8'h6f;
					97 :sub_address<=8'h70;
					98 :sub_address<=8'h71;
					99 :sub_address<=8'h72;
					100:sub_address<=8'h73;
					101:sub_address<=8'h74;
					102:sub_address<=8'h75;
					103:sub_address<=8'h76;
					104:sub_address<=8'h77;
					105:sub_address<=8'h78;
					106:sub_address<=8'h79;
					107:sub_address<=8'h7a;
					108:sub_address<=8'h7b;
					109:sub_address<=8'h7c;
					110:sub_address<=8'h7d;
					111:sub_address<=8'h7e;
					112:sub_address<=8'h7f;
					113:sub_address<=8'h80;
					114:sub_address<=8'h81;
					115:sub_address<=8'h82;
					116:sub_address<=8'h83;
					117:sub_address<=8'h84;
					118:sub_address<=8'h85;
					119:sub_address<=8'h86;
					120:sub_address<=8'h87;
					121:sub_address<=8'h88;
					122:sub_address<=8'h89;
					123:sub_address<=8'h8a;
				endcase
			end
			// COM7:sub_address    <=8'h12;
			// VSTART:sub_address  <=8'h19;
			// VSTOP:sub_address   <=8'h1a;
			// VREF:sub_address    <=8'h03;
			// HSTART:sub_address  <=8'h17;
			// HSTOP:sub_address   <=8'h18;
			// HREF:sub_address    <=8'h32;
		endcase
	end 
end
always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		register<=0;
	else
	begin
		case(register_counter)
			0  :register<=8'h40;//COM7
			1  :register<=8'h81;//ori:81
			2  :register<=8'h3e;
			3  :register<=8'h09;
			4  :register<=8'he0;
			5  :register<=8'h80;
			6  :register<=8'h80;
			7  :register<=8'h00;
			8  :register<=8'h00;
			9  :register<=8'he5;
			10 :register<=8'h43;//ori:43
			11 :register<=8'h12;//ori:12
			12 :register<=8'h91;//ori:91
			13 :register<=8'h91;
			14 :register<=8'h20;//COM5
			15 :register<=8'h04;
			16 :register<=8'h80;
			17 :register<=8'h40;
			18 :register<=8'h00;
			19 :register<=8'h04;//ori:04
			20 :register<=8'h80;//ori:80
			21 :register<=8'hc6;//HSTOP,59
			22 :register<=8'h26;//HSTART,09
			23 :register<=8'h00;//HREF,00
			24 :register<=8'h00;
			25 :register<=8'h3d;//VSTOP,59
			26 :register<=8'h01;//VSTRT,09
			27 :register<=8'ha6;
			28 :register<=8'h2e;
			29 :register<=8'h10;
			30 :register<=8'h02;
			31 :register<=8'h08;
			32 :register<=8'h00;
			33 :register<=8'h06;
			34 :register<=8'he2;
			35 :register<=8'hbf;
			36 :register<=8'h04;
			37 :register<=8'h00;//uyvy
			38 :register<=8'h00;
			39 :register<=8'h77;
			40 :register<=8'h06;
			41 :register<=8'h88;
			42 :register<=8'h88;
			43 :register<=8'hc1;
			44 :register<=8'h3f;
			45 :register<=8'h42;
			46 :register<=8'h92;
			47 :register<=8'h40;
			48 :register<=8'hb9;
			49 :register<=8'h96;
			50 :register<=8'h10;
			51 :register<=8'hc0;
			52 :register<=8'haf;
			53 :register<=8'h55;
			54 :register<=8'hf0;
			55 :register<=8'h10;
			56 :register<=8'h68;
			57 :register<=8'h96;
			58 :register<=8'h60;
			59 :register<=8'h80;
			60 :register<=8'he0;
			61 :register<=8'h8c;
			62 :register<=8'h20;
			63 :register<=8'hd9;
			64 :register<=8'h74;
			65 :register<=8'h02;
			66 :register<=8'he7;
			67 :register<=8'h3a;
			68 :register<=8'h3d;
			69 :register<=8'h03;
			70 :register<=8'h12;
			71 :register<=8'h26;
			72 :register<=8'h38;
			73 :register<=8'h40;
			74 :register<=8'h40;
			75 :register<=8'h40;
			76 :register<=8'h0d;
			77 :register<=8'h23;
			78 :register<=8'h02;
			79 :register<=8'hb8;
			80 :register<=8'h92;
			81 :register<=8'h0a;
			82 :register<=8'hdf;
			83 :register<=8'h00;
			84 :register<=8'h00;
			85 :register<=8'h00;
			86 :register<=8'h00;
			87 :register<=8'h01;
			88 :register<=8'h70;
			89 :register<=8'h64;
			90 :register<=8'hc3;
			91 :register<=8'h00;
			92 :register<=8'h00;
			93 :register<=8'h40;
			94 :register<=8'h30;
			95 :register<=8'h4b;
			96 :register<=8'h60;
			97 :register<=8'h70;
			98 :register<=8'h70;
			99 :register<=8'h70;
			100:register<=8'h70;
			101:register<=8'h60;
			102:register<=8'h60;
			103:register<=8'h50;
			104:register<=8'h48;
			105:register<=8'h3a;
			106:register<=8'h2e;
			107:register<=8'h28;
			108:register<=8'h22;
			109:register<=8'h04;
			110:register<=8'h07;
			111:register<=8'h10;
			112:register<=8'h28;
			113:register<=8'h36;
			114:register<=8'h44;
			115:register<=8'h52;
			116:register<=8'h60;
			117:register<=8'h6c;
			118:register<=8'h78;
			119:register<=8'h8c;
			120:register<=8'h9e;
			121:register<=8'hbb;
			122:register<=8'hd2;
			123:register<=8'he6;
		endcase
	end 
end

always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		start_reg<=0;
	else start_reg<=start_button;
end
/* reg output */
always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		configure_over<=0;
	else if(state==CONFIGURE_REGISTERS_OVER)
		configure_over<=1;
end

always@(negedge clk_sccb or negedge rst)
begin
	if(!rst)
		scl<=1;
	else 
	begin
		case(state_sccb)
			SCCB_START:
			begin
				if(sccb_counter==0)
					scl<=1;
				else scl<=~scl;
			end 
			SCCB_END:
			begin
				if(sccb_counter==1)
					scl<=1;
				else scl<=~scl;
			end 
			DEVICE_ADDRESS,SUB_ADDRESS,WRITE_DATA,READING:
				scl<=~scl;
			default:scl<=1;
		endcase
	end 
end
always@(*)
begin
	case(state_sccb)
		SCCB_START:sda_reg=~sccb_counter[0];
		DEVICE_ADDRESS:
		begin
			case(sccb_counter[4:1])
				0:sda_reg=device_address[7];
				1:sda_reg=device_address[6];
				2:sda_reg=device_address[5];
				3:sda_reg=device_address[4];
				4:sda_reg=device_address[3];
				5:sda_reg=device_address[2];
				6:sda_reg=device_address[1];
				7:sda_reg=device_address[0];
				default:sda_reg=1'b1;
			endcase
		end 
		SUB_ADDRESS:
		begin
			case(sccb_counter[4:1])
				0:sda_reg=sub_address[7];
				1:sda_reg=sub_address[6];
				2:sda_reg=sub_address[5];
				3:sda_reg=sub_address[4];
				4:sda_reg=sub_address[3];
				5:sda_reg=sub_address[2];
				6:sda_reg=sub_address[1];
				7:sda_reg=sub_address[0];
				default:sda_reg=1'b1;
			endcase
		end 
		WRITE_DATA:
		begin
			case(sccb_counter[4:1])
				0:sda_reg=register[7];
				1:sda_reg=register[6];
				2:sda_reg=register[5];
				3:sda_reg=register[4];
				4:sda_reg=register[3];
				5:sda_reg=register[2];
				6:sda_reg=register[1];
				7:sda_reg=register[0];
				default:sda_reg=1'b1;
			endcase
		end 
		SCCB_END:sda_reg=sccb_counter[0];
		default:sda_reg=1'b1;
	endcase
end 
		


/* fsm */
always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		state<=IDLE;
	else state<=nextstate;
end

always@(*)
begin
    case(state)
		IDLE:
		begin
			if(start_button&&(!start_reg))
				nextstate=CONFIGURE_REGISTERS_BEGIN;
			else nextstate=IDLE;
		end 
		CONFIGURE_REGISTERS_BEGIN:
		begin
			nextstate=CONFIGURE_REGISTERS;
		end 
		CONFIGURE_REGISTERS:
		begin
			if (register_counter==123&&!sccb_end&&sccb_end_reg1) 
			begin
				nextstate=READ_ID;
			end
			else 
			begin
				nextstate=CONFIGURE_REGISTERS;
			end
		end
		READ_ID:
		begin
			if(!sccb_end&&sccb_end_reg1&&read_over)
				nextstate=CONFIGURE_REGISTERS_OVER;
			else nextstate=READ_ID;
		end 
		CONFIGURE_REGISTERS_OVER:
		begin
			nextstate=IDLE;
		end 
		default:nextstate=IDLE;
    endcase
end

/* fsm */
always@(posedge clk_sccb or negedge rst)
begin
	if(!rst)
		state_sccb<=SCCB_IDLE;
	else state_sccb<=nextstate_sccb;
end
always@(*)
begin
    case(state_sccb)
		SCCB_IDLE:
		begin
			if(sccb_valid)
				nextstate_sccb=SCCB_START;
			else nextstate_sccb=SCCB_IDLE;
		end 
		SCCB_START:
		begin
			if(sccb_counter==1)
				nextstate_sccb=DEVICE_ADDRESS;
			else nextstate_sccb=SCCB_START;
		end 
		DEVICE_ADDRESS:
		begin
			if(sccb_counter==17)
			begin
				if(read_phase2)
					nextstate_sccb=READING;
				else
					nextstate_sccb=SUB_ADDRESS;
			end 
			else nextstate_sccb=DEVICE_ADDRESS;
		end 
		READING:
		begin
			if(sccb_counter==17)
				nextstate_sccb=SCCB_END;
			else nextstate_sccb=READING;
		end 
		SUB_ADDRESS:
		begin
			if(sccb_counter==17)
			begin
				if(state==READ_ID)
					nextstate_sccb=SCCB_END;
				else
					nextstate_sccb=WRITE_DATA;
			end 
			else nextstate_sccb=SUB_ADDRESS;
		end 
		WRITE_DATA:
		begin
			if(sccb_counter==17)
				nextstate_sccb=SCCB_END;
			else nextstate_sccb=WRITE_DATA;
		end 
		SCCB_END:
		begin
			if(sccb_counter==1)
			begin
				if(state==READ_ID&&!read_over)
					nextstate_sccb=SCCB_START;
				else
					nextstate_sccb=SCCB_IDLE;
			end 
			else nextstate_sccb=SCCB_END;
		end 
		default:nextstate_sccb=SCCB_IDLE;
    endcase
end
endmodule
