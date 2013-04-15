`timescale 1ns/10ps
module tier2_top(/*autoarg*/
    //input
    rd_clk, wr_clk, rst, data_from_mq, pass_plane, 
    compression_ratio, word_last_flag_plane_sp, word_last_flag_plane_mp, 
    word_last_flag_plane_cp, zero_plane_number, 
    one_codeblock_over, flush_over, pass_error_sp, 
    pass_error_mp, pass_error_cp, 

    //output
    output_address, write_en, rst_syn, output_to_fpga_32
);

parameter WORD_WIDTH=18,
			ADDR_WIDTH=14;
			

	input rd_clk;
	input wr_clk;
	input rst;
	input [15:0]data_from_mq;
	input [1:0]pass_plane ;
	input [2:0]compression_ratio;
	input word_last_flag_plane_sp;
	input word_last_flag_plane_mp;
	input word_last_flag_plane_cp;
	input [3:0]zero_plane_number;
	input one_codeblock_over;
	input flush_over;
	input [30:0]pass_error_sp;
	input [30:0]pass_error_mp;
	input [30:0]pass_error_cp;

	//output [31:0]codestream_output_32;
	output [31:0]output_address;
	output [3:0]write_en;
	output rst_syn;
	output [31:0]output_to_fpga_32;

	/***** codestream_generate *****/
	wire codestream_generate_over;
	wire [ADDR_WIDTH-1:0]lram_address_rd;
	wire [7:0]codeblock_counter;
	//wire [15:0]codestream_output;
	wire [31:0]codestream_output_32;
	wire [31:0]output_address;
	wire [3:0]write_en;
	wire rst_syn;
	wire [31:0]output_to_fpga_32;
	wire lram_read_en;
	/****** fifo_t1_t2 ******/
	wire [8:0]target_slope;
	wire	[WORD_WIDTH-1:0]	output_to_ram;
	wire	[ADDR_WIDTH-1:0]	lram_address_wr;
	wire			lram_write_en;
	wire buffer_all_over;
	wire codeblock_shift_over;
	wire [19:0]target_byte_number;
	/***** tier2_ram *****/
	wire [WORD_WIDTH-1:0]ldata_ram;
	/***** tier2_control *****/
	wire			codestream_generate_start;
	wire			cal_truncation_point_start;
	wire clk=rd_clk;
	wire [WORD_WIDTH-1:0]data_from_ram=ldata_ram;
	wire [30:0]pass_error_plane_sp=pass_error_sp;
	wire [30:0]pass_error_plane_mp=pass_error_mp;
	wire [30:0]pass_error_plane_cp=pass_error_cp;



	
	tier2_ram	tier2_ram (
		.rd_clk			(rd_clk),
		.laddr_rd		(lram_address_rd),
		.laddr_wr		(lram_address_wr),
		.output_to_ram	(output_to_ram),
		.lram_write_en	(lram_write_en),
		.lram_read_en	(lram_read_en),
		.ldata_ram		(ldata_ram),
		.rst_syn(rst_syn)
	);

	tier2_control tier2_control(/*autoinst*/
    .clk                        (clk                            ),
    .rst                        (rst                            ),
    .rst_syn                    (rst_syn                        ),
    .buffer_all_over            (buffer_all_over                ),
    .cal_truncation_point_over  (cal_truncation_point_over      ),
    .codestream_generate_over   (codestream_generate_over       ),
    .codestream_generate_start  (codestream_generate_start      ),
    .cal_truncation_point_start (cal_truncation_point_start     )
);

	codestream_generate	codestream_generate (/*autoinst*/
    .clk                        (clk                             ),
    .rst                        (rst                             ),
    .codeblock_shift_over       (codeblock_shift_over            ),
    .codestream_generate_start  (codestream_generate_start       ),
    .data_from_ram              (data_from_ram[WORD_WIDTH-1:0]   ),
    .target_slope               (target_slope[8:0]               ),
    .target_byte_number         (target_byte_number[19:0]        ),
    .codestream_generate_over   (codestream_generate_over        ),
    .codeblock_counter          (codeblock_counter[7:0]          ),
    .lram_read_en               (lram_read_en                    ),
    .lram_address_rd            (lram_address_rd[ADDR_WIDTH-1:0] ),
    .output_to_fpga_32          (output_to_fpga_32[31:0]         ),
    .output_address             (output_address[31:0]            ),
    .write_en                   (write_en[3:0]                   ),
    .rst_syn                    (rst_syn                         )
);
	

	fifo_t1_t2	fifo_t1_t2 (/*autoinst*/
    .flush_over                 (flush_over                      ),
    .zero_plane_number          (zero_plane_number[3:0]          ),
    .codeblock_counter          (codeblock_counter[7:0]          ),
    .wr_clk                     (wr_clk                          ),
    .rd_clk                     (rd_clk                          ),
    .rst                        (rst                             ),
    .rst_syn                    (rst_syn                         ),
    .data_from_mq               (data_from_mq[15:0]              ),
    .cal_truncation_point_start (cal_truncation_point_start      ),
    .compression_ratio                   (compression_ratio[2:0]                   ),
    .pass_plane                 (pass_plane[1:0]                 ),
    .word_last_flag_plane_sp    (word_last_flag_plane_sp         ),
    .word_last_flag_plane_mp    (word_last_flag_plane_mp         ),
    .word_last_flag_plane_cp    (word_last_flag_plane_cp         ),
    .one_codeblock_over         (one_codeblock_over              ),
    .pass_error_plane_sp        (pass_error_plane_sp[30:0]       ),
    .pass_error_plane_mp        (pass_error_plane_mp[30:0]       ),
    .pass_error_plane_cp        (pass_error_plane_cp[30:0]       ),
    .target_slope               (target_slope[8:0]               ),
    .codeblock_shift_over       (codeblock_shift_over            ),
    .cal_truncation_point_over  (cal_truncation_point_over       ),
    .output_to_ram              (output_to_ram[WORD_WIDTH-1:0]   ),
    .buffer_all_over            (buffer_all_over                 ),
    .lram_write_en              (lram_write_en                   ),
    .lram_address_wr            (lram_address_wr[ADDR_WIDTH-1:0] ),
    .target_byte_number         (target_byte_number[19:0]        )
);
endmodule
