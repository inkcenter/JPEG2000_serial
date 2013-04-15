`timescale 1ns/10ps
module bpc_state_generate( //out
							bp_data1_state,
                            bp_data2_state,
                            bp_data3_state,
                            bp_data4_state,

							stripe_over_flag,
							level_flag,
							last_stripe_vld,
							stop_flag,
							bpc_start_flag,
							code_over_flag,
							top_plane,
							bit1_nmsedec,
							bit2_nmsedec,
							bit3_nmsedec,
							bit4_nmsedec,
							mul_factor_error,							
							//in
							pass_judge_1,
							pass_judge_2,
							pass_judge_3,
							pass_judge_4,
							block_count_0_lh_y,
							block_count_0_lh_u,
							block_count_0_lh_v,
							block_count_0_hl_y,
							block_count_0_hl_u,
							block_count_0_hl_v,
							block_count_0_hh_y,
							block_count_0_hh_u,
							block_count_0_hh_v,  
							block_count_1_lh_y,
							block_count_1_lh_u,
							block_count_1_lh_v,
							block_count_1_hl_y,
							block_count_1_hl_u,
							block_count_1_hl_v,
							block_count_1_hh_y,
							block_count_1_hh_u,
							block_count_1_hh_v,  
							block_count_2_lh_y,
							block_count_2_lh_u,
							block_count_2_lh_v,
							block_count_2_hl_y,
							block_count_2_hl_u,
							block_count_2_hl_v,
							block_count_2_hh_y,
							block_count_2_hh_u,
							block_count_2_hh_v, 
							block_count_3_lh_y,
							block_count_3_lh_u,
							block_count_3_lh_v,
							block_count_3_hl_y,
							block_count_3_hl_u,
							block_count_3_hl_v,
							block_count_3_hh_y,
							block_count_3_hh_u,
							block_count_3_hh_v,
							block_count_4_lh_y,
							block_count_4_lh_u,
							block_count_4_lh_v,
							block_count_4_hl_y,
							block_count_4_hl_u,
							block_count_4_hl_v,
							block_count_4_hh_y,
							block_count_4_hh_u,
							block_count_4_hh_v,
							block_count_4_ll_y,
							block_count_4_ll_u,
							block_count_4_ll_v,
							bpc_start_delay,
							code_over_delay,
							stall_vld,
							last_stripe_vld_delay,
							stripe_over_delay,
							count_bp,
							level_delay,
							level_reg,
							stop_delay4,
							data_out1,
							data_out2,
							data_out3,
							data_out4,
							count_YUV,
							band,
							clk_sg,
							clk_rc,
							rst,
							rst_syn);
							

						
input bpc_start_delay;
input code_over_delay;
input stall_vld;
input last_stripe_vld_delay;
input [3:0]count_bp;
input [2:0]level_delay;
input [2:0]level_reg;
input stripe_over_delay;
input stop_delay4;									
input [16:0] data_out1;
input [16:0] data_out2;
input [16:0] data_out3;
input [16:0] data_out4;
input [1:0] count_YUV;
input [1:0] band;
input clk_sg;
input clk_rc;
input rst;	
input rst_syn;

input [3:0]block_count_0_lh_y;
input [3:0]block_count_0_lh_u;
input [3:0]block_count_0_lh_v;
input [3:0]block_count_0_hl_y;
input [3:0]block_count_0_hl_u;
input [3:0]block_count_0_hl_v;
input [3:0]block_count_0_hh_y;
input [3:0]block_count_0_hh_u;
input [3:0]block_count_0_hh_v;  
input [3:0]block_count_1_lh_y;
input [3:0]block_count_1_lh_u;
input [3:0]block_count_1_lh_v;
input [3:0]block_count_1_hl_y;
input [3:0]block_count_1_hl_u;
input [3:0]block_count_1_hl_v;
input [3:0]block_count_1_hh_y;
input [3:0]block_count_1_hh_u;
input [3:0]block_count_1_hh_v;  
input [3:0]block_count_2_lh_y;
input [3:0]block_count_2_lh_u;
input [3:0]block_count_2_lh_v;
input [3:0]block_count_2_hl_y;
input [3:0]block_count_2_hl_u;
input [3:0]block_count_2_hl_v;
input [3:0]block_count_2_hh_y;
input [3:0]block_count_2_hh_u;
input [3:0]block_count_2_hh_v; 
input [3:0]block_count_3_lh_y;
input [3:0]block_count_3_lh_u;
input [3:0]block_count_3_lh_v;
input [3:0]block_count_3_hl_y;
input [3:0]block_count_3_hl_u;
input [3:0]block_count_3_hl_v;
input [3:0]block_count_3_hh_y;
input [3:0]block_count_3_hh_u;
input [3:0]block_count_3_hh_v;
input [3:0]block_count_4_lh_y;
input [3:0]block_count_4_lh_u;
input [3:0]block_count_4_lh_v;
input [3:0]block_count_4_hl_y;
input [3:0]block_count_4_hl_u;
input [3:0]block_count_4_hl_v;
input [3:0]block_count_4_hh_y;
input [3:0]block_count_4_hh_u;
input [3:0]block_count_4_hh_v;
input [3:0]block_count_4_ll_y;
input [3:0]block_count_4_ll_u;
input [3:0]block_count_4_ll_v;
input [2:0]pass_judge_1;
input [2:0]pass_judge_2;
input [2:0]pass_judge_3;
input [2:0]pass_judge_4;

output[16:0] bit1_nmsedec;	
output[16:0] bit2_nmsedec;
output[16:0] bit3_nmsedec;
output[16:0] bit4_nmsedec;
output[3:0] mul_factor_error;
output [3:0]bp_data1_state;
output [3:0]bp_data2_state;
output [3:0]bp_data3_state;
output [3:0]bp_data4_state;
output stripe_over_flag;
output [2:0]level_flag;
output last_stripe_vld;
output stop_flag;
output bpc_start_flag;
output code_over_flag;
output [3:0]top_plane;

wire [3:0] bp_data1_state;
wire [3:0] bp_data2_state;
wire [3:0] bp_data3_state;
wire [3:0] bp_data4_state;

reg [3:0]top_plane;
reg mag_in_1;    
reg gama_in_1;   
reg [3:0]MSB_1;
wire sign_in_1;	
wire sigma_in_1;
reg mag_in_2;  
reg gama_in_2; 
reg [3:0]MSB_2;
wire sign_in_2;
wire sigma_in_2;
reg mag_in_3;   
reg gama_in_3;  
reg [3:0]MSB_3;
wire sign_in_3;
wire sigma_in_3;
reg mag_in_4;   
reg gama_in_4;  
reg [3:0]MSB_4;
wire sign_in_4;
wire sigma_in_4;


//********************************** for error *************************************//
reg [16:0] data_out1_for_error_n;
reg [16:0] data_out2_for_error_n;
reg [16:0] data_out3_for_error_n;
reg [16:0] data_out4_for_error_n;
reg[15:0] data_out1_for_error_a;
reg[15:0] data_out2_for_error_a;
reg[15:0] data_out3_for_error_a;
reg[15:0] data_out4_for_error_a;
reg[6:0] index1_bit_a;
reg[6:0] index2_bit_a;
reg[6:0] index3_bit_a;
reg[6:0] index4_bit_a;
reg[6:0] index1_bit_b;
reg[6:0] index2_bit_b;
reg[6:0] index3_bit_b;
reg[6:0] index4_bit_b;
reg[6:0] index1_bit_c;
reg[6:0] index2_bit_c;
reg[6:0] index3_bit_c;
reg[6:0] index4_bit_c;
reg[6:0] index1_bit_d;
reg[6:0] index2_bit_d;
reg[6:0] index3_bit_d;
reg[6:0] index4_bit_d;
reg[16:0]bit1_nmsedec;
reg[16:0]bit2_nmsedec;
reg[16:0]bit3_nmsedec;
reg[16:0]bit4_nmsedec;   
reg[16:0]bit1_nmsedec_n;
reg[16:0]bit2_nmsedec_n;
reg[16:0]bit3_nmsedec_n;
reg[16:0]bit4_nmsedec_n;
reg[3:0] mul_factor_error;
reg[3:0] mul_factor_error_n;
//reg[1:0] count_YUV_reg;
//reg[1:0] count_YUV_reg_1;
reg[1:0] count_YUV_for_error;
reg[1:0] count_YUV_for_error_delay;
wire zero_judge_1;
wire zero_judge_2;
wire zero_judge_3;
wire zero_judge_4;
wire[7:0] index1_bit_d_p;
wire[7:0] index2_bit_d_p;
wire[7:0] index3_bit_d_p;
wire[7:0] index4_bit_d_p;
reg [3:0]count_bp_delay_1;
reg [3:0]count_bp_delay_2;
reg [3:0]count_bp_delay_a;

reg clk_sg_reg;
always@(posedge clk_rc or negedge rst)
	begin
		if(!rst)
			clk_sg_reg<=0;
		else if(rst_syn)
			clk_sg_reg<=0;	
		else 	
			clk_sg_reg<=clk_sg;
	end
wire pos_clk_bpc=((clk_sg_reg==1'b0)&&(clk_sg==1'b1))?1'b1:1'b0;

always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		count_bp_delay_1 <= 4'b0;
		count_bp_delay_2 <= 4'b0;
		count_bp_delay_a <= 4'b0;
	end
	else if(rst_syn)begin
		count_bp_delay_1 <= 4'b0;
		count_bp_delay_2 <= 4'b0;
		count_bp_delay_a <= 4'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		count_bp_delay_1<=count_bp;
		count_bp_delay_2<=count_bp_delay_1;
		count_bp_delay_a<=count_bp_delay_2;
	end
end


always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		data_out1_for_error_n <= 17'b0;
		data_out2_for_error_n <= 17'b0;
		data_out3_for_error_n <= 17'b0;
		data_out4_for_error_n <= 17'b0;
	end
	else if(rst_syn)begin
		data_out1_for_error_n <= 17'b0;
		data_out2_for_error_n <= 17'b0;
		data_out3_for_error_n <= 17'b0;
		data_out4_for_error_n <= 17'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			data_out1_for_error_n <= data_out1;
			data_out2_for_error_n <= data_out2;
			data_out3_for_error_n <= data_out3;
			data_out4_for_error_n <= data_out4;
		end
	end		
end		

		

always@(posedge clk_rc or negedge rst) begin
	    if(!rst) begin
		    data_out1_for_error_a <= 16'b0;
			data_out2_for_error_a <= 16'b0;
			data_out3_for_error_a <= 16'b0;
			data_out4_for_error_a <= 16'b0;
		end
		else if(rst_syn)begin
			data_out1_for_error_a <= 16'b0;
		    data_out2_for_error_a <= 16'b0;
		    data_out3_for_error_a <= 16'b0;
		    data_out4_for_error_a <= 16'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				data_out1_for_error_a <= data_out1_for_error_n;
				data_out2_for_error_a <= data_out2_for_error_n;
				data_out3_for_error_a <= data_out3_for_error_n;
				data_out4_for_error_a <= data_out4_for_error_n;
			end
		end	
end



 always @(*) begin
    index1_bit_a=0;
	case(count_bp_delay_a)			////notice
       15:index1_bit_a=data_out1_for_error_a[15:9];
	   14:index1_bit_a=data_out1_for_error_a[14:8];
	   13:index1_bit_a=data_out1_for_error_a[13:7];
       12:index1_bit_a=data_out1_for_error_a[12:6];
       11:index1_bit_a=data_out1_for_error_a[11:5];
       10:index1_bit_a=data_out1_for_error_a[10:4];
       9:index1_bit_a=data_out1_for_error_a[9:3];
       8:index1_bit_a=data_out1_for_error_a[8:2];
       7:index1_bit_a=data_out1_for_error_a[7:1];
       6:index1_bit_a=data_out1_for_error_a[6:0];
       5:index1_bit_a={data_out1_for_error_a[5:0],1'b0};
       4:index1_bit_a={data_out1_for_error_a[4:0],2'b00};
     endcase		
end
always @(*) begin
    index2_bit_a=0;
     case(count_bp_delay_a)
       15:index2_bit_a=data_out2_for_error_a[15:9];
	   14:index2_bit_a=data_out2_for_error_a[14:8];
	   13:index2_bit_a=data_out2_for_error_a[13:7];
       12:index2_bit_a=data_out2_for_error_a[12:6];
       11:index2_bit_a=data_out2_for_error_a[11:5];
       10:index2_bit_a=data_out2_for_error_a[10:4];
       9:index2_bit_a=data_out2_for_error_a[9:3];
       8:index2_bit_a=data_out2_for_error_a[8:2];
       7:index2_bit_a=data_out2_for_error_a[7:1];
       6:index2_bit_a=data_out2_for_error_a[6:0];
       5:index2_bit_a={data_out2_for_error_a[5:0],1'b0};
       4:index2_bit_a={data_out2_for_error_a[4:0],2'b00};
     endcase
end 
 always @(*) begin
    index3_bit_a=0;
     case(count_bp_delay_a)
       15:index3_bit_a=data_out3_for_error_a[15:9];
	   14:index3_bit_a=data_out3_for_error_a[14:8];
	   13:index3_bit_a=data_out3_for_error_a[13:7];
       12:index3_bit_a=data_out3_for_error_a[12:6];
       11:index3_bit_a=data_out3_for_error_a[11:5];
       10:index3_bit_a=data_out3_for_error_a[10:4];
       9:index3_bit_a=data_out3_for_error_a[9:3];
       8:index3_bit_a=data_out3_for_error_a[8:2];
       7:index3_bit_a=data_out3_for_error_a[7:1];
       6:index3_bit_a=data_out3_for_error_a[6:0];
       5:index3_bit_a={data_out3_for_error_a[5:0],1'b0};
       4:index3_bit_a={data_out3_for_error_a[4:0],2'b00};
     endcase
end 	
 always @(*) begin
    index4_bit_a=0;
     case(count_bp_delay_a)
       15:index4_bit_a=data_out4_for_error_a[15:9];
	   14:index4_bit_a=data_out4_for_error_a[14:8];
	   13:index4_bit_a=data_out4_for_error_a[13:7];
       12:index4_bit_a=data_out4_for_error_a[12:6];
       11:index4_bit_a=data_out4_for_error_a[11:5];
       10:index4_bit_a=data_out4_for_error_a[10:4];
       9:index4_bit_a=data_out4_for_error_a[9:3];
       8:index4_bit_a=data_out4_for_error_a[8:2];
       7:index4_bit_a=data_out4_for_error_a[7:1];
       6:index4_bit_a=data_out4_for_error_a[6:0];
       5:index4_bit_a={data_out4_for_error_a[5:0],1'b0};
       4:index4_bit_a={data_out4_for_error_a[4:0],2'b00};
     endcase
end 
always@(posedge clk_rc or negedge rst) begin
   	    if(!rst) begin
   		    index1_bit_b <= 7'b0;
   			index2_bit_b <= 7'b0;
   			index3_bit_b <= 7'b0;
   			index4_bit_b <= 7'b0;
   		end
		else if(rst_syn)begin
			index1_bit_b <= 7'b0;
		    index2_bit_b <= 7'b0;
		    index3_bit_b <= 7'b0;
		    index4_bit_b <= 7'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				index1_bit_b <= index1_bit_a;
				index2_bit_b <= index2_bit_a;
				index3_bit_b <= index3_bit_a;
				index4_bit_b <= index4_bit_a;
			end
		end	
end
always@(posedge clk_rc or negedge rst) begin
   	    if(!rst) begin
   		    index1_bit_c <= 7'b0;
   			index2_bit_c <= 7'b0;
   			index3_bit_c <= 7'b0;
   			index4_bit_c <= 7'b0;
   		end
		else if(rst_syn)begin
			index1_bit_c <= 7'b0;
		    index2_bit_c <= 7'b0;
		    index3_bit_c <= 7'b0;
		    index4_bit_c <= 7'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				index1_bit_c <= index1_bit_b;
				index2_bit_c <= index2_bit_b;
				index3_bit_c <= index3_bit_b;
				index4_bit_c <= index4_bit_b;
			end
	end
end
always@(posedge clk_rc or negedge rst) begin
   	    if(!rst) begin
   		    index1_bit_d <= 7'b0;
   			index2_bit_d <= 7'b0;
   			index3_bit_d <= 7'b0;
   			index4_bit_d <= 7'b0;
   		end
		else if(rst_syn)begin
			index1_bit_d <= 7'b0;
		    index2_bit_d <= 7'b0;
		    index3_bit_d <= 7'b0;
		    index4_bit_d <= 7'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				index1_bit_d <= index1_bit_c;
				index2_bit_d <= index2_bit_c;
				index3_bit_d <= index3_bit_c;
				index4_bit_d <= index4_bit_c;
			end
	end	
end

reg[13:0] index1_bit2_d;
reg[13:0] index2_bit2_d;
reg[13:0] index3_bit2_d;
reg[13:0] index4_bit2_d;
always@(posedge clk_rc or negedge rst) begin
		if(!rst) begin
			index1_bit2_d <= 14'b0;
			index2_bit2_d <= 14'b0;
			index3_bit2_d <= 14'b0;
			index4_bit2_d <= 14'b0;
		end
		else if(rst_syn)begin
			index1_bit2_d <= 14'b0;
			index2_bit2_d <= 14'b0;
			index3_bit2_d <= 14'b0;
			index4_bit2_d <= 14'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				index1_bit2_d <= index1_bit_c*index1_bit_c;
				index2_bit2_d <= index2_bit_c*index2_bit_c;
				index3_bit2_d <= index3_bit_c*index3_bit_c;
				index4_bit2_d <= index4_bit_c*index4_bit_c;
			end
	end
end


assign index1_bit_d_p= {1'b1,(~index1_bit_d+1)};
assign index2_bit_d_p= {1'b1,(~index2_bit_d+1)};
assign index3_bit_d_p= {1'b1,(~index3_bit_d+1)};
assign index4_bit_d_p= {1'b1,(~index4_bit_d+1)};
assign zero_judge_1 = (index1_bit_d==7'b0);
assign zero_judge_2 = (index2_bit_d==7'b0);
assign zero_judge_3 = (index3_bit_d==7'b0);
assign zero_judge_4 = (index4_bit_d==7'b0);

always @(*) begin
  bit1_nmsedec_n=bit1_nmsedec;
    case(pass_judge_1)
      3'b001,3'b100:    begin
                          if(count_bp_delay_a>6)
                            bit1_nmsedec_n=$signed({1'b0,index1_bit_d,8'b0000_0000})+$signed({2'b00,index1_bit_d,7'b000_0000})+$signed(16'b1011_1000_0000_0000);
                          else
                            bit1_nmsedec_n=$signed({1'b0,index1_bit2_d,1'b0});        
                        end
    
      3'b010:           begin
                          if(count_bp_delay_a>6)
                             bit1_nmsedec_n=index1_bit_d[6]?($signed({2'b00,index1_bit_d,7'b000_0000})-$signed(16'b0010_1000_0000_0000) ) : ((zero_judge_1)? ($signed(17'b00001_1000_0000_0000)):($signed({1'b1,index1_bit_d_p,7'b000_0000})+$signed(16'b0001_1000_0000_0000)));
                           else  
                             bit1_nmsedec_n=$signed({1'b0,index1_bit2_d,1'b0})-$signed({1'b0,index1_bit_d,8'b0000_0000})+$signed(16'b0010_0000_0000_0000);
                        end
	  
	 default:           begin
                          bit1_nmsedec_n=bit1_nmsedec;
         	            end      
   endcase
end

always @(*) begin
  bit2_nmsedec_n=bit2_nmsedec;
    case(pass_judge_2)
      3'b001,3'b100:    begin
                          if(count_bp_delay_a>6)
                            bit2_nmsedec_n=$signed({1'b0,index2_bit_d,8'b0000_0000})+$signed({2'b00,index2_bit_d,7'b000_0000})+$signed(16'b1011_1000_0000_0000);
                          else
                            bit2_nmsedec_n=$signed({1'b0,index2_bit2_d,1'b0});        
                        end
    
      3'b010:           begin
                          if(count_bp_delay_a>6)
                             bit2_nmsedec_n=index2_bit_d[6]?($signed({2'b00,index2_bit_d,7'b000_0000})-$signed(16'b0010_1000_0000_0000) ) : ((zero_judge_2)? ($signed(17'b00001_1000_0000_0000)):($signed({1'b1,index2_bit_d_p,7'b000_0000})+$signed(16'b0001_1000_0000_0000)));
                           else  
                             bit2_nmsedec_n=$signed({1'b0,index2_bit2_d,1'b0})-$signed({1'b0,index2_bit_d,8'b0000_0000})+$signed(16'b0010_0000_0000_0000);
                        end
	  
	 default:           begin
                          bit2_nmsedec_n=bit2_nmsedec;
         	            end 
      
   endcase
end

always @(*) begin
  bit3_nmsedec_n=bit3_nmsedec;
    case(pass_judge_3)
      3'b001,3'b100:    begin
                         if(count_bp_delay_a>6)
                            bit3_nmsedec_n=$signed({1'b0,index3_bit_d,8'b0000_0000})+$signed({2'b00,index3_bit_d,7'b000_0000})+$signed(16'b1011_1000_0000_0000);
                          else
                            bit3_nmsedec_n=$signed({1'b0,index3_bit2_d,1'b0});        
                        end
    
      3'b010:           begin
                           if(count_bp_delay_a>6)
                             bit3_nmsedec_n=index3_bit_d[6]?($signed({2'b00,index3_bit_d,7'b000_0000})-$signed(16'b0010_1000_0000_0000) ) : ((zero_judge_3)? ($signed(17'b00001_1000_0000_0000)):($signed({1'b1,index3_bit_d_p,7'b000_0000})+$signed(16'b0001_1000_0000_0000)));
                           else  
                             bit3_nmsedec_n=$signed({1'b0,index3_bit2_d,1'b0})-$signed({1'b0,index3_bit_d,8'b0000_0000})+$signed(16'b0010_0000_0000_0000);
                        end
	  
	 default:           begin
                          bit3_nmsedec_n=bit3_nmsedec;
         	            end 
      
   endcase
end


always @(*) begin
  bit4_nmsedec_n=bit4_nmsedec;
    case(pass_judge_4)
      3'b001,3'b100:    begin
                          if(count_bp_delay_a>6)
                            bit4_nmsedec_n=$signed({1'b0,index4_bit_d,8'b0000_0000})+$signed({2'b00,index4_bit_d,7'b000_0000})+$signed(16'b1011_1000_0000_0000);
                          else
                            bit4_nmsedec_n=$signed({1'b0,index4_bit2_d,1'b0});        
                        end
    
      3'b010:           begin
                           if(count_bp_delay_a>6)
                             bit4_nmsedec_n=index4_bit_d[6]?($signed({2'b00,index4_bit_d,7'b000_0000})-$signed(16'b0010_1000_0000_0000) ) : ((zero_judge_4)?($signed(17'b00001_1000_0000_0000)):($signed({1'b1,index4_bit_d_p,7'b000_0000})+$signed(16'b0001_1000_0000_0000)));
                           else  
                             bit4_nmsedec_n=$signed({1'b0,index4_bit2_d,1'b0})-$signed({1'b0,index4_bit_d,8'b0000_0000})+$signed(16'b0010_0000_0000_0000);
                        end
	  
	 default:           begin
                          bit4_nmsedec_n=bit4_nmsedec;
         	            end 
      
   endcase
end

always @(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    bit1_nmsedec <= 17'b0;
	bit2_nmsedec <= 17'b0;
	bit3_nmsedec <= 17'b0;
	bit4_nmsedec <= 17'b0;
  end
  else if(rst_syn)begin
	bit1_nmsedec <= 17'b0;
    bit2_nmsedec <= 17'b0;
    bit3_nmsedec <= 17'b0;
    bit4_nmsedec <= 17'b0;
  end
  else if(pos_clk_bpc==1'b1)begin
	if(stall_vld==1'b0) begin
		bit1_nmsedec <= bit1_nmsedec_n;
		bit2_nmsedec <= bit2_nmsedec_n;
		bit3_nmsedec <= bit3_nmsedec_n;
		bit4_nmsedec <= bit4_nmsedec_n;
	end
 end 
end


	
always @(*) begin  
	case(count_YUV_for_error_delay) 
	  2'b00:                begin
                              mul_factor_error_n = 4'b1100;
                            end
      2'b01:                begin
                              mul_factor_error_n = 4'b1101;
                            end										 
	  2'b10:                begin
                              mul_factor_error_n = 4'b1010;
                            end
							
	default:               begin
	                          mul_factor_error_n = 4'b0;
							end
	endcase
end

	
always @(posedge clk_rc or negedge rst) begin
		if(!rst) begin
				mul_factor_error <= 4'b0;
		end
		else if(rst_syn)begin
			mul_factor_error <= 4'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				mul_factor_error <= mul_factor_error_n;
			end
	end
end

always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		//count_YUV_reg<=2'b0;
		//count_YUV_reg_1<=2'b0;
		count_YUV_for_error<=2'b0;
		count_YUV_for_error_delay<=2'b0;
	end
	else if(rst_syn)begin
		//count_YUV_reg<=2'b0;
		//count_YUV_reg_1<=2'b0;
		count_YUV_for_error<=2'b0;
		count_YUV_for_error_delay<=2'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			count_YUV_for_error<=count_YUV;
			count_YUV_for_error_delay<=count_YUV_for_error;
		end
	end		
end		
		
		
	
//**********************************************************************//


wire [15:0]din_mag_1;
wire [15:0]din_mag_2;
wire [15:0]din_mag_3;
wire [15:0]din_mag_4;
reg [16:0] data_out1_reg;
reg [16:0] data_out2_reg;
reg [16:0] data_out3_reg;
reg [16:0] data_out4_reg;

always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
	    data_out1_reg <= 17'b0;
		data_out2_reg <= 17'b0;
		data_out3_reg <= 17'b0;
		data_out4_reg <= 17'b0;
	end
	else if(rst_syn)begin
		data_out1_reg <= 17'b0;
	    data_out2_reg <= 17'b0;
	    data_out3_reg <= 17'b0;
	    data_out4_reg <= 17'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			data_out1_reg <= data_out1;
			data_out2_reg <= data_out2;
			data_out3_reg <= data_out3;
			data_out4_reg <= data_out4;
		end
		else begin
			data_out1_reg <= data_out1_reg;
			data_out2_reg <= data_out2_reg;
			data_out3_reg <= data_out3_reg;
			data_out4_reg <= data_out4_reg;
		end
	end	
end
	
assign din_mag_1=data_out1_reg[15:0];
assign din_mag_2=data_out2_reg[15:0];
assign din_mag_3=data_out3_reg[15:0];
assign din_mag_4=data_out4_reg[15:0];

always @(*)
  begin
    MSB_1=0;
    casez(din_mag_1)
	  16'b1???_????_????_????:MSB_1=15;	
      16'b01??_????_????_????:MSB_1=14;
      16'b001?_????_????_????:MSB_1=13;
      16'b0001_????_????_????:MSB_1=12;
      16'b0000_1???_????_????:MSB_1=11;
      16'b0000_01??_????_????:MSB_1=10;
      16'b0000_001?_????_????:MSB_1=9;
      16'b0000_0001_????_????:MSB_1=8;
      16'b0000_0000_1???_????:MSB_1=7;
      16'b0000_0000_01??_????:MSB_1=6;
      16'b0000_0000_001?_????:MSB_1=5;
      16'b0000_0000_0001_????:MSB_1=4;
      16'b0000_0000_0000_????:MSB_1=0;
    endcase
  end
  
always @(*)
 begin
   MSB_2=0;
   casez(din_mag_2)
     16'b1???_????_????_????:MSB_2=15;
     16'b01??_????_????_????:MSB_2=14;
     16'b001?_????_????_????:MSB_2=13;
     16'b0001_????_????_????:MSB_2=12;
     16'b0000_1???_????_????:MSB_2=11;
     16'b0000_01??_????_????:MSB_2=10;
     16'b0000_001?_????_????:MSB_2=9;
     16'b0000_0001_????_????:MSB_2=8;
     16'b0000_0000_1???_????:MSB_2=7;
     16'b0000_0000_01??_????:MSB_2=6;
     16'b0000_0000_001?_????:MSB_2=5;
     16'b0000_0000_0001_????:MSB_2=4;
     16'b0000_0000_0000_????:MSB_2=0;
   endcase
 end
 
always @(*)
 begin
   MSB_3=0;
   casez(din_mag_3)
     16'b1???_????_????_????:MSB_3=15;
     16'b01??_????_????_????:MSB_3=14;
     16'b001?_????_????_????:MSB_3=13;
     16'b0001_????_????_????:MSB_3=12;
     16'b0000_1???_????_????:MSB_3=11;
     16'b0000_01??_????_????:MSB_3=10;
     16'b0000_001?_????_????:MSB_3=9;
     16'b0000_0001_????_????:MSB_3=8;
     16'b0000_0000_1???_????:MSB_3=7;
     16'b0000_0000_01??_????:MSB_3=6;
     16'b0000_0000_001?_????:MSB_3=5;
     16'b0000_0000_0001_????:MSB_3=4;
     16'b0000_0000_0000_????:MSB_3=0;
   endcase
 end
  
always @(*)
 begin
   MSB_4=0;
   casez(din_mag_4)
     16'b1???_????_????_????:MSB_4=15;
     16'b01??_????_????_????:MSB_4=14;
     16'b001?_????_????_????:MSB_4=13;
     16'b0001_????_????_????:MSB_4=12;
     16'b0000_1???_????_????:MSB_4=11;
     16'b0000_01??_????_????:MSB_4=10;
     16'b0000_001?_????_????:MSB_4=9;
     16'b0000_0001_????_????:MSB_4=8;
     16'b0000_0000_1???_????:MSB_4=7;
     16'b0000_0000_01??_????:MSB_4=6;
     16'b0000_0000_001?_????:MSB_4=5;
     16'b0000_0000_0001_????:MSB_4=4;
     16'b0000_0000_0000_????:MSB_4=0;
   endcase
 end

assign sign_in_1=data_out1_reg[16];
assign sigma_in_1=(count_bp<MSB_1)?1:0;
//always @(count_bp or data_out1_reg)begin
always @(*)begin
  case(count_bp)
	15:begin
         mag_in_1=data_out1_reg[15];
       end
    14:begin
         mag_in_1=data_out1_reg[14];
       end
    13:begin
         mag_in_1=data_out1_reg[13];
       end     
    12:begin
         mag_in_1=data_out1_reg[12];
       end 
    11:begin
         mag_in_1=data_out1_reg[11];
       end
    10:begin
         mag_in_1=data_out1_reg[10];
       end
     9:begin
         mag_in_1=data_out1_reg[9];
       end
     8:begin
         mag_in_1=data_out1_reg[8];
       end
     7:begin
         mag_in_1=data_out1_reg[7];
       end
     6:begin
         mag_in_1=data_out1_reg[6];
       end
     5:begin
         mag_in_1=data_out1_reg[5];
       end
     4:begin
         mag_in_1=data_out1_reg[4];
       end
     default:
       begin
         mag_in_1=0;
       end
  endcase
end
always @(*)begin 
  if(MSB_1<6)
    gama_in_1=0;
  else if(count_bp> MSB_1-2)
    gama_in_1=0;
  else
    gama_in_1=1;
end

assign sign_in_2=data_out2_reg[16];
assign sigma_in_2=(count_bp<MSB_2)?1:0;
always @(*)begin
  case(count_bp)
	15:begin
         mag_in_2=data_out2_reg[15];
       end
    14:begin
         mag_in_2=data_out2_reg[14];
       end
    13:begin
         mag_in_2=data_out2_reg[13];
       end     
    12:begin
         mag_in_2=data_out2_reg[12];
       end 
    11:begin
         mag_in_2=data_out2_reg[11];
       end
    10:begin
         mag_in_2=data_out2_reg[10];
       end
     9:begin
         mag_in_2=data_out2_reg[9];
       end
     8:begin
         mag_in_2=data_out2_reg[8];
       end
     7:begin
         mag_in_2=data_out2_reg[7];
       end
     6:begin
         mag_in_2=data_out2_reg[6];
       end
     5:begin
         mag_in_2=data_out2_reg[5];
       end
     4:begin
         mag_in_2=data_out2_reg[4];
       end
     default:
       begin
         mag_in_2=0;
       end
  endcase
end
always @(*)begin 
  if(MSB_2<6)
    gama_in_2=0;
  else if(count_bp> MSB_2-2)
    gama_in_2=0;
  else
    gama_in_2=1;
end

assign sign_in_3=data_out3_reg[16];
assign sigma_in_3=(count_bp<MSB_3)?1:0;
always @(*)begin
  case(count_bp)
	15:begin
         mag_in_3=data_out3_reg[15];
       end
    14:begin
         mag_in_3=data_out3_reg[14];
       end
    13:begin
         mag_in_3=data_out3_reg[13];
       end     
    12:begin
         mag_in_3=data_out3_reg[12];
       end 
    11:begin
         mag_in_3=data_out3_reg[11];
       end
    10:begin
         mag_in_3=data_out3_reg[10];
       end
     9:begin
         mag_in_3=data_out3_reg[9];
       end
     8:begin
         mag_in_3=data_out3_reg[8];
       end
     7:begin
         mag_in_3=data_out3_reg[7];
       end
     6:begin
         mag_in_3=data_out3_reg[6];
       end
     5:begin
         mag_in_3=data_out3_reg[5];
       end
     4:begin
         mag_in_3=data_out3_reg[4];
       end
     default:
       begin
         mag_in_3=0;
       end
  endcase
end
always @(*)begin 
  if(MSB_3<6)
    gama_in_3=0;
  else if(count_bp> MSB_3-2)
    gama_in_3=0;
  else
    gama_in_3=1;
end

assign sign_in_4=data_out4_reg[16];
assign sigma_in_4=(count_bp<MSB_4)?1:0;
always @(*)begin
  case(count_bp)
	15:begin//12
         mag_in_4=data_out4_reg[15];
       end
    14:begin//11
         mag_in_4=data_out4_reg[14];
       end
    13:begin
         mag_in_4=data_out4_reg[13];
       end     
    12:begin
         mag_in_4=data_out4_reg[12];
       end 
    11:begin
         mag_in_4=data_out4_reg[11];
       end
    10:begin
         mag_in_4=data_out4_reg[10];
       end
     9:begin
         mag_in_4=data_out4_reg[9];
       end
     8:begin
         mag_in_4=data_out4_reg[8];
       end
     7:begin
         mag_in_4=data_out4_reg[7];
       end
     6:begin
         mag_in_4=data_out4_reg[6];
       end
     5:begin
         mag_in_4=data_out4_reg[5];
       end
     4:begin
         mag_in_4=data_out4_reg[4];
       end
     default:
       begin
         mag_in_4=0;
       end
  endcase
end
//always @(MSB_4 or count_bp)begin 
always @(*)begin
  if(MSB_4<6)
    gama_in_4=0;
  else if(count_bp> MSB_4-2)
    gama_in_4=0;
  else
    gama_in_4=1;
end

assign bp_data1_state={sign_in_1,mag_in_1,gama_in_1,sigma_in_1};
assign bp_data2_state={sign_in_2,mag_in_2,gama_in_2,sigma_in_2};
assign bp_data3_state={sign_in_3,mag_in_3,gama_in_3,sigma_in_3};
assign bp_data4_state={sign_in_4,mag_in_4,gama_in_4,sigma_in_4};



wire [6:0]select;
assign select=(level_reg!=3'b111)?({level_reg,count_YUV,band}):7'b0;


always@(*)
	begin		
		case(select)
				7'b1000000:begin	//ll
							top_plane=block_count_4_ll_y+3;
						end
				7'b1000001:begin	//hl
							top_plane=block_count_4_hl_y+3;
						end
				7'b1000010:begin	//lh
							top_plane=block_count_4_lh_y+3;
						end
				7'b1000011:begin	//hh
							top_plane=block_count_4_hh_y+3;
						end
				
				7'b1000100:begin
							top_plane=block_count_4_ll_u+3;
						end
				7'b1000101:begin
							top_plane=block_count_4_hl_u+3;
						end
				7'b1000110:begin
							top_plane=block_count_4_lh_u+3;
						end
				7'b1000111:begin
							top_plane=block_count_4_hh_u+3;
						end
				7'b1001000:begin
							top_plane=block_count_4_ll_v+3;
						end		
				7'b1001001:begin		
							top_plane=block_count_4_hl_v+3;
						end		
				7'b1001010:begin		
							top_plane=block_count_4_lh_v+3;
						end		
				7'b1001011:begin		
							top_plane=block_count_4_hh_v+3;
						end		
				
				///011
				7'b0110001:begin
							top_plane=block_count_3_hl_y+3;
						end
				7'b0110010:begin
							top_plane=block_count_3_lh_y+3;
						end
				7'b0110011:begin
							top_plane=block_count_3_hh_y+3;
						end
				7'b0110101:begin
							top_plane=block_count_3_hl_u+3;
						end
				7'b0110110:begin		
							top_plane=block_count_3_lh_u+3;
						end
				7'b0110111:begin
							top_plane=block_count_3_hh_u+3;
						end
				7'b0111001:begin
							top_plane=block_count_3_hl_v+3;
						end
				7'b0111010:begin
							top_plane=block_count_3_lh_v+3;
						end
				7'b0111011:begin
							top_plane=block_count_3_hh_v+3;
						end
				///010
				7'b0100001:begin
							top_plane=block_count_2_hl_y+3;
						end
				7'b0100010:begin
							top_plane=block_count_2_lh_y+3;
						end
				7'b0100011:begin
							top_plane=block_count_2_hh_y+3;
						end
				7'b0100101:begin
							top_plane=block_count_2_hl_u+3;
						end
				7'b0100110:begin
							top_plane=block_count_2_lh_u+3;
						end
				7'b0100111:begin
							top_plane=block_count_2_hh_u+3;
						end
				7'b0101001:begin
							top_plane=block_count_2_hl_v+3;
						end
				7'b0101010:begin
							top_plane=block_count_2_lh_v+3;
						end
				7'b0101011:begin
							top_plane=block_count_2_hh_v+3;
						end
				//001
				7'b0010001:begin
							top_plane=block_count_1_hl_y+3;
						end
				7'b0010010:begin
							top_plane=block_count_1_lh_y+3;
						end
				7'b0010011:begin
							top_plane=block_count_1_hh_y+3;
						end
				7'b0010101:begin
							top_plane=block_count_1_hl_u+3;
						end
				7'b0010110:begin
							top_plane=block_count_1_lh_u+3;
						end
				7'b0010111:begin
							top_plane=block_count_1_hh_u+3;
						end
				7'b0011001:begin
							top_plane=block_count_1_hl_v+3;
						end
				7'b0011010:begin
							top_plane=block_count_1_lh_v+3;
						end
				7'b0011011:begin
							top_plane=block_count_1_hh_v+3;
						end
				///000
				7'b0000001:begin
							top_plane=block_count_0_hl_y+3;
						end
				7'b0000010:begin
							top_plane=block_count_0_lh_y+3;
						end
				7'b0000011:begin
							top_plane=block_count_0_hh_y+3;
						end
				7'b0000101:begin
							top_plane=block_count_0_hl_u+3;
						end
				7'b0000110:begin
							top_plane=block_count_0_lh_u+3;
						end
				7'b0000111:begin
							top_plane=block_count_0_hh_u+3;
						end
				7'b0001001:begin
							top_plane=block_count_0_hl_v+3;
						end
				7'b0001010:begin
							top_plane=block_count_0_lh_v+3;
						end
				7'b0001011:begin
							top_plane=block_count_0_hh_v+3;
						end
				default:	top_plane=0;
		endcase
	end



//***********************************************************//
reg bpc_start_flag;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		bpc_start_flag <= 1'b0;
	end
	else if(rst_syn)begin
		bpc_start_flag <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			bpc_start_flag <=bpc_start_delay;
		end
	end
end


reg code_over_flag;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		code_over_flag <= 1'b0;
	end
	else if(rst_syn)begin
		code_over_flag <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			code_over_flag <= code_over_delay;
		end
	end
end

reg [2:0] level_flag;


always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		level_flag <= 3'b0;
	end
	else if(rst_syn)begin
		level_flag <= 3'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			level_flag <= level_delay;
		end
	end
end

reg  stripe_over_flag;
//reg stripe_over_delay1;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		//stripe_over_delay1 <= 1'b0;
		stripe_over_flag <= 1'b0;
	end
	else if(rst_syn)begin
		//stripe_over_delay1 <= 1'b0;		
		stripe_over_flag <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin	
		if(stall_vld == 1'b0)begin
			//stripe_over_delay1 <= stripe_over_delay;
			stripe_over_flag <= stripe_over_delay;
		end
	end
end

reg last_stripe_vld;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		last_stripe_vld <= 1'b0;
	end
	else if(rst_syn)begin
		last_stripe_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			last_stripe_vld <= last_stripe_vld_delay;
		end
	end
end

reg stop_flag;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		stop_flag <= 1'b0;
	end
	else if(rst_syn)begin
		stop_flag <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			stop_flag <= stop_delay4;
		end
	end
end

reg[1:0]band_flag;
reg[1:0]band_delay1;
always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		band_delay1 <= 2'b0;
		band_flag <= 2'b0;
	end
	else if(rst_syn)begin
		band_delay1 <= 2'b0;
		band_flag <= 2'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			band_delay1 <= band;
			band_flag <= band_delay1;
		end
	end
end


 
endmodule 
