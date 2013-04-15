//==================================================================================================
//  Filename      : camera_control.v
//  Created On    : 2013-04-04 19:32:51
//  Last Modified : 2013-04-06 16:28:00
//  Revision      : 
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
READ_ID                   =13,
COM7                      =2,
VSTART                    =7,
VSTOP                     =8,
VREF                      =11,
HSTART                    =9,
HSTOP                     =10,
HREF                      =12,
CONFIGURE_REGISTERS_OVER  =3,
READ_DATA_BEGIN           =4,
READ_DATA                 =5,
READ_DATA_OVER            =6;

parameter SCCB_IDLE =0,
SCCB_START          =1,
DEVICE_ADDRESS      =2,
SUB_ADDRESS         =3,
WRITE_DATA          =4,
READING             =6,
READ_OVER           =7,
SCCB_END            =5;



/* reg */
reg configure_over;
reg read_over;
reg read_phase2;
reg sda_response;
reg scl;
reg sda_reg;
reg sccb_valid;
reg [6:0]time_counter;
reg [12:0]col_counter;
reg [4:0]state;
reg [4:0]nextstate;
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
			COM7:
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
		READ_ID,COM7, VSTART, VSTOP, VREF, HSTART, HSTOP, HREF:sccb_valid=1;
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
			//READ_ID:sub_address<=8'h0b;
			READ_ID:sub_address <=8'h3a;
			COM7:sub_address    <=8'h12;
			VSTART:sub_address  <=8'h19;
			VSTOP:sub_address   <=8'h1a;
			VREF:sub_address    <=8'h03;
			HSTART:sub_address  <=8'h17;
			HSTOP:sub_address   <=8'h18;
			HREF:sub_address    <=8'h32;
		endcase
	end 
end
always@(posedge clk_25 or negedge rst)
begin
	if(!rst)
		register<=0;
	else
	begin
		case(state)
			//COM7:register<=8'h40;//yuv
			COM7:register   <=8'h00;//yuv
			VSTART:register <=8'h09;//row start
			VSTOP:register  <=8'h59;//row stop
			VREF:register   <=8'h00;//[5:3]:row stop low bits,[2:0]:row start low bits 
			HSTART:register <=8'h09;//col start
			HSTOP:register  <=8'h59;//col stop
			HREF:register   <=8'h00;//[5:3]col stop low bits,[2:0]col start low bits
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
			nextstate=COM7;
		end 
		READ_ID:
		begin
			if(!sccb_end&&sccb_end_reg1&&read_over)
				nextstate=CONFIGURE_REGISTERS_OVER;
			else nextstate=READ_ID;
		end 
		COM7:
		begin 
			if(!sccb_end&&sccb_end_reg1)
				nextstate=VSTART;
			else nextstate=COM7;
		end 
		VSTART:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=VSTOP;
			else nextstate=VSTART;
		end 
		VSTOP:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=VREF;
			else nextstate=VSTOP;
		end 
		VREF:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=HSTART;
			else nextstate=VREF;
		end 
		HSTART:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=HSTOP;
			else nextstate=HSTART;
		end 
		HSTOP:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=HREF;
			else nextstate=HSTOP;
		end 
		HREF:
		begin
			if(!sccb_end&&sccb_end_reg1)
				nextstate=READ_ID;
			else nextstate=HREF;
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
