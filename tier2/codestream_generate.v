`timescale 1ns/1ns
module codestream_generate(/*autoarg*/
    //input
    clk, rst, codeblock_shift_over, codestream_generate_start, 
    data_from_ram, target_slope, target_byte_number, 

    //output
    codestream_generate_over, codeblock_counter, 
    lram_read_en, lram_address_rd, output_to_fpga_32, 
    output_address, write_en, rst_syn
);

parameter WORD_WIDTH=18,
			ADDR_WIDTH=14;

	input clk;
	input rst;
	input codeblock_shift_over;
	input codestream_generate_start;
	input [WORD_WIDTH-1:0]data_from_ram;
	input [8:0]target_slope;
	input [19:0]target_byte_number;

	output codestream_generate_over;
	output [7:0]codeblock_counter;
	output lram_read_en;
	output [ADDR_WIDTH-1:0]lram_address_rd;
	output [31:0]output_to_fpga_32;
	//output [31:0]codestream_output_32;
	output [31:0]output_address;
	output [3:0]write_en;
	output rst_syn;

	parameter IDLE=0,
		GENERATE_FILE_HEADER=1,
		SOT=2,
		LSOT=3,
		ISOT=4,
		PSOT_1=5,
		PSOT_2=6,
		TPSOT=7,
		TNSOT=8,
		SOD=9,
		SOP=10,	
		LSOP=11,
		PACKET_INDEX=12,
		TAGTREE_CODE_BEGIN=13,
		TAGTREE_CODING=14,
		SHIFT_CODEBLOCK_INFO=15,
		EPH=16,
		PACKET_DATA_READ_BEGIN=17,
		PACKET_DATA_READING=18,
		ONE_PACKET_OVER=19,
		EMPTY_PACKET=20,
		ALL_PACKET_OVER=21,
		NEXT_PACKET=22,
		EOC=23,
		CODESTREAM_GENERATE_OVER=24,
		SHIFT_LAST_BYTE=25,
		ONE_TILE_OVER=26,
		NEXT_TILE=27,
		OUTPUT_TOTAL_BYTE_NUMBER=28,
		WAIT_SHIFT_OVER=29;

	parameter ONE_BYTE=0,
			TWO_BYTE=1,
			THREE_BYTE=2;

	parameter IDLE_TAGTREE=0,
			GET_CODEBLOCK_ADDRESS=1,
			READ_PASS_FIRST_HEADER=2,
			READ_PASS_SECOND_HEADER=3,
			COMPARE_SLOPE=4,
			CODEBLOCK_INCLUDED=5,
			PASS_NOT_INCLUDED_ONCE=7,
			NEXT_PASS=8,
			PASS_NOT_INCLUDED_TWICE=9,
			CODEBLOCK_NOT_INCLUDED=10,
			INCLUSION_TAGTREE_OVER=11,
			ZERO_PLANE_TAGTREE_BEGIN=12,
			TAGTREE_CODING_OVER=16,
			SHIFT_INCLUSION_TAGTREE_BEGIN=17,
			SHIFT_ZERO_PLANE_TAGTREE_BEGIN=18,
			SHIFT_BASE_NODE_ZERO_PLANE=21,
			READ_PASS_LENGTH_BEGIN=22,
			PASS_INCLUDED=23,
			PASS_ALL_SCANED=24,
			SHIFT_PACKET_EMPTY_FLAG=25,
			ONE_SUBBAND_OVER=26,
			SHIFT_PASS_NUMBER=27,
			SHIFT_PASS_LENGTH=28,
			ONE_PASS_OVER=29,
			ONE_CODEBLOCK_OVER=30,
			SHIFT_BIT_ADDED=31,
			SHIFT_BASE_NODE_INCLUSION=34,
			SHIFT_PADDING_BIT=35,
			ALL_SUBBAND_OVER=36,
			READ_PASS_DATA=37,
			READ_FORMER_PASS_DATA=38,
			FIND_NEXT_CODEBLOCK_ADDRESS_BEGIN=39,
			FIND_NEXT_CODEBLOCK_ADDRESS_OVER=40;
			




	/************* reg *****************/
	reg find_next_codeblock;
	reg [ADDR_WIDTH-1:0]next_codeblock_address;
	reg next_codeblock_already_found;
	reg [ADDR_WIDTH-1:0]packet_first_codeblock_address;
	reg [31:0]output_to_fpga_32;
	reg one_tile_over_reg_1;
	reg one_tile_over_reg_2;
	reg one_tile_over_reg_3;
	reg one_tile_over_reg_4;
	reg one_tile_over_reg_5;
	reg [15:0]tile_counter;
	reg shift_last_word;
	reg [3:0]write_en;
	reg [31:0]output_address;
	reg [1:0]output_count;
	reg [31:0]codestream_output_32;
	reg bit_rate_met;
	reg [1:0]word_last_flag_former_pass;
	reg read_former_pass_reg;
	reg [7:0]pass_word_number_temp;//stores the former pass word number
	reg [ADDR_WIDTH-1:0]pass_address_temp;//stores the former pass address
	reg [3:0]pass_length_bit_temp;// in case of counting in the not included pass bit length
	reg total_byte_count_en;
	reg [20:0]total_byte_counter;// the total tile-part byte number from SOT(including the SOT marker) to the last byte of codestream
	reg [1:0]subband_counter;
	reg [4:0]pass_counter_2;
	reg [8:0]pass_number_code;
	reg [3:0]pass_bit_counter;
	reg [8:0]pass_byte_number_limit;
	reg [3:0]pass_length_bit;
	reg output_valid_reg_1;
	reg output_valid_reg_2;
	reg codestream_output_en;
	reg [8:0]pass_byte_number;
	reg [8:0]pass_byte_number_0;
	reg [8:0]pass_byte_number_1;
	reg [8:0]pass_byte_number_2;
	reg [8:0]pass_byte_number_3;
	reg [8:0]pass_byte_number_4;
	reg [8:0]pass_byte_number_5;
	reg [8:0]pass_byte_number_6;
	reg [8:0]pass_byte_number_7;
	reg [8:0]pass_byte_number_8;
	reg [8:0]pass_byte_number_9;
	reg [8:0]pass_byte_number_10;
	reg [8:0]pass_byte_number_11;
	reg [8:0]pass_byte_number_12;
	reg [8:0]pass_byte_number_13;
	reg [8:0]pass_byte_number_14;
	reg [8:0]pass_byte_number_15;
	reg [8:0]pass_byte_number_16;
	reg [8:0]pass_byte_number_17;
	reg [8:0]pass_byte_number_18;
	reg [8:0]pass_byte_number_19;
	reg [8:0]pass_byte_number_20;
	reg [8:0]pass_byte_number_21;
	reg [8:0]pass_byte_number_22;
	reg [8:0]pass_byte_number_23;
	reg [8:0]pass_byte_number_24;
	reg [8:0]pass_byte_number_25;
	reg [8:0]pass_byte_number_26;
	reg [8:0]pass_byte_number_27;
	reg [8:0]pass_byte_number_28;
	reg [8:0]pass_byte_number_29;
	reg [8:0]pass_byte_number_30;
	reg [8:0]pass_byte_number_31;
	reg current_codeblock_inclusion;
	reg [4:0]pass_counter;
	reg [7:0]current_codeblock_index;
	reg shift_en;
	reg [3:0]shift_counter;
	reg [7:0]bit_buffer;
	reg shift_bit;
	reg pass_not_included_once;
	reg [3:0]zero_plane_number_reg;
	reg [ADDR_WIDTH-1:0]lram_address_rd;
	reg [WORD_WIDTH-1:0]pass_first_header;
	reg [WORD_WIDTH-1:0]pass_second_header;
	//reg [15:0]codeblock_inclusion;
	reg [5:0]state_tagtree;
	reg [5:0]nextstate_tagtree;
	reg [4:0]packet_counter;
	reg [1:0]state_byte;
	reg [1:0]nextstate_byte;
	reg single_byte;
	reg [23:0]codestream_buffer;
	reg [15:0]codestream_segment;
	reg [6:0]state;
	reg [6:0]nextstate;
	reg lram_read_en;
	reg [7:0]codeblock_counter;
//	/***** integer *****/
//	integer a_1;	
////integer disc;
//	/***** initial *****/
//	always@(negedge clk)
//	begin
//		// a_1=$fopen("output.txt","aw");
//		a_1=$fopen("output.txt","a");
//		if(codestream_output_en)
//		begin
//			//disc = a_1 | 1 ;
//			//$display("a_1=%h , disc=%h",a_1,disc);
//			$fwrite(a_1,"%h",codestream_output);
//			$display("%h",codestream_output);
//		end
//		$fclose(a_1);
//		if(state==TAGTREE_CODING||state==SHIFT_CODEBLOCK_INFO||state==PACKET_DATA_READING)
//		begin
//			if(pass_first_header[17:16]!=2'b11)
//			begin
//				$display("warning!pass_first_header is wrong!",$time);
//			end
//		end
//	end
	
	/************* wire ****************/
	wire [7:0]codeblock_index;
	wire one_tile_over;
	wire rst_syn;
	//wire all_packet_over;
	wire all_subband_over;
	wire one_subband_over;
	wire bit_stuff_0;
	wire one_pass_over;
	wire bit_shift_over;
	wire bit_full_byte;
	wire tagtree_coding_over;
	wire pass_included;
	wire [8:0]pass_slope;
	wire [3:0]zero_plane_number;
	wire [7:0]pass_word_number;
	wire [1:0]word_last_flag;
	wire [15:0]codestream_output;
	wire shift_file_header_over;
	/***** wire output *****/
	assign codestream_generate_over=state==CODESTREAM_GENERATE_OVER;
	assign codestream_output=codestream_output_en?codestream_buffer[23:8]:0;

	/***** reg output *****/
	always@(*)
	begin
		if(state==OUTPUT_TOTAL_BYTE_NUMBER)
			output_to_fpga_32={11'b0,total_byte_counter};
	    else if(state==ONE_TILE_OVER)
			output_to_fpga_32=32'b1;
		else output_to_fpga_32=codestream_output_32;
	end
	
	always@(*)
	begin
	    if((codestream_output_en&&(output_count==2))||(shift_last_word&&(output_count==2))||state==ONE_TILE_OVER||state==OUTPUT_TOTAL_BYTE_NUMBER)
			write_en=4'b1111;
		else write_en=4'b0;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			output_address<=12;
		else if(rst_syn)
			output_address<=12;
		else if(nextstate==OUTPUT_TOTAL_BYTE_NUMBER)
			output_address<=4;
		else if(nextstate==ONE_TILE_OVER)
			output_address<=8;
		else if(codestream_output_en&&(output_count==2))
			output_address<=output_address+4;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			output_count<=0;
		else if(codestream_output_en)
			case(output_count)
				0:output_count<=1;
				1:output_count<=2;
				2:output_count<=1;
			endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			codestream_output_32<=0;
		else if(codestream_output_en)
		begin
			codestream_output_32<=codestream_output_32<<16;
			codestream_output_32[15:0]<=codestream_output;
		end

	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			lram_address_rd<=0;
		else if(rst_syn)
			lram_address_rd<=0;
		else 
		begin
			case(nextstate_tagtree)
				GET_CODEBLOCK_ADDRESS:
				begin
					if(subband_counter==0)
						lram_address_rd<=packet_first_codeblock_address;
					else lram_address_rd<=next_codeblock_address;
				end
				READ_PASS_FIRST_HEADER,READ_PASS_SECOND_HEADER,READ_PASS_DATA,READ_FORMER_PASS_DATA:lram_address_rd<=lram_address_rd+1;
				NEXT_PASS:
				begin
					if(state==TAGTREE_CODING||state==SHIFT_CODEBLOCK_INFO||(state==PACKET_DATA_READING&&pass_not_included_once)||find_next_codeblock)
						lram_address_rd<=lram_address_rd+pass_word_number;
				end
				
				PASS_INCLUDED:
				begin
					if(pass_not_included_once&&state==PACKET_DATA_READING)
						lram_address_rd<=pass_address_temp;
				end
			endcase
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			lram_read_en<=0;
		else if(rst_syn)
			lram_read_en<=0;
		else if(state==TAGTREE_CODING)
			lram_read_en<=1;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			codeblock_counter<=0;
		else if(rst_syn)
			codeblock_counter<=0;
		else if(state==IDLE&&codestream_generate_start||state==GENERATE_FILE_HEADER&&codeblock_counter==59||state_tagtree==TAGTREE_CODING_OVER||state==TAGTREE_CODE_BEGIN||state==PACKET_DATA_READ_BEGIN||(state_tagtree==ONE_SUBBAND_OVER))
			codeblock_counter<=0;
		else if(codeblock_shift_over||state==GENERATE_FILE_HEADER)
			codeblock_counter<=codeblock_counter+1;
	end
	/***** wire internal *****/
	assign codeblock_index=pass_first_header[15:8];
	assign bit_shift_over=zero_plane_number_reg==0;
	assign one_tile_over=state==ONE_TILE_OVER;
	assign rst_syn=(one_tile_over_reg_1||one_tile_over_reg_2||one_tile_over_reg_3||one_tile_over_reg_4||one_tile_over_reg_5);
	assign pass_all_scaned=(pass_counter!=0&&codeblock_index!=current_codeblock_index);
	assign all_subband_over=state_tagtree==ALL_SUBBAND_OVER;
	assign one_subband_over=state_tagtree==ONE_SUBBAND_OVER;
	assign bit_stuff_0=(shift_counter==8&&bit_buffer==8'hff);
	assign one_pass_over=(state_tagtree==SHIFT_PASS_LENGTH)&&(pass_bit_counter==pass_length_bit);
	assign bit_full_byte=shift_counter==8;
	assign tagtree_coding_over=state_tagtree==TAGTREE_CODING_OVER;
	assign pass_included=pass_slope>=target_slope;
	assign pass_slope=pass_second_header[8:0];
	assign zero_plane_number=pass_second_header[15:12];
	assign pass_word_number=pass_first_header[7:0];
	assign word_last_flag=pass_second_header[17:16];
	assign shift_file_header_over=(state==GENERATE_FILE_HEADER)&&codeblock_counter==59;
	/************* reg internal ************/
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			find_next_codeblock<=0;
		else if(rst_syn)
			find_next_codeblock<=0;
		else if(nextstate_tagtree==FIND_NEXT_CODEBLOCK_ADDRESS_BEGIN)
			find_next_codeblock<=1;
		else if(nextstate_tagtree==FIND_NEXT_CODEBLOCK_ADDRESS_OVER)
			find_next_codeblock<=0;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			next_codeblock_address<=0;
		else if(rst_syn)
			next_codeblock_address<=0;
		else if((pass_all_scaned&&(nextstate_tagtree==PASS_ALL_SCANED||nextstate_tagtree==CODEBLOCK_NOT_INCLUDED))||(find_next_codeblock&&(nextstate_tagtree==FIND_NEXT_CODEBLOCK_ADDRESS_OVER)))
			next_codeblock_address<=lram_address_rd-2;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			next_codeblock_already_found<=0;
		else if(rst_syn)
			next_codeblock_already_found<=0;
		else if(pass_all_scaned&&(nextstate_tagtree==PASS_ALL_SCANED||nextstate_tagtree==CODEBLOCK_NOT_INCLUDED))
			next_codeblock_already_found<=1;
		else if(state_tagtree==ONE_SUBBAND_OVER)
			next_codeblock_already_found<=0;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			current_codeblock_inclusion<=0;
		else if(rst_syn)
			current_codeblock_inclusion<=0;
		else 
			case(state_tagtree)
				CODEBLOCK_INCLUDED:current_codeblock_inclusion<=1;
				CODEBLOCK_NOT_INCLUDED:current_codeblock_inclusion<=0;
			endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			packet_first_codeblock_address<=0;
		else if(rst_syn)
			packet_first_codeblock_address<=0;
		else if(state==ONE_PACKET_OVER)
			packet_first_codeblock_address<=next_codeblock_address;//packet_first_codeblock_address is the address of the first codeblock of next packet
	end

	always@(posedge clk)
	begin
		one_tile_over_reg_1<=one_tile_over;
		one_tile_over_reg_2<=one_tile_over_reg_1;
		one_tile_over_reg_3<=one_tile_over_reg_2;
		one_tile_over_reg_4<=one_tile_over_reg_3;
		one_tile_over_reg_5<=one_tile_over_reg_4;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			tile_counter<=0;
		else if(state==ONE_TILE_OVER)
			tile_counter<=tile_counter+1;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			shift_last_word<=0;
		else if((codestream_output==16'hffd9||codestream_output==16'hd900)&&state==WAIT_SHIFT_OVER)
			shift_last_word<=1;
		else if(output_count==2)
			shift_last_word<=0;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			bit_rate_met<=0;
		else if(rst_syn)
			bit_rate_met<=0;
		else if(state==ONE_PACKET_OVER&&(total_byte_counter[20:1]>=target_byte_number))
			bit_rate_met<=1;
		else if(state==EOC)
			bit_rate_met<=0;
	end
	
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			word_last_flag_former_pass<=0;
		else if(rst_syn)
			word_last_flag_former_pass<=0;
		else if(state==PACKET_DATA_READING&&state_tagtree==PASS_NOT_INCLUDED_ONCE)
			word_last_flag_former_pass<=word_last_flag;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			read_former_pass_reg<=0;
		else if(rst_syn)
			read_former_pass_reg<=0;
		else if(state_tagtree==READ_FORMER_PASS_DATA)
			read_former_pass_reg<=1;
		else read_former_pass_reg<=0;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			pass_address_temp<=0;
			pass_word_number_temp<=0;
		end
		else if(rst_syn)
		begin
			pass_address_temp<=0;
			pass_word_number_temp<=0;
		end
		else if(state_tagtree==PASS_NOT_INCLUDED_ONCE&&state==PACKET_DATA_READING)
		begin
			pass_address_temp<=lram_address_rd;
			pass_word_number_temp<=pass_word_number;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			pass_length_bit_temp<=0;
		else if(rst_syn)
			pass_length_bit_temp<=0;
		else if(state_tagtree==ONE_CODEBLOCK_OVER)
			pass_length_bit_temp<=0;
		else if(state_tagtree==PASS_NOT_INCLUDED_ONCE&&state==SHIFT_CODEBLOCK_INFO)
			pass_length_bit_temp<=pass_length_bit;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			total_byte_counter<=0;
		else if(rst_syn)
			total_byte_counter<=0;
		else if(total_byte_count_en)
		begin
			if(write_en)
				total_byte_counter<=total_byte_counter+4;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			total_byte_count_en<=0;
		else if(rst_syn)
			total_byte_count_en<=0;
		else if(state==SOT||state==GENERATE_FILE_HEADER)//when SOD shows up
			total_byte_count_en<=1;
		

	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			subband_counter<=0;
		else if(rst_syn)
			subband_counter<=0;
		else if(state_tagtree==ALL_SUBBAND_OVER)
			subband_counter<=0;
		else if(state_tagtree==ONE_SUBBAND_OVER)
			subband_counter<=subband_counter+1;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			pass_counter_2<=0;
		else if(rst_syn)
			pass_counter_2<=0;
		else if(state_tagtree==ONE_CODEBLOCK_OVER)
			pass_counter_2<=0;
		else if(nextstate_tagtree==ONE_PASS_OVER)
			pass_counter_2<=pass_counter_2+1;
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			pass_number_code<=0;
			pass_bit_counter<=0;
		end
		else if(rst_syn)
		begin
			pass_number_code<=0;
			pass_bit_counter<=0;
		end
		else 
		begin
			case(state_tagtree)
				PASS_ALL_SCANED:
				begin
					case(pass_counter)
						1:
						begin
							pass_number_code<=9'b0_0000_0000;
							pass_bit_counter<=1;
						end
						2:
						begin
							//pass_number_code<=9'b0000_000_10;
							pass_number_code<=9'b0000_000_01;
							pass_bit_counter<=2;
						end
						3:
						begin
							//pass_number_code<=9'b0_0000_1100;
							pass_number_code<=9'b0_0000_0011;
							pass_bit_counter<=4;
						end
						4:
						begin
							//pass_number_code<=9'b0_0000_1101;
							pass_number_code<=9'b0_0000_1011;
							pass_bit_counter<=4;
						end
						5:
						begin
							//pass_number_code<=9'b0_0000_1110;
							pass_number_code<=9'b0_0000_0111;
							pass_bit_counter<=4;
						end
						6:
						begin
							//pass_number_code<=9'b1111_0000_0;
							pass_number_code<=9'b0_0000_1111;
							pass_bit_counter<=9;
						end
						7:
						begin
							//pass_number_code<=9'b1111_0000_1;
							pass_number_code<=9'b1_0000_1111;
							pass_bit_counter<=9;
						end
						8:
						begin
							//pass_number_code<=9'b1111_0001_0;
							pass_number_code<=9'b0_1000_1111;
							pass_bit_counter<=9;
						end
						9:
						begin
							//pass_number_code<=9'b1111_0001_1;
							pass_number_code<=9'b1_1000_1111;
							pass_bit_counter<=9;
						end
						10:
						begin
							//pass_number_code<=9'b1111_0010_0;
							pass_number_code<=9'b0_0100_1111;
							pass_bit_counter<=9;
						end
						11:
						begin
							//pass_number_code<=9'b1111_0010_1;
							pass_number_code<=9'b1_0100_1111;
							pass_bit_counter<=9;
						end
						12:
						begin
							//pass_number_code<=9'b1111_0011_0;
							pass_number_code<=9'b0_1100_1111;
							pass_bit_counter<=9;
						end
						13:
						begin
							//pass_number_code<=9'b1111_0011_1;
							pass_number_code<=9'b1_1100_1111;
							pass_bit_counter<=9;
						end
						14:
						begin
							//pass_number_code<=9'b1111_0100_0;
							pass_number_code<=9'b0_0010_1111;
							pass_bit_counter<=9;
						end
						15:
						begin
							//pass_number_code<=9'b1111_0100_1;
							pass_number_code<=9'b1_0010_1111;
							pass_bit_counter<=9;
						end
						16:
						begin
							//pass_number_code<=9'b1111_0101_0;
							pass_number_code<=9'b0_1010_1111;
							pass_bit_counter<=9;
						end
						17:
						begin
							//pass_number_code<=9'b1111_0101_1;
							pass_number_code<=9'b1_1010_1111;
							pass_bit_counter<=9;
						end
						18:
						begin
							//pass_number_code<=9'b1111_0110_0;
							pass_number_code<=9'b0_0110_1111;
							pass_bit_counter<=9;
						end
						19:
						begin
							//pass_number_code<=9'b1111_0110_1;
							pass_number_code<=9'b1_0110_1111;
							pass_bit_counter<=9;
						end
						20:
						begin
							//pass_number_code<=9'b1111_0111_0;
							pass_number_code<=9'b0_1110_1111;
							pass_bit_counter<=9;
						end
						21:
						begin
							//pass_number_code<=9'b1111_0111_1;
							pass_number_code<=9'b1_1110_1111;
							pass_bit_counter<=9;
						end
						22:
						begin
							//pass_number_code<=9'b1111_1000_0;
							pass_number_code<=9'b0_0001_1111;
							pass_bit_counter<=9;
						end
						23:
						begin
							//pass_number_code<=9'b1111_1000_1;
							pass_number_code<=9'b1_0001_1111;
							pass_bit_counter<=9;
						end
						24:
						begin
							//pass_number_code<=9'b1111_1001_0;
							pass_number_code<=9'b0_1001_1111;
							pass_bit_counter<=9;
						end
						25:
						begin
							//pass_number_code<=9'b1111_1001_1;
							pass_number_code<=9'b1_1001_1111;
							pass_bit_counter<=9;
						end
						26:
						begin
							//pass_number_code<=9'b1111_1010_0;
							pass_number_code<=9'b0_0101_1111;
							pass_bit_counter<=9;
						end
						27:
						begin
							//pass_number_code<=9'b1111_1010_1;
							pass_number_code<=9'b1_0101_1111;
							pass_bit_counter<=9;
						end
						28:
						begin
							//pass_number_code<=9'b1111_1011_0;
							pass_number_code<=9'b0_1101_1111;
							pass_bit_counter<=9;
						end
						29:
						begin
							//pass_number_code<=9'b1111_1011_1;
							pass_number_code<=9'b1_1101_1111;
							pass_bit_counter<=9;
						end
						30:
						begin
							//pass_number_code<=9'b1111_1100_0;
							pass_number_code<=9'b0_0011_1111;
							pass_bit_counter<=9;
						end
						31:
						begin
							//pass_number_code<=9'b1111_1100_1;
							pass_number_code<=9'b1_0011_1111;
							pass_bit_counter<=9;
						end
					endcase
				end

				SHIFT_PASS_NUMBER:
				begin
					if(!bit_stuff_0)
					begin
						pass_number_code<=pass_number_code>>1;
						if(nextstate_tagtree==SHIFT_BIT_ADDED)
						begin
							case(pass_length_bit)
								9:pass_bit_counter<=7;// 7 means adding six 1's and one 0  
								8:pass_bit_counter<=6;
								7:pass_bit_counter<=5;
								6:pass_bit_counter<=4;
								5:pass_bit_counter<=3;
								4:pass_bit_counter<=2;
								default:pass_bit_counter<=1;
							endcase
						end
						else pass_bit_counter<=pass_bit_counter-1;
					end
				end
				SHIFT_BIT_ADDED:
				begin
					if(!bit_stuff_0)
					begin
						if(nextstate_tagtree==SHIFT_PASS_LENGTH)
							pass_bit_counter<=1;
						else pass_bit_counter<=pass_bit_counter-1;
					end
				end
				SHIFT_PASS_LENGTH:
				begin
					if(!bit_stuff_0)
					begin
						if(nextstate_tagtree==ONE_PASS_OVER)
							pass_bit_counter<=1;
						else pass_bit_counter<=pass_bit_counter+1;
					end
				end
				

			endcase
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			pass_byte_number_limit<=0;
			pass_length_bit<=0;
		end
		else if(rst_syn)
		begin
			pass_byte_number_limit<=0;
			pass_length_bit<=0;
		end
		//else if(state_tagtree==NEXT_CODEBLOCK&&state==SHIFT_CODEBLOCK_INFO||state==NEXT_PACKET)
		else if(state_tagtree==ONE_CODEBLOCK_OVER)
		begin
			pass_byte_number_limit<=0;
			pass_length_bit<=0;
		end
		else if(state==SHIFT_CODEBLOCK_INFO)
		begin
			if(state_tagtree==PASS_INCLUDED||state_tagtree==PASS_NOT_INCLUDED_ONCE)
			begin
				if(pass_byte_number_limit<pass_byte_number)
				begin
					casex(pass_byte_number)
						9'b1_xxxx_xxxx:
							begin
								pass_byte_number_limit<=511;
								pass_length_bit<=9;
							end
						9'b0_1xxx_xxxx:
							begin
								pass_byte_number_limit<=255;
								pass_length_bit<=8;
							end
						9'b0_01xx_xxxx:
							begin
								pass_byte_number_limit<=127;
								pass_length_bit<=7;
							end
						9'b0_001x_xxxx:
							begin
								pass_byte_number_limit<=63;
								pass_length_bit<=6;
							end
						9'b0_0001_xxxx:
							begin
								pass_byte_number_limit<=31;
								pass_length_bit<=5;
							end
						9'b0_0000_1xxx:
							begin
								pass_byte_number_limit<=15;
								pass_length_bit<=4;
							end
						default:pass_length_bit<=3;
					endcase
				end
			end
			else if(state_tagtree==PASS_NOT_INCLUDED_TWICE)
				pass_length_bit<=pass_length_bit_temp;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			output_valid_reg_1<=0;//if the state generates codestream,then output_valid_reg_1 is 1,else 0
		else if(rst_syn)
			output_valid_reg_1<=0;
		else 
			case(state)
				GENERATE_FILE_HEADER,SOP,EPH,EOC,SOT:output_valid_reg_1<=1;
				TAGTREE_CODE_BEGIN,PACKET_DATA_READ_BEGIN,ONE_PACKET_OVER,CODESTREAM_GENERATE_OVER,WAIT_SHIFT_OVER:output_valid_reg_1<=0;
				SHIFT_CODEBLOCK_INFO:
				begin
					if(bit_full_byte)
						output_valid_reg_1<=1;
					else output_valid_reg_1<=0;
				end
				PACKET_DATA_READING:
				begin
					case(state_tagtree)
						READ_PASS_DATA,READ_FORMER_PASS_DATA:
							output_valid_reg_1<=1;
						NEXT_PASS:
							output_valid_reg_1<=0;
					endcase
				end
			endcase
	end
	always@(posedge clk)
	begin
	    output_valid_reg_2<=output_valid_reg_1;
	end
		
	
	always@(*)
	begin
	    //case(state)
			//GENERATE_FILE_HEADER,SOP,LSOP,PACKET_INDEX,SHIFT_CODEBLOCK_INFO,PACKET_DATA_READING:
			begin
				if(((state_byte==TWO_BYTE)||(state_byte==THREE_BYTE))&&output_valid_reg_2)
					codestream_output_en=1;
				else if(shift_last_word&&output_count==1)
					codestream_output_en=1;
				else codestream_output_en=0;
			end
			//default:codestream_output_en=output_valid_reg_1;
	   //endcase
	end
	
	
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			pass_byte_number<=0;
		else if(rst_syn)
			pass_byte_number<=0;
		else if(state==SHIFT_CODEBLOCK_INFO)
	    case(state_tagtree)
			READ_PASS_SECOND_HEADER:
			begin
				pass_byte_number[8:1]<=pass_word_number;
				pass_byte_number[0]<=0;
			end
			COMPARE_SLOPE:
			begin
				if(word_last_flag==2'b01)
					pass_byte_number<=pass_byte_number-1;
			end
			SHIFT_BIT_ADDED,ONE_PASS_OVER:
			begin
				if(nextstate_tagtree==SHIFT_PASS_LENGTH)
				begin
					case(pass_counter_2)
						0 :pass_byte_number<=pass_byte_number_0;
						1 :pass_byte_number<=pass_byte_number_1 ;
						2 :pass_byte_number<=pass_byte_number_2 ;
						3 :pass_byte_number<=pass_byte_number_3 ;
						4 :pass_byte_number<=pass_byte_number_4 ;
						5 :pass_byte_number<=pass_byte_number_5 ;
						6 :pass_byte_number<=pass_byte_number_6 ;
						7 :pass_byte_number<=pass_byte_number_7 ;
						8 :pass_byte_number<=pass_byte_number_8 ;
						9 :pass_byte_number<=pass_byte_number_9 ;
						10:pass_byte_number<=pass_byte_number_10;
						11:pass_byte_number<=pass_byte_number_11;
						12:pass_byte_number<=pass_byte_number_12;
						13:pass_byte_number<=pass_byte_number_13;
						14:pass_byte_number<=pass_byte_number_14;
						15:pass_byte_number<=pass_byte_number_15;
						16:pass_byte_number<=pass_byte_number_16;
						17:pass_byte_number<=pass_byte_number_17;
						18:pass_byte_number<=pass_byte_number_18;
						19:pass_byte_number<=pass_byte_number_19;
						20:pass_byte_number<=pass_byte_number_20;
						21:pass_byte_number<=pass_byte_number_21;
						22:pass_byte_number<=pass_byte_number_22;
						23:pass_byte_number<=pass_byte_number_23;
						24:pass_byte_number<=pass_byte_number_24;
						25:pass_byte_number<=pass_byte_number_25;
						26:pass_byte_number<=pass_byte_number_26;
						27:pass_byte_number<=pass_byte_number_27;
						28:pass_byte_number<=pass_byte_number_28;
						29:pass_byte_number<=pass_byte_number_29;
						30:pass_byte_number<=pass_byte_number_30;
						31:pass_byte_number<=pass_byte_number_31;
					endcase
				end
			end
			SHIFT_PASS_LENGTH:
			begin
				if(!bit_stuff_0)
				pass_byte_number<=pass_byte_number<<1;
			end
		endcase

		else if(state==PACKET_DATA_READING)
		begin
			case(state_tagtree)
				PASS_INCLUDED://here pass_byte_number is used to count the number of pass word
				begin
					if(pass_not_included_once)
						pass_byte_number<=pass_word_number_temp;
					else pass_byte_number<=pass_word_number;
				end
				READ_PASS_DATA,READ_FORMER_PASS_DATA:pass_byte_number<=pass_byte_number-1;

			endcase
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			pass_byte_number_0 <=0;
			pass_byte_number_1 <=0;
			pass_byte_number_2 <=0;
			pass_byte_number_3 <=0;
			pass_byte_number_4 <=0;
			pass_byte_number_5 <=0;
			pass_byte_number_6 <=0;
			pass_byte_number_7 <=0;
			pass_byte_number_8 <=0;
			pass_byte_number_9 <=0;
			pass_byte_number_10<=0;
			pass_byte_number_11<=0;
			pass_byte_number_12<=0;
			pass_byte_number_13<=0;
			pass_byte_number_14<=0;
			pass_byte_number_15<=0;
			pass_byte_number_16<=0;
			pass_byte_number_17<=0;
			pass_byte_number_18<=0;
			pass_byte_number_19<=0;
			pass_byte_number_20<=0;
			pass_byte_number_21<=0;
			pass_byte_number_22<=0;
			pass_byte_number_23<=0;
			pass_byte_number_24<=0;
			pass_byte_number_25<=0;
			pass_byte_number_26<=0;
			pass_byte_number_27<=0;
			pass_byte_number_28<=0;
			pass_byte_number_29<=0;
			pass_byte_number_30<=0;
			pass_byte_number_31<=0;
		end
		else if(rst_syn)
		begin
			pass_byte_number_0 <=0;
			pass_byte_number_1 <=0;
			pass_byte_number_2 <=0;
			pass_byte_number_3 <=0;
			pass_byte_number_4 <=0;
			pass_byte_number_5 <=0;
			pass_byte_number_6 <=0;
			pass_byte_number_7 <=0;
			pass_byte_number_8 <=0;
			pass_byte_number_9 <=0;
			pass_byte_number_10<=0;
			pass_byte_number_11<=0;
			pass_byte_number_12<=0;
			pass_byte_number_13<=0;
			pass_byte_number_14<=0;
			pass_byte_number_15<=0;
			pass_byte_number_16<=0;
			pass_byte_number_17<=0;
			pass_byte_number_18<=0;
			pass_byte_number_19<=0;
			pass_byte_number_20<=0;
			pass_byte_number_21<=0;
			pass_byte_number_22<=0;
			pass_byte_number_23<=0;
			pass_byte_number_24<=0;
			pass_byte_number_25<=0;
			pass_byte_number_26<=0;
			pass_byte_number_27<=0;
			pass_byte_number_28<=0;
			pass_byte_number_29<=0;
			pass_byte_number_30<=0;
			pass_byte_number_31<=0;
		end
		else if(state==SHIFT_CODEBLOCK_INFO)
		begin
			if(state_tagtree==ONE_CODEBLOCK_OVER)
			begin
				pass_byte_number_0 <=0;
				pass_byte_number_1 <=0;
				pass_byte_number_2 <=0;
				pass_byte_number_3 <=0;
				pass_byte_number_4 <=0;
				pass_byte_number_5 <=0;
				pass_byte_number_6 <=0;
				pass_byte_number_7 <=0;
				pass_byte_number_8 <=0;
				pass_byte_number_9 <=0;
				pass_byte_number_10<=0;
				pass_byte_number_11<=0;
				pass_byte_number_12<=0;
				pass_byte_number_13<=0;
				pass_byte_number_14<=0;
				pass_byte_number_15<=0;
				pass_byte_number_16<=0;
				pass_byte_number_17<=0;
				pass_byte_number_18<=0;
				pass_byte_number_19<=0;
				pass_byte_number_20<=0;
				pass_byte_number_21<=0;
				pass_byte_number_22<=0;
				pass_byte_number_23<=0;
				pass_byte_number_24<=0;
				pass_byte_number_25<=0;
				pass_byte_number_26<=0;
				pass_byte_number_27<=0;
				pass_byte_number_28<=0;
				pass_byte_number_29<=0;
				pass_byte_number_30<=0;
				pass_byte_number_31<=0;
			end
			else if(state_tagtree==PASS_INCLUDED||state_tagtree==PASS_NOT_INCLUDED_ONCE)
			begin
				case(pass_counter)
					0 :pass_byte_number_0 <=pass_byte_number;
        	        1 :pass_byte_number_1 <=pass_byte_number;
        	        2 :pass_byte_number_2 <=pass_byte_number;
        	        3 :pass_byte_number_3 <=pass_byte_number;
        	        4 :pass_byte_number_4 <=pass_byte_number;
        	        5 :pass_byte_number_5 <=pass_byte_number;
        	        6 :pass_byte_number_6 <=pass_byte_number;
        	        7 :pass_byte_number_7 <=pass_byte_number;
        	        8 :pass_byte_number_8 <=pass_byte_number;
        	        9 :pass_byte_number_9 <=pass_byte_number;
        	        10:pass_byte_number_10<=pass_byte_number;
        	        11:pass_byte_number_11<=pass_byte_number;
        	        12:pass_byte_number_12<=pass_byte_number;
        	        13:pass_byte_number_13<=pass_byte_number;
        	        14:pass_byte_number_14<=pass_byte_number;
        	        15:pass_byte_number_15<=pass_byte_number;
        	        16:pass_byte_number_16<=pass_byte_number;
        	        17:pass_byte_number_17<=pass_byte_number;
        	        18:pass_byte_number_18<=pass_byte_number;
        	        19:pass_byte_number_19<=pass_byte_number;
        	        20:pass_byte_number_20<=pass_byte_number;
        	        21:pass_byte_number_21<=pass_byte_number;
        	        22:pass_byte_number_22<=pass_byte_number;
        	        23:pass_byte_number_23<=pass_byte_number;
        	        24:pass_byte_number_24<=pass_byte_number;
        	        25:pass_byte_number_25<=pass_byte_number;
        	        26:pass_byte_number_26<=pass_byte_number;
        	        27:pass_byte_number_27<=pass_byte_number;
        	        28:pass_byte_number_28<=pass_byte_number;
        	        29:pass_byte_number_29<=pass_byte_number;
        	        30:pass_byte_number_30<=pass_byte_number;
        	        31:pass_byte_number_31<=pass_byte_number;
				endcase
			end
		end
	end
	
	
	
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			pass_counter<=0;
		else if(rst_syn)
			pass_counter<=0;
		else if(state==NEXT_PACKET)
			pass_counter<=0;
		else if(state==TAGTREE_CODING||state==SHIFT_CODEBLOCK_INFO||state==PACKET_DATA_READING)
		begin
			if(state_tagtree==ONE_CODEBLOCK_OVER||state_tagtree==TAGTREE_CODING_OVER)
				pass_counter<=0;
			else if(state_tagtree==NEXT_PASS&&(!read_former_pass_reg)&&(!find_next_codeblock))
				pass_counter<=pass_counter+1;
			else if(state_tagtree==PASS_NOT_INCLUDED_TWICE||(pass_not_included_once&&pass_all_scaned))
				pass_counter<=pass_counter-1;//to subtract the former not included pass
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			current_codeblock_index<=0;
		else if(rst_syn)
			current_codeblock_index<=0;
		else if(state_tagtree==READ_PASS_SECOND_HEADER&&pass_counter==0)
			current_codeblock_index<=codeblock_index;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			bit_buffer<=0;
		else if(rst_syn)
			bit_buffer<=0;
		else if(shift_en)
		begin
			bit_buffer<=bit_buffer<<1;
			bit_buffer[0]<=shift_bit;
		end
	end
	
	always@(*)
	begin	
		if(bit_stuff_0)
			shift_en=1;
		else
	    case(state_tagtree)
			SHIFT_PACKET_EMPTY_FLAG,SHIFT_BASE_NODE_INCLUSION,SHIFT_BASE_NODE_ZERO_PLANE,SHIFT_PASS_NUMBER,SHIFT_BIT_ADDED,SHIFT_PASS_LENGTH,SHIFT_PADDING_BIT:
				shift_en=1;
			default:shift_en=0;
	    endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			shift_counter<=0;
		else if(rst_syn)
			shift_counter<=0;
		else if(shift_counter==8)
		begin
			if(shift_en)
			begin
				if(state_tagtree==SHIFT_PADDING_BIT&&(!bit_stuff_0))
					shift_counter<=0;
				else shift_counter<=1;
			end
			else shift_counter<=0;
		end
		else if(shift_en)
			shift_counter<=shift_counter+1;
	end
	
	
	always@(*)
	begin
		if(bit_stuff_0)
			shift_bit=0;
		else
	    case(state_tagtree)
			SHIFT_PACKET_EMPTY_FLAG:// 1 means not empty
			begin
				shift_bit=1;
			end
			SHIFT_BASE_NODE_INCLUSION:shift_bit=current_codeblock_inclusion;
			SHIFT_PASS_NUMBER:shift_bit=pass_number_code[0];			
			SHIFT_BASE_NODE_ZERO_PLANE:
			begin
				if(zero_plane_number_reg==0)
					shift_bit=1;
				else shift_bit=0;
			end
			SHIFT_BIT_ADDED:
			begin
				if(pass_bit_counter==1)
					shift_bit=0;
				else shift_bit=1;
			end
			SHIFT_PASS_LENGTH:
			begin
				case(pass_length_bit)
					1:shift_bit=pass_byte_number[0];
					2:shift_bit=pass_byte_number[1];
					3:shift_bit=pass_byte_number[2];
					4:shift_bit=pass_byte_number[3];
					5:shift_bit=pass_byte_number[4];
					6:shift_bit=pass_byte_number[5];
					7:shift_bit=pass_byte_number[6];
					8:shift_bit=pass_byte_number[7];
					9:shift_bit=pass_byte_number[8];
					default:shift_bit=0;
				endcase
			end
			default:shift_bit=0;
	    endcase
	end
	
	
	
	
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			pass_not_included_once<=0;
		else if(rst_syn)
			pass_not_included_once<=0;
		else if(nextstate_tagtree==PASS_NOT_INCLUDED_ONCE)
			pass_not_included_once<=1;
		else 
			case(state_tagtree)
				PASS_INCLUDED:pass_not_included_once<=0;
				CODEBLOCK_INCLUDED:pass_not_included_once<=0;
				PASS_NOT_INCLUDED_TWICE:pass_not_included_once<=0;
				READ_PASS_SECOND_HEADER:
				begin
					if(pass_all_scaned)
						pass_not_included_once<=0;
				end
			endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			zero_plane_number_reg <=0;
		end
		else if(rst_syn)
		begin
			zero_plane_number_reg <=0;
		end
		else if(state_tagtree==ONE_SUBBAND_OVER&&state==SHIFT_CODEBLOCK_INFO)
		begin
			zero_plane_number_reg <=0;
		end
		else if(state_tagtree==COMPARE_SLOPE&&state==TAGTREE_CODING)
		begin
			zero_plane_number_reg <=zero_plane_number;
		end	
		else if(state_tagtree==SHIFT_BASE_NODE_ZERO_PLANE)
			zero_plane_number_reg<=zero_plane_number_reg-1;

	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			pass_first_header<=0;
			pass_second_header<=0;
		end
		else if(rst_syn)
		begin
			pass_first_header<=0;
			pass_second_header<=0;
		end
		else
			case(state_tagtree)
				READ_PASS_FIRST_HEADER:pass_first_header<=data_from_ram;
				READ_PASS_SECOND_HEADER:pass_second_header<=data_from_ram;
			endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			packet_counter<=0;
		else if(rst_syn)
			packet_counter<=0;
		else if(state==NEXT_PACKET)
			packet_counter<=packet_counter+1;
	end
	
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			codestream_buffer<=0;
		else if(output_valid_reg_1)
		begin
			if(single_byte)
			begin
				case(state_byte)
					ONE_BYTE:codestream_buffer[15:8]<=codestream_segment[15:8];
					TWO_BYTE:codestream_buffer[23:16]<=codestream_segment[15:8];
					THREE_BYTE:
					begin
						codestream_buffer<=codestream_buffer<<16;
						codestream_buffer[15:8]<=codestream_segment[15:8];
					end
				endcase
			end
			else 
			begin
				case(state_byte)
					ONE_BYTE:codestream_buffer[15:0]<=codestream_segment;
					TWO_BYTE:codestream_buffer[23:8]<=codestream_segment;
					THREE_BYTE:
					begin
						codestream_buffer<=codestream_buffer<<16;
						codestream_buffer[15:0]<=codestream_segment;
					end
				endcase
			end
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
		begin
			codestream_segment<=0;
			single_byte<=0;
		end
		else if(rst_syn)
		begin
			codestream_segment<=0;
			single_byte<=0;
		end
		else 
			case(state)
				GENERATE_FILE_HEADER:
				begin
					codestream_segment<=0;
					single_byte<=0;
					case(codeblock_counter)
						0 :codestream_segment<=16'hff4f;  //SOC
						1 :codestream_segment<=16'hff51;  //SIZ
						2 :codestream_segment<=16'h002f;  //LSIZ
						3 :codestream_segment<=16'h0000;  //RSIZ
						4 :codestream_segment<=16'h0000;  //XSIZ_1
						//5 :codestream_segment<=16'h0200;  //XSIZ_2 for 512
						5 :codestream_segment<=16'h0280;  //XSIZ_2 for 640
						// 5 :codestream_segment<=16'h0080;  //XSIZ_2 for 128
						//5 :codestream_segment<=16'h0400;  //XSIZ_2 for 1024
						6 :codestream_segment<=16'h0000;  //YSIZ_1
						//7 :codestream_segment<=16'h0200;  //YSIZ_2 for 512
						7 :codestream_segment<=16'h0280;  //YSIZ_2 for 640
						//7 :codestream_segment<=16'h0080;  //YSIZ_2 for 128
						//7 :codestream_segment<=16'h0300;  //YSIZ_2 for 768
						8 :codestream_segment<=16'h0000;  //XOSIZ_1
						9 :codestream_segment<=16'h0000;  //XOSIZ_2
						10:codestream_segment<=16'h0000;  //YOSIZ_1
						11:codestream_segment<=16'h0000;  //YOSIZ_2
						12:codestream_segment<=16'h0000;  //XTSIZ_1
						//13:codestream_segment<=16'h0200;  //XTSIZ_2 for 512
						13:codestream_segment<=16'h0080;  //XTSIZ_2 for 128: tile size
						14:codestream_segment<=16'h0000;  //YTSIZ_1
						//15:codestream_segment<=16'h0200;  //YTSIZ_2
						15:codestream_segment<=16'h0080;  //YTSIZ_2
						16:codestream_segment<=16'h0000;  //XTOSIZ_1
						17:codestream_segment<=16'h0000;  //XTOSIZ_2
						18:codestream_segment<=16'h0000;  //YTOSIZ_1
						19:codestream_segment<=16'h0000;  //YTOSIZ_2
						20:codestream_segment<=16'h0003;  //CSIZ
						21:
						begin                             
							codestream_segment<=16'h0700; //SSIZ_1
							single_byte<=1;               //take the most significant byte
						end                               
						22:                              
						begin                             
							codestream_segment<=16'h0100; //XRSIZ_1            
							single_byte<=1;               
						end                               
						23:                              
						begin                           
							codestream_segment<=16'h0100; //YRSIZ
							single_byte<=1;               
						end                              
						24:                             
						begin                          
							codestream_segment<=16'h0700; //SSIZ_2
							single_byte<=1;               
						end                              
						25:                             
						begin                          
							codestream_segment<=16'h0100; //XRSIZ_2
							single_byte<=1;
						end
						26:
						begin
							codestream_segment<=16'h0100; //YRSIZ_2
							single_byte<=1;
						end
						27:
						begin
							codestream_segment<=16'h0700; //SSIZ_3
							single_byte<=1;
						end
						28:
						begin
							codestream_segment<=16'h0100; //XRSIZ_3
							single_byte<=1;
						end
						29:
						begin
							codestream_segment<=16'h0100; //YRSIZ_3
							single_byte<=1;
						end
						30:codestream_segment<=16'hff52; //COD
						31:codestream_segment<=16'h000c; //LCOD
						32:
						begin
							codestream_segment<=16'h0600; //SCOD
							single_byte<=1;
						end
						33:
						begin
							codestream_segment<=16'h0000; //PROGRESSION_ORDER
							single_byte<=1;
						end
						34:codestream_segment<=16'h0001; //LAYER_NUMBER
						35:
						begin
							codestream_segment<=16'h0100; //COMPONENT_TRANSFORMATION
							single_byte<=1;
						end
						36:
						begin
							codestream_segment<=16'h0500; //DWT_LEVEL_NUMBER
							single_byte<=1;
						end
						37:
						begin
							codestream_segment<=16'h0400; //CODEBLOCK_WIDTH
							single_byte<=1;
						end
						38:
						begin
							codestream_segment<=16'h0400; //CODEBLOCK_HEIGHT
							single_byte<=1;
						end
						39:
						begin
							codestream_segment<=16'h0e00; //CODEBLOCK_STYLE
							single_byte<=1;
						end
						40:
						begin
							codestream_segment<=16'h0000; //TRANFORMATION_STYLE
							single_byte<=1;
						end
						41:codestream_segment<=16'hff5c;  //QCD
						42:codestream_segment<=16'h0023;  //LQCD
						43:
						begin
							codestream_segment<=16'h4200; //SQCD
							single_byte<=1;
						end
						44:codestream_segment<=16'h6f10;  //STEP_LL5
						45:codestream_segment<=16'h6ee8;  //STEP_HL5
						46:codestream_segment<=16'h6ee8;  //STEP_LH5
						47:codestream_segment<=16'h6eb8;  //STEP_HH5
						48:codestream_segment<=16'h66fc;  //STEP_HL4
						49:codestream_segment<=16'h66fc;  //STEP_LH4
						50:codestream_segment<=16'h66e0;  //STEP_HH4
						51:codestream_segment<=16'h5f4c;  //STEP_HL3
						52:codestream_segment<=16'h5f4c;  //STEP_LH3
						53:codestream_segment<=16'h5f62;  //STEP_HH3
						54:codestream_segment<=16'h4803;  //STEP_HL2
						55:codestream_segment<=16'h4803;  //STEP_LH2
						56:codestream_segment<=16'h4845;  //STEP_HH2
						57:codestream_segment<=16'h4fd2;  //STEP_HL1
						58:codestream_segment<=16'h4fd2;  //STEP_LH1
						59:codestream_segment<=16'h4f60;  //STEP_HH1
						
					endcase
				end
				SOT:
				begin
					single_byte<=0;
					codestream_segment<=16'hff90;
				end
				LSOT://length of marker segment
				begin
					single_byte<=0;
					codestream_segment<=16'h000a;
				end
				ISOT://tile index
				begin
					single_byte<=0;
					codestream_segment<=tile_counter;
				end

				PSOT_1://length of the tile part
				begin
					single_byte<=0;
					codestream_segment<=16'h0;
				end

				PSOT_2://length of the tile part
				begin
					single_byte<=0;
					codestream_segment<=16'h0;
				end
				TPSOT://tile part index
				begin
					single_byte<=1;
					codestream_segment<=16'h0;
				end
				TNSOT://number of tile part for the tile
				begin
					single_byte<=1;
					codestream_segment<=16'h0100;
				end
				SOD:
				begin
					single_byte<=0;
					codestream_segment<=16'hff93;
				end
				SOP:
				begin
					single_byte<=0;
					codestream_segment<=16'hff91;
				end
				LSOP:
				begin
					single_byte<=0;
					codestream_segment<=16'h0004;
				end
				PACKET_INDEX:
				begin
					single_byte<=0;
					codestream_segment<={11'b0,packet_counter[4:0]};
				end
				SHIFT_CODEBLOCK_INFO:
				begin
					single_byte<=0;
					if(bit_full_byte)
					begin
						single_byte<=1;
						codestream_segment<={bit_buffer,8'b0};
					end
				end
				EPH:
				begin
					single_byte<=0;
					codestream_segment<=16'hff92;
				end
				PACKET_DATA_READING:
				begin
					if(state_tagtree==READ_PASS_DATA)
					begin
						codestream_segment<=data_from_ram;
						if(pass_byte_number==1&&word_last_flag==1)
							single_byte<=1;
						else single_byte<=0;
					end
					else if(state_tagtree==READ_FORMER_PASS_DATA)
					begin
						codestream_segment<=data_from_ram;
						if(pass_byte_number==1&&word_last_flag_former_pass==1)
							single_byte<=1;
						else single_byte<=0;
					end
				end
				EMPTY_PACKET:
				begin
					single_byte<=1;
					codestream_segment<=16'h8000;
				end
				EOC:
				begin
					single_byte<=0;
					codestream_segment<=16'hffd9;
				end
				SHIFT_LAST_BYTE:
				begin
					single_byte<=1;
					codestream_segment<=16'h0;
				end
				

				
			endcase
	end
	
	

	/***** fsm *****/
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			state_tagtree<=IDLE_TAGTREE;
		else if(rst_syn)
			state_tagtree<=IDLE_TAGTREE;
		else state_tagtree<=nextstate_tagtree;
	end
	always@(*)
	begin
	    case(state_tagtree)
			IDLE_TAGTREE:
			begin
				case(state)
					TAGTREE_CODING,PACKET_DATA_READING:
					begin
						nextstate_tagtree=GET_CODEBLOCK_ADDRESS;
					end 
					SHIFT_CODEBLOCK_INFO:
					begin
						if(subband_counter==0)
							nextstate_tagtree=SHIFT_PACKET_EMPTY_FLAG;
						else nextstate_tagtree=SHIFT_INCLUSION_TAGTREE_BEGIN;
					end
					default:nextstate_tagtree=IDLE_TAGTREE;
				endcase
			end
			FIND_NEXT_CODEBLOCK_ADDRESS_BEGIN:
			begin
				nextstate_tagtree=NEXT_PASS;
			end 
			GET_CODEBLOCK_ADDRESS:nextstate_tagtree=READ_PASS_FIRST_HEADER;
			READ_PASS_FIRST_HEADER:nextstate_tagtree=READ_PASS_SECOND_HEADER;
			READ_PASS_SECOND_HEADER:
			begin
				case(state)
					TAGTREE_CODING:
					begin
						if(pass_all_scaned)
							nextstate_tagtree=CODEBLOCK_NOT_INCLUDED;
						else nextstate_tagtree=COMPARE_SLOPE;
					end
					SHIFT_CODEBLOCK_INFO,PACKET_DATA_READING:
					begin
						if(find_next_codeblock)
						begin
							if(codeblock_index!=current_codeblock_index)
								nextstate_tagtree=FIND_NEXT_CODEBLOCK_ADDRESS_OVER;
							else nextstate_tagtree=NEXT_PASS;
						end 
						else if(pass_all_scaned)
							nextstate_tagtree=PASS_ALL_SCANED;
						else nextstate_tagtree=COMPARE_SLOPE;
					end
					default:nextstate_tagtree=READ_PASS_SECOND_HEADER;
				endcase
			end
			FIND_NEXT_CODEBLOCK_ADDRESS_OVER:nextstate_tagtree=ONE_SUBBAND_OVER;
			COMPARE_SLOPE:
			begin
				if(pass_included)
				begin
					case(state)
						TAGTREE_CODING:nextstate_tagtree=CODEBLOCK_INCLUDED;
						SHIFT_CODEBLOCK_INFO,PACKET_DATA_READING:nextstate_tagtree=PASS_INCLUDED;
						default:nextstate_tagtree=COMPARE_SLOPE;
					endcase
				end
				else if(pass_not_included_once)
					nextstate_tagtree=PASS_NOT_INCLUDED_TWICE;
				else nextstate_tagtree=PASS_NOT_INCLUDED_ONCE;
			end
			CODEBLOCK_INCLUDED:
			begin
				nextstate_tagtree=INCLUSION_TAGTREE_OVER;
			end
			PASS_NOT_INCLUDED_ONCE:nextstate_tagtree=NEXT_PASS;
			NEXT_PASS:nextstate_tagtree=READ_PASS_FIRST_HEADER;
			PASS_NOT_INCLUDED_TWICE:
			begin
				case(state)
					TAGTREE_CODING:nextstate_tagtree=CODEBLOCK_NOT_INCLUDED;
					SHIFT_CODEBLOCK_INFO,PACKET_DATA_READING:nextstate_tagtree=PASS_ALL_SCANED;
					default:nextstate_tagtree=PASS_NOT_INCLUDED_TWICE;
				endcase
			end
			CODEBLOCK_NOT_INCLUDED:
			begin
				nextstate_tagtree=INCLUSION_TAGTREE_OVER;
			end
			INCLUSION_TAGTREE_OVER:nextstate_tagtree=TAGTREE_CODING_OVER;
			TAGTREE_CODING_OVER:nextstate_tagtree=IDLE_TAGTREE;
			SHIFT_PACKET_EMPTY_FLAG:nextstate_tagtree=SHIFT_INCLUSION_TAGTREE_BEGIN;
			SHIFT_INCLUSION_TAGTREE_BEGIN:
			begin
				nextstate_tagtree=SHIFT_BASE_NODE_INCLUSION;
			end
			SHIFT_BASE_NODE_INCLUSION:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_BASE_NODE_INCLUSION;
				else if(current_codeblock_inclusion)
					nextstate_tagtree=SHIFT_ZERO_PLANE_TAGTREE_BEGIN;
				else nextstate_tagtree=ONE_CODEBLOCK_OVER;
			end

			SHIFT_ZERO_PLANE_TAGTREE_BEGIN:
			begin
				nextstate_tagtree=SHIFT_BASE_NODE_ZERO_PLANE;
			end
			SHIFT_BASE_NODE_ZERO_PLANE:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_BASE_NODE_ZERO_PLANE;
				else if(bit_shift_over)
					nextstate_tagtree=READ_PASS_LENGTH_BEGIN;
				else nextstate_tagtree=SHIFT_BASE_NODE_ZERO_PLANE;
			end
			READ_PASS_LENGTH_BEGIN:
			begin
				if(codeblock_counter==0)
					nextstate_tagtree=GET_CODEBLOCK_ADDRESS;
				else nextstate_tagtree=READ_PASS_FIRST_HEADER;//the NEXT_CODEBLOCK state has already get the codeblock address for codeblocks with codeblock_index!=0
			end
			PASS_INCLUDED:
			begin
				case(state)
					SHIFT_CODEBLOCK_INFO:nextstate_tagtree=NEXT_PASS;
					PACKET_DATA_READING:
					begin
						if(pass_not_included_once)
							nextstate_tagtree=READ_FORMER_PASS_DATA;
						else nextstate_tagtree=READ_PASS_DATA;
					end
					default:nextstate_tagtree=PASS_INCLUDED;
				endcase
			end
			PASS_ALL_SCANED:
			begin
				case(state)
					SHIFT_CODEBLOCK_INFO:nextstate_tagtree=SHIFT_PASS_NUMBER;
					PACKET_DATA_READING:nextstate_tagtree=ONE_CODEBLOCK_OVER;
					default:nextstate_tagtree=PASS_ALL_SCANED;
				endcase
			end
			SHIFT_PASS_NUMBER:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_PASS_NUMBER;
				if(pass_bit_counter==1)
					nextstate_tagtree=SHIFT_BIT_ADDED;
				else nextstate_tagtree=SHIFT_PASS_NUMBER;
			end
			SHIFT_BIT_ADDED:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_BIT_ADDED;
				else if(pass_bit_counter==1)
					nextstate_tagtree=SHIFT_PASS_LENGTH;
				else nextstate_tagtree=SHIFT_BIT_ADDED;
			end

			SHIFT_PASS_LENGTH:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_PASS_LENGTH;
				else if(one_pass_over)
					nextstate_tagtree=ONE_PASS_OVER;
				else nextstate_tagtree=SHIFT_PASS_LENGTH;
			end
			ONE_PASS_OVER:
			begin
				if(pass_counter_2==pass_counter)
					nextstate_tagtree=ONE_CODEBLOCK_OVER;
				else nextstate_tagtree=SHIFT_PASS_LENGTH;
			end
			ONE_CODEBLOCK_OVER:			
			begin
				if(next_codeblock_already_found)
					nextstate_tagtree=ONE_SUBBAND_OVER;
				else nextstate_tagtree=FIND_NEXT_CODEBLOCK_ADDRESS_BEGIN;
			end
			ONE_SUBBAND_OVER:
			begin
				if(subband_counter==2||(subband_counter==0&&(packet_counter==0||packet_counter==1||packet_counter==2)))
				begin
					if(state==SHIFT_CODEBLOCK_INFO)
					begin
						if(shift_counter==0||shift_counter==8)
							nextstate_tagtree=ALL_SUBBAND_OVER;
						else nextstate_tagtree=SHIFT_PADDING_BIT;
					end
					else nextstate_tagtree=ALL_SUBBAND_OVER;
				end
				else nextstate_tagtree=IDLE_TAGTREE;
			end
			ALL_SUBBAND_OVER:nextstate_tagtree=IDLE_TAGTREE;
			SHIFT_PADDING_BIT:
			begin
				if(bit_stuff_0)
					nextstate_tagtree=SHIFT_PADDING_BIT;
				else if(bit_full_byte)
					nextstate_tagtree=ALL_SUBBAND_OVER;
				else nextstate_tagtree=SHIFT_PADDING_BIT;
			end
			READ_PASS_DATA:
			begin
				if(pass_byte_number==1)
					nextstate_tagtree=NEXT_PASS;
				else nextstate_tagtree=READ_PASS_DATA;
			end
			READ_FORMER_PASS_DATA:
			begin
				if(pass_byte_number==1)
					nextstate_tagtree=NEXT_PASS;
				else nextstate_tagtree=READ_FORMER_PASS_DATA;
			end
			//PASS_ALL_SCANED:nextstate_tagtree=IDLE_TAGTREE;

			default:nextstate_tagtree=IDLE_TAGTREE;
		endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			state_byte<=TWO_BYTE;
		else state_byte<=nextstate_byte;
	end
	always@(*)
	begin
	    case(state_byte)
			ONE_BYTE:
			begin
				if(output_valid_reg_1)
				begin
					if(single_byte)
						nextstate_byte=TWO_BYTE;
					else nextstate_byte=THREE_BYTE;
				end
				else nextstate_byte=ONE_BYTE;
			end
			TWO_BYTE:
			begin
				if(output_valid_reg_1)
				begin
					if(single_byte)
						nextstate_byte=ONE_BYTE;
					else nextstate_byte=TWO_BYTE;
				end
				else nextstate_byte=TWO_BYTE;
			end
			THREE_BYTE:
			begin
				if(output_valid_reg_1)
				begin
					if(single_byte)
						nextstate_byte=TWO_BYTE;
					else nextstate_byte=THREE_BYTE;
				end
				else nextstate_byte=THREE_BYTE;
			end
			default:nextstate_byte=TWO_BYTE;
		endcase
	end
	
	/* fsm */
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			state<=IDLE;
			//state<=GENERATE_FILE_HEADER;
		else state<=nextstate;
	end
	always@(*)
	begin
	    case(state)
			IDLE:
			begin
				if(codestream_generate_start)
				begin
					if(tile_counter==0)
						nextstate=GENERATE_FILE_HEADER;
					else nextstate=SOT;
				end
				else nextstate=IDLE;
			end
			GENERATE_FILE_HEADER:
			begin
				if(shift_file_header_over)
					nextstate=SOT;
				else nextstate=GENERATE_FILE_HEADER;
			end
			SOT:nextstate=LSOT;
			LSOT:nextstate=ISOT;
			ISOT:nextstate=PSOT_1;
			PSOT_1:nextstate=PSOT_2;
			PSOT_2:nextstate=TPSOT;
			TPSOT:nextstate=TNSOT;
			TNSOT:nextstate=SOD;
			SOD:nextstate=SOP;
			SOP:nextstate=LSOP;
			LSOP:nextstate=PACKET_INDEX;
			PACKET_INDEX:
			begin
				if(bit_rate_met)
					nextstate=EMPTY_PACKET;
				else nextstate=TAGTREE_CODE_BEGIN;
			end
			TAGTREE_CODE_BEGIN:nextstate=TAGTREE_CODING;
			TAGTREE_CODING:
			begin
				if(tagtree_coding_over)
					nextstate=SHIFT_CODEBLOCK_INFO;
				else nextstate=TAGTREE_CODING;
			end
			SHIFT_CODEBLOCK_INFO:
			begin
				if(one_subband_over)
				begin
					if(subband_counter==2||(packet_counter==0||packet_counter==1||packet_counter==2))
						nextstate=SHIFT_CODEBLOCK_INFO;
					else nextstate=TAGTREE_CODE_BEGIN;
				end
				else if(all_subband_over)
					nextstate=EPH;
				else nextstate=SHIFT_CODEBLOCK_INFO;
			end
			EPH:
			begin
				if(bit_rate_met)
					nextstate=ONE_PACKET_OVER;
				else nextstate=PACKET_DATA_READ_BEGIN;
			end
			PACKET_DATA_READ_BEGIN:nextstate=PACKET_DATA_READING;
			PACKET_DATA_READING:
			begin
				if(all_subband_over)
					nextstate=ONE_PACKET_OVER;
				else nextstate=PACKET_DATA_READING;
			end
			ONE_PACKET_OVER:
			begin
				if(packet_counter==17)
					nextstate=ALL_PACKET_OVER;
				else nextstate=NEXT_PACKET;
			end
			NEXT_PACKET:nextstate=SOP;
			EMPTY_PACKET:nextstate=EPH;
			ALL_PACKET_OVER:
			begin
				if(tile_counter==24)
					nextstate=EOC;
				else nextstate=OUTPUT_TOTAL_BYTE_NUMBER;
			end
			OUTPUT_TOTAL_BYTE_NUMBER:
			begin
				nextstate=ONE_TILE_OVER;
			end
			ONE_TILE_OVER:
			begin
				if(tile_counter==24)
					nextstate=CODESTREAM_GENERATE_OVER;
				else nextstate=IDLE;
			end
			
			EOC:
			begin
				if(state_byte==THREE_BYTE||state_byte==ONE_BYTE)
					nextstate=SHIFT_LAST_BYTE;
				else nextstate=WAIT_SHIFT_OVER;
			end
			SHIFT_LAST_BYTE:
				nextstate=WAIT_SHIFT_OVER;
			WAIT_SHIFT_OVER:
			begin
				if(shift_last_word&&output_count==2)
					nextstate=OUTPUT_TOTAL_BYTE_NUMBER;
				else nextstate=WAIT_SHIFT_OVER;
			end
			CODESTREAM_GENERATE_OVER:nextstate=CODESTREAM_GENERATE_OVER;
			

			default:nextstate=IDLE;
		endcase


	end
	
	
	
	

endmodule
