`timescale 1ns/10ps
module pass_error_cal (//output
                        pass_error_sp,
						pass_error_mrp,
						pass_error_cp,
					   //input
					    bit_nmsedec_sp,
						bit_nmsedec_mrp,
						bit_nmsedec_cp,
						mul_factor_error_reg,
						count_bp_delay_b_reg,
						cal_out_vld,
						clk_pass_cal,
						clk_pass_pre,
						rst,
						rst_syn
						);
						
output[30:0] pass_error_sp;
output[30:0] pass_error_mrp;
output[30:0] pass_error_cp;

input[25:0] bit_nmsedec_sp;
input[25:0] bit_nmsedec_mrp;
input[25:0] bit_nmsedec_cp;
input cal_out_vld;
input[3:0]mul_factor_error_reg;
input[3:0]count_bp_delay_b_reg;
input clk_pass_cal;
input clk_pass_pre;
input rst;
input rst_syn;
 
reg clk_pass_cal_reg;
always@(posedge clk_pass_pre or negedge rst)
	begin
		if(!rst)
			clk_pass_cal_reg<=0;
		else 	
			clk_pass_cal_reg<=clk_pass_cal;
	end
wire pos_error_bpc=((clk_pass_cal_reg==1'b0)&&(clk_pass_cal==1'b1))?1'b1:1'b0;
//******************//
reg[25:0] bit_nmsedec_sp_cal;
reg[25:0] bit_nmsedec_mrp_cal;
reg[25:0] bit_nmsedec_cp_cal;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
      bit_nmsedec_sp_cal <= 26'b0;
      bit_nmsedec_mrp_cal <= 26'b0;
      bit_nmsedec_cp_cal <= 26'b0;
  end
  else if(rst_syn) begin
      bit_nmsedec_sp_cal <= 26'b0;
      bit_nmsedec_mrp_cal <= 26'b0;
      bit_nmsedec_cp_cal <= 26'b0;
  end
  else if(pos_error_bpc==1'b1)begin
	if(cal_out_vld==1'b1) begin
		bit_nmsedec_sp_cal <= bit_nmsedec_sp;
		bit_nmsedec_mrp_cal <= bit_nmsedec_mrp;
		bit_nmsedec_cp_cal <= bit_nmsedec_cp;
	end
  end
end

reg[4:0]mul_factor_error_cal;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
      mul_factor_error_cal <= 5'b0;
  end
  else if(rst_syn) begin
      mul_factor_error_cal <= 5'b0;
  end
   else if(pos_error_bpc==1'b1)begin
		if(cal_out_vld==1'b1) begin
			mul_factor_error_cal <= {1'b0,mul_factor_error_reg};
		end
	end	
end

reg[3:0]count_bp_delay_b_cal; 
reg[3:0]count_bp_delay_b_cal_n; 

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
      count_bp_delay_b_cal <= 4'b0;
  end
  else if(rst_syn) begin
      count_bp_delay_b_cal <= 4'b0;
  end
   else if(pos_error_bpc==1'b1)begin
		if(cal_out_vld==1'b1) begin
			count_bp_delay_b_cal_n <= count_bp_delay_b_reg;
			count_bp_delay_b_cal<=count_bp_delay_b_cal_n;
		end
	end	
end

wire[30:0] mul_out_sp;
wire[30:0] mul_out_mrp;
wire[30:0] mul_out_cp;

assign mul_out_sp = $signed(mul_factor_error_cal)*$signed(bit_nmsedec_sp_cal);
assign mul_out_mrp = $signed(mul_factor_error_cal)*$signed(bit_nmsedec_mrp_cal);
assign mul_out_cp = $signed(mul_factor_error_cal)*$signed(bit_nmsedec_cp_cal);

reg[30:0] mul_out_sp_reg;
reg[30:0] mul_out_mrp_reg;
reg[30:0] mul_out_cp_reg;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
      mul_out_sp_reg <= 31'b0;
	  mul_out_mrp_reg <= 31'b0;
	  mul_out_cp_reg <= 31'b0; 
  end
  else if(rst_syn) begin
      mul_out_sp_reg <= 31'b0;
	  mul_out_mrp_reg <= 31'b0;
	  mul_out_cp_reg <= 31'b0; 
  end
  else if(pos_error_bpc==1'b1)begin
      mul_out_sp_reg <= mul_out_sp;
	  mul_out_mrp_reg <= mul_out_mrp;
	  mul_out_cp_reg <= mul_out_cp; 
  end
end

reg[30:0] pass_error_sp_n;
reg[30:0] pass_error_mrp_n;
reg[30:0] pass_error_cp_n;

reg[30:0] pass_error_sp;
reg[30:0] pass_error_mrp;
reg[30:0] pass_error_cp;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
      pass_error_sp <= 31'b0;
	  pass_error_mrp <= 31'b0;
	  pass_error_cp <= 31'b0; 
  end
  else if(rst_syn) begin
      pass_error_sp <= 31'b0;
	  pass_error_mrp <= 31'b0;
	  pass_error_cp <= 31'b0;
  end
   else if(pos_error_bpc==1'b1)begin
      pass_error_sp <= pass_error_sp_n;
	  pass_error_mrp <= pass_error_mrp_n;
	  pass_error_cp <= pass_error_cp_n; 
  end
end

always @(*) begin
  case(count_bp_delay_b_cal) 
    15:                 begin
	                     pass_error_sp_n = {mul_out_sp_reg[21:0],9'b0};
						 pass_error_mrp_n = {mul_out_mrp_reg[21:0],9'b0};
						 pass_error_cp_n = {mul_out_cp_reg[21:0],9'b0};
						end
						
	14:                 begin
	                     pass_error_sp_n = {mul_out_sp_reg[23:0],7'b0};
						 pass_error_mrp_n = {mul_out_mrp_reg[23:0],7'b0};
						 pass_error_cp_n = {mul_out_cp_reg[23:0],7'b0};
						end
						
	13:                 begin
	                     pass_error_sp_n = {mul_out_sp_reg[25:0],5'b0};
						 pass_error_mrp_n = {mul_out_mrp_reg[25:0],5'b0};
						 pass_error_cp_n = {mul_out_cp_reg[25:0],5'b0};
						end
	12:                 begin
	                     pass_error_sp_n = {mul_out_sp_reg[27:0],3'b0};
						 pass_error_mrp_n = {mul_out_mrp_reg[27:0],3'b0};
						 pass_error_cp_n = {mul_out_cp_reg[27:0],3'b0};
						end										
    11:                 begin
	                     pass_error_sp_n = {mul_out_sp_reg[29:0],1'b0};
						 pass_error_mrp_n = {mul_out_mrp_reg[29:0],1'b0};
						 pass_error_cp_n = {mul_out_cp_reg[29:0],1'b0};
						end
	10:                 begin
	                     pass_error_sp_n = {1'b0,mul_out_sp_reg[30:1]};
						 pass_error_mrp_n = {1'b0,mul_out_mrp_reg[30:1]};
						 pass_error_cp_n = {1'b0,mul_out_cp_reg[30:1]};
						end	
    9:                 begin
	                     pass_error_sp_n = {3'b0,mul_out_sp_reg[30:3]};
						 pass_error_mrp_n = {3'b0,mul_out_mrp_reg[30:3]};
						 pass_error_cp_n = {3'b0,mul_out_cp_reg[30:3]};
						end						
	8:                 begin
	                     pass_error_sp_n = {5'b0,mul_out_sp_reg[30:5]};
						 pass_error_mrp_n = {5'b0,mul_out_mrp_reg[30:5]};
						 pass_error_cp_n = {5'b0,mul_out_cp_reg[30:5]};
					   end						
    7:                 begin
	                     pass_error_sp_n = {7'b0,mul_out_sp_reg[30:7]};
						 pass_error_mrp_n = {7'b0,mul_out_mrp_reg[30:7]};
						 pass_error_cp_n = {7'b0,mul_out_cp_reg[30:7]};
					   end	
	6:                 begin
	                     pass_error_sp_n = {9'b0,mul_out_sp_reg[30:9]};
						 pass_error_mrp_n = {9'b0,mul_out_mrp_reg[30:9]};
						 pass_error_cp_n = {9'b0,mul_out_cp_reg[30:9]};
					   end
    5:                 begin
	                     pass_error_sp_n = {11'b0,mul_out_sp_reg[30:11]};
						 pass_error_mrp_n = {11'b0,mul_out_mrp_reg[30:11]};
						 pass_error_cp_n = {11'b0,mul_out_cp_reg[30:11]};
					   end
    4:                 begin
	                     pass_error_sp_n = {13'b0,mul_out_sp_reg[30:13]};
						 pass_error_mrp_n = {13'b0,mul_out_mrp_reg[30:13]};
						 pass_error_cp_n = {13'b0,mul_out_cp_reg[30:13]};
					   end		
  default:             begin
                         pass_error_sp_n = 31'b0;
						 pass_error_mrp_n = 31'b0;
						 pass_error_cp_n = 31'b0;  
					   end
  endcase
end

endmodule
