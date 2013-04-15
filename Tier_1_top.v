//==================================================================================================
//  Filename      : Tier_1_top.v
//  Created On    : 2013-04-04 21:43:33
//  Last Modified : 2013-04-06 14:43:19
//  Revision      : 
//  Author        : Tian Changsong
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns/10ps
module Tier_1_top(/*autoport*/
//output
			data_from_mq,
			pass_plane,
			word_last_flag_plane_sp,
			word_last_flag_plane_mp,
			word_last_flag_plane_cp,
			zero_plane_number,
			one_codeblock_over,
			flush_over,
			pass_error_sp,
			pass_error_mp,
			pass_error_cp,
			ena_all_1,
			wea_all_1,
			addra_all_1,
			test_tier1,
//input
			douta_all_1,
			clk_dwt,
			rst,
			start_cpu,
			rst_syn,
			compression_ratio);

input [31:0]douta_all_1;											
input clk_dwt;										

//input clk_rc;										
input rst;
input start_cpu;									
input rst_syn;										
input [2:0]compression_ratio;

wire clk_rc=clk_dwt;
					
output [15:0]data_from_mq;				
output [1:0]pass_plane;
//output [2:0]compression_ratio;									
output word_last_flag_plane_sp;				
output word_last_flag_plane_mp;					
output word_last_flag_plane_cp;					
output [3:0]zero_plane_number;
output one_codeblock_over;
output flush_over;
output [30:0]pass_error_sp;
output [30:0]pass_error_mp;
output [30:0]pass_error_cp;


output ena_all_1;
output [3:0]wea_all_1;
output[17:0] addra_all_1;
output test_tier1;

wire [3:0]wea_all_1;
wire ena_all_1;
wire [17:0] addra_all_1;
wire [3:0]count_bp;
wire start_aga; 
wire bit_enough_to_bpc;

wire [16:0] dina_o1;
wire [16:0] dina_o2;
wire [13:0] addra_o1;
wire [13:0] addra_o2;
wire ena_o1;
wire ena_o2;
wire wea_o1;
wire wea_o2; 
wire start;
wire test_tier1;
wire clk_sg;
reg [31:0]douta_all_1_reg;//data from sram,for test
always @(posedge clk_dwt or negedge rst)
begin
	if (!rst) 
	begin
		douta_all_1_reg<=0;		
	end
	else  
	begin
		douta_all_1_reg<=douta_all_1;
	end
end
assign test_tier1=clk_dwt&&start&&clk_sg&&(&douta_all_1_reg);




wire [15:0] odd_data_raw;
wire [15:0] even_data_raw;
wire [16:0] douta_o1;
wire [16:0] douta_o2;
wire [2:0] level;
wire [1:0] wr_over;
wire dwt_work;

wire [15:0] row_ldata;
wire [15:0] row_hdata;
wire row_out_vld;
wire [15:0] odd_data;
wire [15:0] even_data;
wire start_cf;
wire ce0_ctrl;
wire[16:0] quant_out_h;
wire[16:0] quant_out_l;
wire quant_out_vld;

wire[1:0]unvalid_cnt;	
wire[16:0] douta_64;
wire[16:0] doutb_64;					
wire[16:0] douta_1;
wire[16:0] doutb_1;
wire [16:0]	 dina_1;			
wire [16:0]	 dina_64;				
wire [16:0]	 dina_2;			
wire [16:0]	 dina_3;
wire [16:0]	 dina_4;			
wire [11:0] addra_64;
wire [11:0] addrb_64;
wire [13:0] addra_1;
wire [13:0] addrb_1; 
wire wea_64;
wire web_64;
wire wea_1;
wire web_1;											
wire ena_64;
wire enb_64;
wire ena_1;
wire enb_1;
wire [13:0] addra_o1_r;
wire [13:0] addra_o1_w;
wire [13:0] addra_o2_r;
wire [13:0] addra_o2_w;
wire wea_o1_r;
wire wea_o1_w;
wire wea_o2_r;
wire wea_o2_w;
wire ena_o1_r;
wire ena_o1_w;
wire ena_o2_r;
wire ena_o2_w;
//assign addra_o1 = (start_test == 1)? addra_o1_r:addra_o1_w;
//assign addra_o2 = (start_test == 1)? addra_o2_r:addra_o2_w;
//assign wea_o1 = (start_test == 1)? wea_o1_r:wea_o1_w;
//assign wea_o2 = (start_test == 1)? wea_o2_r:wea_o2_w;
//assign ena_o1 = (start_test == 1)? ena_o1_r:ena_o1_w;
//assign ena_o2 = (start_test == 1)? ena_o2_r:ena_o2_w;

wire bpc_start;
wire bpc_start_reg;
wire[15:0] odd_data_normal;
wire[15:0] even_data_normal;
wire sel;
assign sel = (level !=3'b000);
assign odd_data = (sel == 1)? odd_data_normal:odd_data_raw;
assign even_data = (sel == 1)? even_data_normal:even_data_raw;
wire [16:0]douta_2;
wire [16:0]douta_3;
wire [16:0]douta_4;
wire[16:0] doutb_o1;
wire[16:0] doutb_o2;

wire ena_2_m;
wire ena_3_m;
wire ena_4_m;
wire wea_2_m;
wire wea_3_m;
wire wea_4_m;
wire [13:0] addra_2_m;
wire [13:0] addra_3_m;
wire [13:0] addra_4_m;
wire ena_2_b;
wire ena_3_b;
wire ena_4_b;
wire [13:0] addra_2_b;
wire [13:0] addra_3_b;
wire [13:0] addra_4_b;
wire ena_1_b;
wire ena_1_m;
wire wea_1_b;
wire wea_1_m;
wire [13:0] addra_1_b;
wire [13:0] addra_1_m;
wire clka;
//*********************  ram_1 control  ***********************//
assign  clka=(bpc_start_reg==1'b1)?clk_rc:clk_dwt;
assign  addra_1=(bpc_start_reg==1'b1)?addra_1_b:addra_1_m;
assign  ena_1=(bpc_start_reg==1'b1)?ena_1_b:ena_1_m;
assign  wea_1=(bpc_start_reg==1'b1)?wea_1_b:wea_1_m;
//*************************************************************//

wire rf_over;
wire [3:0]block_count_0_lh_y;
wire [3:0]block_count_0_lh_u;
wire [3:0]block_count_0_lh_v;
wire [3:0]block_count_0_hl_y;
wire [3:0]block_count_0_hl_u;
wire [3:0]block_count_0_hl_v;
wire [3:0]block_count_0_hh_y;
wire [3:0]block_count_0_hh_u;
wire [3:0]block_count_0_hh_v;  
wire [3:0]block_count_1_lh_y;
wire [3:0]block_count_1_lh_u;
wire [3:0]block_count_1_lh_v;
wire [3:0]block_count_1_hl_y;
wire [3:0]block_count_1_hl_u;
wire [3:0]block_count_1_hl_v;
wire [3:0]block_count_1_hh_y;
wire [3:0]block_count_1_hh_u;
wire [3:0]block_count_1_hh_v;  
wire [3:0]block_count_2_lh_y;
wire [3:0]block_count_2_lh_u;
wire [3:0]block_count_2_lh_v;
wire [3:0]block_count_2_hl_y;
wire [3:0]block_count_2_hl_u;
wire [3:0]block_count_2_hl_v;
wire [3:0]block_count_2_hh_y;
wire [3:0]block_count_2_hh_u;
wire [3:0]block_count_2_hh_v; 
wire [3:0]block_count_3_lh_y;
wire [3:0]block_count_3_lh_u;
wire [3:0]block_count_3_lh_v;
wire [3:0]block_count_3_hl_y;
wire [3:0]block_count_3_hl_u;
wire [3:0]block_count_3_hl_v;
wire [3:0]block_count_3_hh_y;
wire [3:0]block_count_3_hh_u;
wire [3:0]block_count_3_hh_v;
wire [3:0]block_count_4_lh_y;
wire [3:0]block_count_4_lh_u;
wire [3:0]block_count_4_lh_v;
wire [3:0]block_count_4_hl_y;
wire [3:0]block_count_4_hl_u;
wire [3:0]block_count_4_hl_v;
wire [3:0]block_count_4_hh_y;
wire [3:0]block_count_4_hh_u;
wire [3:0]block_count_4_hh_v;
wire [3:0]block_count_4_ll_y;
wire [3:0]block_count_4_ll_u;
wire [3:0]block_count_4_ll_v;
//子带位平面数
//wire [3:0]block_count_0_hl;
//wire [3:0]block_count_0_lh;
//wire [3:0]block_count_0_hh;
//wire [3:0]block_count_1_hl;
//wire [3:0]block_count_1_lh;
//wire [3:0]block_count_1_hh;
//wire [3:0]block_count_2_hl;
//wire [3:0]block_count_2_lh;
//wire [3:0]block_count_2_hh;
//wire [3:0]block_count_3_hl;
//wire [3:0]block_count_3_lh;
//wire [3:0]block_count_3_hh;
//wire [3:0]block_count_4_hl;
//wire [3:0]block_count_4_lh;
//wire [3:0]block_count_4_hh;
//wire [3:0]block_count_4_ll;

wire [16:0] data_out1;
wire [16:0] data_out2;
wire [16:0] data_out3;
wire [16:0] data_out4;
wire [1:0] count_YUV;
wire stripe_over_delay;
wire [2:0]level_reg;
wire [2:0]level_delay;
wire last_stripe_vld_delay;
wire stop_delay4;
wire code_over_delay;
wire bpc_start_delay;
wire [1:0]band;
wire [3:0]zero_bp_count;

wire [3:0]bp_data1_state;
wire [3:0]bp_data2_state;
wire [3:0]bp_data3_state;
wire [3:0]bp_data4_state;
wire stripe_over_flag;
wire [2:0]level_flag;
wire last_stripe_vld;
wire stop_flag;
wire bpc_start_flag;
wire code_over_flag;
wire [3:0]top_plane;
wire stall_vld;
wire halt;
wire halt_to_fifo;

wire [7:0] arrange_out0;
wire [7:0] arrange_out1;
wire [7:0] arrange_out2;
wire [7:0] arrange_out3;
wire [7:0] arrange_out4;
wire [7:0] arrange_out5;
wire [7:0] arrange_out6;
wire [7:0] arrange_out7;
wire [7:0] arrange_out8;
wire [7:0] arrange_out9;
wire [3:0] vld_num;
wire flush;
wire flush_mq2;
wire [9:0]wrfull;
wire [9:0]wr_vld;
wire [9:0] rd_vld;
wire [9:0] rdempty;

wire [7:0] fifo_in0;
wire [7:0] fifo_in1;
wire [7:0] fifo_in2;
wire [7:0] fifo_in3;
wire [7:0] fifo_in4;
wire [7:0] fifo_in5;
wire [7:0] fifo_in6;
wire [7:0] fifo_in7;
wire [7:0] fifo_in8;
wire [7:0] fifo_in9;
wire [7:0] fifo_out;
wire [7:0] fifo_out0;
wire [7:0] fifo_out1;
wire [7:0] fifo_out2;
wire [7:0] fifo_out3;
wire [7:0] fifo_out4;
wire [7:0] fifo_out5;
wire [7:0] fifo_out6;
wire [7:0] fifo_out7;
wire [7:0] fifo_out8;
wire [7:0] fifo_out9;
wire[2:0] pass_judge_1;
wire[2:0] pass_judge_2;
wire[2:0] pass_judge_3;
wire[2:0] pass_judge_4;

wire  bit1_add_vld;
wire  bit2_add_vld;
wire  bit3_add_vld;
wire  bit4_add_vld;
wire  [15:0]MQ_out; //from fifo
wire  word_last_flag;
wire [1:0] data_valid_pass_reg;
wire  flush_over;
wire [1:0]word_last_valid;
wire block_all_bp_over;
wire stop_rd;
wire one_codeblock_over;
wire [1:0] Y_U_V_over;
wire[16:0] bit1_nmsedec;	
wire[16:0] bit2_nmsedec;
wire[16:0] bit3_nmsedec;
wire[16:0] bit4_nmsedec;
wire[3:0] mul_factor_error;
wire stop_d;	
wire clear0;
wire pass_error_start;
wire [2:0]pass_judge_1_d;
wire [2:0]pass_judge_2_d;								
wire [2:0]pass_judge_3_d;
wire [2:0]pass_judge_4_d;
wire [3:0]count_bp_to_genere;	

// mine start
//wire rst_n=~rst;
wire entropy_calc_over;
// initial
// begin
	// $fsdbDumpfile("wave.fsdb");
	// $fsdbDumpvars(4,test);
// end
// always #10000 $display($time);

wire[16:0]data_LL=doutb_1;
wire[16:0]data_LH=douta_3;		//notice RAM2 and RAM3 sequence
wire[16:0]data_HL=douta_2;      //notice RAM2 and RAM3 sequence 
wire[16:0]data_HH=douta_4;
wire      [13:0]                              address_HH;
wire      [13:0]                              address_HL;
wire      [13:0]                              address_LH;
wire      [13:0]                              address_LL;
wire [13:0]address_LL_sel=addrb_1|address_LL;
wire [13:0]address_HL_sel=entropy_calc_over?addra_2_b:address_HL;
wire [13:0]address_LH_sel=entropy_calc_over?addra_3_b:address_LH;
wire [13:0]address_HH_sel=entropy_calc_over?addra_4_b:address_HH;
wire                                    read_en_HL;
wire                                    read_en_LH;
wire                                    read_en_LL;
wire                                    read_en_HH;
wire en_sel_HH=entropy_calc_over?ena_4_b:read_en_HH;
wire en_sel_LH=entropy_calc_over?ena_3_b:read_en_LH;
wire en_sel_HL=entropy_calc_over?ena_2_b:read_en_HL;
wire en_sel_LL=enb_1||read_en_LL;
wire clk=clk_rc;

//wire rst_syn;
//wire [31:0]output_address;
//wire rd_clk=clk_dwt;
//wire wr_clk=clk_dwt;
wire [15:0]data_from_mq={MQ_out[7:0],MQ_out[15:8]};
wire [1:0]pass_plane=data_valid_pass_reg;
wire word_last_sp;
wire word_last_mrp;
wire word_last_cp;
wire word_last_flag_plane_sp=word_last_sp;
wire word_last_flag_plane_mp=word_last_mrp;
wire word_last_flag_plane_cp=word_last_cp;
wire [3:0]zero_plane_number=zero_bp_count;
//wire [3:0]write_en;
wire [30:0]pass_error_sp;
wire [30:0]pass_error_mrp;
wire [30:0]pass_error_mp=pass_error_mrp;
wire [30:0]pass_error_cp;
//wire [2:0]compression_ratio=0;
//0: 5
//1: 10
//2: 20
//3: 40
//4: 80







// reg [1:0]start_count;
// reg	start_cpu_reg1;
// reg start_cpu_reg2;
// reg	start_cpu_reg3;
// reg	start_cpu_reg4;
// reg start_reg1;
// reg	start_reg2;
// reg	start_reg3;
// reg	start_reg4;

// always@(posedge clk_dwt or negedge rst)
// begin
    // if(!rst)
		// start_count<=0;
	// else if(!clk_sg)
		// start_count<=0;
	// else if(clk_sg)
		// start_count<=start_count+1;
// end
// always@(posedge clk_dwt or negedge rst)
// begin
	// if(!rst)
	// begin
		// start_cpu_reg1<=0;
		// start_cpu_reg2<=0;
		// start_cpu_reg3<=0;
		// start_cpu_reg4<=0;
	// end
	// else 
	// begin		
		// start_cpu_reg1<=start_cpu;
		// start_cpu_reg2<=start_cpu_reg1;
		// start_cpu_reg3<=start_cpu_reg2;
		// start_cpu_reg4<=start_cpu_reg3;
	// end
// end
// always@(posedge clk_dwt or negedge rst)
// begin
	// if(!rst)
	// begin
		// start_reg2<=0;
		// start_reg3<=0;
		// start_reg4<=0;
	// end
	// else 
	// begin		
		// start_reg2<=start_reg1;
		// start_reg3<=start_reg2;
		// start_reg4<=start_reg3;
	// end
// end

// always@(posedge clk_dwt or negedge rst)
// begin
    // if(!rst)
		// start_reg1<=0;
	// else if(start_count==2&&(start_cpu_reg1||start_cpu_reg2||start_cpu_reg3||start_cpu_reg4))
		// start_reg1<=1;
	// else start_reg1<=0;
// end
// assign start=start_reg1||start_reg2||start_reg3||start_reg4;







wire tier1_over=code_over_flag;
wire [13:0]byte_number_codeblock;
wire [13:0]song_require=byte_number_codeblock;
reg [1:0]div_counter;
always@(posedge clk_dwt or negedge rst)
begin
	if(!rst)
		div_counter<=0;
	else div_counter<=div_counter+1;
end
assign clk_sg=div_counter[1];
//mine start
	entropy_calc entropy_calc(/*autoinst*/
    .clk                        (clk                            ),
    .rst                        (rst                            ),
	.rst_syn					(rst_syn						),
    .data_HH                    (data_HH[16:0]                  ),
    .data_LH                    (data_LH[16:0]                  ),
    .data_HL                    (data_HL[16:0]                  ),
    .data_LL                    (data_LL[16:0]                  ),
    .Y_U_V_over                 (Y_U_V_over[1:0]                ),
    .tier1_over                 (tier1_over                     ),
    .one_codeblock_over         (one_codeblock_over             ),
    .compression_ratio          (compression_ratio[2:0]         ),
    
	.bpc_start                  (bpc_start                      ),
    .entropy_calc_over          (entropy_calc_over              ),
    .read_en_LL                 (read_en_LL                     ),
    .read_en_HL                 (read_en_HL                     ),
    .read_en_LH                 (read_en_LH                     ),
    .read_en_HH                 (read_en_HH                     ),
    .address_LL                 (address_LL[13:0]               ),
    .address_LH                 (address_LH[13:0]               ),
    .address_HL                 (address_HL[13:0]               ),
    .address_HH                 (address_HH[13:0]               ),
    .byte_number_codeblock      (byte_number_codeblock[13:0]    )
);
//mine end
 // putdata		u_putdata(	.dina_o1 (dina_o1),
 //                        .dina_o2 (dina_o2),
 //                        .addra_o1_w(addra_o1_w),
 //                        .addra_o2_w(addra_o2_w),
 //                        .ena_o1_w(ena_o1_w),
 //                        .ena_o2_w(ena_o2_w),
 //                        .wea_o1_w(wea_o1_w),
 //                        .wea_o2_w(wea_o2_w),
 //                        //input       
	// 					.start(start),
	// 					.clk(clk_dwt),
 //                        .rst(rst),
 //                       .rst_syn(rst_syn) );
processing   u_processing(/*autoinst*/
			.addra_all_1(addra_all_1[17:0]),
			.dina_o1(dina_o1[16:0]),
			.dina_o2(dina_o2[16:0]),
			.addra_o1_w(addra_o1_w[13:0]),
			.addra_o2_w(addra_o2_w[13:0]),
			.wea_o1_w(wea_o1_w),
			.wea_o2_w(wea_o2_w),
			.ena_o1_w(ena_o1_w),
			.ena_o2_w(ena_o2_w),
			.start(start),
			.douta_all_1(douta_all_1[31:0]),
			.start_cpu(start_cpu),
			.clk_dwt(clk_dwt),
			.clk_sg(clk_sg),
			.rst(rst),
			.rst_syn(rst_syn));

// putdata u_putdata(	
// 							//output
// 							.dina_o1(dina_o1),
// 							.dina_o2(dina_o2),
// 							.addra_o1_w(addra_o1_w),
// 							.addra_o2_w(addra_o2_w),
// 							.ena_o1_w(ena_o1_w),
// 							.ena_o2_w(ena_o2_w),
// 							.wea_o1_w(wea_o1_w),
// 							.wea_o2_w(wea_o2_w),
// 							.start(start),
// 							//input
// 							.clk_dwt(clk_dwt),
// 							.clk_sg(clk_sg),
// 							.rst(rst),
// 							.start_cpu(start_cpu),
// 							.rst_syn(rst_syn));


read_raw_control	u_read_raw_control( .addra_o1_r(addra_o1_r),
										.addra_o2_r(addra_o2_r),
										.ena_o1_r(ena_o1_r),
										.ena_o2_r(ena_o2_r),
										.wea_o1_r(wea_o1_r),
										.wea_o2_r(wea_o2_r),
										.odd_data_raw (odd_data_raw),		
										.even_data_raw (even_data_raw),	
										//input		
										.dout_o1(doutb_o1),
										.dout_o2(doutb_o2),
										.level(level),	
										.wr_over(wr_over),	
										.start(start),	
										.dwt_work(dwt_work),
										.rf_over(rf_over),
										.clk_mmu(clk_dwt),	
                                        .rst(rst),
										.rst_syn(rst_syn));

flu   u_flu( .row_ldata(row_ldata),
             .row_hdata(row_hdata),
             .row_out_vld(row_out_vld), 	   					
			 //input					
			 .odd_data(odd_data),				
			 .even_data(even_data),					
			 .start_cf(start_cf),					
			 .level(level),					
			 .dwt_work(dwt_work),
			 .rf_over(rf_over),			 
			 .clk_flu(clk_dwt),					
			 .rst(rst),
			 .rst_syn(rst_syn));
			 
mmu		u_mmu(	//OUT 
				.dina_64(dina_64),
				.dina_1(dina_1),
				.dina_2(dina_3),	//notice RAM2 and RAM3 sequence
				.dina_3(dina_2),	//notice RAM2 and RAM3 sequence
				.dina_4(dina_4),
				.addra_64(addra_64),
				.addrb_64(addrb_64),
				.addra_1(addra_1_m),
				.addrb_1(addrb_1),
				.addra_2(addra_2_m),
				.addra_3(addra_3_m),
				.addra_4(addra_4_m),
				.wea_64(wea_64),
				.web_64(web_64),
				.wea_1(wea_1_m),
				.web_1(web_1),
				.wea_2(wea_2_m),
				.wea_3(wea_3_m),
				.wea_4(wea_4_m),
				.ena_64(ena_64),
				.enb_64(enb_64),
				.ena_1(ena_1_m),
				.enb_1(enb_1),
				.ena_2(ena_2_m),
				.ena_3(ena_3_m),
				.ena_4(ena_4_m),
				.odd_data(odd_data_normal),
				.even_data(even_data_normal),
				.start_cf(start_cf),
				.level(level),
				.wr_over(wr_over),		
				.ce0_ctrl(ce0_ctrl),
				.unvalid_cnt(unvalid_cnt),
				.dwt_work(dwt_work),
				.Y_U_V_over(Y_U_V_over),
				//input	
				.bpc_start(bpc_start),				
				.douta_64(douta_64),
				.doutb_64(doutb_64),
				.douta_1(douta_1),
				.doutb_1(doutb_1),
				.quant_out_l(quant_out_l),
				.quant_out_h(quant_out_h),
				.quant_out_vld(quant_out_vld),
				.start(start),
				.clk_mmu(clk_dwt),
				.rst(rst),
				.rst_syn(rst_syn));
					
quant_circuit	u_quant_circuit(	.quant_out_h(quant_out_h),		
                                    .quant_out_l(quant_out_l),
                                    .quant_out_vld(quant_out_vld),
									//input					
									.row_ldata(row_ldata),				
									.row_hdata(row_hdata),					
									.row_out_vld(row_out_vld),					
									.dwt_work(dwt_work),				
									.ce0_ctrl(ce0_ctrl),		
									.level(level),	
									.clk_qk(clk_dwt),		
									.rst(rst),
									.rst_syn(rst_syn));		

ram_16k_normal   u_o1(
	                   .clka (clk_dwt),
	                   .ena (ena_o1_w),
	                   .wea (wea_o1_w),
	                   .addra (addra_o1_w),
	                   .dina (dina_o1),
	                   .douta (douta_o1),
	                   .clkb (clk_dwt),
	                   .enb (ena_o1_r),
	                   .web (wea_o1_r),
	                   .addrb (addra_o1_r),
	                   .dinb (17'b0),
	                   .doutb(doutb_o1));
					 
ram_16k_normal   u_o2(
	                   .clka (clk_dwt),
	                   .ena (ena_o2_w),
	                   .wea (wea_o2_w),
	                   .addra (addra_o2_w),
	                   .dina (dina_o2),
	                   .douta (douta_o2),
	                   .clkb (clk_dwt),
	                   .enb (ena_o2_r),
	                   .web (wea_o2_r),
	                   .addrb (addra_o2_r),
	                   .dinb (17'b0),
	                   .doutb(doutb_o2));

ram_4k       u_64(
	                 .clka (clk_dwt),
	                 .ena (ena_64),
	                 .wea (wea_64),
	                 .addra (addra_64),
	                 .dina (dina_64),
	                 .douta (douta_64),
	                 .clkb (clk_dwt),
	                 .enb (enb_64),
	                 .web (web_64),
	                 .addrb (addrb_64),
	                 .dinb (17'b0),
	                 .doutb(doutb_64));

ram_16k_normal  u_1(
	                 .clka (clka),
	                 .ena (ena_1),
	                 .wea (wea_1),
	                 .addra (addra_1),
	                 .dina (dina_1),
	                 .douta (douta_1),
	                 .clkb (clk_dwt),
	                 .enb (en_sel_LL),
	                 .web (web_1),
	                 .addrb (address_LL_sel),
	                 .dinb (17'b0),
	                 .doutb(doutb_1));

ram_dual_port  u_2(
	                 .clka (clk_dwt),
	                 .ena (ena_2_m),
	                 .wea (wea_2_m),
	                 .addra (addra_2_m),
	                 .dina (dina_2),
	                 .clkb (clk_rc),
	                 .enb (en_sel_HL),
	                 .addrb (address_HL_sel),
	                 .doutb(douta_2));

ram_dual_port  u_3(
	                 .clka (clk_dwt),
	                 .ena (ena_3_m),
	                 .wea (wea_3_m),
	                 .addra (addra_3_m),
	                 .dina (dina_3),
	                 .clkb (clk_rc),
	                 .enb (en_sel_LH),
	                 .addrb (address_LH_sel),
	                 .doutb(douta_3));
					 
ram_dual_port  u_4(
	                 .clka (clk_dwt),
	                 .ena (ena_4_m),
	                 .wea (wea_4_m),
	                 .addra (addra_4_m),
	                 .dina (dina_4),
	                 .clkb (clk_rc),
	                 .enb (en_sel_HH),
	                 .addrb (address_HH_sel),
	                 .doutb(douta_4));	
					 
bit_plane_count		u_bit_plane_count(  //out
										.block_count_0_lh_y(block_count_0_lh_y),
										.block_count_0_lh_u(block_count_0_lh_u),
										.block_count_0_lh_v(block_count_0_lh_v),
										.block_count_0_hl_y(block_count_0_hl_y),
										.block_count_0_hl_u(block_count_0_hl_u),
										.block_count_0_hl_v(block_count_0_hl_v),
										.block_count_0_hh_y(block_count_0_hh_y),
										.block_count_0_hh_u(block_count_0_hh_u),
										.block_count_0_hh_v(block_count_0_hh_v),
										.block_count_1_lh_y(block_count_1_lh_y),
										.block_count_1_lh_u(block_count_1_lh_u),
										.block_count_1_lh_v(block_count_1_lh_v),
										.block_count_1_hl_y(block_count_1_hl_y),
										.block_count_1_hl_u(block_count_1_hl_u),
										.block_count_1_hl_v(block_count_1_hl_v),
										.block_count_1_hh_y(block_count_1_hh_y),
										.block_count_1_hh_u(block_count_1_hh_u),
										.block_count_1_hh_v(block_count_1_hh_v),
										.block_count_2_lh_y(block_count_2_lh_y),
										.block_count_2_lh_u(block_count_2_lh_u),
										.block_count_2_lh_v(block_count_2_lh_v),
										.block_count_2_hl_y(block_count_2_hl_y),
										.block_count_2_hl_u(block_count_2_hl_u),
										.block_count_2_hl_v(block_count_2_hl_v),
										.block_count_2_hh_y(block_count_2_hh_y),
										.block_count_2_hh_u(block_count_2_hh_u),
										.block_count_2_hh_v(block_count_2_hh_v),
										.block_count_3_lh_y(block_count_3_lh_y),
										.block_count_3_lh_u(block_count_3_lh_u),
										.block_count_3_lh_v(block_count_3_lh_v),
										.block_count_3_hl_y(block_count_3_hl_y),
										.block_count_3_hl_u(block_count_3_hl_u),
										.block_count_3_hl_v(block_count_3_hl_v),
										.block_count_3_hh_y(block_count_3_hh_y),
										.block_count_3_hh_u(block_count_3_hh_u),
										.block_count_3_hh_v(block_count_3_hh_v),
										.block_count_4_lh_y(block_count_4_lh_y),
										.block_count_4_lh_u(block_count_4_lh_u),
										.block_count_4_lh_v(block_count_4_lh_v),
										.block_count_4_hl_y(block_count_4_hl_y),
										.block_count_4_hl_u(block_count_4_hl_u),
										.block_count_4_hl_v(block_count_4_hl_v),
										.block_count_4_hh_y(block_count_4_hh_y),
										.block_count_4_hh_u(block_count_4_hh_u),
										.block_count_4_hh_v(block_count_4_hh_v),
										.block_count_4_ll_y(block_count_4_ll_y),
										.block_count_4_ll_u(block_count_4_ll_u),
										.block_count_4_ll_v(block_count_4_ll_v),
										//.block_count_0_hl(block_count_0_hl),
										//.block_count_0_lh(block_count_0_lh),
										//.block_count_0_hh(block_count_0_hh),
										//.block_count_1_hl(block_count_1_hl),
										//.block_count_1_lh(block_count_1_lh),
										//.block_count_1_hh(block_count_1_hh),
										//.block_count_2_hl(block_count_2_hl),
										//.block_count_2_lh(block_count_2_lh),
										//.block_count_2_hh(block_count_2_hh),
										//.block_count_3_hl(block_count_3_hl),
										//.block_count_3_lh(block_count_3_lh),
										//.block_count_3_hh(block_count_3_hh),
										//.block_count_4_hl(block_count_4_hl),
										//.block_count_4_lh(block_count_4_lh),
										//.block_count_4_hh(block_count_4_hh),
										//.block_count_4_ll(block_count_4_ll),
										// in
									   .clk_mmu(clk_dwt),	
                                       .rst(rst),		 
                                       .quant_out_vld(quant_out_vld), 
									   .dina_1(dina_1),
                                       .dina_2(dina_3), //notice RAM2 and RAM3 sequence
                                       .dina_3(dina_2), //notice RAM2 and RAM3 sequence
                                       .dina_4(dina_4),
									   .unvalid_cnt(unvalid_cnt),
									   .level(level),
									   .rst_syn(rst_syn)); 

											
bpc_read_control	u_bpc_read_control(	.data_out1(data_out1),
                                        .data_out2(data_out2),
                                        .data_out3(data_out3),
                                        .data_out4(data_out4),
                                        .addra_2(addra_2_b),
                                        .addra_3(addra_3_b),
                                        .addra_4(addra_4_b),
                                        .addra_1(addra_1_b), 
                                        .wea_1(wea_1_b),
                                        .ena_2(ena_2_b),
                                        .ena_3(ena_3_b),
                                        .ena_4(ena_4_b),
                                        .ena_1(ena_1_b),
                                        .bpc_start_reg(bpc_start_reg),
										.count_YUV(count_YUV),
										.band(band),
										.stripe_over_delay(stripe_over_delay),
										.level_reg(level_reg),
										.level_delay(level_delay),
										.last_stripe_vld_delay(last_stripe_vld_delay),
										.stop_delay4(stop_delay4),
										.code_over_delay(code_over_delay),
										.bpc_start_delay(bpc_start_delay),
										.count_bp(count_bp),
										.halt(halt),
										.halt_to_fifo(halt_to_fifo),
										.block_all_bp_over(block_all_bp_over),
										.zero_bp_count(zero_bp_count),
										.count_bp_to_genere(count_bp_to_genere),										
										//in
										.top_plane(top_plane),
										.stall_vld(stall_vld),
                                        .douta_1(douta_1),	
                                        .douta_2(douta_2),
                                        .douta_3(douta_3),
                                        .douta_4(douta_4),	
                                        .bpc_start(bpc_start),
                                        .clk_rc(clk_rc),		
                                        .rst(rst),	
										.start_aga_song(start_aga),
										.bpc_halt_T2(bit_enough_to_bpc),
										.flush_over(flush_over),
										.rst_syn(rst_syn),
										.clk_sg(clk_sg));

bpc_state_generate	u_bpc_state_generate(	//output
											.bp_data1_state(bp_data1_state),
											.bp_data2_state(bp_data2_state), 
											.bp_data3_state(bp_data3_state), 
											.bp_data4_state(bp_data4_state),
											.stripe_over_flag(stripe_over_flag),
											.level_flag(level_flag),
											.last_stripe_vld(last_stripe_vld),
											.stop_flag(stop_flag),
											.bpc_start_flag(bpc_start_flag),
											.code_over_flag(code_over_flag),
											.top_plane(top_plane),
											//input 
											.pass_judge_1(pass_judge_1_d),
											.pass_judge_2(pass_judge_2_d),
											.pass_judge_3(pass_judge_3_d),
											.pass_judge_4(pass_judge_4_d),
											.bit1_nmsedec(bit1_nmsedec),
											.bit2_nmsedec(bit2_nmsedec),
											.bit3_nmsedec(bit3_nmsedec),
											.bit4_nmsedec(bit4_nmsedec),
											.mul_factor_error(mul_factor_error),											
											.count_bp(count_bp),
											.bpc_start_delay(bpc_start_delay),
											.code_over_delay(code_over_delay),
											.stall_vld(stall_vld),
											.last_stripe_vld_delay(last_stripe_vld_delay),
											.level_reg(level_reg),
											.level_delay(level_delay),
											.stripe_over_delay(stripe_over_delay),
											.stop_delay4(stop_delay4),
											.data_out1(data_out1),
                                            .data_out2(data_out2),
                                            .data_out3(data_out3),
                                            .data_out4(data_out4),
                                            .count_YUV(count_YUV),
											.band(band),
                                            .clk_sg(clk_sg),
											.clk_rc(clk_rc),
											.rst(rst),
											.rst_syn(rst_syn),
											.block_count_0_lh_y(block_count_0_lh_y),
											.block_count_0_lh_u(block_count_0_lh_u),
											.block_count_0_lh_v(block_count_0_lh_v),
											.block_count_0_hl_y(block_count_0_hl_y),
											.block_count_0_hl_u(block_count_0_hl_u),
											.block_count_0_hl_v(block_count_0_hl_v),
											.block_count_0_hh_y(block_count_0_hh_y),
											.block_count_0_hh_u(block_count_0_hh_u),
											.block_count_0_hh_v(block_count_0_hh_v),
											.block_count_1_lh_y(block_count_1_lh_y),
											.block_count_1_lh_u(block_count_1_lh_u),
											.block_count_1_lh_v(block_count_1_lh_v),
											.block_count_1_hl_y(block_count_1_hl_y),
											.block_count_1_hl_u(block_count_1_hl_u),
											.block_count_1_hl_v(block_count_1_hl_v),
											.block_count_1_hh_y(block_count_1_hh_y),
											.block_count_1_hh_u(block_count_1_hh_u),
											.block_count_1_hh_v(block_count_1_hh_v),
											.block_count_2_lh_y(block_count_2_lh_y),
											.block_count_2_lh_u(block_count_2_lh_u),
											.block_count_2_lh_v(block_count_2_lh_v),
											.block_count_2_hl_y(block_count_2_hl_y),
											.block_count_2_hl_u(block_count_2_hl_u),
											.block_count_2_hl_v(block_count_2_hl_v),
											.block_count_2_hh_y(block_count_2_hh_y),
											.block_count_2_hh_u(block_count_2_hh_u),
											.block_count_2_hh_v(block_count_2_hh_v),
											.block_count_3_lh_y(block_count_3_lh_y),
											.block_count_3_lh_u(block_count_3_lh_u),
											.block_count_3_lh_v(block_count_3_lh_v),
											.block_count_3_hl_y(block_count_3_hl_y),
											.block_count_3_hl_u(block_count_3_hl_u),
											.block_count_3_hl_v(block_count_3_hl_v),
											.block_count_3_hh_y(block_count_3_hh_y),
											.block_count_3_hh_u(block_count_3_hh_u),
											.block_count_3_hh_v(block_count_3_hh_v),
											.block_count_4_lh_y(block_count_4_lh_y),
											.block_count_4_lh_u(block_count_4_lh_u),
											.block_count_4_lh_v(block_count_4_lh_v),
											.block_count_4_hl_y(block_count_4_hl_y),
											.block_count_4_hl_u(block_count_4_hl_u),
											.block_count_4_hl_v(block_count_4_hl_v),
											.block_count_4_hh_y(block_count_4_hh_y),
											.block_count_4_hh_u(block_count_4_hh_u),
											.block_count_4_hh_v(block_count_4_hh_v),
											.block_count_4_ll_y(block_count_4_ll_y),
											.block_count_4_ll_u(block_count_4_ll_u),
											.block_count_4_ll_v(block_count_4_ll_v));
											
bpc_unit   u_bpc_unit( //out
					   .arrange_out0(arrange_out0),
                       .arrange_out1( arrange_out1 ), 
                       .arrange_out2( arrange_out2 ), 
                       .arrange_out3( arrange_out3 ), 
                       .arrange_out4( arrange_out4 ), 
                       .arrange_out5( arrange_out5 ), 
                       .arrange_out6( arrange_out6 ), 
                       .arrange_out7( arrange_out7 ), 
                       .arrange_out8( arrange_out8 ), 
                       .arrange_out9( arrange_out9 ), 
                       .vld_num(vld_num), 
                       .flush(flush), 
                       .flush_mq2(flush_mq2), 
                       .pass_judge_1(pass_judge_1), 
                       .pass_judge_2(pass_judge_2), 
                       .pass_judge_3(pass_judge_3), 
                       .pass_judge_4(pass_judge_4), 
                       .bit1_add_vld(bit1_add_vld), 
                       .bit2_add_vld(bit2_add_vld), 
                       .bit3_add_vld(bit3_add_vld), 
                       .bit4_add_vld(bit4_add_vld),  
					   .pass_judge_1_d(pass_judge_1_d),
					   .pass_judge_2_d(pass_judge_2_d),
					   .pass_judge_3_d(pass_judge_3_d),
					   .pass_judge_4_d(pass_judge_4_d),				  
					   .stop_d(stop_d),
					   .clear0(clear0),					   
					   .pass_error_start(pass_error_start),   
						//in 
						.halt(halt),
					    .code_over_flag(code_over_flag),
					    .bpc_start_flag(bpc_start_flag),
					    .last_stripe_vld(last_stripe_vld),
					    .stripe_over_flag(stripe_over_flag),
					    .level_flag(level_flag),
					    .stop_flag(stop_flag),
					    .band(band),
                        .stall_vld(stall_vld),
                        .data1_state(bp_data1_state),
                        .data2_state(bp_data2_state),
                        .data3_state(bp_data3_state),
                        .data4_state(bp_data4_state),				
					    .clk_bpc(clk_sg),
						.clk_dwt(clk_dwt),						
					    .rst(rst),
						.rst_syn(rst_syn));

write_fifo u_write_fifo(	//output
                            .fifo_in0  (fifo_in0),
				            .fifo_in1  (fifo_in1),
				            .fifo_in2  (fifo_in2),
				            .fifo_in3  (fifo_in3),
				            .fifo_in4  (fifo_in4),
				            .fifo_in5  (fifo_in5),
				            .fifo_in6  (fifo_in6),
				            .fifo_in7  (fifo_in7),
				            .fifo_in8  (fifo_in8),
				            .fifo_in9  (fifo_in9),
				            .wr_vld  (wr_vld),
							.stall_vld  (stall_vld),
				            //input
				            .wrfull  (wrfull),
				            .arrange_out0  (arrange_out0),
				            .arrange_out1  (arrange_out1),
				            .arrange_out2  (arrange_out2),
				            .arrange_out3  (arrange_out3),
				            .arrange_out4  (arrange_out4),
				            .arrange_out5  (arrange_out5),
				            .arrange_out6  (arrange_out6),
				            .arrange_out7  (arrange_out7),
				            .arrange_out8  (arrange_out8),
				            .arrange_out9  (arrange_out9),
				            .vld_num  (vld_num),
				            .flush  (flush),
				            .clk_wr  (clk_sg),
							.clk_dwt	(clk_dwt),
				            .rst  (rst),
							.rst_syn(rst_syn));

fifoa  u_fifoa(//output
                   .fifo_out0  (fifo_out0),
			       .fifo_out1  (fifo_out1),
			       .fifo_out2  (fifo_out2),
			       .fifo_out3  (fifo_out3),
			       .fifo_out4  (fifo_out4),
			       .fifo_out5  (fifo_out5),
			       .fifo_out6  (fifo_out6),
			       .fifo_out7  (fifo_out7),
			       .fifo_out8  (fifo_out8),
			       .fifo_out9  (fifo_out9),
			       .rdempty  (rdempty),
			       .wrfull  (wrfull),
			       //input
			       .wr_vld  (wr_vld),
			       .rd_vld  (rd_vld),
			       .fifo_in0  (fifo_in0),
			       .fifo_in1  (fifo_in1),
			       .fifo_in2  (fifo_in2),
			       .fifo_in3  (fifo_in3),
			       .fifo_in4  (fifo_in4),
			       .fifo_in5  (fifo_in5),
			       .fifo_in6  (fifo_in6),
			       .fifo_in7  (fifo_in7),
			       .fifo_in8  (fifo_in8),
                   .fifo_in9  (fifo_in9),
			       .clk_rd  (clk_rc),
			       .clk_wr  (clk_rc));
				   
read_fifo u_read_fifo(//output
                          .fifo_out  (fifo_out),
                          .rd_vld  (rd_vld),
						  .start_aga (start_aga),
				        //input
				          .fifo_out0  (fifo_out0),
				          .fifo_out1  (fifo_out1),
				          .fifo_out2  (fifo_out2),
				          .fifo_out3  (fifo_out3),
				          .fifo_out4  (fifo_out4),
				          .fifo_out5  (fifo_out5),
				          .fifo_out6  (fifo_out6),
				          .fifo_out7  (fifo_out7),
				          .fifo_out8  (fifo_out8),
				          .fifo_out9  (fifo_out9),
				          .rdempty  (rdempty),
				          .stop_rd  (stop_rd),
				          .clk_rd  (clk_rc),
						  .halt_to_fifo	(halt_to_fifo),
				          .rst  (rst),
						  .rst_syn(rst_syn));
	
mq			u_mq(	.MQ_out(MQ_out),
					.word_last_flag(word_last_flag),
					.stop(stop_rd),
					.data_valid_pass_reg(data_valid_pass_reg),
					.flush_over(flush_over),
					.word_last_valid(word_last_valid),
					.bit_enough_to_bpc(bit_enough_to_bpc),
					//input
					.PCXD(fifo_out),
					.flush(flush_mq2),
					.clk(clk_rc),
					.rst(rst),
					.rst_syn(rst_syn),
					.start_aga(start_aga),
					.block_all_bp_over(block_all_bp_over),
					.song_require(song_require),
					.one_codeblock_over(one_codeblock_over));

pass_error_unit   u_pass_error_unit (//output
                                      .pass_error_sp (pass_error_sp),
						              .pass_error_mrp (pass_error_mrp),
						              .pass_error_cp (pass_error_cp),
						              //input
									  .clear0(clear0),
						              .bit1_nmsedec (bit1_nmsedec),
                                      .bit2_nmsedec (bit2_nmsedec),
                                      .bit3_nmsedec (bit3_nmsedec),
                                      .bit4_nmsedec (bit4_nmsedec),
                                      .pass_judge_1_delay (pass_judge_1),
                                      .pass_judge_2_delay (pass_judge_2),
                                      .pass_judge_3_delay (pass_judge_3),
                                      .pass_judge_4_delay (pass_judge_4),
									  .bit1_add_vld (bit1_add_vld),
						              .bit2_add_vld (bit2_add_vld),
						              .bit3_add_vld (bit3_add_vld),
						              .bit4_add_vld (bit4_add_vld),
                                      .mul_factor_error (mul_factor_error),
                                      .count_bp (count_bp_to_genere),
                                      .stop_d (stop_d),
                                      .stall_vld (stall_vld),
                                      .pass_error_start  (pass_error_start),
                                      .clk_pass_pre  (clk_rc),
						              .clk_pass_cal (clk_sg),
                                      .rst(rst),
									  .rst_syn(rst_syn));
									  
mq_out_state_generate 		u_mq_out_state_generate(//output
													.word_last_sp(word_last_sp),	
													.word_last_cp(word_last_cp), 		
													.word_last_mrp(word_last_mrp), 		 		
													//input		
													.data_valid_pass_reg(data_valid_pass_reg), 		
													.word_last_valid(word_last_valid), 		
													.word_last_flag(word_last_flag), 		
													.flush_over(flush_over), 												
					                                .clk(clk_rc), 
                                                    .rst(rst),
													.rst_syn(rst_syn));


										
										
										
										
endmodule 										
