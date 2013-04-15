`timescale 1ns/10ps
module bit_plane_count(//out 
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
						
						//block_count_0_hl,
						//block_count_0_lh,
						//block_count_0_hh,
						//block_count_1_hl,
						//block_count_1_lh,
						//block_count_1_hh,
						//block_count_2_hl,
						//block_count_2_lh,
						//block_count_2_hh,
						//block_count_3_hl,
						//block_count_3_lh,
						//block_count_3_hh,
						//block_count_4_hl,
						//block_count_4_lh,
						//block_count_4_hh,
						//block_count_4_ll,

						//in
						clk_mmu,
						rst,
						rst_syn,	
						quant_out_vld,	
						dina_1,
						dina_2,
						dina_3,
						dina_4,
						unvalid_cnt,
						level);

input clk_mmu;
input rst;
input rst_syn;
input quant_out_vld;
input [16:0]dina_1;
input [16:0]dina_2;
input [16:0]dina_3;
input [16:0]dina_4;
input [1:0]unvalid_cnt;
input [2:0]level;

//output 
output [3:0]block_count_0_lh_y;
output [3:0]block_count_0_lh_u;
output [3:0]block_count_0_lh_v;
output [3:0]block_count_0_hl_y;
output [3:0]block_count_0_hl_u;
output [3:0]block_count_0_hl_v;
output [3:0]block_count_0_hh_y;
output [3:0]block_count_0_hh_u;
output [3:0]block_count_0_hh_v;  
output [3:0]block_count_1_lh_y;
output [3:0]block_count_1_lh_u;
output [3:0]block_count_1_lh_v;
output [3:0]block_count_1_hl_y;
output [3:0]block_count_1_hl_u;
output [3:0]block_count_1_hl_v;
output [3:0]block_count_1_hh_y;
output [3:0]block_count_1_hh_u;
output [3:0]block_count_1_hh_v;  
output [3:0]block_count_2_lh_y;
output [3:0]block_count_2_lh_u;
output [3:0]block_count_2_lh_v;
output [3:0]block_count_2_hl_y;
output [3:0]block_count_2_hl_u;
output [3:0]block_count_2_hl_v;
output [3:0]block_count_2_hh_y;
output [3:0]block_count_2_hh_u;
output [3:0]block_count_2_hh_v; 
output [3:0]block_count_3_lh_y;
output [3:0]block_count_3_lh_u;
output [3:0]block_count_3_lh_v;
output [3:0]block_count_3_hl_y;
output [3:0]block_count_3_hl_u;
output [3:0]block_count_3_hl_v;
output [3:0]block_count_3_hh_y;
output [3:0]block_count_3_hh_u;
output [3:0]block_count_3_hh_v;
output [3:0]block_count_4_lh_y;
output [3:0]block_count_4_lh_u;
output [3:0]block_count_4_lh_v;
output [3:0]block_count_4_hl_y;
output [3:0]block_count_4_hl_u;
output [3:0]block_count_4_hl_v;
output [3:0]block_count_4_hh_y;
output [3:0]block_count_4_hh_u;
output [3:0]block_count_4_hh_v;
output [3:0]block_count_4_ll_y;
output [3:0]block_count_4_ll_u;
output [3:0]block_count_4_ll_v;

//output [3:0]block_count_0_hl;
//output [3:0]block_count_0_lh;
//output [3:0]block_count_0_hh;
//output [3:0]block_count_1_hl;
//output [3:0]block_count_1_lh;
//output [3:0]block_count_1_hh;
//output [3:0]block_count_2_hl;
//output [3:0]block_count_2_lh;
//output [3:0]block_count_2_hh;
//output [3:0]block_count_3_hl;
//output [3:0]block_count_3_lh;
//output [3:0]block_count_3_hh;
//output [3:0]block_count_4_hl;
//output [3:0]block_count_4_lh;
//output [3:0]block_count_4_hh;
//output [3:0]block_count_4_ll;


/// 码块位平面数
reg [3:0]block_count_0_lh_y;
reg [3:0]block_count_0_lh_u;
reg [3:0]block_count_0_lh_v;
reg [3:0]block_count_0_hl_y;
reg [3:0]block_count_0_hl_u;
reg [3:0]block_count_0_hl_v;
reg [3:0]block_count_0_hh_y;
reg [3:0]block_count_0_hh_u;
reg [3:0]block_count_0_hh_v;  
reg [3:0]block_count_1_lh_y;
reg [3:0]block_count_1_lh_u;
reg [3:0]block_count_1_lh_v;
reg [3:0]block_count_1_hl_y;
reg [3:0]block_count_1_hl_u;
reg [3:0]block_count_1_hl_v;
reg [3:0]block_count_1_hh_y;
reg [3:0]block_count_1_hh_u;
reg [3:0]block_count_1_hh_v;  
reg [3:0]block_count_2_lh_y;
reg [3:0]block_count_2_lh_u;
reg [3:0]block_count_2_lh_v;
reg [3:0]block_count_2_hl_y;
reg [3:0]block_count_2_hl_u;
reg [3:0]block_count_2_hl_v;
reg [3:0]block_count_2_hh_y;
reg [3:0]block_count_2_hh_u;
reg [3:0]block_count_2_hh_v; 
reg [3:0]block_count_3_lh_y;
reg [3:0]block_count_3_lh_u;
reg [3:0]block_count_3_lh_v;
reg [3:0]block_count_3_hl_y;
reg [3:0]block_count_3_hl_u;
reg [3:0]block_count_3_hl_v;
reg [3:0]block_count_3_hh_y;
reg [3:0]block_count_3_hh_u;
reg [3:0]block_count_3_hh_v;
reg [3:0]block_count_4_lh_y;
reg [3:0]block_count_4_lh_u;
reg [3:0]block_count_4_lh_v;
reg [3:0]block_count_4_hl_y;
reg [3:0]block_count_4_hl_u;
reg [3:0]block_count_4_hl_v;
reg [3:0]block_count_4_hh_y;
reg [3:0]block_count_4_hh_u;
reg [3:0]block_count_4_hh_v;
reg [3:0]block_count_4_ll_y;
reg [3:0]block_count_4_ll_u;
reg [3:0]block_count_4_ll_v;
// 子带位平面数
//reg [3:0]block_count_0_hl;
//reg [3:0]block_count_0_lh;
//reg [3:0]block_count_0_hh;
//reg [3:0]block_count_1_hl;
//reg [3:0]block_count_1_lh;
//reg [3:0]block_count_1_hh;
//reg [3:0]block_count_2_hl;
//reg [3:0]block_count_2_lh;
//reg [3:0]block_count_2_hh;
//reg [3:0]block_count_3_hl;
//reg [3:0]block_count_3_lh;
//reg [3:0]block_count_3_hh;
//reg [3:0]block_count_4_hl;
//reg [3:0]block_count_4_lh;
//reg [3:0]block_count_4_hh;
//reg [3:0]block_count_4_ll;

reg [16:0]com1;
reg [16:0]com2;
reg [16:0]com3;
reg [16:0]com4;
reg [3:0]plane_count_ram1;
reg [3:0]plane_count_ram2;
reg [3:0]plane_count_ram3;
reg [3:0]plane_count_ram4;
reg [3:0]plane_count_add_ram1;
reg [3:0]plane_count_add_ram2;
reg [3:0]plane_count_add_ram3;
reg [3:0]plane_count_add_ram4;
reg [3:0]plane_count_reg1_ram1;
reg [3:0]plane_count_reg2_ram1;
reg [3:0]plane_count_reg3_ram1;
reg [3:0]plane_count_reg1_ram2;
reg [3:0]plane_count_reg2_ram2;
reg [3:0]plane_count_reg3_ram2;
reg [3:0]plane_count_reg1_ram3;
reg [3:0]plane_count_reg2_ram3;
reg [3:0]plane_count_reg3_ram3;
reg [3:0]plane_count_reg1_ram4;
reg [3:0]plane_count_reg2_ram4;
reg [3:0]plane_count_reg3_ram4;
wire [3:0]plane_count_reg_ram1;
wire [3:0]plane_count_reg_ram2;
wire [3:0]plane_count_reg_ram3;
wire [3:0]plane_count_reg_ram4;
wire [3:0]plane_count_reg_mid_ram1;
wire [3:0]plane_count_reg_mid_ram2;
wire [3:0]plane_count_reg_mid_ram3;
wire [3:0]plane_count_reg_mid_ram4;
wire return_sta;
wire unvalid_cnt_over_before;
reg unvalid_cnt_over_before_1;
reg unvalid_cnt_over_before_2;

reg return_1;
reg return_2;
reg unvalid_cnt_over;
reg quant_out_vld_reg;
reg quant_out_vld_reg_1;
reg quant_out_vld_reg_2;
reg return_sta_1;
reg return_sta_2;
reg [1:0]unvalid_cnt_n;
reg [1:0]unvalid_cnt_n_1;
reg [1:0]unvalid_cnt_n_2;
reg [1:0]unvalid_cnt_n_3;
reg [2:0]level_delay_1;
reg [2:0]level_delay_bef_1;
reg [2:0]level_delay_bef_2;
reg [2:0]level_delay_bef_3;
reg [2:0]cnount_level;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		level_delay_1<=0;
	end
	else if(rst_syn)begin
		level_delay_1<=0;
	end
	else begin
		level_delay_bef_1<=level;
		level_delay_bef_2<=level_delay_bef_1;
		level_delay_bef_3<=level_delay_bef_2;
		level_delay_1<=level_delay_bef_3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		quant_out_vld_reg<=0;
	end
	else if(rst_syn)begin
		quant_out_vld_reg<=0;
	end	
	else begin
		quant_out_vld_reg<=quant_out_vld;
		quant_out_vld_reg_1<=quant_out_vld_reg;
		quant_out_vld_reg_2<=quant_out_vld_reg_1;
	end
end


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		unvalid_cnt_n<=0;
	end
	else if(rst_syn)begin
		unvalid_cnt_n<=0;
	end
	else begin
		unvalid_cnt_n<=unvalid_cnt;
		unvalid_cnt_n_1<=unvalid_cnt_n;
		unvalid_cnt_n_2<=unvalid_cnt_n_1;
		unvalid_cnt_n_3<=unvalid_cnt_n_2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		com1<=0;
	end
	else if(rst_syn)begin
		com1<=0;
	end
	else if(level_delay_1==3'd4)begin
		com1<=dina_1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		com2<=0;
	end
	else if(rst_syn)begin
		com2<=0;
	end
	else if(quant_out_vld_reg_1==1'b1)begin
		com2<=dina_2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		com3<=0;
	end
	else if(rst_syn)begin
		com3<=0;
	end
	else if(quant_out_vld_reg_1==1'b1)begin
		com3<=dina_3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		com4<=0;
	end
	else if(rst_syn)begin
		com4<=0;
	end
	else if(quant_out_vld_reg_1==1'b1)begin
		com4<=dina_4;
	end
end
/*
always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count<=0;
	end
	else if(quant_out_vld_reg)begin
		case(com2)
			16'bxxxxxx1xxxxxxxxxx: plane_count<=4'd11;
			16'bxxxxxxx1xxxxxxxxx: plane_count<=4'd10;
			16'bxxxxxxxx1xxxxxxxx: plane_count<=4'd9;
			16'bxxxxxxxxx1xxxxxxx: plane_count<=4'd8;
			16'bxxxxxxxxxx1xxxxxx: plane_count<=4'd7;
			16'bxxxxxxxxxxx1xxxxx: plane_count<=4'd6;
			16'bxxxxxxxxxxxx1xxxx: plane_count<=4'd5;
			16'bxxxxxxxxxxxxx1xxx: plane_count<=4'd4;
			16'bxxxxxxxxxxxxxx1xx: plane_count<=4'd3;
			16'bxxxxxxxxxxxxxxx1x: plane_count<=4'd2;
			16'bxxxxxxxxxxxxxxxx1: plane_count<=4'd1;
			16'bxxxxxxxxxxxxxxxxx: plane_count<=4'd0;
			default: plane_count<=4'd0;
		endcase
	end
end
*/

assign return_n=((quant_out_vld_reg_1==1'b0)&&(quant_out_vld_reg_2==1'b1));
assign return_sta=((quant_out_vld_reg==1'b1)&&(quant_out_vld_reg_1==1'b0));
assign unvalid_cnt_over_before=((unvalid_cnt_n==0)&&(unvalid_cnt_n_1==2'd2));

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		return_1<=0;
	end
	else if(rst_syn)begin
		return_1<=0;
	end
	else begin
		return_1<=return_n;
		return_2<=return_1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		unvalid_cnt_over<=0;
	end
	else if(rst_syn)begin
		unvalid_cnt_over<=0;
	end	
	else begin
		unvalid_cnt_over_before_1<=unvalid_cnt_over_before;
		unvalid_cnt_over_before_2<=unvalid_cnt_over_before_1;
		unvalid_cnt_over<=unvalid_cnt_over_before_2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		return_sta_1<=0;
		return_sta_2<=0;
	end
	else if(rst_syn)begin
		return_sta_1<=0;
		return_sta_2<=0;
	end
	else begin
		return_sta_1<=return_sta;
		return_sta_2<=return_sta_1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		cnount_level<=0;
	end
	else if(rst_syn)begin
		cnount_level<=0;
	end	
	else if(unvalid_cnt_over_before)begin
		cnount_level<=cnount_level+1;
	end
end
////*********************** ram2 bit_plane_count LH **********************************/////

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_ram2<=0;
	end
	else if(rst_syn)begin
		plane_count_ram2<=0;
	end
	else if(quant_out_vld_reg_2)begin
		if(com2[15]==1'b1)begin
			plane_count_ram2<=4'd12;
		end
		else if(com2[14]==1'b1)begin
			plane_count_ram2<=4'd11;
		end
		else if(com2[13]==1'b1)begin
			plane_count_ram2<=4'd10;
		end
		else if(com2[12]==1'b1)begin
			plane_count_ram2<=4'd9;
		end
		else if(com2[11]==1'b1)begin
			plane_count_ram2<=4'd8;
		end
		else if(com2[10]==1'b1)begin
			plane_count_ram2<=4'd7;
		end
		else if(com2[9]==1'b1)begin
			plane_count_ram2<=4'd6;
		end
		else if(com2[8]==1'b1)begin
			plane_count_ram2<=4'd5;
		end
		else if(com2[7]==1'b1)begin
			plane_count_ram2<=4'd4;
		end
		else if(com2[6]==1'b1)begin
			plane_count_ram2<=4'd3;
		end
		else if(com2[5]==1'b1)begin
			plane_count_ram2<=4'd2;
		end
		else if(com2[4]==1'b1)begin
			plane_count_ram2<=4'd1;
		end
		else begin
			plane_count_ram2<=4'd0;
		end
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_add_ram2<=0;	
	end	
	else if(rst_syn)begin
		plane_count_add_ram2<=0;
	end
	else if(return_sta_2)begin
		plane_count_add_ram2<=0;
	end
	else if(plane_count_ram2 >= plane_count_add_ram2)begin
		plane_count_add_ram2<=plane_count_ram2;
	end
	else begin
		plane_count_add_ram2<=plane_count_add_ram2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg1_ram2<=0;
	end
	else if(rst_syn)begin
		plane_count_reg1_ram2<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg1_ram2<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==0))begin
		plane_count_reg1_ram2<=plane_count_add_ram2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg2_ram2<=0;
	end
	else if(rst_syn)begin
		plane_count_reg2_ram2<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg2_ram2<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==1))begin
		plane_count_reg2_ram2<=plane_count_add_ram2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg3_ram2<=0;
	end
	else if(rst_syn)begin
		plane_count_reg3_ram2<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg3_ram2<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==2))begin
		plane_count_reg3_ram2<=plane_count_add_ram2;
	end
end

assign plane_count_reg_mid_ram2=(unvalid_cnt_over==0)?4'b0:(plane_count_reg1_ram2>=plane_count_reg2_ram2)?plane_count_reg1_ram2:plane_count_reg2_ram2;
assign plane_count_reg_ram2=(unvalid_cnt_over==0)?4'b0:(plane_count_reg3_ram2>=plane_count_reg_mid_ram2)?plane_count_reg3_ram2:plane_count_reg_mid_ram2;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		block_count_0_lh_y<=0;
		block_count_0_lh_u<=0;
		block_count_0_lh_v<=0;
		block_count_1_lh_y<=0;
		block_count_1_lh_u<=0;
		block_count_1_lh_v<=0;
		block_count_2_lh_y<=0;
		block_count_2_lh_u<=0;
		block_count_2_lh_v<=0;
		block_count_3_lh_y<=0;
		block_count_3_lh_u<=0;
		block_count_3_lh_v<=0;
		block_count_4_lh_y<=0;
		block_count_4_lh_u<=0;
		block_count_4_lh_v<=0;
	end
	else if(rst_syn)begin
		block_count_0_lh_y<=0;
		block_count_0_lh_u<=0;
		block_count_0_lh_v<=0;
		block_count_1_lh_y<=0;
		block_count_1_lh_u<=0;
		block_count_1_lh_v<=0;
		block_count_2_lh_y<=0;
		block_count_2_lh_u<=0;
		block_count_2_lh_v<=0;
		block_count_3_lh_y<=0;
		block_count_3_lh_u<=0;
		block_count_3_lh_v<=0;
		block_count_4_lh_y<=0;
		block_count_4_lh_u<=0;
		block_count_4_lh_v<=0;	
	end
	else if(level_delay_1==3'd0)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_0_lh_y<=plane_count_reg1_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2'd1))begin
			block_count_0_lh_u<=plane_count_reg2_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2'd2))begin
			block_count_0_lh_v<=plane_count_reg3_ram2;
		end
	end
	else if(level_delay_1==3'd1)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_1_lh_y<=plane_count_reg1_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_1_lh_u<=plane_count_reg2_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_1_lh_v<=plane_count_reg3_ram2;
		end
	end
	else if(level_delay_1==3'd2)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_2_lh_y<=plane_count_reg1_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_2_lh_u<=plane_count_reg2_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_2_lh_v<=plane_count_reg3_ram2;
		end
	end
	else if(level_delay_1==3'd3)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_3_lh_y<=plane_count_reg1_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_3_lh_u<=plane_count_reg2_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_3_lh_v<=plane_count_reg3_ram2;
		end
	end
	else if(level_delay_1==3'd4)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_4_lh_y<=plane_count_reg1_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_4_lh_u<=plane_count_reg2_ram2;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_4_lh_v<=plane_count_reg3_ram2;
		end
	end
end

// always@(posedge clk_mmu or negedge rst)begin
	// if(!rst)begin
		// block_count_0_lh<=0;
		// block_count_1_lh<=0;
		// block_count_2_lh<=0;
		// block_count_3_lh<=0;
		// block_count_4_lh<=0;
	// end
	// else if(rst_syn)begin
		// block_count_0_lh<=0;
		// block_count_1_lh<=0;
		// block_count_2_lh<=0;
		// block_count_3_lh<=0;
		// block_count_4_lh<=0;	
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd1))begin
		// block_count_0_lh<=plane_count_reg_ram2;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd2))begin
		// block_count_1_lh<=plane_count_reg_ram2;
	// end	
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd3))begin
		// block_count_2_lh<=plane_count_reg_ram2;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd4))begin
		// block_count_3_lh<=plane_count_reg_ram2;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd5))begin
		// block_count_4_lh<=plane_count_reg_ram2;
	// end
// end

////*********************** ram3 bit_plane_count HL **********************************/////

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_ram3<=0;
	end
	else if(rst_syn)begin
		plane_count_ram3<=0;
	end
	else if(quant_out_vld_reg_2)begin
		if(com3[15]==1'b1)begin
			plane_count_ram3<=4'd12;
		end
		else if(com3[14]==1'b1)begin
			plane_count_ram3<=4'd11;
		end
		else if(com3[13]==1'b1)begin
			plane_count_ram3<=4'd10;
		end
		else if(com3[12]==1'b1)begin
			plane_count_ram3<=4'd9;
		end
		else if(com3[11]==1'b1)begin
			plane_count_ram3<=4'd8;
		end
		else if(com3[10]==1'b1)begin
			plane_count_ram3<=4'd7;
		end
		else if(com3[9]==1'b1)begin
			plane_count_ram3<=4'd6;
		end
		else if(com3[8]==1'b1)begin
			plane_count_ram3<=4'd5;
		end
		else if(com3[7]==1'b1)begin
			plane_count_ram3<=4'd4;
		end
		else if(com3[6]==1'b1)begin
			plane_count_ram3<=4'd3;
		end
		else if(com3[5]==1'b1)begin
			plane_count_ram3<=4'd2;
		end
		else if(com3[4]==1'b1)begin
			plane_count_ram3<=4'd1;
		end
		else begin
			plane_count_ram3<=4'd0;
		end
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_add_ram3<=0;	
	end	
	else if(rst_syn)begin
		plane_count_add_ram3<=0;
	end
	else if(return_sta_2)begin
		plane_count_add_ram3<=0;
	end
	else if(plane_count_ram3 >= plane_count_add_ram3)begin
		plane_count_add_ram3<=plane_count_ram3;
	end
	else begin
		plane_count_add_ram3<=plane_count_add_ram3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg1_ram3<=0;
	end
	else if(rst_syn)begin
		plane_count_reg1_ram3<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg1_ram3<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==0))begin
		plane_count_reg1_ram3<=plane_count_add_ram3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg2_ram3<=0;
	end
	else if(rst_syn)begin
		plane_count_reg2_ram3<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg2_ram3<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==1))begin
		plane_count_reg2_ram3<=plane_count_add_ram3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg3_ram3<=0;
	end
	else if(rst_syn)begin
		plane_count_reg3_ram3<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg3_ram3<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==2))begin
		plane_count_reg3_ram3<=plane_count_add_ram3;
	end
end

assign plane_count_reg_mid_ram3=(unvalid_cnt_over==0)?4'b0:(plane_count_reg1_ram3>=plane_count_reg2_ram3)?plane_count_reg1_ram3:plane_count_reg2_ram3;
assign plane_count_reg_ram3=(unvalid_cnt_over==0)?4'b0:(plane_count_reg3_ram3>=plane_count_reg_mid_ram3)?plane_count_reg3_ram3:plane_count_reg_mid_ram3;


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		block_count_0_hl_y<=0;
		block_count_0_hl_u<=0;
		block_count_0_hl_v<=0;
		block_count_1_hl_y<=0;
		block_count_1_hl_u<=0;
		block_count_1_hl_v<=0;
		block_count_2_hl_y<=0;
		block_count_2_hl_u<=0;
		block_count_2_hl_v<=0;
		block_count_3_hl_y<=0;
		block_count_3_hl_u<=0;
		block_count_3_hl_v<=0;
		block_count_4_hl_y<=0;
		block_count_4_hl_u<=0;
		block_count_4_hl_v<=0;
	end
	else if(rst_syn)begin
		block_count_0_hl_y<=0;
	    block_count_0_hl_u<=0;
	    block_count_0_hl_v<=0;
	    block_count_1_hl_y<=0;
	    block_count_1_hl_u<=0;
	    block_count_1_hl_v<=0;
	    block_count_2_hl_y<=0;
	    block_count_2_hl_u<=0;
	    block_count_2_hl_v<=0;
	    block_count_3_hl_y<=0;
	    block_count_3_hl_u<=0;
	    block_count_3_hl_v<=0;
	    block_count_4_hl_y<=0;
	    block_count_4_hl_u<=0;
	    block_count_4_hl_v<=0;	
	end
	else if(level_delay_1==3'd0)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_0_hl_y<=plane_count_reg1_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_0_hl_u<=plane_count_reg2_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_0_hl_v<=plane_count_reg3_ram3;
		end
	end
	else if(level_delay_1==3'd1)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_1_hl_y<=plane_count_reg1_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_1_hl_u<=plane_count_reg2_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_1_hl_v<=plane_count_reg3_ram3;
		end
	end
	else if(level_delay_1==3'd2)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_2_hl_y<=plane_count_reg1_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_2_hl_u<=plane_count_reg2_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_2_hl_v<=plane_count_reg3_ram3;
		end
	end
	else if(level_delay_1==3'd3)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_3_hl_y<=plane_count_reg1_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_3_hl_u<=plane_count_reg2_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_3_hl_v<=plane_count_reg3_ram3;
		end
	end
	else if(level_delay_1==3'd4)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_4_hl_y<=plane_count_reg1_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_4_hl_u<=plane_count_reg2_ram3;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_4_hl_v<=plane_count_reg3_ram3;
		end
	end
end

// always@(posedge clk_mmu or negedge rst)begin
	// if(!rst)begin
		// block_count_0_hl<=0;
		// block_count_1_hl<=0;
		// block_count_2_hl<=0;
		// block_count_3_hl<=0;
		// block_count_4_hl<=0;
	// end
	// else if(rst_syn)begin
		// block_count_0_hl<=0;
	    // block_count_1_hl<=0;
	    // block_count_2_hl<=0;
	    // block_count_3_hl<=0;
	    // block_count_4_hl<=0;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd1))begin
		// block_count_0_hl<=plane_count_reg_ram3;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd2))begin
		// block_count_1_hl<=plane_count_reg_ram3;
	// end	
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd3))begin
		// block_count_2_hl<=plane_count_reg_ram3;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd4))begin
		// block_count_3_hl<=plane_count_reg_ram3;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd5))begin
		// block_count_4_hl<=plane_count_reg_ram3;
	// end
// end

////*********************** ram4 bit_plane_count HH **********************************/////

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_ram4<=0;
	end
	else if(rst_syn)begin
		plane_count_ram4<=0;
	end
	else if(quant_out_vld_reg_2)begin
		if(com4[15]==1'b1)begin
			plane_count_ram4<=4'd12;
		end
		else if(com4[14]==1'b1)begin
			plane_count_ram4<=4'd11;
		end
		else if(com4[13]==1'b1)begin
			plane_count_ram4<=4'd10;
		end
		else if(com4[12]==1'b1)begin
			plane_count_ram4<=4'd9;
		end
		else if(com4[11]==1'b1)begin
			plane_count_ram4<=4'd8;
		end
		else if(com4[10]==1'b1)begin
			plane_count_ram4<=4'd7;
		end
		else if(com4[9]==1'b1)begin
			plane_count_ram4<=4'd6;
		end
		else if(com4[8]==1'b1)begin
			plane_count_ram4<=4'd5;
		end
		else if(com4[7]==1'b1)begin
			plane_count_ram4<=4'd4;
		end
		else if(com4[6]==1'b1)begin
			plane_count_ram4<=4'd3;
		end
		else if(com4[5]==1'b1)begin
			plane_count_ram4<=4'd2;
		end
		else if(com4[4]==1'b1)begin
			plane_count_ram4<=4'd1;
		end
		else begin
			plane_count_ram4<=4'd0;
		end
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_add_ram4<=0;	
	end	
	else if(rst_syn)begin
		plane_count_add_ram4<=0;
	end
	else if(return_sta_2)begin
		plane_count_add_ram4<=0;
	end
	else if(plane_count_ram4 >= plane_count_add_ram4)begin
		plane_count_add_ram4<=plane_count_ram4;
	end
	else begin
		plane_count_add_ram4<=plane_count_add_ram4;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg1_ram4<=0;
	end
	else if(rst_syn)begin
		plane_count_reg1_ram4<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg1_ram4<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==0))begin
		plane_count_reg1_ram4<=plane_count_add_ram4;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg2_ram4<=0;
	end
	else if(rst_syn)begin
		plane_count_reg2_ram4<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg2_ram4<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==1))begin
		plane_count_reg2_ram4<=plane_count_add_ram4;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg3_ram4<=0;
	end
	else if(rst_syn)begin
		plane_count_reg3_ram4<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg3_ram4<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==2))begin
		plane_count_reg3_ram4<=plane_count_add_ram4;
	end
end

assign plane_count_reg_mid_ram4=(unvalid_cnt_over==0)?4'b0:(plane_count_reg1_ram4>=plane_count_reg2_ram4)?plane_count_reg1_ram4:plane_count_reg2_ram4;
assign plane_count_reg_ram4=(unvalid_cnt_over==0)?4'b0:(plane_count_reg3_ram4>=plane_count_reg_mid_ram4)?plane_count_reg3_ram4:plane_count_reg_mid_ram4;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		block_count_0_hh_y<=0;
		block_count_0_hh_u<=0;
		block_count_0_hh_v<=0;
		block_count_1_hh_y<=0;
		block_count_1_hh_u<=0;
		block_count_1_hh_v<=0;
		block_count_2_hh_y<=0;
		block_count_2_hh_u<=0;
		block_count_2_hh_v<=0;
		block_count_3_hh_y<=0;
		block_count_3_hh_u<=0;
		block_count_3_hh_v<=0;
		block_count_4_hh_y<=0;
		block_count_4_hh_u<=0;
		block_count_4_hh_v<=0;
	end
	else if(rst_syn)begin
		block_count_0_hh_y<=0;
		block_count_0_hh_u<=0;
		block_count_0_hh_v<=0;
		block_count_1_hh_y<=0;
		block_count_1_hh_u<=0;
		block_count_1_hh_v<=0;
		block_count_2_hh_y<=0;
		block_count_2_hh_u<=0;
		block_count_2_hh_v<=0;
		block_count_3_hh_y<=0;
		block_count_3_hh_u<=0;
		block_count_3_hh_v<=0;
		block_count_4_hh_y<=0;
		block_count_4_hh_u<=0;
		block_count_4_hh_v<=0;		
	end
	else if(level_delay_1==3'd0)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_0_hh_y<=plane_count_reg1_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_0_hh_u<=plane_count_reg2_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_0_hh_v<=plane_count_reg3_ram4;
		end
	end
	else if(level_delay_1==3'd1)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_1_hh_y<=plane_count_reg1_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_1_hh_u<=plane_count_reg2_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_1_hh_v<=plane_count_reg3_ram4;
		end
	end
	else if(level_delay_1==3'd2)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_2_hh_y<=plane_count_reg1_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_2_hh_u<=plane_count_reg2_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_2_hh_v<=plane_count_reg3_ram4;
		end
	end
	else if(level_delay_1==3'd3)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_3_hh_y<=plane_count_reg1_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_3_hh_u<=plane_count_reg2_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_3_hh_v<=plane_count_reg3_ram4;
		end
	end
	else if(level_delay_1==3'd4)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_4_hh_y<=plane_count_reg1_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_4_hh_u<=plane_count_reg2_ram4;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_4_hh_v<=plane_count_reg3_ram4;
		end
	end
end

// always@(posedge clk_mmu or negedge rst)begin
	// if(!rst)begin
		// block_count_0_hh<=0;
		// block_count_1_hh<=0;
		// block_count_2_hh<=0;
		// block_count_3_hh<=0;
		// block_count_4_hh<=0;
	// end
	// else if(rst_syn)begin
		// block_count_0_hh<=0;
		// block_count_1_hh<=0;
		// block_count_2_hh<=0;
		// block_count_3_hh<=0;
		// block_count_4_hh<=0;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd1))begin
		// block_count_0_hh<=plane_count_reg_ram4;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd2))begin
		// block_count_1_hh<=plane_count_reg_ram4;
	// end	
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd3))begin
		// block_count_2_hh<=plane_count_reg_ram4;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd4))begin
		// block_count_3_hh<=plane_count_reg_ram4;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd5))begin
		// block_count_4_hh<=plane_count_reg_ram4;
	// end
// end 

////*********************** ram1 bit_plane_count **********************************////


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_ram1<=0;
	end
	else if(rst_syn)begin
		plane_count_ram1<=0;
	end
	else if(quant_out_vld_reg_1)begin
		if(com1[15]==1'b1)begin
			plane_count_ram1<=4'd12;
		end
		else if(com1[14]==1'b1)begin
			plane_count_ram1<=4'd11;
		end
		else if(com1[13]==1'b1)begin
			plane_count_ram1<=4'd10;
		end
		else if(com1[12]==1'b1)begin
			plane_count_ram1<=4'd9;
		end
		else if(com1[11]==1'b1)begin
			plane_count_ram1<=4'd8;
		end
		else if(com1[10]==1'b1)begin
			plane_count_ram1<=4'd7;
		end
		else if(com1[9]==1'b1)begin
			plane_count_ram1<=4'd6;
		end
		else if(com1[8]==1'b1)begin
			plane_count_ram1<=4'd5;
		end
		else if(com1[7]==1'b1)begin
			plane_count_ram1<=4'd4;
		end
		else if(com1[6]==1'b1)begin
			plane_count_ram1<=4'd3;
		end
		else if(com1[5]==1'b1)begin
			plane_count_ram1<=4'd2;
		end
		else if(com1[4]==1'b1)begin
			plane_count_ram1<=4'd1;
		end
		else begin
			plane_count_ram1<=4'd0;
		end
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_add_ram1<=0;	
	end	
	else if(rst_syn)begin
		plane_count_add_ram1<=0;	
	end	
	else if(return_sta_2)begin
		plane_count_add_ram1<=0;
	end
	else if(plane_count_ram1 >= plane_count_add_ram1)begin
		plane_count_add_ram1<=plane_count_ram1;
	end
	else begin
		plane_count_add_ram1<=plane_count_add_ram1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg1_ram1<=0;
	end
	else if(rst_syn)begin
		plane_count_reg1_ram1<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg1_ram1<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==0))begin
		plane_count_reg1_ram1<=plane_count_add_ram1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg2_ram1<=0;
	end
	else if(rst_syn)begin
		plane_count_reg2_ram1<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg2_ram1<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==1))begin
		plane_count_reg2_ram1<=plane_count_add_ram1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		plane_count_reg3_ram1<=0;
	end
	else if(rst_syn)begin
		plane_count_reg3_ram1<=0;
	end
	else if(unvalid_cnt_over==1'b1)begin
		plane_count_reg3_ram1<=0;
	end
	else if((return_1==1'b1)&&(unvalid_cnt_n_2==2))begin
		plane_count_reg3_ram1<=plane_count_add_ram1;
	end
end

assign plane_count_reg_mid_ram1=(unvalid_cnt_over==0)?4'b0:(plane_count_reg1_ram1>=plane_count_reg2_ram1)?plane_count_reg1_ram1:plane_count_reg2_ram1;
assign plane_count_reg_ram1=(unvalid_cnt_over==0)?4'b0:(plane_count_reg3_ram1>=plane_count_reg_mid_ram1)?plane_count_reg3_ram1:plane_count_reg_mid_ram1;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		block_count_4_ll_y<=0;
		block_count_4_ll_u<=0;
		block_count_4_ll_v<=0;
	end
	else if(rst_syn)begin
		block_count_4_ll_y<=0;
		block_count_4_ll_u<=0;
		block_count_4_ll_v<=0;		
	end
	else if(level_delay_1==3'd4)begin
		if((return_2==1'b1)&&(unvalid_cnt_n_3==0))begin
			block_count_4_ll_y<=plane_count_reg1_ram1;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==1))begin
			block_count_4_ll_u<=plane_count_reg2_ram1;
		end
		else if((return_2==1'b1)&&(unvalid_cnt_n_3==2))begin
			block_count_4_ll_v<=plane_count_reg3_ram1;
		end
	end
end

// always@(posedge clk_mmu or negedge rst)begin
	// if(!rst)begin
		// block_count_4_ll<=0;
	// end
	// else if(rst_syn)begin
		// block_count_4_ll<=0;
	// end
	// else if((unvalid_cnt_over==1'b1)&&(cnount_level==3'd5))begin
		// block_count_4_ll<=plane_count_reg_ram1;
	// end
// end 

endmodule 


