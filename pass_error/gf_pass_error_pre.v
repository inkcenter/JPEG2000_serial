`timescale 1ns/10ps
module pass_error_pre (//output
                  bit_nmsedec_sp,
						bit_nmsedec_mrp,
						bit_nmsedec_cp,
						mul_factor_error_reg,
						count_bp_delay_b_reg,
						cal_out_vld,
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
						//count_bp_delay_b,
						count_bp,
						stop_d,
						clear0,
						stall_vld,
						pass_error_start,
						clk_pass_pre,
						rst,
						rst_syn);
									 
input[16:0] bit1_nmsedec; 
input[16:0] bit2_nmsedec;
input[16:0] bit3_nmsedec;
input[16:0] bit4_nmsedec;

input[2:0] pass_judge_1_delay;
input[2:0] pass_judge_2_delay;
input[2:0] pass_judge_3_delay;
input[2:0] pass_judge_4_delay;

input bit1_add_vld;
input bit2_add_vld;
input bit3_add_vld;
input bit4_add_vld;


input pass_error_start;
input[3:0] mul_factor_error;
input stop_d;
input clear0;
input [3:0]count_bp;
input stall_vld;
input clk_pass_pre;
input rst;
input rst_syn;


output[25:0] bit_nmsedec_sp;
output[25:0] bit_nmsedec_mrp;
output[25:0] bit_nmsedec_cp;
output cal_out_vld;
output[3:0]mul_factor_error_reg;
output[3:0]count_bp_delay_b_reg;
 

wire return_zero_1;
reg[16:0] bit1_nmsedec_reg;
reg[16:0] bit2_nmsedec_reg;
reg[16:0] bit3_nmsedec_reg;
reg[16:0] bit4_nmsedec_reg;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    bit1_nmsedec_reg <= 17'b0;
	bit2_nmsedec_reg <= 17'b0;
	bit3_nmsedec_reg <= 17'b0;
	bit4_nmsedec_reg <= 17'b0;
  end
  else if(rst_syn) begin
    bit1_nmsedec_reg <= 17'b0;
	bit2_nmsedec_reg <= 17'b0;
	bit3_nmsedec_reg <= 17'b0;
	bit4_nmsedec_reg <= 17'b0;
  end
  else if(stall_vld==1'b0) begin
    bit1_nmsedec_reg <= bit1_nmsedec;
	bit2_nmsedec_reg <= bit2_nmsedec;
	bit3_nmsedec_reg <= bit3_nmsedec;
	bit4_nmsedec_reg <= bit4_nmsedec;
  end
end

reg[2:0] pass_judge_1_reg; 
reg[2:0] pass_judge_2_reg;
reg[2:0] pass_judge_3_reg;
reg[2:0] pass_judge_4_reg;

   
always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    pass_judge_1_reg <= 3'b0;
	pass_judge_2_reg <= 3'b0;
	pass_judge_3_reg <= 3'b0;
	pass_judge_4_reg <= 3'b0;
  end
  else if(rst_syn) begin
    pass_judge_1_reg <= 3'b0;
	pass_judge_2_reg <= 3'b0;
	pass_judge_3_reg <= 3'b0;
	pass_judge_4_reg <= 3'b0;
  end
  else if(return_zero_1==1'b1) begin
     pass_judge_1_reg <= 3'b0;
	 pass_judge_2_reg <= 3'b0;
	 pass_judge_3_reg <= 3'b0;
	 pass_judge_4_reg <= 3'b0;
  end
  else if(stall_vld==1'b0) begin
    pass_judge_1_reg <= pass_judge_1_delay;
	pass_judge_2_reg <= pass_judge_2_delay;
	pass_judge_3_reg <= pass_judge_3_delay;
	pass_judge_4_reg <= pass_judge_4_delay;
  end
end

reg bit1_add_vld_reg;
reg bit2_add_vld_reg;
reg bit3_add_vld_reg;
reg bit4_add_vld_reg;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    bit1_add_vld_reg <= 1'b0;
	bit2_add_vld_reg <= 1'b0;
	bit3_add_vld_reg <= 1'b0;
	bit4_add_vld_reg <= 1'b0;
  end
  else if(rst_syn) begin
    bit1_add_vld_reg <= 1'b0;
	bit2_add_vld_reg <= 1'b0;
	bit3_add_vld_reg <= 1'b0;
	bit4_add_vld_reg <= 1'b0;
  end
  else if(return_zero_1==1'b1) begin
     bit1_add_vld_reg <= 1'b0;
	 bit2_add_vld_reg <= 1'b0;
	 bit3_add_vld_reg <= 1'b0;
	 bit4_add_vld_reg <= 1'b0;
  end
  else if(stall_vld==1'b0) begin
     bit1_add_vld_reg <= bit1_add_vld;
	 bit2_add_vld_reg <= bit2_add_vld;
	 bit3_add_vld_reg <= bit3_add_vld;
	 bit4_add_vld_reg <= bit4_add_vld;
  end
end



reg pass_error_start_delay_1;
reg pass_error_start_delay_2;
reg pass_error_start_delay_3;
reg pass_error_start_delay_4;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    pass_error_start_delay_1 <=1'b0;
	pass_error_start_delay_2 <=1'b0;
    pass_error_start_delay_3 <=1'b0;
	pass_error_start_delay_4 <=1'b0;
  end
  else if(rst_syn) begin
    pass_error_start_delay_1 <=1'b0;
	pass_error_start_delay_2 <=1'b0;
    pass_error_start_delay_3 <=1'b0;
	pass_error_start_delay_4 <=1'b0;
  end
  else if(stall_vld==1'b0) begin
    pass_error_start_delay_1 <=pass_error_start;
	pass_error_start_delay_2 <=pass_error_start_delay_1;
    pass_error_start_delay_3 <=pass_error_start_delay_2;
	pass_error_start_delay_4 <=pass_error_start_delay_3;
  end
end

reg stop_d_delay_1;
reg stop_d_delay_2;
reg stop_d_delay_3;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    stop_d_delay_1 <=1'b0;
	stop_d_delay_2 <=1'b0;
    stop_d_delay_3 <=1'b0;
  end
  else if(rst_syn) begin
    stop_d_delay_1 <=1'b0;
	stop_d_delay_2 <=1'b0;
    stop_d_delay_3 <=1'b0;
  end
  else if(stall_vld==1'b0) begin
    stop_d_delay_1 <=stop_d;
	stop_d_delay_2 <=stop_d_delay_1;
    stop_d_delay_3 <=stop_d_delay_2;
  end
end
   
   
reg[1:0] fsm_pass_error;
reg[1:0] fsm_pass_error_n;

parameter pass_error_idle= 2'b00;
parameter pass_error_cal= 2'b01;
parameter pass_error_wait= 2'b10;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    fsm_pass_error <= 2'b0;
  end
  else if(rst_syn) begin
    fsm_pass_error <= 2'b0;
  end
  else begin
    fsm_pass_error <=fsm_pass_error_n;
  end
end

reg[1:0] fsm_pass_error_delay;

always  @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    fsm_pass_error_delay <= 1'b0;
  end
  else if(rst_syn) begin
    fsm_pass_error_delay <= 1'b0;
  end
  else begin
    fsm_pass_error_delay <=fsm_pass_error;
  end
end

wire last_renew_vld;

assign last_renew_vld= ((fsm_pass_error == pass_error_wait)&&(fsm_pass_error_delay == pass_error_cal));


always @(*) begin 
 fsm_pass_error_n = fsm_pass_error;
 case(fsm_pass_error) 
   pass_error_idle :         begin
                              if(pass_error_start_delay_4) begin
							    fsm_pass_error_n = pass_error_cal;
							  end
							  else begin
							    fsm_pass_error_n = pass_error_idle;
							  end
							 end
							 
   pass_error_cal :          begin
                              if(stop_d_delay_3==1'b1) begin
							    fsm_pass_error_n = pass_error_wait;
							  end
							  else begin
							    fsm_pass_error_n = pass_error_cal;
							  end
							 end
   pass_error_wait :         begin
                              if(stop_d_delay_3==1'b0) begin
							    fsm_pass_error_n = pass_error_cal;
							  end
							  else begin
							    fsm_pass_error_n = pass_error_wait;
							  end
							 end
   default:                  begin
                               fsm_pass_error_n = 2'b11;
                             end
  endcase
end


reg fsm_for_last;
reg fsm_for_last_n;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    fsm_for_last <= 1'b0;
  end
  else if(rst_syn) begin
    fsm_for_last <= 1'b0;
  end
  else begin
    fsm_for_last <=fsm_for_last_n;
  end
end

wire last_count_vld;
assign last_count_vld= (fsm_for_last==1'b1);

reg[2:0] last_count;

assign return_zero_1= (last_count==5);

reg return_zero_2;
reg return_zero_3;
reg return_zero_4;
reg return_zero_5;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    return_zero_2 <= 4'b0;
	return_zero_3 <= 4'b0;
	return_zero_4 <= 4'b0;
	return_zero_5 <= 4'b0;
  end
  else if(rst_syn)
  begin
	return_zero_2 <= 4'b0;
	return_zero_3 <= 4'b0;
	return_zero_4 <= 4'b0;
	return_zero_5 <= 4'b0;
end
  else begin
	return_zero_2 <=return_zero_1;
    return_zero_3 <= return_zero_2;
	return_zero_4 <= return_zero_3;
	return_zero_5 <= return_zero_4;

  end
  end
 
wire return_zero_x;
assign return_zero_x = (return_zero_4==1'b1)||(return_zero_5==1'b1);

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    last_count <= 3'b0;
  end
  else if(rst_syn) begin
    last_count <= 3'b0;
  end
  else if(return_zero_1==1'b1) begin
    last_count <= 3'b0;
  end
  else if(last_count_vld==1'b1)begin
    last_count <=last_count+1;
  end
end

always @(*) begin
  fsm_for_last_n = fsm_for_last;
  case(fsm_for_last)
    1'b0:               begin
	                     if(last_renew_vld==1'b1) begin
						   fsm_for_last_n=1'b1;
						 end
						 else begin
						   fsm_for_last_n=1'b0;
						 end
						end
	1'b1:               begin
	                     if(last_count==4) begin
						   fsm_for_last_n=1'b0;
						 end
						 else begin
						   fsm_for_last_n=1'b1;
						 end
						end
  endcase
end




wire error_cal;

assign error_cal= (fsm_pass_error == pass_error_cal);

reg error_cal_delay;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    error_cal_delay <= 1'b0;
  end
  else if(rst_syn) begin
    error_cal_delay <= 1'b0;
  end
  else begin
    error_cal_delay <=error_cal;
  end
end

wire factor_get;

assign factor_get= ((error_cal_delay==1'b0)&&(error_cal==1'b1));


reg[3:0] mul_factor_error_reg;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    mul_factor_error_reg <= 4'b0;
  end
  else if(rst_syn) begin
    mul_factor_error_reg <= 4'b0;
  end
  else if(factor_get==1'b1)begin
    mul_factor_error_reg <=mul_factor_error;
  end
end

reg[3:0] count_bp_delay_b_reg;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    count_bp_delay_b_reg <= 4'b0;
  end
  else if(rst_syn)begin
	count_bp_delay_b_reg <= 4'b0;
  end
  else if(factor_get==1'b1)begin
    count_bp_delay_b_reg <=count_bp;
  end
end


wire cal_out_vld_1;

assign cal_out_vld_1=(last_count==4)||(last_count==3);
reg cal_out_vld_2;
reg cal_out_vld_3;
reg cal_out_vld_4;
reg cal_out_vld_5;
always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    cal_out_vld_2 <=1'b0;
	cal_out_vld_3 <=1'b0;
	cal_out_vld_4 <=1'b0;
	cal_out_vld_5 <=1'b0;
  end
  else if(rst_syn) begin
    cal_out_vld_2 <=1'b0;
	cal_out_vld_3 <=1'b0;
	cal_out_vld_4 <=1'b0;
	cal_out_vld_5 <=1'b0;
  end
  else begin
    cal_out_vld_2 <= cal_out_vld_1;
	cal_out_vld_3 <= cal_out_vld_2;
	cal_out_vld_4 <= cal_out_vld_3;
	cal_out_vld_5 <= cal_out_vld_4;
  end
end

wire cal_out_vld;

assign cal_out_vld = cal_out_vld_1||cal_out_vld_2||cal_out_vld_3||cal_out_vld_4||cal_out_vld_5;

reg[1:0] count_data;

always @(posedge clk_pass_pre or negedge rst) begin
  if(!rst) begin
    count_data <=2'b00;
  end
  else if(rst_syn) begin
    count_data <=2'b00;
  end
  else if((error_cal==1'b1)&&(stall_vld==1'b0))begin
    count_data <=count_data+1;
  end
end  

reg[25:0] bit_nmsedec_sp;
reg[25:0] bit_nmsedec_mrp;
reg[25:0] bit_nmsedec_cp;

reg[25:0] bit_nmsedec_sp_n;
reg[25:0] bit_nmsedec_mrp_n;
reg[25:0] bit_nmsedec_cp_n;



always @(posedge clk_pass_pre or negedge rst) begin
	if(!rst) begin
		bit_nmsedec_sp <=26'b0;
	end
   else if(rst_syn) begin
    bit_nmsedec_sp <=26'b0;
   end
	else if(clear0==1'b1)begin
		bit_nmsedec_sp <=26'b0;
	end
	else if(return_zero_x==1'b1) begin
		bit_nmsedec_sp <=26'b0;
	end
	else if(((error_cal==1'b1)&&(stall_vld==1'b0))||(last_renew_vld==1'b1)) begin
		bit_nmsedec_sp <= bit_nmsedec_sp_n;
	end
end
  
always @(posedge clk_pass_pre or negedge rst) begin
   if(!rst) begin
     bit_nmsedec_mrp <=26'b0;
   end
   else if(rst_syn) begin
     bit_nmsedec_mrp <=26'b0;
   end
   else if(clear0==1'b1)begin
		bit_nmsedec_mrp <=26'b0;
	end
   else if(return_zero_x==1'b1) begin
     bit_nmsedec_mrp <=26'b0;
   end
   else if(((error_cal==1'b1)&&(stall_vld==1'b0))||(last_renew_vld==1'b1)) begin
     bit_nmsedec_mrp <= bit_nmsedec_mrp_n;
   end
end

always @(posedge clk_pass_pre or negedge rst) begin
   if(!rst) begin
     bit_nmsedec_cp <=26'b0;
   end
   else if(rst_syn) begin
     bit_nmsedec_cp <=26'b0;
   end
   else if(clear0==1'b1)begin
		bit_nmsedec_cp <=26'b0;
   end
   else if(return_zero_x==1'b1) begin
     bit_nmsedec_cp <=26'b0;
   end
   else if(((error_cal==1'b1)&&(stall_vld==1'b0))||(last_renew_vld==1'b1)) begin
     bit_nmsedec_cp <= bit_nmsedec_cp_n;
   end
end

always @(*) begin
  bit_nmsedec_sp_n = bit_nmsedec_sp;
  bit_nmsedec_mrp_n = bit_nmsedec_mrp;
  bit_nmsedec_cp_n = bit_nmsedec_cp;
    if(error_cal_delay==1'b1) begin
         case(count_data) 
           2'b00:         begin
        					   case(pass_judge_1_reg)
        					     3'b001:    begin
        						             if(bit1_add_vld_reg==1'b1) begin
											    bit_nmsedec_sp_n = bit_nmsedec_sp + {{9{bit1_nmsedec_reg[16]}},bit1_nmsedec_reg};
        									 end
											 else begin
											    bit_nmsedec_sp_n = bit_nmsedec_sp;
											 end
											end
        						 3'b010:    begin
        						             bit_nmsedec_mrp_n = bit_nmsedec_mrp + {{9{bit1_nmsedec_reg[16]}},bit1_nmsedec_reg};
        									end
        						 3'b100:    begin
								             if(bit1_add_vld_reg==1'b1) begin
        						               bit_nmsedec_cp_n = bit_nmsedec_cp + {{9{bit1_nmsedec_reg[16]}},bit1_nmsedec_reg};
        									 end
											 else begin
											   bit_nmsedec_cp_n = bit_nmsedec_cp;
											 end
											end	
                                default:   begin
                                             bit_nmsedec_sp_n = bit_nmsedec_sp;
        									 bit_nmsedec_mrp_n = bit_nmsedec_mrp;
        									 bit_nmsedec_cp_n = bit_nmsedec_cp;
        									end
        					   endcase
        				  end
        				   
        	2'b01:         begin
        	                case(pass_judge_2_reg)
        					     3'b001:    begin
        						             if(bit2_add_vld_reg==1'b1) begin
											   bit_nmsedec_sp_n = bit_nmsedec_sp + {{9{bit2_nmsedec_reg[16]}},bit2_nmsedec_reg};
        									 end
											 else begin
											   bit_nmsedec_sp_n = bit_nmsedec_sp;
											 end
											end
        						 3'b010:    begin
        						             bit_nmsedec_mrp_n = bit_nmsedec_mrp + {{9{bit2_nmsedec_reg[16]}},bit2_nmsedec_reg};
        									end
        						 3'b100:    begin
								             if(bit2_add_vld_reg==1'b1) begin
        						               bit_nmsedec_cp_n = bit_nmsedec_cp + {{9{bit2_nmsedec_reg[16]}},bit2_nmsedec_reg};
        									 end
											 else begin
											   bit_nmsedec_cp_n = bit_nmsedec_cp;
											 end
											end	
                                default:   begin
                                            bit_nmsedec_sp_n = bit_nmsedec_sp;
        									 bit_nmsedec_mrp_n = bit_nmsedec_mrp;
        									 bit_nmsedec_cp_n = bit_nmsedec_cp;
        									end
        					endcase
        				   end
           
           2'b10:         begin
        	                case(pass_judge_3_reg)
        					     3'b001:    begin
								              if(bit3_add_vld_reg==1'b1) begin
        						                bit_nmsedec_sp_n = bit_nmsedec_sp + {{9{bit3_nmsedec_reg[16]}},bit3_nmsedec_reg};
        									  end
											  else begin
											    bit_nmsedec_sp_n = bit_nmsedec_sp;
                                              end												
											end
        						 3'b010:    begin
        						             bit_nmsedec_mrp_n = bit_nmsedec_mrp + {{9{bit3_nmsedec_reg[16]}},bit3_nmsedec_reg};
        									end
        						 3'b100:    begin
								              if(bit3_add_vld_reg==1'b1) begin
        						                bit_nmsedec_cp_n = bit_nmsedec_cp + {{9{bit3_nmsedec_reg[16]}},bit3_nmsedec_reg};
        									  end
											  else begin
											    bit_nmsedec_cp_n = bit_nmsedec_cp;
											  end
											end	
                                default:   begin
                                            bit_nmsedec_sp_n = bit_nmsedec_sp;
        									 bit_nmsedec_mrp_n = bit_nmsedec_mrp;
        									 bit_nmsedec_cp_n = bit_nmsedec_cp;
        									end
        					endcase
        				   end	
        				   
        	2'b11:         begin
        	                case(pass_judge_4_reg)
        					     3'b001:    begin
								             if(bit4_add_vld_reg==1'b1) begin
        						               bit_nmsedec_sp_n = bit_nmsedec_sp + {{9{bit4_nmsedec_reg[16]}},bit4_nmsedec_reg};
        									 end
											 else begin
											   bit_nmsedec_sp_n = bit_nmsedec_sp;
											 end
											end
        						 3'b010:    begin
        						             bit_nmsedec_mrp_n = bit_nmsedec_mrp + {{9{bit4_nmsedec_reg[16]}},bit4_nmsedec_reg};
        									end
        						 3'b100:    begin
								             if(bit4_add_vld_reg==1'b1) begin
        						               bit_nmsedec_cp_n = bit_nmsedec_cp + {{9{bit4_nmsedec_reg[16]}},bit4_nmsedec_reg};
        									 end
											 else begin
											   bit_nmsedec_cp_n = bit_nmsedec_cp;
											 end
											end	
                                default:   begin
                                            bit_nmsedec_sp_n = bit_nmsedec_sp;
        									 bit_nmsedec_mrp_n = bit_nmsedec_mrp;
        									 bit_nmsedec_cp_n = bit_nmsedec_cp;
        									end
        					endcase
        				   end	
          endcase
	end
	else begin
	  bit_nmsedec_sp_n = bit_nmsedec_sp;
      bit_nmsedec_mrp_n = bit_nmsedec_mrp;
      bit_nmsedec_cp_n = bit_nmsedec_cp;
    end
end


endmodule
								
						   

   
						
