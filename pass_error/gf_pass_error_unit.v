`timescale 1ns/10ps
module pass_error_unit (//output
                        pass_error_sp,
						pass_error_mrp,
						pass_error_cp,
						//input
						bit1_nmsedec,
				        bit2_nmsedec,
				        bit3_nmsedec,
				        bit4_nmsedec,
                        pass_judge_1_delay,
                        pass_judge_2_delay,
                        pass_judge_3_delay,
                        pass_judge_4_delay,
						bit1_add_vld,
						bit2_add_vld,
						bit3_add_vld,
						bit4_add_vld,
                        mul_factor_error,
					    count_bp,
                        stop_d,
						clear0,
                        stall_vld,
                        pass_error_start,
                        clk_pass_pre,
						clk_pass_cal,	//clk_sg
                        rst,
						rst_syn
								);
						
output[30:0] pass_error_sp;
output[30:0] pass_error_mrp;
output[30:0] pass_error_cp;


input[16:0] bit1_nmsedec; 
input[16:0] bit2_nmsedec;
input[16:0] bit3_nmsedec;
input[16:0] bit4_nmsedec;

input bit1_add_vld;
input bit2_add_vld;
input bit3_add_vld;
input bit4_add_vld;

input[2:0] pass_judge_1_delay;
input[2:0] pass_judge_2_delay;
input[2:0] pass_judge_3_delay;
input[2:0] pass_judge_4_delay;

input pass_error_start;
input[3:0] mul_factor_error;
input stop_d;
input [3:0] count_bp;
input stall_vld;
input clear0;
input clk_pass_pre;
input clk_pass_cal;
input rst;
input rst_syn;


wire[25:0] bit_nmsedec_sp;
wire[25:0] bit_nmsedec_mrp;
wire[25:0] bit_nmsedec_cp;
wire cal_out_vld;
wire[3:0]mul_factor_error_reg;
wire[3:0]count_bp_delay_b_reg;

wire[30:0] pass_error_sp;
wire[30:0] pass_error_mrp;
wire[30:0] pass_error_cp;

pass_error_pre   u_pass_error_pre (//output
                                      .bit_nmsedec_sp  (bit_nmsedec_sp),
						              .bit_nmsedec_mrp (bit_nmsedec_mrp),
						              .bit_nmsedec_cp (bit_nmsedec_cp),
						              .mul_factor_error_reg (mul_factor_error_reg),
						              .count_bp_delay_b_reg (count_bp_delay_b_reg),
						              .cal_out_vld (cal_out_vld),
						              //input
						              .bit1_nmsedec (bit1_nmsedec),
						              .bit2_nmsedec (bit2_nmsedec),
						              .bit3_nmsedec (bit3_nmsedec),
						              .bit4_nmsedec (bit4_nmsedec),
						              .pass_judge_1_delay (pass_judge_1_delay),
						              .pass_judge_2_delay (pass_judge_2_delay),
						              .pass_judge_3_delay (pass_judge_3_delay),
						              .pass_judge_4_delay (pass_judge_4_delay),
									  .bit1_add_vld (bit1_add_vld),
						              .bit2_add_vld (bit2_add_vld),
						              .bit3_add_vld (bit3_add_vld),
						              .bit4_add_vld (bit4_add_vld),
									  
						              .mul_factor_error (mul_factor_error),
						              //.count_bp_delay_b (count_bp_delay_b),
									  .count_bp(count_bp),
						              .stop_d (stop_d),
									  .clear0(clear0),
						              .stall_vld (stall_vld),
						              .pass_error_start (pass_error_start),
						              .clk_pass_pre (clk_pass_pre),
						              .rst (rst),
									  .rst_syn(rst_syn)
									  );	
									  
pass_error_cal  u_pass_error_cal (//output
                                   .pass_error_sp  (pass_error_sp),
					               .pass_error_mrp (pass_error_mrp),
					               .pass_error_cp (pass_error_cp),
					              //input
					               .bit_nmsedec_sp (bit_nmsedec_sp),
					               .bit_nmsedec_mrp (bit_nmsedec_mrp),
					               .bit_nmsedec_cp (bit_nmsedec_cp),
					               .mul_factor_error_reg (mul_factor_error_reg),
					               .count_bp_delay_b_reg (count_bp_delay_b_reg),
					               .cal_out_vld (cal_out_vld),
					               .clk_pass_cal (clk_pass_cal),
								   .clk_pass_pre(clk_pass_pre),
					               .rst (rst),
								   .rst_syn(rst_syn)
								   );	
								   
endmodule

								   
								   