//==================================================================================================
//  Filename      : sram_control.v
//  Created On    : 2013-04-04 19:32:32
//  Last Modified : 2013-04-05 18:10:17
//  Revision      : 
//  Author        : Tian Changsong
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns/1ps	
module sram_control(/*autoport*/
//inout
			data_sram,
//output
			address_to_sram,
			adv,
			write_en_n,
			chip_en,
			output_en,
			byte_en,
			output_test_sram,
			jpeg_start,
			data_to_jpeg,
//input
			clk_100,
			rst,
			cam_data,
			cam_pclk,
			cam_href,
			cam_vsyn,
			configure_over,
			address_from_dwt);
	input clk_100;
	input rst;
	input [7:0]cam_data;
	inout [31:0]data_sram;
	input cam_pclk;
	input cam_href;
	input cam_vsyn;
	input configure_over;
	input [17:0]address_from_dwt;

	output [17:0]address_to_sram;
	output adv;
	output write_en_n;
	output chip_en;
	output output_en;
	output [3:0]byte_en;
	output output_test_sram;
	output jpeg_start;
	output [31:0]data_to_jpeg;


	parameter IDLE=0,
	WRITE_WAITING=1,
	WRITTING_1=2,
	WRITTING_2=12,
	JPEG_START=4,
	JPEG_WORKING=5;


	/**** reg ****/
	reg write_en_n;
	reg frame_valid;
	reg [7:0]cam_data_reg;//for test
	reg data_ready_write;
	reg [9:0]row_counter;
	reg cam_href_reg1;
	reg cam_href_reg2;
	reg cam_vsyn_reg1;
	reg cam_vsyn_reg2;
	reg [31:0]cam_data_buffer;
	reg [1:0]cam_data_counter;
	reg [3:0]state;
	reg [3:0]nextstate;
	reg [17:0]address;
	reg [31:0]data_to_write;
	reg [27:0]time_counter;
	reg [31:0]data_reg;
	reg pclk_reg1;
	reg pclk_reg2;
	reg jpeg_working;

	/* wire */
	wire jpeg_start;
	wire output_test_sram;
	wire encoding_free;
	wire adv=0;
	wire output_en;
	wire chip_en;
	wire [31:0]data_sram;
	wire [3:0]byte_en;
	wire row_full;
	wire address_to_sram;
	wire [31:0]data_to_jpeg;
	/* wire assign */
	assign jpeg_start = state==JPEG_START;
	assign address_to_sram = jpeg_working?address_from_dwt:address;
	assign encoding_free=(state==IDLE||state==WRITTING_1||state==WRITTING_2||state==WRITE_WAITING);
	assign row_full=row_counter==640;
	assign output_test_sram=&data_reg&&(&cam_data_reg);
	assign data_sram=write_en_n?32'bz:data_to_write;
	assign data_to_jpeg = jpeg_working?data_sram:0;

	//assign write_en_n=!(state==WRITTING);
	assign chip_en=0;
	assign output_en=0;
	assign byte_en=4'b0000;


	/** reg assign **/
	always @(posedge clk_100 or negedge rst)
	begin
		if (!rst) 
		begin
			// reset
			jpeg_working<=0;
		end
		else if (nextstate==JPEG_WORKING) 
		begin
			jpeg_working<=1;
		end
		else 
		begin
			jpeg_working<=0;
		end
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			frame_valid<=0;
		else if(!encoding_free)
			frame_valid<=0;
		else if(encoding_free&&configure_over&&(cam_vsyn_reg1&&!cam_vsyn_reg2))
			frame_valid<=1;
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			cam_data_reg<=0;
		else cam_data_reg<=cam_data;
	end
	

	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			row_counter<=0;
		else if((cam_vsyn_reg1&&!cam_vsyn_reg2)||row_full)
			row_counter<=0;
		else if(!cam_href_reg1&&cam_href_reg2&&frame_valid)
			row_counter<=row_counter+1;
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			data_ready_write<=0;
		else if(cam_data_counter==3&&(pclk_reg1&&!pclk_reg2)&&cam_href&&frame_valid)
			data_ready_write<=1;
		else data_ready_write<=0;
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
		begin
			cam_href_reg1<=0;
			cam_href_reg2<=0;
			cam_vsyn_reg1<=0;
			cam_vsyn_reg2<=0;
		end 
		else
		begin
			cam_href_reg1<=cam_href;
			cam_href_reg2<=cam_href_reg1;
			cam_vsyn_reg1<=cam_vsyn;
			cam_vsyn_reg2<=cam_vsyn_reg1;
		end 
	end
	
	always@(negedge clk_100 or negedge rst)
	begin
		if(!rst)
			data_to_write<=0;
		else if(data_ready_write)
			data_to_write<=cam_data_buffer;
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			cam_data_counter<=0;
		else if(pclk_reg1&&!pclk_reg2&&cam_href&&frame_valid)
			cam_data_counter<=cam_data_counter+1;
	end
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			cam_data_buffer<=0;
		else if(pclk_reg1&&!pclk_reg2&&cam_href&&frame_valid)
			case(cam_data_counter)
				0:cam_data_buffer[31:24]<=cam_data;
				1:cam_data_buffer[23:16]<=cam_data;
				2:cam_data_buffer[15:8]<=cam_data;
				3:cam_data_buffer[7:0]<=cam_data;
			endcase
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
		begin
			pclk_reg1<=0;
			pclk_reg2<=0;
		end 
		else 
		begin
			pclk_reg1<=cam_pclk;
			pclk_reg2<=pclk_reg1;
		end 
	end
	always@(*)
	begin
	    case(state)
			WRITTING_1,WRITTING_2:write_en_n=0;
			default:write_en_n=1;
	    endcase
	end
	
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			data_reg<=0;
		else data_reg<=data_sram;
	end
	
	always@(posedge clk_100 or negedge rst)
	begin
		if(!rst)
			time_counter<=0;
		else time_counter<=time_counter+1;
	end
	
	always@(negedge clk_100 or negedge rst)
	begin
		if(!rst)
			address<=0;
		else if(cam_vsyn||row_full)
			address<=0;
		else 
		begin
			case(state)
				WRITTING_2:
					address<=address+1;
			endcase
		end 
	end
	


	/** fsm **/
	always@(negedge clk_100 or negedge rst)
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
				if(frame_valid)
					nextstate=WRITE_WAITING;
				else nextstate=IDLE;
			end 
			WRITE_WAITING:
			begin
				if(row_full)
					nextstate=JPEG_START;
				else if(data_ready_write)
					nextstate=WRITTING_1;
				else nextstate=WRITE_WAITING;
			end 
			WRITTING_1:nextstate=WRITTING_2;
			WRITTING_2:
			begin
				if(data_ready_write)
					nextstate=WRITTING_1;
				else nextstate=WRITE_WAITING;
			end 
			JPEG_START:
			begin
				nextstate=JPEG_WORKING;
			end
			JPEG_WORKING:nextstate=JPEG_WORKING;

			default:nextstate=IDLE;
	    endcase
	end
	

endmodule
