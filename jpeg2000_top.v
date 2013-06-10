`timescale 1ns/10ps
module jpeg2000_top(/*autoport*/
//output
			write_en,
			output_address,
			addra_all_1,
			output_to_fpga_32,
			test_tier1,
			one_image_over,
//input
			clk_dwt,
			rst,
			start_cpu,
			douta_all_1,
			compression_ratio);



input clk_dwt;
//input clk_rc;

input rst;
input start_cpu;
input [31:0]douta_all_1;
input [2:0]compression_ratio;

output [3:0]write_en;
output [31:0]output_address;
output [17:0] addra_all_1;
output [31:0]output_to_fpga_32;
output test_tier1;
output one_image_over;

wire [15:0]data_from_mq;				
wire [1:0]pass_plane;									
wire word_last_flag_plane_sp;				
wire word_last_flag_plane_mp;					
wire word_last_flag_plane_cp;					
wire [3:0]zero_plane_number;
wire one_codeblock_over;
wire flush_over;
wire [30:0]pass_error_sp;
wire [30:0]pass_error_mp;
wire [30:0]pass_error_cp;
wire [17:0] addra_all_1;
wire [31:0]output_address;
wire [3:0]write_en;
wire rst_syn;
wire test_tier1;

wire [31:0]output_to_fpga_32;

Tier_1_top		u_Tier_1_top(//Outputs
						.data_from_mq(data_from_mq),						
						.pass_plane(pass_plane),												
						.word_last_flag_plane_sp(word_last_flag_plane_sp),						
						.word_last_flag_plane_mp(word_last_flag_plane_mp),						
						.word_last_flag_plane_cp(word_last_flag_plane_cp),						
						.zero_plane_number(zero_plane_number),						
						.one_codeblock_over(one_codeblock_over),						
						.flush_over(flush_over),						
						.pass_error_sp(pass_error_sp),						
						.pass_error_mp(pass_error_mp),						
						.pass_error_cp(pass_error_cp),												
						.addra_all_1(addra_all_1),
						//Inputs
						.compression_ratio(compression_ratio),
						.douta_all_1(douta_all_1),
						.clk_dwt(clk_dwt),
						//.clk_rc(clk_rc),
				
						.rst(rst),
                        .start_cpu(start_cpu),
						.rst_syn(rst_syn),
						.test_tier1(test_tier1));	
						
tier2_top		U_tier2_top(	//Inputs
						.rd_clk                     (clk_dwt                         ),
						.wr_clk                     (clk_dwt                         ),
						.rst                        (rst                            ),
						.data_from_mq               (data_from_mq[15:0]             ),
						.pass_plane                 (pass_plane[1:0]                ),
						.compression_ratio          (compression_ratio[2:0]         ),
						.word_last_flag_plane_sp    (word_last_flag_plane_sp        ),
						.word_last_flag_plane_mp    (word_last_flag_plane_mp        ),
						.word_last_flag_plane_cp    (word_last_flag_plane_cp        ),
						.zero_plane_number          (zero_plane_number[3:0]         ),
						.one_codeblock_over         (one_codeblock_over             ),
						.flush_over                 (flush_over                     ),
						.pass_error_sp              (pass_error_sp[30:0]            ),
						.pass_error_mp              (pass_error_mp[30:0]            ),
						.pass_error_cp              (pass_error_cp[30:0]            ),
						//Output
						.output_address             (output_address[31:0]           ),
						.write_en                   (write_en[3:0]                  ),
						.rst_syn                    (rst_syn                        ),
						.output_to_fpga_32          (output_to_fpga_32[31:0]        ),
						.one_image_over(one_image_over));
endmodule 						


												
