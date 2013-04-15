`timescale 1ns/10ps
module bpc_unit(//output
                arrange_out0,
				arrange_out1,
				arrange_out2,
				arrange_out3,
				arrange_out4,
				arrange_out5,
				arrange_out6,
				arrange_out7,
				arrange_out8,
				arrange_out9,
				vld_num,
				flush,
				flush_mq2,
				pass_judge_1,
				pass_judge_2,
				pass_judge_3,
				pass_judge_4,
				bit1_add_vld,
				bit2_add_vld,
				bit3_add_vld,
				bit4_add_vld,
				stop_d,
                pass_error_start,
				pass_judge_1_d,
				pass_judge_2_d,
				pass_judge_3_d,
				pass_judge_4_d,
				clear0,
				//input
				halt,
				code_over_flag,
				bpc_start_flag,
				last_stripe_vld,
				stripe_over_flag,
				level_flag,
				stop_flag,
				band,
				stall_vld,
				data1_state,
				data2_state,
				data3_state,
				data4_state,
				//count_bp_delay,
				clk_bpc,
				clk_dwt,
				rst,
				rst_syn);
	
output [7:0] arrange_out0;
output [7:0] arrange_out1;
output [7:0] arrange_out2;
output [7:0] arrange_out3;
output [7:0] arrange_out4;
output [7:0] arrange_out5;
output [7:0] arrange_out6;
output [7:0] arrange_out7;
output [7:0] arrange_out8;
output [7:0] arrange_out9;
output [3:0] vld_num;
output flush;
output flush_mq2;
output[2:0] pass_judge_1;
output[2:0] pass_judge_2;
output[2:0] pass_judge_3;
output[2:0] pass_judge_4;
output stop_d;
output bit1_add_vld;
output bit2_add_vld;
output bit3_add_vld;
output bit4_add_vld;

output pass_error_start;					
output[2:0] pass_judge_1_d;
output[2:0] pass_judge_2_d;
output[2:0] pass_judge_3_d;
output[2:0] pass_judge_4_d;
output clear0;


input stall_vld;
input [1:0] band;
input [3:0] data1_state;
input [3:0] data2_state;
input [3:0] data3_state;
input [3:0] data4_state;
//input [3:0] count_bp_delay;
input clk_bpc;
input clk_dwt;
input rst;
input rst_syn;
input code_over_flag;
input bpc_start_flag;
input last_stripe_vld;
input stripe_over_flag;
input [2:0]level_flag;
input stop_flag;
input halt;

reg clk_bpc_reg;
always@(posedge clk_dwt or negedge rst)
	begin
		if(!rst)
			clk_bpc_reg<=0;
		else if(rst_syn)
			clk_bpc_reg<=0;
		else 	
			clk_bpc_reg<=clk_bpc;
	end
wire pos_clk_bpc=((clk_bpc_reg==1'b0)&&(clk_bpc==1'b1))?1'b1:1'b0;
////////////////////////////////////////////////////////window 1/////////////////////////////////////////
reg[1:0] bpc_start_fsm;
reg[1:0] bpc_start_fsm_n;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_start_fsm <= 2'b0;
	end
	else if(rst_syn)begin
		bpc_start_fsm <= 2'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		bpc_start_fsm <= bpc_start_fsm_n;
	end
 end 
///////////////////////////////////////////////////////////////////////
//    for test

reg [5:0] incnt;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		incnt <= 6'b0;
	end
	else if(rst_syn)begin
		incnt <= 6'b0;
	end	
	else if(pos_clk_bpc==1'b1)begin
		if((bpc_start_fsm!=2'b00)&&(stall_vld==1'b0)) begin
			incnt <= incnt + 1'b1;
		end
	end
end  
  
///////////////////////////////////////////////////////////////////////
reg [3:0] count_bpc_start;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		count_bpc_start <= 4'b0;
	end
	else if(rst_syn)begin
		count_bpc_start <= 4'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(bpc_start_fsm == 2'b01) begin
			count_bpc_start <= count_bpc_start + 1;
		end
		else begin
			count_bpc_start <= 4'b0;
		end
	end
end  
always@(*) begin
  bpc_start_fsm_n = bpc_start_fsm;
  case(bpc_start_fsm)
    2'b00: begin
      if(bpc_start_flag == 1'b1) begin
        bpc_start_fsm_n = 2'b01;
      end
    end 
    2'b01: begin
      if(count_bpc_start == 4'b1110) begin
        bpc_start_fsm_n = 2'b10;
      end
    end
    2'b10: begin
      if(code_over_flag == 1'b1) begin
        bpc_start_fsm_n = 2'b00;
      end
    end
    default: begin
      bpc_start_fsm_n = bpc_start_fsm;
    end
  endcase
end

wire bpc_normal;
assign bpc_normal = (bpc_start_fsm == 2'b10);
	
reg [2:0] level_flag_reg;
reg [2:0] level_flag_reg1;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		level_flag_reg <= 3'b0;
		level_flag_reg1 <= 3'b0;
	end
	else if(rst_syn)begin
		level_flag_reg <= 3'b0;
		level_flag_reg1 <= 3'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			level_flag_reg <= level_flag;
			level_flag_reg1 <= level_flag_reg;
		end
	end
end
reg last_stripe_vld_reg;
reg last_stripe_vld_reg1;
reg last_stripe_vld_reg_reg;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		last_stripe_vld_reg <= 1'b0;
		last_stripe_vld_reg1 <= 1'b0;
		last_stripe_vld_reg_reg <= 1'b0;
	end
	else if(rst_syn)begin
		last_stripe_vld_reg <= 1'b0;
		last_stripe_vld_reg1 <= 1'b0;
		last_stripe_vld_reg_reg <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			last_stripe_vld_reg <= last_stripe_vld;
			last_stripe_vld_reg_reg <= last_stripe_vld_reg;
			last_stripe_vld_reg1 <= last_stripe_vld_reg_reg;
		end
	end
end
reg stripe_over_flag_1;
reg stripe_start_flag;
reg stripe_over_flag_reg;
reg stripe_over_flag_reg1;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		stripe_over_flag_1<=1'b0;
		stripe_over_flag_reg <= 1'b0;
		stripe_over_flag_reg1 <= 1'b0;
		stripe_start_flag <= 1'b0;
	end
	else if(rst_syn)begin
		stripe_over_flag_1<=1'b0;
		stripe_over_flag_reg <= 1'b0;
		stripe_over_flag_reg1 <= 1'b0;
		stripe_start_flag <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			stripe_over_flag_1<=stripe_over_flag;
			stripe_over_flag_reg <= stripe_over_flag_1;
			stripe_over_flag_reg1 <= stripe_over_flag_reg;
			stripe_start_flag <= stripe_over_flag_reg1;
		end
	end
end
wire stripe_over_flag_line;
assign stripe_over_flag_line=((stripe_over_flag_reg1==1'b1)&&(stripe_over_flag_reg==1'b0));
wire stripe_start_line;
assign stripe_start_line=((stripe_start_flag==1'b1)&&(stripe_over_flag_reg1==1'b0));

//**************************************************************************************//
	reg [5:0] win_a2;
	reg [5:0] win_a3;
	reg [5:0] win_a4;
	reg [5:0] win_a5;
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_a2 <= 6'b0;
		win_a3 <= 6'b0;
		win_a4 <= 6'b0;
		win_a5 <= 6'b0;
	end
	else if(rst_syn)begin
		win_a2 <= 6'b0;
	    win_a3 <= 6'b0;
	    win_a4 <= 6'b0;
	    win_a5 <= 6'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_a2 <= {data1_state,1'b0,1'b0};
			win_a3 <= {data2_state,1'b0,1'b0};
			win_a4 <= {data3_state,1'b0,1'b0};
			win_a5 <= {data4_state,1'b0,1'b0};
		end
	end
end	
	reg [5:0] win_b2;
	reg [5:0] win_b3;
	reg [5:0] win_b4;
	reg [5:0] win_b5;
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_b2 <= 6'b0;
		win_b3 <= 6'b0;
		win_b4 <= 6'b0;
		win_b5 <= 6'b0;
	end
	else if(rst_syn)begin
		win_b2 <= 6'b0;
	    win_b3 <= 6'b0;
	    win_b4 <= 6'b0;
	    win_b5 <= 6'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_b2 <= win_a2;
			win_b3 <= win_a3;
			win_b4 <= win_a4;
			win_b5 <= win_a5;
		end
	end
end	
	reg [5:0] win_c2;
	reg [5:0] win_c3;
	reg [5:0] win_c4;
	reg [5:0] win_c5;
	
	reg [5:0] win_c2_n;
	reg [5:0] win_c3_n;
	reg [5:0] win_c4_n;
	reg [5:0] win_c5_n;
	
	reg [64:0] last_sp;
	
	reg win_a1;
	reg win_b1;
	reg win_c1;
	
	always@(*) begin
	    case(level_flag_reg1) 
		    3'b000: begin
			    win_a1 = last_sp[62];
				win_b1 = last_sp[63];
				win_c1 = last_sp[64];
			end
			3'b001: begin
			    win_a1 = last_sp[30];
				win_b1 = last_sp[31];
				win_c1 = last_sp[32];
			end
			3'b010: begin
			    win_a1 = last_sp[14];
				win_b1 = last_sp[15];
				win_c1 = last_sp[16];
			end
			3'b011: begin
			    win_a1 = last_sp[6];
				win_b1 = last_sp[7];
				win_c1 = last_sp[8];
			end
			3'b100: begin
			    win_a1 = last_sp[2];
				win_b1 = last_sp[3];
				win_c1 = last_sp[4];
			end
			default: begin
			  win_a1 = 0;
			  win_b1 = 0;
			  win_c1 = 0;
			end
		endcase
	end
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    last_sp <= 65'b0;
	end
	else if(rst_syn)begin
		last_sp <= 65'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
		    last_sp <= last_sp;
		end
		else if(last_stripe_vld_reg1 == 1'b1) begin
		    last_sp <= {last_sp[63:0],1'b0};
		end
		else begin
		    last_sp <= {last_sp[63:0],win_c5_n[1]};
		end
	end
end	
	
	reg stop_a;
    reg stop_b;
	
	
	reg c2_spvld;
	reg c3_spvld;
	reg c4_spvld;
	reg c5_spvld;
	
	always@(*) begin
	    if((stripe_over_flag_line == 1'b1)||((stop_a==1'b1)&&(stop_b==1'b0))) begin
		    c2_spvld = (win_b2[2] == 1'b0)? (win_b1||win_c1||win_c2[1]||win_c3[1]||win_b3[2]):1'b0;
		end
		else if(stripe_start_line == 1'b1) begin
		    c2_spvld = (win_b2[2] == 1'b0)? (win_a1||win_b1||win_a2[2]||win_a3[2]||win_b3[2]):1'b0;
		end
		else begin
		    c2_spvld = (win_b2[2] == 1'b0)? (win_a1||win_b1||win_c1||win_a2[2]||win_a3[2]||win_b3[2]||win_c2[1]||win_c3[1]||win_b3[2]):1'b0;
		end
	end
	
	always@(*) begin
	    if((stripe_over_flag_line == 1'b1)||((stop_a==1'b1)&&(stop_b==1'b0))) begin
		    c3_spvld = (win_b3[2] == 1'b0)? ((win_b2[2]^(c2_spvld&&win_b2[4]))||win_c2[1]||win_c3[1]||win_c4[1]||win_b4[2]):1'b0;
		end
		else if(stripe_start_line == 1'b1) begin
		    c3_spvld = (win_b3[2] == 1'b0)? ((win_b2[2]^(c2_spvld&&win_b2[4]))||win_a2[2]||win_a3[2]||win_a4[2]||win_b4[2]):1'b0;
		end
		else begin
		    c3_spvld = (win_b3[2] == 1'b0)? (win_a2[2]||win_a3[2]||win_a4[2]||(win_b2[2]^(c2_spvld&&win_b2[4]))||win_b4[2]||win_c2[1]||win_c3[1]||win_c4[1]):1'b0;
		end
	end
	
	always@(*) begin
	    if((stripe_over_flag_line == 1'b1)||((stop_a==1'b1)&&(stop_b==1'b0))) begin
		    c4_spvld = (win_b4[2] == 1'b0)? ((win_b3[2]^(c3_spvld&&win_b3[4]))||win_c3[1]||win_c4[1]||win_c5[1]||win_b5[2]):1'b0;
		end
		else if(stripe_start_line == 1'b1) begin
		    c4_spvld = (win_b4[2] == 1'b0)? ((win_b3[2]^(c3_spvld&&win_b3[4]))||win_a3[2]||win_a4[2]||win_a5[2]||win_b5[2]):1'b0;
		end
		else begin
		    c4_spvld = (win_b4[2] == 1'b0)? (win_a3[2]||win_a4[2]||win_a5[2]||(win_b3[2]^(c3_spvld&&win_b3[4]))||win_b5[2]||win_c3[1]||win_c4[1]||win_c5[1]):1'b0;
		end
	end
	
	always@(*) begin
	    if((stripe_over_flag_line == 1'b1)||((stop_a==1'b1)&&(stop_b==1'b0)))begin
		    c5_spvld = (win_b5[2] == 1'b0)? ((win_b4[2]^(c4_spvld&&win_b4[4]))||win_c4[1]||win_c5[1]):1'b0;
		end
		else if(stripe_start_line == 1'b1) begin
		    c5_spvld = (win_b5[2] == 1'b0)? ((win_b4[2]^(c4_spvld&&win_b4[4]))||win_a4[2]||win_a5[2]):1'b0;
		end
		else begin
		    c5_spvld = (win_b5[2] == 1'b0)? (win_a4[2]||win_a5[2]||(win_b4[2]^(c4_spvld&&win_b4[4]))||win_c4[1]||win_c5[1]):1'b0;
		end
	end
	
	always@(*) begin
	    win_c2_n = {win_b2[5:2],(win_b2[2]^(c2_spvld&&win_b2[4])),win_b2[0]};
		win_c3_n = {win_b3[5:2],(win_b3[2]^(c3_spvld&&win_b3[4])),win_b3[0]};
		win_c4_n = {win_b4[5:2],(win_b4[2]^(c4_spvld&&win_b4[4])),win_b4[0]};
		win_c5_n = {win_b5[5:2],(win_b5[2]^(c5_spvld&&win_b5[4])),win_b5[0]};
	end
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_c2 <= 6'b0;
		win_c3 <= 6'b0;
		win_c4 <= 6'b0;
		win_c5 <= 6'b0;
	end
	else if(rst_syn)begin
		win_c2 <= 6'b0;
	    win_c3 <= 6'b0;
	    win_c4 <= 6'b0;
	    win_c5 <= 6'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_c2 <= win_c2_n;
			win_c3 <= win_c3_n;
			win_c4 <= win_c4_n;
			win_c5 <= win_c5_n;
		end
	end
end
////////////////////////////////////////////////////////////window 2///////////////////////////////////////////////	
	
		
	reg [2:0] level_flag_reg2;
	reg [2:0] level_flag_reg3;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    level_flag_reg2 <= 3'b0;
		level_flag_reg3 <= 3'b0;
	end
	else if(rst_syn)begin
	    level_flag_reg2 <= 3'b0;	
		level_flag_reg3 <= 3'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    level_flag_reg2 <= level_flag_reg1;
			level_flag_reg3 <= level_flag_reg2;
		end
	end
end	
	reg stripe_start_flag_reg;
	reg stripe_over_flag_reg2;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    stripe_over_flag_reg2 <= 1'b0;
	    stripe_start_flag_reg <= 1'b0;
	end
	else if(rst_syn)begin
		stripe_over_flag_reg2 <= 1'b0;
	    stripe_start_flag_reg <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    stripe_over_flag_reg2 <= stripe_start_flag;
		    stripe_start_flag_reg <= stripe_over_flag_reg2;
		end
	end
end	
	wire stripe_over_flag_line1;
	assign stripe_over_flag_line1=((stripe_over_flag_reg2==1'b1)&&(stripe_start_flag_reg==1'b0));
	
	wire stripe_start_line1;
	assign stripe_start_line1=((stripe_start_flag_reg==1'b1)&&(stripe_over_flag_reg2==1'b0));
	
	reg last_stripe_vld_reg2;
	reg last_stripe_vld_reg3;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    last_stripe_vld_reg2 <= 1'b0;
		last_stripe_vld_reg3 <= 1'b0;
	end
	else if(rst_syn)begin
		last_stripe_vld_reg2 <= 1'b0;
	    last_stripe_vld_reg3 <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    last_stripe_vld_reg2 <= last_stripe_vld_reg1;
			last_stripe_vld_reg3 <= last_stripe_vld_reg2;
		end
	end
end	
	reg [5:0] win_d2;
	reg [5:0] win_d3;
	reg [5:0] win_d4;
	reg [5:0] win_d5;
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_d2 <= 6'b0;
		win_d3 <= 6'b0;
		win_d4 <= 6'b0;
		win_d5 <= 6'b0;
	end
	else if(rst_syn)begin
		win_d2 <= 6'b0;
	    win_d3 <= 6'b0;
	    win_d4 <= 6'b0;
	    win_d5 <= 6'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_d2 <= win_c2;
			win_d3 <= win_c3;
			win_d4 <= win_c4;
			win_d5 <= win_c5;
		end
	end
end	
	reg [5:0] win_e2;
	reg [5:0] win_e3;
	reg [5:0] win_e4;
	reg [5:0] win_e5;
	
	reg [5:0] win_e2_n;
	reg [5:0] win_e3_n;
	reg [5:0] win_e4_n;
	reg [5:0] win_e5_n;
	
	reg [64:0] last_cp;
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    last_cp <= 65'b0;
	end
	else if(rst_syn)begin
		last_cp <= 65'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
		    last_cp <= last_cp;
		end
		else if(last_stripe_vld_reg3 == 1'b1) begin
		    last_cp <= {last_cp[63:0],1'b0};
		end
		else begin
		    last_cp <= {last_cp[63:0],(win_d5[1]||win_d5[4])};
		end
	end
end	
	reg win_c1_sp;
	reg win_d1;
	reg win_e1;
	
	always@(*) begin
	    case(level_flag_reg3)
		    3'b000: begin
			    win_c1_sp = last_cp[62];
			    win_d1 = last_cp[63];
				win_e1 = last_cp[64];
			end
			3'b001: begin
			    win_c1_sp = last_cp[30];
			    win_d1 = last_cp[31];
				win_e1 = last_cp[32];
			end
			3'b010: begin
			    win_c1_sp = last_cp[14];
			    win_d1 = last_cp[15];
				win_e1 = last_cp[16];
			end
            3'b011: begin
			    win_c1_sp = last_cp[6];
			    win_d1 = last_cp[7];
				win_e1 = last_cp[8];
			end	
			3'b100: begin
			    win_c1_sp = last_cp[2];
			    win_d1 = last_cp[3];
				win_e1 = last_cp[4];
			end	
			default: begin
			    win_c1_sp = 1'b0;
			    win_d1 = 1'b0;
				win_e1 = 1'b0;
			end
		endcase
	end
	
	always@(*) begin
	    win_e2_n = {win_d2[5:1],(win_d2[1]||win_d2[4])};
		win_e3_n = {win_d3[5:1],(win_d3[1]||win_d3[4])};
		win_e4_n = {win_d4[5:1],(win_d4[1]||win_d4[4])};
		win_e5_n = {win_d5[5:1],(win_d5[1]||win_d5[4])};
	end
	
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_e2 <= 6'b0;
		win_e3 <= 6'b0;
		win_e4 <= 6'b0;
		win_e5 <= 6'b0;
	end
	else if(rst_syn)begin
		win_e2 <= 6'b0;
		win_e3 <= 6'b0;
	    win_e4 <= 6'b0;
	    win_e5 <= 6'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_e2 <= win_e2_n;
			win_e3 <= win_e3_n;
			win_e4 <= win_e4_n;
			win_e5 <= win_e5_n;
		end
	end
end	
	wire bit1_add_vld;
	wire bit2_add_vld;
	wire bit3_add_vld;
	wire bit4_add_vld;
	
	assign bit1_add_vld= win_e2[4];
	assign bit2_add_vld= win_e3[4];
	assign bit3_add_vld= win_e4[4];
	assign bit4_add_vld= win_e5[4];
	
	
	reg win_a1_reg1;
	reg win_a1_reg2;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_a1_reg1 <= 1'b0;
		win_a1_reg2 <= 1'b0;
	end
	else if(rst_syn)begin
		win_a1_reg1 <= 1'b0;
	    win_a1_reg2 <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_a1_reg1 <= win_a1;
			win_a1_reg2 <= win_a1_reg1;
		end
	end
end	
	reg win_b1_reg1;
	reg win_b1_reg2;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_b1_reg1 <= 1'b0;
		win_b1_reg2 <= 1'b0;
	end
	else if(rst_syn)begin
		win_b1_reg1 <= 1'b0;
	    win_b1_reg2 <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_b1_reg1 <= win_b1;
			win_b1_reg2 <= win_b1_reg1;
		end
	end
end	
	reg win_c1_reg1;
	reg win_c1_reg2;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
	    win_c1_reg1 <= 1'b0;
		win_c1_reg2 <= 1'b0;
	end
	else if(rst_syn)begin
		win_c1_reg1 <= 1'b0;
	    win_c1_reg2 <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
		    win_c1_reg1 <= win_c1;
			win_c1_reg2 <= win_c1_reg1;
		end
	end
end	
/////////////////////////////primary coding//////////////////////////////////////////////////////

reg c2_sp_vld_reg;
reg sp0_vld;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		c2_sp_vld_reg <= 1'b0;
		sp0_vld <= 1'b0;
	end
	else if(rst_syn)begin
		c2_sp_vld_reg <= 1'b0;
		sp0_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			c2_sp_vld_reg <= c2_spvld;
			sp0_vld <= c2_sp_vld_reg;
		end
	end
end
reg c3_sp_vld_reg;
reg sp1_vld;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		c3_sp_vld_reg <= 1'b0;
		sp1_vld <= 1'b0;
	end
	else if(rst_syn)begin
		c3_sp_vld_reg <= 1'b0;
		sp1_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			c3_sp_vld_reg <= c3_spvld;
			sp1_vld <= c3_sp_vld_reg;
		end
	end
end
reg c4_sp_vld_reg;
reg sp2_vld;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		c4_sp_vld_reg <= 1'b0;
		sp2_vld <= 1'b0;
	end
	else if(rst_syn)begin
		c4_sp_vld_reg <= 1'b0;
		sp2_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			c4_sp_vld_reg <= c4_spvld;
			sp2_vld <= c4_sp_vld_reg;
		end
	end
end
reg c5_sp_vld_reg;
reg sp3_vld;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		c5_sp_vld_reg <= 1'b0;
		sp3_vld <= 1'b0;
	end
	else if(rst_syn)begin
		c5_sp_vld_reg <= 1'b0;
		sp3_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			c5_sp_vld_reg <= c5_spvld;
			sp3_vld <= c5_sp_vld_reg;
		end
	end
end
reg [63:0] last_sign;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		last_sign <= 64'b0;
	end
	else if(rst_syn)begin
		last_sign <= 64'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			last_sign <= last_sign;
		end
		else if(last_stripe_vld_reg3 == 1'b1) begin
			last_sign <= {last_sign[62:0],1'b0};
		end
		else begin
			last_sign <= {last_sign[62:0],win_d5[5]};
		end
	end
end
reg sign_d1;

always@(*) begin
    case(level_flag_reg3)
	    3'b000: begin
			sign_d1 = last_sign[63];
		end
		3'b001: begin
			sign_d1 = last_sign[31];
		end
		3'b010: begin
			sign_d1 = last_sign[15];
		end
		3'b011: begin
			sign_d1 = last_sign[7];
		end
		3'b100: begin
			sign_d1 = last_sign[3];
		end
		default: begin
			sign_d1 = 0;
		end
	endcase
end

wire [5:0] zc0_cxd;
wire [5:0] zc1_cxd;
wire [5:0] zc2_cxd;
wire [5:0] zc3_cxd;

wire [5:0] sc0_cxd;
wire [5:0] sc1_cxd;
wire [5:0] sc2_cxd;
wire [5:0] sc3_cxd;

wire [5:0] mrc0_cxd;
wire [5:0] mrc1_cxd;
wire [5:0] mrc2_cxd;
wire [5:0] mrc3_cxd;

wire [5:0] rlc_cxd;
wire [5:0] u0_cxd;
wire [5:0] u1_cxd;
wire rlc_vld;
wire u01_vld;

reg cp0_vld;
reg cp1_vld;
reg cp2_vld;
reg cp3_vld;

reg mrc0_vld;
reg mrc1_vld;
reg mrc2_vld;
reg mrc3_vld;

reg zc0_vld;
reg zc1_vld;
reg zc2_vld;
reg zc3_vld;

wire sc0_vld;
wire sc1_vld;
wire sc2_vld;
wire sc3_vld;

assign sc0_vld = ((win_d2[4]==1'b1)&&(win_d2[2]==1'b0));
assign sc1_vld = ((win_d3[4]==1'b1)&&(win_d3[2]==1'b0));
assign sc2_vld = ((win_d4[4]==1'b1)&&(win_d4[2]==1'b0));
assign sc3_vld = ((win_d5[4]==1'b1)&&(win_d5[2]==1'b0));

always@(*) begin
    if((sp0_vld == 1'b1)||((rlc_vld == 1'b0)&&(cp0_vld == 1'b1))) begin
	    zc0_vld = 1'b1;
	end
	else begin
	    zc0_vld = 1'b0;
	end
end

always@(*) begin
    if((sp1_vld == 1'b1)||((rlc_vld == 1'b0)&&(cp1_vld == 1'b1))||((rlc_vld == 1'b1)&&(win_d2[4]==1'b1))) begin
	    zc1_vld = 1'b1;
	end
	else begin
	    zc1_vld = 1'b0;
	end
end

always@(*) begin
    if((sp2_vld == 1'b1)||((rlc_vld == 1'b0)&&(cp2_vld == 1'b1))||((rlc_vld == 1'b1)&&((win_d2[4]==1'b1)||(win_d3[4]==1'b1)))) begin
	    zc2_vld = 1'b1;
	end
	else begin
	    zc2_vld = 1'b0;
	end
end

always@(*) begin
    if((sp3_vld == 1'b1)||((rlc_vld == 1'b0)&&(cp3_vld == 1'b1))||((rlc_vld == 1'b1)&&((win_d2[4]==1'b1)||(win_d3[4]==1'b1)||(win_d4[4]==1'b1)))) begin
	    zc3_vld = 1'b1;
	end
	else begin
	    zc3_vld = 1'b0;
	end
end

always@(*) begin
    if(win_d2[2] == 1'b1) begin
	    mrc0_vld = 1'b1;
	end
	else begin
	    mrc0_vld = 1'b0;
	end
end

always@(*) begin
    if(win_d3[2] == 1'b1) begin
	    mrc1_vld = 1'b1;
	end
	else begin
	    mrc1_vld = 1'b0;
	end
end

always@(*) begin
    if(win_d4[2] == 1'b1) begin
	    mrc2_vld = 1'b1;
	end
	else begin
	    mrc2_vld = 1'b0;
	end
end

always@(*) begin
    if(win_d5[2] == 1'b1) begin
	    mrc3_vld = 1'b1;
	end
	else begin
	    mrc3_vld = 1'b0;
	end
end

always@(*) begin
    if((sp0_vld == 1'b0)&&(mrc0_vld == 1'b0)) begin
	    cp0_vld = 1'b1;
	end
	else begin
	    cp0_vld = 1'b0;
	end
end

always@(*) begin
    if((sp1_vld == 1'b0)&&(mrc1_vld == 1'b0)) begin
	    cp1_vld = 1'b1;
	end
	else begin
	    cp1_vld = 1'b0;
	end
end

always@(*) begin
    if((sp2_vld == 1'b0)&&(mrc2_vld == 1'b0)) begin
	    cp2_vld = 1'b1;
	end
	else begin
	    cp2_vld = 1'b0;
	end
end

always@(*) begin
    if((sp3_vld == 1'b0)&&(mrc3_vld == 1'b0)) begin
	    cp3_vld = 1'b1;
	end
	else begin
	    cp3_vld = 1'b0;
	end
end

wire[2:0] pass_judge_1_d;
wire[2:0] pass_judge_2_d;
wire[2:0] pass_judge_3_d;
wire[2:0] pass_judge_4_d;

assign pass_judge_1_d = {cp0_vld,mrc0_vld,sp0_vld};
assign pass_judge_2_d = {cp1_vld,mrc1_vld,sp1_vld};
assign pass_judge_3_d = {cp2_vld,mrc2_vld,sp2_vld};
assign pass_judge_4_d = {cp3_vld,mrc3_vld,sp3_vld};

reg[2:0] pass_judge_1;
reg[2:0] pass_judge_2;
reg[2:0] pass_judge_3;
reg[2:0] pass_judge_4;

always @(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		pass_judge_1 <= 3'b0;
		pass_judge_2 <= 3'b0;
		pass_judge_3 <= 3'b0;
		pass_judge_4 <= 3'b0;
	end
	else if(rst_syn)begin
		pass_judge_1 <= 3'b0;
		pass_judge_2 <= 3'b0;
		pass_judge_3 <= 3'b0;
		pass_judge_4 <= 3'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0) begin
			pass_judge_1 <= pass_judge_1_d;
			pass_judge_2 <= pass_judge_2_d;
			pass_judge_3 <= pass_judge_3_d;
			pass_judge_4 <= pass_judge_4_d;
		end
	end
end
reg rlc_v0;
reg rlc_v1;
reg rlc_d0;
reg rlc_d1;
reg rlc_d2;
reg rlc_d3;
reg rlc_h0;
reg rlc_h1;
reg rlc_h2;
reg rlc_h3;
reg rlc_h4;
reg rlc_h5;
reg rlc_h6;
reg rlc_h7;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    rlc_v0 = win_d1;
		rlc_v1 = 1'b0;
		rlc_d0 = win_c1_sp;
		rlc_d1 = 1'b0;
		rlc_d2 = 1'b0;
		rlc_d3 = 1'b0;
		rlc_h0 = win_c2[1];
		rlc_h1 = win_c3[1];
		rlc_h2 = win_c4[1];
		rlc_h3 = win_c5[1];
		rlc_h4 = 1'b0;
		rlc_h5 = 1'b0;
		rlc_h6 = 1'b0;
		rlc_h7 = 1'b0;
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    rlc_v0 = win_d1;
		rlc_v1 = 1'b0;
		rlc_d0 = 1'b0;
		rlc_d1 = win_e1;
		rlc_d2 = 1'b0;
		rlc_d3 = 1'b0;
		rlc_h0 = 1'b0;
		rlc_h1 = 1'b0;
		rlc_h2 = 1'b0;
		rlc_h3 = 1'b0;
		rlc_h4 = win_e2[0];
		rlc_h5 = win_e3[0];
		rlc_h6 = win_e4[0];
		rlc_h7 = win_e5[0];
	end
	else begin
	    rlc_v0 = win_d1;
		rlc_v1 = 1'b0;
		rlc_d0 = win_c1_sp;
		rlc_d1 = win_e1;
		rlc_d2 = 1'b0;
		rlc_d3 = 1'b0;
		rlc_h0 = win_c2[1];
		rlc_h1 = win_c3[1];
		rlc_h2 = win_c4[1];
		rlc_h3 = win_c5[1];
		rlc_h4 = win_e2[0];
		rlc_h5 = win_e3[0];
		rlc_h6 = win_e4[0];
		rlc_h7 = win_e5[0];
	end
end

reg zc0_h0;
reg zc0_h1;
reg zc0_v0;
reg zc0_v1;
reg zc0_d0;
reg zc0_d1;
reg zc0_d2;
reg zc0_d3;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    if(sp0_vld == 1'b1) begin
		    zc0_h0 = win_c2[2];
			zc0_h1 = 1'b0;
			zc0_v0 = win_b1_reg2;
			zc0_v1 = win_d3[2];
			zc0_d0 = win_a1_reg2;
			zc0_d1 = 1'b0;
			zc0_d2 = win_c3[2];
			zc0_d3 = 1'b0;
		end
		else begin
		    zc0_h0 = win_c2[1];
			zc0_h1 = 1'b0;
			zc0_v0 = win_d1;
			zc0_v1 = win_d3[1];
			zc0_d0 = win_c1_sp;
			zc0_d1 = 1'b0;
			zc0_d2 = win_c3[1];
			zc0_d3 = 1'b0;
		end
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    if(sp0_vld == 1'b1) begin
		    zc0_h0 = 1'b0;
			zc0_h1 = win_e2[1];
			zc0_v0 = win_b1_reg2;
			zc0_v1 = win_d3[2];
			zc0_d0 = 1'b0;
			zc0_d1 = win_c1_reg2;
			zc0_d2 = 1'b0;
			zc0_d3 = win_e3[1];
		end
		else begin
		    zc0_h0 = 1'b0;
			zc0_h1 = win_e2[0];
			zc0_v0 = win_d1;
			zc0_v1 = win_d3[1];
			zc0_d0 = 1'b0;
			zc0_d1 = win_e1;
			zc0_d2 = 1'b0;
			zc0_d3 = win_e3[0];
		end
	end
	else begin
	    if(sp0_vld == 1'b1) begin
		    zc0_h0 = win_c2[2];
			zc0_h1 = win_e2[1];
			zc0_v0 = win_b1_reg2;
			zc0_v1 = win_d3[2];
			zc0_d0 = win_a1_reg2;
			zc0_d1 = win_c1_reg2;
			zc0_d2 = win_c3[2];
			zc0_d3 = win_e3[1];
		end
		else begin
		    zc0_h0 = win_c2[1];
			zc0_h1 = win_e2[0];
			zc0_v0 = win_d1;
			zc0_v1 = win_d3[1];
			zc0_d0 = win_c1_sp;
			zc0_d1 = win_e1;
			zc0_d2 = win_c3[1];
			zc0_d3 = win_e3[0];
		end
	end
end

reg zc1_h0;
reg zc1_h1;
reg zc1_v0;
reg zc1_v1;
reg zc1_d0;
reg zc1_d1;
reg zc1_d2;
reg zc1_d3;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    if(sp1_vld == 1'b1) begin
		    zc1_h0 = win_c3[2];
			zc1_h1 = 1'b0;
			zc1_v0 = win_d2[1];
			zc1_v1 = win_d4[2];
			zc1_d0 = win_c2[2];
			zc1_d1 = 1'b0;
			zc1_d2 = win_c4[2];
			zc1_d3 = 1'b0;
		end
		else begin
		    zc1_h0 = win_c3[1];
			zc1_h1 = 1'b0;
			zc1_v0 = win_e2_n[0];
			zc1_v1 = win_d4[1];
			zc1_d0 = win_c2[1];
			zc1_d1 = 1'b0;
			zc1_d2 = win_c4[1];
			zc1_d3 = 1'b0;
		end
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    if(sp1_vld == 1'b1) begin
		    zc1_h0 = 1'b0;
			zc1_h1 = win_e3[1];
			zc1_v0 = win_d2[1];
			zc1_v1 = win_d4[2];
			zc1_d0 = 1'b0;
			zc1_d1 = win_e2[1];
			zc1_d2 = 1'b0;
			zc1_d3 = win_e4[1];
		end
		else begin
		    zc1_h0 = 1'b0;
			zc1_h1 = win_e3[0];
			zc1_v0 = win_e2_n[0];
			zc1_v1 = win_d4[1];
			zc1_d0 = 1'b0;
			zc1_d1 = win_e2[0];
			zc1_d2 = 1'b0;
			zc1_d3 = win_e4[0];
		end
	end
	else begin
	    if(sp1_vld == 1'b1) begin
		    zc1_h0 = win_c3[2];
			zc1_h1 = win_e3[1];
			zc1_v0 = win_d2[1];
			zc1_v1 = win_d4[2];
			zc1_d0 = win_c2[2];
			zc1_d1 = win_e2[1];
			zc1_d2 = win_c4[2];
			zc1_d3 = win_e4[1];
		end
		else begin
		    zc1_h0 = win_c3[1];
			zc1_h1 = win_e3[0];
			zc1_v0 = win_e2_n[0];
			zc1_v1 = win_d4[1];
			zc1_d0 = win_c2[1];
			zc1_d1 = win_e2[0];
			zc1_d2 = win_c4[1];
			zc1_d3 = win_e4[0];
		end
	end
end

reg zc2_h0;
reg zc2_h1;
reg zc2_v0;
reg zc2_v1;
reg zc2_d0;
reg zc2_d1;
reg zc2_d2;
reg zc2_d3;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    if(sp2_vld == 1'b1) begin
		    zc2_h0 = win_c4[2];
			zc2_h1 = 1'b0;
			zc2_v0 = win_d3[1];
			zc2_v1 = win_d5[2];
			zc2_d0 = win_c3[2];
			zc2_d1 = 1'b0;
			zc2_d2 = win_c5[2];
			zc2_d3 = 1'b0;
		end
		else begin
		    zc2_h0 = win_c4[1];
			zc2_h1 = 1'b0;
			zc2_v0 = win_e3_n[0];
			zc2_v1 = win_d5[1];
			zc2_d0 = win_c3[1];
			zc2_d1 = 1'b0;
			zc2_d2 = win_c5[1];
			zc2_d3 = 1'b0;
		end
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    if(sp2_vld == 1'b1) begin
		    zc2_h0 = 1'b0;
			zc2_h1 = win_e4[1];
			zc2_v0 = win_d3[1];
			zc2_v1 = win_d5[2];
			zc2_d0 = 1'b0;
			zc2_d1 = win_e3[1];
			zc2_d2 = 1'b0;
			zc2_d3 = win_e5[1];
		end
		else begin
		    zc2_h0 = 1'b0;
			zc2_h1 = win_e4[0];
			zc2_v0 = win_e3_n[0];
			zc2_v1 = win_d5[1];
			zc2_d0 = 1'b0;
			zc2_d1 = win_e3[0];
			zc2_d2 = 1'b0;
			zc2_d3 = win_e5[0];
		end
	end
	else begin
	    if(sp2_vld == 1'b1) begin
		    zc2_h0 = win_c4[2];
			zc2_h1 = win_e4[1];
			zc2_v0 = win_d3[1];
			zc2_v1 = win_d5[2];
			zc2_d0 = win_c3[2];
			zc2_d1 = win_e3[1];
			zc2_d2 = win_c5[2];
			zc2_d3 = win_e5[1];
		end
		else begin
		    zc2_h0 = win_c4[1];
			zc2_h1 = win_e4[0];
			zc2_v0 = win_e3_n[0];
			zc2_v1 = win_d5[1];
			zc2_d0 = win_c3[1];
			zc2_d1 = win_e3[0];
			zc2_d2 = win_c5[1];
			zc2_d3 = win_e5[0];
		end
	end
end

reg zc3_h0;
reg zc3_h1;
reg zc3_v0;
reg zc3_v1;
reg zc3_d0;
reg zc3_d1;
reg zc3_d2;
reg zc3_d3;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    if(sp3_vld == 1'b1) begin
		    zc3_h0 = win_c5[2];
			zc3_h1 = 1'b0;
			zc3_v0 = win_d4[1];
			zc3_v1 = 1'b0;
			zc3_d0 = win_c4[2];
			zc3_d1 = 1'b0;
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
		else begin
		    zc3_h0 = win_c5[1];
			zc3_h1 = 1'b0;
			zc3_v0 = win_e4_n[0];
			zc3_v1 = 1'b0;
			zc3_d0 = win_c4[1];
			zc3_d1 = 1'b0;
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    if(sp3_vld == 1'b1) begin
		    zc3_h0 = 1'b0;
			zc3_h1 = win_e5[1];
			zc3_v0 = win_d4[1];
			zc3_v1 = 1'b0;
			zc3_d0 = 1'b0;
			zc3_d1 = win_e4[1];
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
		else begin
		    zc3_h0 = 1'b0;
			zc3_h1 = win_e5[0];
			zc3_v0 = win_e4_n[0];
			zc3_v1 = 1'b0;
			zc3_d0 = 1'b0;
			zc3_d1 = win_e4[0];
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
	end
	else begin
	    if(sp3_vld == 1'b1) begin
		    zc3_h0 = win_c5[2];
			zc3_h1 = win_e5[1];
			zc3_v0 = win_d4[1];
			zc3_v1 = 1'b0;
			zc3_d0 = win_c4[2];
			zc3_d1 = win_e4[1];
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
		else begin
		    zc3_h0 = win_c5[1];
			zc3_h1 = win_e5[0];
			zc3_v0 = win_e4_n[0];
			zc3_v1 = 1'b0;
			zc3_d0 = win_c4[1];
			zc3_d1 = win_e4[0];
			zc3_d2 = 1'b0;
			zc3_d3 = 1'b0;
		end
	end
end

reg sc0_sign_h0;
reg sc0_sign_h1;
reg sc0_sign_v0;
reg sc0_sign_v1;

reg sc1_sign_h0;
reg sc1_sign_h1;
reg sc1_sign_v0;
reg sc1_sign_v1;

reg sc2_sign_h0;
reg sc2_sign_h1;
reg sc2_sign_v0;
reg sc2_sign_v1;

reg sc3_sign_h0;
reg sc3_sign_h1;
reg sc3_sign_v0;
reg sc3_sign_v1;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    sc0_sign_h0 = win_c2[5];
	    sc0_sign_h1 = 1'b0;
	    sc0_sign_v0 = sign_d1;
	    sc0_sign_v1 = win_d3[5];
		sc1_sign_h0 = win_c3[5];
	    sc1_sign_h1 = 1'b0;
	    sc1_sign_v0 = win_d2[5];
	    sc1_sign_v1 = win_d4[5];
	    sc2_sign_h0 = win_c4[5];
	    sc2_sign_h1 = 1'b0;
	    sc2_sign_v0 = win_d3[5];
	    sc2_sign_v1 = win_d5[5];
	    sc3_sign_h0 = win_c5[5];
	    sc3_sign_h1 = 1'b0;
	    sc3_sign_v0 = win_d4[5];
	    sc3_sign_v1 = 1'b0;
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    sc0_sign_h0 = 1'b0;
	    sc0_sign_h1 = win_e2[5];
	    sc0_sign_v0 = sign_d1;
	    sc0_sign_v1 = win_d3[5];
		sc1_sign_h0 = 1'b0;
	    sc1_sign_h1 = win_e3[5];
	    sc1_sign_v0 = win_d2[5];
	    sc1_sign_v1 = win_d4[5];
	    sc2_sign_h0 = 1'b0;
	    sc2_sign_h1 = win_e4[5];
	    sc2_sign_v0 = win_d3[5];
	    sc2_sign_v1 = win_d5[5];
	    sc3_sign_h0 = 1'b0;
	    sc3_sign_h1 = win_e5[5];
	    sc3_sign_v0 = win_d4[5];
	    sc3_sign_v1 = 1'b0;
	end
	else begin
        sc0_sign_h0 = win_c2[5];
	    sc0_sign_h1 = win_e2[5];
	    sc0_sign_v0 = sign_d1;
	    sc0_sign_v1 = win_d3[5];
		sc1_sign_h0 = win_c3[5];
	    sc1_sign_h1 = win_e3[5];
	    sc1_sign_v0 = win_d2[5];
	    sc1_sign_v1 = win_d4[5];
	    sc2_sign_h0 = win_c4[5];
	    sc2_sign_h1 = win_e4[5];
	    sc2_sign_v0 = win_d3[5];
	    sc2_sign_v1 = win_d5[5];
	    sc3_sign_h0 = win_c5[5];
	    sc3_sign_h1 = win_e5[5];
	    sc3_sign_v0 = win_d4[5];
	    sc3_sign_v1 = 1'b0;
	end
end

reg mrc0_h0;
reg mrc0_h1;
reg mrc0_v0;
reg mrc0_v1;
reg mrc0_d0;
reg mrc0_d1;
reg mrc0_d2;
reg mrc0_d3;

reg mrc1_h0;
reg mrc1_h1;
reg mrc1_v0;
reg mrc1_v1;
reg mrc1_d0;
reg mrc1_d1;
reg mrc1_d2;
reg mrc1_d3;

reg mrc2_h0;
reg mrc2_h1;
reg mrc2_v0;
reg mrc2_v1;
reg mrc2_d0;
reg mrc2_d1;
reg mrc2_d2;
reg mrc2_d3;

reg mrc3_h0;
reg mrc3_h1;
reg mrc3_v0;
reg mrc3_v1;
reg mrc3_d0;
reg mrc3_d1;
reg mrc3_d2;
reg mrc3_d3;

always@(*) begin
    if(stripe_start_line1 == 1'b1) begin
	    mrc0_h0 = win_c2[1];
        mrc0_h1 = 1'b0;
        mrc0_v0 = win_b1_reg2;
        mrc0_v1 = win_d3[1];
        mrc0_d0 = win_a1_reg2;
        mrc0_d1 = 1'b0;
        mrc0_d2 = win_c3[1];
        mrc0_d3 = 1'b0;
		mrc1_h0 = win_c3[1];
        mrc1_h1 = 1'b0;
        mrc1_v0 = win_d2[1];
        mrc1_v1 = win_d4[1];
        mrc1_d0 = win_c2[1];
        mrc1_d1 = 1'b0;
        mrc1_d2 = win_c4[1];
        mrc1_d3 = 1'b0;
		mrc2_h0 = win_c4[1];
        mrc2_h1 = 1'b0;
        mrc2_v0 = win_d3[1];
        mrc2_v1 = win_d5[1];
        mrc2_d0 = win_c3[1];
        mrc2_d1 = 1'b0;
        mrc2_d2 = win_c5[1];
        mrc2_d3 = 1'b0;
		mrc3_h0 = win_c5[1];
        mrc3_h1 = 1'b0;
        mrc3_v0 = win_d4[1];
        mrc3_v1 = 1'b0;
        mrc3_d0 = win_c4[1];
        mrc3_d1 = 1'b0;
        mrc3_d2 = 1'b0;
        mrc3_d3 = 1'b0;
	end
	else if(stripe_over_flag_line1 == 1'b1) begin
	    mrc0_h0 = 1'b0;
        mrc0_h1 = win_e2[1];
        mrc0_v0 = win_b1_reg2;
        mrc0_v1 = win_d3[1];
        mrc0_d0 = 1'b0;
        mrc0_d1 = win_c1_reg2;
        mrc0_d2 = 1'b0;
        mrc0_d3 = win_e3[1];
		mrc1_h0 = 1'b0;
        mrc1_h1 = win_e3[1];
        mrc1_v0 = win_d2[1];
        mrc1_v1 = win_d4[1];
        mrc1_d0 = 1'b0;
        mrc1_d1 = win_e2[1];
        mrc1_d2 = 1'b0;
        mrc1_d3 = win_e4[1];
		mrc2_h0 = 1'b0;
        mrc2_h1 = win_e4[1];
        mrc2_v0 = win_d3[1];
        mrc2_v1 = win_d5[1];
        mrc2_d0 = 1'b0;
        mrc2_d1 = win_e3[1];
        mrc2_d2 = 1'b0;
        mrc2_d3 = win_e5[1];
		mrc3_h0 = 1'b0;
        mrc3_h1 = win_e5[1];
        mrc3_v0 = win_d4[1];
        mrc3_v1 = 1'b0;
        mrc3_d0 = 1'b0;
        mrc3_d1 = win_e4[1];
        mrc3_d2 = 1'b0;
        mrc3_d3 = 1'b0;
	end
	else begin
	    mrc0_h0 = win_c2[1];
        mrc0_h1 = win_e2[1];
        mrc0_v0 = win_b1_reg2;
        mrc0_v1 = win_d3[1];
        mrc0_d0 = win_a1_reg2;
        mrc0_d1 = win_c1_reg2;
        mrc0_d2 = win_c3[1];
        mrc0_d3 = win_e3[1];
		mrc1_h0 = win_c3[1];
        mrc1_h1 = win_e3[1];
        mrc1_v0 = win_d2[1];
        mrc1_v1 = win_d4[1];
        mrc1_d0 = win_c2[1];
        mrc1_d1 = win_e2[1];
        mrc1_d2 = win_c4[1];
        mrc1_d3 = win_e4[1];
		mrc2_h0 = win_c4[1];
        mrc2_h1 = win_e4[1];
        mrc2_v0 = win_d3[1];
        mrc2_v1 = win_d5[1];
        mrc2_d0 = win_c3[1];
        mrc2_d1 = win_e3[1];
        mrc2_d2 = win_c5[1];
        mrc2_d3 = win_e5[1];
		mrc3_h0 = win_c5[1];
        mrc3_h1 = win_e5[1];
        mrc3_v0 = win_d4[1];
        mrc3_v1 = 1'b0;
        mrc3_d0 = win_c4[1];
        mrc3_d1 = win_e4[1];
        mrc3_d2 = 1'b0;
        mrc3_d3 = 1'b0;
	end
end

ZC  u_zc0(.zc_CxD  (zc0_cxd),
          //input
          .data_v  (win_d2[4]),
          .flag_band  (band),
          .h0  (zc0_h0),
		  .h1  (zc0_h1),
          .v0  (zc0_v0),
		  .v1  (zc0_v1),
          .d0  (zc0_d0),
		  .d1  (zc0_d1),
          .d2  (zc0_d2),
		  .d3  (zc0_d3));

ZC  u_zc1(.zc_CxD  (zc1_cxd),
          //input
          .data_v  (win_d3[4]),
          .flag_band  (band),
          .h0  (zc1_h0),
		  .h1  (zc1_h1),
          .v0  (zc1_v0),
		  .v1  (zc1_v1),
          .d0  (zc1_d0),
		  .d1  (zc1_d1),
          .d2  (zc1_d2),
		  .d3  (zc1_d3));

ZC  u_zc2(.zc_CxD  (zc2_cxd),
          //input
          .data_v  (win_d4[4]),
          .flag_band  (band),
          .h0  (zc2_h0),
		  .h1  (zc2_h1),
          .v0  (zc2_v0),
		  .v1  (zc2_v1),
          .d0  (zc2_d0),
		  .d1  (zc2_d1),
          .d2  (zc2_d2),
		  .d3  (zc2_d3));

ZC  u_zc3(.zc_CxD  (zc3_cxd),
          //input
          .data_v  (win_d5[4]),
          .flag_band  (band),
          .h0  (zc3_h0),
		  .h1  (zc3_h1),
          .v0  (zc3_v0),
		  .v1  (zc3_v1),
          .d0  (zc3_d0),
		  .d1  (zc3_d1),
          .d2  (zc3_d2),
		  .d3  (zc3_d3));
		  
SC  u_sc0(.sc_CxD  (sc0_cxd),
          //input
          .data_x  (win_d2[5]),
          .h0  (zc0_h0),
		  .h1  (zc0_h1),
          .v0  (zc0_v0),
		  .v1  (zc0_v1),
          .sign_h0  (sc0_sign_h0),
          .sign_h1  (sc0_sign_h1),
          .sign_v0  (sc0_sign_v0),
          .sign_v1  (sc0_sign_v1));	

SC  u_sc1(.sc_CxD  (sc1_cxd),
          //input
          .data_x  (win_d3[5]),
          .h0  (zc1_h0),
		  .h1  (zc1_h1),
          .v0  (zc1_v0),
		  .v1  (zc1_v1),
          .sign_h0  (sc1_sign_h0),
          .sign_h1  (sc1_sign_h1),
          .sign_v0  (sc1_sign_v0),
          .sign_v1  (sc1_sign_v1));

SC  u_sc2(.sc_CxD  (sc2_cxd),
          //input
          .data_x  (win_d4[5]),
          .h0  (zc2_h0),
		  .h1  (zc2_h1),
          .v0  (zc2_v0),
		  .v1  (zc2_v1),
          .sign_h0  (sc2_sign_h0),
          .sign_h1  (sc2_sign_h1),
          .sign_v0  (sc2_sign_v0),
          .sign_v1  (sc2_sign_v1));

SC  u_sc3(.sc_CxD  (sc3_cxd),
          //input
          .data_x  (win_d5[5]),
          .h0  (zc3_h0),
		  .h1  (zc3_h1),
          .v0  (zc3_v0),
		  .v1  (zc3_v1),
          .sign_h0  (sc3_sign_h0),
          .sign_h1  (sc3_sign_h1),
          .sign_v0  (sc3_sign_v0),
          .sign_v1  (sc3_sign_v1));		

MRC u_mrc0(.mrc_CxD  (mrc0_cxd),
           //input
           .data_v  (win_d2[4]),
           .data_mrc_first  (~win_d2[3]),
           .h0  (mrc0_h0),
		   .h1  (mrc0_h1),
           .v0  (mrc0_v0),
		   .v1  (mrc0_v1),
           .d0  (mrc0_d0),
		   .d1  (mrc0_d1),
           .d2  (mrc0_d2),
		   .d3  (mrc0_d3));

MRC u_mrc1(.mrc_CxD  (mrc1_cxd),
           //input
           .data_v  (win_d3[4]),
           .data_mrc_first  (~win_d3[3]),
           .h0  (mrc1_h0),
		   .h1  (mrc1_h1),
           .v0  (mrc1_v0),
		   .v1  (mrc1_v1),
           .d0  (mrc1_d0),
		   .d1  (mrc1_d1),
           .d2  (mrc1_d2),
		   .d3  (mrc1_d3));	

MRC u_mrc2(.mrc_CxD  (mrc2_cxd),
           //input
           .data_v  (win_d4[4]),
           .data_mrc_first  (~win_d4[3]),
           .h0  (mrc2_h0),
		   .h1  (mrc2_h1),
           .v0  (mrc2_v0),
		   .v1  (mrc2_v1),
           .d0  (mrc2_d0),
		   .d1  (mrc2_d1),
           .d2  (mrc2_d2),
		   .d3  (mrc2_d3));	

MRC u_mrc3(.mrc_CxD  (mrc3_cxd),
           //input
           .data_v  (win_d5[4]),
           .data_mrc_first  (~win_d5[3]),
           .h0  (mrc3_h0),
		   .h1  (mrc3_h1),
           .v0  (mrc3_v0),
		   .v1  (mrc3_v1),
           .d0  (mrc3_d0),
		   .d1  (mrc3_d1),
           .d2  (mrc3_d2),
		   .d3  (mrc3_d3));	

RLC u_rlc (.rlc_CxD  (rlc_cxd),
           .u0_CxD  (u0_cxd),
           .u1_CxD  (u1_cxd),
           .rlc_ac  (rlc_vld),
           .u01_ac  (u01_vld),
           //input
           .data_v0  (win_d2[4]),
           .data_v1  (win_d3[4]),
           .data_v2  (win_d4[4]),
           .data_v3  (win_d5[4]),
           .cp_ac0  (cp0_vld),
		   .cp_ac1  (cp1_vld),
		   .cp_ac2  (cp2_vld),
		   .cp_ac3  (cp3_vld),
           .v0  (rlc_v0),
		   .v1  (rlc_v1),
           .d0  (rlc_d0),
		   .d1  (rlc_d1),
		   .d2  (rlc_d2),
		   .d3  (rlc_d3),
           .h0  (rlc_h0),
		   .h1  (rlc_h1),
		   .h2  (rlc_h2),
		   .h3  (rlc_h3),
           .h4  (rlc_h4),
		   .h5  (rlc_h5),
		   .h6  (rlc_h6),
		   .h7  (rlc_h7));		   

reg halt_reg1;
reg halt_reg2;
reg halt_reg3;
reg halt_reg4;
reg halt_reg5;		  
reg halt_reg6;
reg halt_reg7;
reg clear0;
		   
reg [7:0] bpc_out0;
reg [7:0] bpc_out1;
reg [7:0] bpc_out2;
reg [7:0] bpc_out3;
reg [7:0] bpc_out4;
reg [7:0] bpc_out5;
reg [7:0] bpc_out6;
reg [7:0] bpc_out7;
reg [7:0] bpc_out8;
reg [7:0] bpc_out9;
reg [7:0] bpc_out10;	

reg bpc_out0_vld;
reg bpc_out1_vld;
reg bpc_out2_vld;
reg bpc_out3_vld;
reg bpc_out4_vld;
reg bpc_out5_vld;
reg bpc_out6_vld;
reg bpc_out7_vld;
reg bpc_out8_vld;
reg bpc_out9_vld;
reg bpc_out10_vld;

//////////////the shunxun for compare to C/////////////////
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out3_vld <= 1'b0;
		end
		else if(rst_syn)begin
			bpc_out3_vld <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out3_vld <= bpc_out3_vld;
			end
			else if(clear0==1'b1) begin
				bpc_out3_vld <= 0;
			end
			else if(mrc0_vld == 1'b1)begin
				bpc_out3_vld <= mrc0_vld;
			end
			else begin
				bpc_out3_vld <= zc0_vld;
			end
	end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out5_vld <= 1'b0;
		end
		else if(rst_syn)begin
			bpc_out5_vld <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out5_vld <= bpc_out5_vld;
			end
			else if(clear0==1'b1) begin
				bpc_out5_vld <= 0;
			end
			else if(mrc1_vld == 1'b1)begin
				bpc_out5_vld <= mrc1_vld;
			end
			else begin
				bpc_out5_vld <= zc1_vld;
			end
	end
end
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_out7_vld <= 1'b0;
	end
	else if(rst_syn)begin
		bpc_out7_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			bpc_out7_vld <= bpc_out7_vld;
		end
		else if(clear0==1'b1) begin
			bpc_out7_vld <= 0;
		end
		else if(mrc2_vld == 1'b1)begin
			bpc_out7_vld <= mrc2_vld;
		end
		else begin
			bpc_out7_vld <= zc2_vld;
		end
	end
end
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_out9_vld <= 1'b0;
	end
	else if(rst_syn)begin
		bpc_out9_vld <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			bpc_out9_vld <= bpc_out9_vld;
		end
		else if(clear0==1'b1) begin
			bpc_out9_vld <= 0;
		end
		else if(mrc3_vld == 1'b1)begin
			bpc_out9_vld <= mrc3_vld;
		end
		else begin
			bpc_out9_vld <= zc3_vld;
		end
	end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out4_vld <= 1'b0;
			bpc_out6_vld <= 1'b0;
			bpc_out8_vld <= 1'b0;
			bpc_out10_vld <= 1'b0;
			bpc_out0_vld <= 1'b0;
			bpc_out1_vld <= 1'b0;
			bpc_out2_vld <= 1'b0;
		end
		else if(rst_syn)begin
			bpc_out4_vld <= 1'b0;
			bpc_out6_vld <= 1'b0;
			bpc_out8_vld <= 1'b0;
			bpc_out10_vld <= 1'b0;
			bpc_out0_vld <= 1'b0;
			bpc_out1_vld <= 1'b0;
			bpc_out2_vld <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(clear0==1'b1)begin
				bpc_out4_vld <= 0; 
				bpc_out6_vld <= 0;
				bpc_out8_vld <= 0;
				bpc_out10_vld <=0;
				bpc_out0_vld <= 0; 
				bpc_out1_vld <= 0; 
				bpc_out2_vld <= 0; 	
			end
			else if(stall_vld == 1'b0)begin
				bpc_out4_vld <= sc0_vld;
				bpc_out6_vld <= sc1_vld;
				bpc_out8_vld <= sc2_vld;
				bpc_out10_vld <= sc3_vld;
				bpc_out0_vld <= rlc_vld;
				bpc_out1_vld <= u01_vld;
				bpc_out2_vld <= u01_vld;
			end
	end
end
reg [3:0]count_halt;

always@(posedge clk_dwt or negedge rst)begin
	if(!rst)begin
		clear0<=0;
	end
	else if(rst_syn)begin
		clear0<=0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(halt)begin
			clear0<=1;
		end
		else if((halt_reg7==1'b1)&&(count_halt==4'd1))begin
			clear0<=0;
		end
	end
end

always@(posedge clk_dwt or negedge rst)begin
		if(!rst)begin
			count_halt<=0;
		end
		else if(rst_syn)begin
			count_halt<=0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if((halt_reg1==1'b1)&&(halt_reg7==1'b1)&&(clear0==1'b1))begin
				count_halt<=count_halt;
			end
			else if((halt_reg1==1'b1)&&(clear0==1'b1))begin
				count_halt<=count_halt+1;
			end
			else if((halt_reg7==1'b1)&&(clear0==1'b1))begin
				count_halt<=count_halt-1;
			end
		end
end

always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out3 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out3 <= bpc_out3;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out3 <= bpc_out3;
			end
			else if(clear0==1'b1) begin
				bpc_out3 <= 0;
			end
			else if(mrc0_vld == 1'b1) begin
				bpc_out3 <= {2'b10,mrc0_cxd};
			end
			else if(sp0_vld == 1'b1)begin
				bpc_out3 <= {2'b01,zc0_cxd};
			end
			else begin
				bpc_out3 <= {2'b11,zc0_cxd};
			end
	end
end
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_out5 <= 8'b0;
	end
	else if(rst_syn)begin	
		bpc_out5 <= 8'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			bpc_out5 <= bpc_out5;
		end
		else if(clear0==1'b1) begin
			bpc_out5 <= 0;
		end
		else if(mrc1_vld == 1'b1) begin
			bpc_out5 <= {2'b10,mrc1_cxd};
		end
		else if(sp1_vld == 1'b1)begin
			bpc_out5 <= {2'b01,zc1_cxd};
		end
		else begin
			bpc_out5 <= {2'b11,zc1_cxd};
		end
	end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out7 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out7 <= 8'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out7 <= bpc_out7;
			end
			else if(clear0==1'b1) begin
				bpc_out7 <= 0;
			end
			else if(mrc2_vld == 1'b1) begin
				bpc_out7 <= {2'b10,mrc2_cxd};
			end
			else if(sp2_vld == 1'b1)begin
				bpc_out7 <= {2'b01,zc2_cxd};
			end
			else begin
				bpc_out7 <= {2'b11,zc2_cxd};
			end
		end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out9 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out9 <= 8'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out9 <= bpc_out9;
			end
			else if(clear0==1'b1) begin
				bpc_out9 <= 0;
			end
			else if(mrc3_vld == 1'b1) begin
				bpc_out9 <= {2'b10,mrc3_cxd};
			end
			else if(sp3_vld == 1'b1)begin
				bpc_out9 <= {2'b01,zc3_cxd};
			end
			else begin
				bpc_out9 <= {2'b11,zc3_cxd};
			end
		end
end
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_out4 <= 8'b0;
	end
	else if(rst_syn)begin
		bpc_out4 <= 8'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			bpc_out4 <= bpc_out4;
		end
		else if(clear0==1'b1) begin
			bpc_out4 <= 0;
		end
		else if(sp0_vld == 1'b1) begin
			bpc_out4 <= {2'b01,sc0_cxd};
		end
		else begin
			bpc_out4 <= {2'b11,sc0_cxd};
		end
	end
end	   
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out6 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out6 <= 8'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out6 <= bpc_out6;
			end
			else if(clear0==1'b1) begin
				bpc_out6 <= 0;
			end
			else if(sp1_vld == 1'b1) begin
				bpc_out6 <= {2'b01,sc1_cxd};
			end
			else begin
				bpc_out6 <= {2'b11,sc1_cxd};
			end
	end
end

always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_out8 <= 8'b0;
	end
	else if(rst_syn)begin
		bpc_out8 <= bpc_out8;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b1) begin
			bpc_out8 <= bpc_out8;
		end
		else if(clear0==1'b1) begin
			bpc_out8 <= 0;
		end
		else if(sp2_vld == 1'b1) begin
			bpc_out8 <= {2'b01,sc2_cxd};
		end
		else begin
			bpc_out8 <= {2'b11,sc2_cxd};
		end
	end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out10 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out10 <= 8'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				bpc_out10 <= bpc_out10;
			end
			else if(clear0==1'b1) begin
				bpc_out10 <= 0;
			end
			else if(sp3_vld == 1'b1) begin
				bpc_out10 <= {2'b01,sc3_cxd};
			end
			else begin
				bpc_out10 <= {2'b11,sc3_cxd};
			end
	end
end
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			bpc_out0 <= 8'b0;
			bpc_out1 <= 8'b0;
			bpc_out2 <= 8'b0;
		end
		else if(rst_syn)begin
			bpc_out0 <= 8'b0;
			bpc_out1 <= 8'b0;
			bpc_out2 <= 8'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(clear0==1'b1)begin
				bpc_out0 <=0;
				bpc_out1 <=0;
				bpc_out2 <=0;
			end
			else if(stall_vld == 1'b0)begin
				bpc_out0 <= {2'b11,rlc_cxd};
				bpc_out1 <= {2'b11,u0_cxd};
				bpc_out2 <= {2'b11,u1_cxd};
			end
		end
end

reg stop_c;
reg stop_d;
reg stop_e;
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			stop_a <= 1'b0;
			stop_b <= 1'b0;
			stop_c <= 1'b0;
			stop_d <= 1'b0;
			stop_e <= 1'b0;
		end
		else if(rst_syn)begin
			stop_a <= 1'b0;
			stop_b <= 1'b0;
			stop_c <= 1'b0;
			stop_d <= 1'b0;
			stop_e <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b0)begin
				stop_a <= stop_flag;
				stop_b <= stop_a;
				stop_c <= stop_b;
				stop_d <= stop_c;
				stop_e <= stop_d;
			end
	end
end

always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			halt_reg1 <= 1'b0;
			halt_reg2 <= 1'b0;
			halt_reg3 <= 1'b0;
			halt_reg4 <= 1'b0;	
			halt_reg5 <= 1'b0;	
			halt_reg6 <= 1'b0;
			halt_reg7 <= 1'b0;
		end
		else if(rst_syn)begin
			halt_reg1 <= 1'b0;
			halt_reg2 <= 1'b0;
			halt_reg4 <= 1'b0;	
			halt_reg5 <= 1'b0;	
			halt_reg3 <= 1'b0;
			halt_reg6 <= 1'b0;
			halt_reg7 <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
		  begin
			halt_reg1 <= halt;
			halt_reg2 <= halt_reg1;
			halt_reg3 <= halt_reg2;
			halt_reg4 <= halt_reg3;
			halt_reg5 <= halt_reg4;
			halt_reg6 <= halt_reg5;
			halt_reg7 <= halt_reg6;
		  end
	end
end


reg stop0;
reg stop1;
reg stop2;
reg stop3;
reg stop4;
reg stop5;
reg stop6;
reg stop7;
reg stop8;
reg stop9;
reg stop10;
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			stop0 <= 1'b0;
			stop1 <= 1'b0;
			stop2 <= 1'b0;
			stop3 <= 1'b0;
			stop4 <= 1'b0;
			stop5 <= 1'b0;
			stop6 <= 1'b0;
			stop7 <= 1'b0;
			stop8 <= 1'b0;
			stop9 <= 1'b0;
			stop10 <= 1'b0;
		end
		else if(rst_syn)begin
			stop0 <= 1'b0;
			stop1 <= 1'b0;
			stop2 <= 1'b0;
			stop3 <= 1'b0;
			stop4 <= 1'b0;
			stop5 <= 1'b0;
			stop6 <= 1'b0;
			stop7 <= 1'b0;
			stop8 <= 1'b0;
			stop9 <= 1'b0;
			stop10 <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			stop0 <= stop_e;
			stop1 <= stop0;
			stop2 <= stop1;
			stop3 <= stop2;
			stop4 <= stop3;
			stop5 <= stop4;
			stop6 <= stop5;
			stop7 <= stop6;
			stop8 <= stop7;
			stop9 <= stop8;
			stop10 <= stop9;
		end
	end
end
reg stop11;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		stop11 <= 1'b0;
	end
	else if(rst_syn)begin
		stop11 <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		stop11 <= stop10;
	end
end

wire flush=((stop10==1'b1)&&(stop11==1'b0));

reg flush_mq0;
reg flush_mq1;
reg flush_mq11;
reg flush_mq12;
reg flush_mq13;
reg flush_mq2;
always@(posedge clk_dwt or negedge rst) begin
		if(!rst) begin
			flush_mq0 <= 1'b0;
			flush_mq1 <= 1'b0;
			flush_mq11 <= 1'b0;
			flush_mq12 <= 1'b0;
			flush_mq13 <= 1'b0;
			flush_mq2 <= 1'b0;
		end
		else if(rst_syn)begin
			flush_mq0 <= 1'b0;
			flush_mq1 <= 1'b0;
			flush_mq11 <= 1'b0;
			flush_mq12 <= 1'b0;
			flush_mq13 <= 1'b0;
			flush_mq2 <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			begin
				flush_mq0 <= flush;
				flush_mq1 <= flush_mq0;
				flush_mq11 <= flush_mq1;
				flush_mq12 <= flush_mq11;
				flush_mq13 <= flush_mq12;
				flush_mq2 <= flush_mq13;
			end
		end
end

wire [7:0] cell00_out;
wire [7:0] cell01_out;
wire [7:0] cell02_out;
wire [7:0] cell03_out;
wire [7:0] cell04_out;
wire [7:0] cell05_out;
wire [7:0] cell06_out;
wire [7:0] cell07_out;
wire [7:0] cell08_out;
wire [7:0] cell09_out;
wire [7:0] cell0a_out;

wire [7:0] cell10_out;
wire [7:0] cell11_out;
wire [7:0] cell12_out;
wire [7:0] cell13_out;
wire [7:0] cell14_out;
wire [7:0] cell15_out;
wire [7:0] cell16_out;
wire [7:0] cell17_out;
wire [7:0] cell18_out;
wire [7:0] cell19_out;
wire [7:0] cell1a_out;

wire [7:0] cell20_out;
wire [7:0] cell21_out;
wire [7:0] cell22_out;
wire [7:0] cell23_out;
wire [7:0] cell24_out;
wire [7:0] cell25_out;
wire [7:0] cell26_out;
wire [7:0] cell27_out;
wire [7:0] cell28_out;
wire [7:0] cell29_out;
wire [7:0] cell2a_out;

wire [7:0] cell30_out;
wire [7:0] cell31_out;
wire [7:0] cell32_out;
wire [7:0] cell33_out;
wire [7:0] cell34_out;
wire [7:0] cell35_out;
wire [7:0] cell36_out;
wire [7:0] cell37_out;
wire [7:0] cell38_out;
wire [7:0] cell39_out;
wire [7:0] cell3a_out;

wire [7:0] cell40_out;
wire [7:0] cell41_out;
wire [7:0] cell42_out;
wire [7:0] cell43_out;
wire [7:0] cell44_out;
wire [7:0] cell45_out;
wire [7:0] cell46_out;
wire [7:0] cell47_out;
wire [7:0] cell48_out;
wire [7:0] cell49_out;
wire [7:0] cell4a_out;

wire [7:0] cell50_out;
wire [7:0] cell51_out;
wire [7:0] cell52_out;
wire [7:0] cell53_out;
wire [7:0] cell54_out;
wire [7:0] cell55_out;
wire [7:0] cell56_out;
wire [7:0] cell57_out;
wire [7:0] cell58_out;
wire [7:0] cell59_out;
wire [7:0] cell5a_out;

wire [7:0] cell60_out;
wire [7:0] cell61_out;
wire [7:0] cell62_out;
wire [7:0] cell63_out;
wire [7:0] cell64_out;
wire [7:0] cell65_out;
wire [7:0] cell66_out;
wire [7:0] cell67_out;
wire [7:0] cell68_out;
wire [7:0] cell69_out;
wire [7:0] cell6a_out;

wire [7:0] cell70_out;
wire [7:0] cell71_out;
wire [7:0] cell72_out;
wire [7:0] cell73_out;
wire [7:0] cell74_out;
wire [7:0] cell75_out;
wire [7:0] cell76_out;
wire [7:0] cell77_out;
wire [7:0] cell78_out;
wire [7:0] cell79_out;
wire [7:0] cell7a_out;

wire [7:0] cell80_out;
wire [7:0] cell81_out;
wire [7:0] cell82_out;
wire [7:0] cell83_out;
wire [7:0] cell84_out;
wire [7:0] cell85_out;
wire [7:0] cell86_out;
wire [7:0] cell87_out;
wire [7:0] cell88_out;
wire [7:0] cell89_out;
wire [7:0] cell8a_out;

wire [7:0] cell90_out;
wire [7:0] cell91_out;
wire [7:0] cell92_out;
wire [7:0] cell93_out;
wire [7:0] cell94_out;
wire [7:0] cell95_out;
wire [7:0] cell96_out;
wire [7:0] cell97_out;
wire [7:0] cell98_out;
wire [7:0] cell99_out;
wire [7:0] cell9a_out;

wire [7:0] cella0_out;
wire [7:0] cella1_out;
wire [7:0] cella2_out;
wire [7:0] cella3_out;
wire [7:0] cella4_out;
wire [7:0] cella5_out;
wire [7:0] cella6_out;
wire [7:0] cella7_out;
wire [7:0] cella8_out;
wire [7:0] cella9_out;
//wire [7:0] cellaa_out;

wire cella0_out_vld;
wire cella1_out_vld;
wire cella2_out_vld;
wire cella3_out_vld;
wire cella4_out_vld;
wire cella5_out_vld;
wire cella6_out_vld;
wire cella7_out_vld;
wire cella8_out_vld;
wire cella9_out_vld;


reg [7:0] arrange_out0;
reg [7:0] arrange_out1;
reg [7:0] arrange_out2;
reg [7:0] arrange_out3;
reg [7:0] arrange_out4;
reg [7:0] arrange_out5;
reg [7:0] arrange_out6;
reg [7:0] arrange_out7;
reg [7:0] arrange_out8;
reg [7:0] arrange_out9;

always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		arrange_out0 <= 8'b0;
		arrange_out1 <= 8'b0;
		arrange_out2 <= 8'b0;
		arrange_out3 <= 8'b0;
		arrange_out4 <= 8'b0;
		arrange_out5 <= 8'b0;
		arrange_out6 <= 8'b0;
		arrange_out7 <= 8'b0;
		arrange_out8 <= 8'b0;
		arrange_out9 <= 8'b0;
	end
	else if(rst_syn)begin
		arrange_out0 <= 8'b0;
		arrange_out1 <= 8'b0;
		arrange_out2 <= 8'b0;
		arrange_out3 <= 8'b0;
		arrange_out4 <= 8'b0;
		arrange_out5 <= 8'b0;
		arrange_out6 <= 8'b0;
		arrange_out7 <= 8'b0;
		arrange_out8 <= 8'b0;
		arrange_out9 <= 8'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld == 1'b0)begin
			arrange_out0 <= cella0_out;
			arrange_out1 <= cella1_out;
			arrange_out2 <= cella2_out;
			arrange_out3 <= cella3_out;
			arrange_out4 <= cella4_out;
			arrange_out5 <= cella5_out;
			arrange_out6 <= cella6_out;
			arrange_out7 <= cella7_out;
			arrange_out8 <= cella8_out;
			arrange_out9 <= cella9_out;
		end
	end
end

reg bpc_normal_reg;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_normal_reg <= 1'b0;
	end
	else if(rst_syn)begin
		bpc_normal_reg <= 1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		begin
			bpc_normal_reg <= bpc_normal;
		end
	end
end

reg halt_bpc;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst)begin
		halt_bpc<=0;
	end
	else if(rst_syn)begin
		halt_bpc<=0;	 
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stop10==1'b1)begin
			if(halt==1'b1)begin
				halt_bpc<=1;
			end
		end	
		else begin
			halt_bpc<=0;
		end
	end
end

wire [3:0]vld_num;
reg [3:0] vld_num_temp;
assign vld_num=(level_flag!=3'b111)?vld_num_temp:3'b0;
always@(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		vld_num_temp <= 4'b0;
	end
	else if(rst_syn)begin
		vld_num_temp <= 4'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(((stop10 == 1'b1)||(bpc_normal_reg == 1'b0))&&(stall_vld==1'b0)) begin
		//if(stop10 == 1'b1)begin
			vld_num_temp <= 4'b0;
		end
		else if(halt_bpc==1)begin
			vld_num_temp <= 4'b0;
		end
		else if(stall_vld == 1'b0)begin
			vld_num_temp <= cella0_out_vld+cella1_out_vld+cella2_out_vld+cella3_out_vld+cella4_out_vld+cella5_out_vld+cella6_out_vld+cella7_out_vld+cella8_out_vld+cella9_out_vld;
		end
	end
end
arrange_cell u_cell00(cell00_out,cell00_out_vld,stall_vld,bpc_out0,bpc_out1,bpc_out0_vld,1'b1,bpc_out1_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell01(cell01_out,cell01_out_vld,stall_vld,bpc_out1,bpc_out2,bpc_out1_vld,bpc_out0_vld,bpc_out2_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell02(cell02_out,cell02_out_vld,stall_vld,bpc_out2,bpc_out3,bpc_out2_vld,bpc_out1_vld,bpc_out3_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell03(cell03_out,cell03_out_vld,stall_vld,bpc_out3,bpc_out4,bpc_out3_vld,bpc_out2_vld,bpc_out4_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell04(cell04_out,cell04_out_vld,stall_vld,bpc_out4,bpc_out5,bpc_out4_vld,bpc_out3_vld,bpc_out5_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell05(cell05_out,cell05_out_vld,stall_vld,bpc_out5,bpc_out6,bpc_out5_vld,bpc_out4_vld,bpc_out6_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell06(cell06_out,cell06_out_vld,stall_vld,bpc_out6,bpc_out7,bpc_out6_vld,bpc_out5_vld,bpc_out7_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell07(cell07_out,cell07_out_vld,stall_vld,bpc_out7,bpc_out8,bpc_out7_vld,bpc_out6_vld,bpc_out8_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell08(cell08_out,cell08_out_vld,stall_vld,bpc_out8,bpc_out9,bpc_out8_vld,bpc_out7_vld,bpc_out9_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell09(cell09_out,cell09_out_vld,stall_vld,bpc_out9,bpc_out10,bpc_out9_vld,bpc_out8_vld,bpc_out10_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell0a(cell0a_out,cell0a_out_vld,stall_vld,bpc_out10,8'b0,bpc_out10_vld,bpc_out9_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                                       
arrange_cell u_cell10(cell10_out,cell10_out_vld,stall_vld,cell00_out,cell01_out,cell00_out_vld,1'b1,cell01_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell11(cell11_out,cell11_out_vld,stall_vld,cell01_out,cell02_out,cell01_out_vld,cell00_out_vld,cell02_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell12(cell12_out,cell12_out_vld,stall_vld,cell02_out,cell03_out,cell02_out_vld,cell01_out_vld,cell03_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell13(cell13_out,cell13_out_vld,stall_vld,cell03_out,cell04_out,cell03_out_vld,cell02_out_vld,cell04_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell14(cell14_out,cell14_out_vld,stall_vld,cell04_out,cell05_out,cell04_out_vld,cell03_out_vld,cell05_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell15(cell15_out,cell15_out_vld,stall_vld,cell05_out,cell06_out,cell05_out_vld,cell04_out_vld,cell06_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell16(cell16_out,cell16_out_vld,stall_vld,cell06_out,cell07_out,cell06_out_vld,cell05_out_vld,cell07_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell17(cell17_out,cell17_out_vld,stall_vld,cell07_out,cell08_out,cell07_out_vld,cell06_out_vld,cell08_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell18(cell18_out,cell18_out_vld,stall_vld,cell08_out,cell09_out,cell08_out_vld,cell07_out_vld,cell09_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell19(cell19_out,cell19_out_vld,stall_vld,cell09_out,cell0a_out,cell09_out_vld,cell08_out_vld,cell0a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell1a(cell1a_out,cell1a_out_vld,stall_vld,cell0a_out,8'b0,cell0a_out_vld,cell09_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                                       
arrange_cell u_cell20(cell20_out,cell20_out_vld,stall_vld,cell10_out,cell11_out,cell10_out_vld,1'b1,cell11_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell21(cell21_out,cell21_out_vld,stall_vld,cell11_out,cell12_out,cell11_out_vld,cell10_out_vld,cell12_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell22(cell22_out,cell22_out_vld,stall_vld,cell12_out,cell13_out,cell12_out_vld,cell11_out_vld,cell13_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell23(cell23_out,cell23_out_vld,stall_vld,cell13_out,cell14_out,cell13_out_vld,cell12_out_vld,cell14_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell24(cell24_out,cell24_out_vld,stall_vld,cell14_out,cell15_out,cell14_out_vld,cell13_out_vld,cell15_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell25(cell25_out,cell25_out_vld,stall_vld,cell15_out,cell16_out,cell15_out_vld,cell14_out_vld,cell16_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell26(cell26_out,cell26_out_vld,stall_vld,cell16_out,cell17_out,cell16_out_vld,cell15_out_vld,cell17_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell27(cell27_out,cell27_out_vld,stall_vld,cell17_out,cell18_out,cell17_out_vld,cell16_out_vld,cell18_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell28(cell28_out,cell28_out_vld,stall_vld,cell18_out,cell19_out,cell18_out_vld,cell17_out_vld,cell19_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell29(cell29_out,cell29_out_vld,stall_vld,cell19_out,cell1a_out,cell19_out_vld,cell18_out_vld,cell1a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell2a(cell2a_out,cell2a_out_vld,stall_vld,cell1a_out,8'b0,cell1a_out_vld,cell19_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                                   
arrange_cell u_cell30(cell30_out,cell30_out_vld,stall_vld,cell20_out,cell21_out,cell20_out_vld,1'b1,cell21_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell31(cell31_out,cell31_out_vld,stall_vld,cell21_out,cell22_out,cell21_out_vld,cell20_out_vld,cell22_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell32(cell32_out,cell32_out_vld,stall_vld,cell22_out,cell23_out,cell22_out_vld,cell21_out_vld,cell23_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell33(cell33_out,cell33_out_vld,stall_vld,cell23_out,cell24_out,cell23_out_vld,cell22_out_vld,cell24_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell34(cell34_out,cell34_out_vld,stall_vld,cell24_out,cell25_out,cell24_out_vld,cell23_out_vld,cell25_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell35(cell35_out,cell35_out_vld,stall_vld,cell25_out,cell26_out,cell25_out_vld,cell24_out_vld,cell26_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell36(cell36_out,cell36_out_vld,stall_vld,cell26_out,cell27_out,cell26_out_vld,cell25_out_vld,cell27_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell37(cell37_out,cell37_out_vld,stall_vld,cell27_out,cell28_out,cell27_out_vld,cell26_out_vld,cell28_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell38(cell38_out,cell38_out_vld,stall_vld,cell28_out,cell29_out,cell28_out_vld,cell27_out_vld,cell29_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell39(cell39_out,cell39_out_vld,stall_vld,cell29_out,cell2a_out,cell29_out_vld,cell28_out_vld,cell2a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell3a(cell3a_out,cell3a_out_vld,stall_vld,cell2a_out,8'b0,cell2a_out_vld,cell29_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                        
arrange_cell u_cell40(cell40_out,cell40_out_vld,stall_vld,cell30_out,cell31_out,cell30_out_vld,1'b1,cell31_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell41(cell41_out,cell41_out_vld,stall_vld,cell31_out,cell32_out,cell31_out_vld,cell30_out_vld,cell32_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell42(cell42_out,cell42_out_vld,stall_vld,cell32_out,cell33_out,cell32_out_vld,cell31_out_vld,cell33_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell43(cell43_out,cell43_out_vld,stall_vld,cell33_out,cell34_out,cell33_out_vld,cell32_out_vld,cell34_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell44(cell44_out,cell44_out_vld,stall_vld,cell34_out,cell35_out,cell34_out_vld,cell33_out_vld,cell35_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell45(cell45_out,cell45_out_vld,stall_vld,cell35_out,cell36_out,cell35_out_vld,cell34_out_vld,cell36_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell46(cell46_out,cell46_out_vld,stall_vld,cell36_out,cell37_out,cell36_out_vld,cell35_out_vld,cell37_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell47(cell47_out,cell47_out_vld,stall_vld,cell37_out,cell38_out,cell37_out_vld,cell36_out_vld,cell38_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell48(cell48_out,cell48_out_vld,stall_vld,cell38_out,cell39_out,cell38_out_vld,cell37_out_vld,cell39_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell49(cell49_out,cell49_out_vld,stall_vld,cell39_out,cell3a_out,cell39_out_vld,cell38_out_vld,cell3a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell4a(cell4a_out,cell4a_out_vld,stall_vld,cell3a_out,8'b0,cell3a_out_vld,cell39_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                           
arrange_cell u_cell50(cell50_out,cell50_out_vld,stall_vld,cell40_out,cell41_out,cell40_out_vld,1'b1,cell41_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell51(cell51_out,cell51_out_vld,stall_vld,cell41_out,cell42_out,cell41_out_vld,cell40_out_vld,cell42_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell52(cell52_out,cell52_out_vld,stall_vld,cell42_out,cell43_out,cell42_out_vld,cell41_out_vld,cell43_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell53(cell53_out,cell53_out_vld,stall_vld,cell43_out,cell44_out,cell43_out_vld,cell42_out_vld,cell44_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell54(cell54_out,cell54_out_vld,stall_vld,cell44_out,cell45_out,cell44_out_vld,cell43_out_vld,cell45_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell55(cell55_out,cell55_out_vld,stall_vld,cell45_out,cell46_out,cell45_out_vld,cell44_out_vld,cell46_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell56(cell56_out,cell56_out_vld,stall_vld,cell46_out,cell47_out,cell46_out_vld,cell45_out_vld,cell47_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell57(cell57_out,cell57_out_vld,stall_vld,cell47_out,cell48_out,cell47_out_vld,cell46_out_vld,cell48_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell58(cell58_out,cell58_out_vld,stall_vld,cell48_out,cell49_out,cell48_out_vld,cell47_out_vld,cell49_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell59(cell59_out,cell59_out_vld,stall_vld,cell49_out,cell4a_out,cell49_out_vld,cell48_out_vld,cell4a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell5a(cell5a_out,cell5a_out_vld,stall_vld,cell4a_out,8'b0,cell4a_out_vld,cell49_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                             
arrange_cell u_cell60(cell60_out,cell60_out_vld,stall_vld,cell50_out,cell51_out,cell50_out_vld,1'b1,cell51_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell61(cell61_out,cell61_out_vld,stall_vld,cell51_out,cell52_out,cell51_out_vld,cell50_out_vld,cell52_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell62(cell62_out,cell62_out_vld,stall_vld,cell52_out,cell53_out,cell52_out_vld,cell51_out_vld,cell53_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell63(cell63_out,cell63_out_vld,stall_vld,cell53_out,cell54_out,cell53_out_vld,cell52_out_vld,cell54_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell64(cell64_out,cell64_out_vld,stall_vld,cell54_out,cell55_out,cell54_out_vld,cell53_out_vld,cell55_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell65(cell65_out,cell65_out_vld,stall_vld,cell55_out,cell56_out,cell55_out_vld,cell54_out_vld,cell56_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell66(cell66_out,cell66_out_vld,stall_vld,cell56_out,cell57_out,cell56_out_vld,cell55_out_vld,cell57_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell67(cell67_out,cell67_out_vld,stall_vld,cell57_out,cell58_out,cell57_out_vld,cell56_out_vld,cell58_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell68(cell68_out,cell68_out_vld,stall_vld,cell58_out,cell59_out,cell58_out_vld,cell57_out_vld,cell59_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell69(cell69_out,cell69_out_vld,stall_vld,cell59_out,cell5a_out,cell59_out_vld,cell58_out_vld,cell5a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell6a(cell6a_out,cell6a_out_vld,stall_vld,cell5a_out,8'b0,cell5a_out_vld,cell59_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                          
arrange_cell u_cell70(cell70_out,cell70_out_vld,stall_vld,cell60_out,cell61_out,cell60_out_vld,1'b1,cell61_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell71(cell71_out,cell71_out_vld,stall_vld,cell61_out,cell62_out,cell61_out_vld,cell60_out_vld,cell62_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell72(cell72_out,cell72_out_vld,stall_vld,cell62_out,cell63_out,cell62_out_vld,cell61_out_vld,cell63_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell73(cell73_out,cell73_out_vld,stall_vld,cell63_out,cell64_out,cell63_out_vld,cell62_out_vld,cell64_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell74(cell74_out,cell74_out_vld,stall_vld,cell64_out,cell65_out,cell64_out_vld,cell63_out_vld,cell65_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell75(cell75_out,cell75_out_vld,stall_vld,cell65_out,cell66_out,cell65_out_vld,cell64_out_vld,cell66_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell76(cell76_out,cell76_out_vld,stall_vld,cell66_out,cell67_out,cell66_out_vld,cell65_out_vld,cell67_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell77(cell77_out,cell77_out_vld,stall_vld,cell67_out,cell68_out,cell67_out_vld,cell66_out_vld,cell68_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell78(cell78_out,cell78_out_vld,stall_vld,cell68_out,cell69_out,cell68_out_vld,cell67_out_vld,cell69_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell79(cell79_out,cell79_out_vld,stall_vld,cell69_out,cell6a_out,cell69_out_vld,cell68_out_vld,cell6a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell7a(cell7a_out,cell7a_out_vld,stall_vld,cell6a_out,8'b0,cell6a_out_vld,cell69_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                             
arrange_cell u_cell80(cell80_out,cell80_out_vld,stall_vld,cell70_out,cell71_out,cell70_out_vld,1'b1,cell71_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell81(cell81_out,cell81_out_vld,stall_vld,cell71_out,cell72_out,cell71_out_vld,cell70_out_vld,cell72_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell82(cell82_out,cell82_out_vld,stall_vld,cell72_out,cell73_out,cell72_out_vld,cell71_out_vld,cell73_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell83(cell83_out,cell83_out_vld,stall_vld,cell73_out,cell74_out,cell73_out_vld,cell72_out_vld,cell74_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell84(cell84_out,cell84_out_vld,stall_vld,cell74_out,cell75_out,cell74_out_vld,cell73_out_vld,cell75_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell85(cell85_out,cell85_out_vld,stall_vld,cell75_out,cell76_out,cell75_out_vld,cell74_out_vld,cell76_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell86(cell86_out,cell86_out_vld,stall_vld,cell76_out,cell77_out,cell76_out_vld,cell75_out_vld,cell77_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell87(cell87_out,cell87_out_vld,stall_vld,cell77_out,cell78_out,cell77_out_vld,cell76_out_vld,cell78_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell88(cell88_out,cell88_out_vld,stall_vld,cell78_out,cell79_out,cell78_out_vld,cell77_out_vld,cell79_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell89(cell89_out,cell89_out_vld,stall_vld,cell79_out,cell7a_out,cell79_out_vld,cell78_out_vld,cell7a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell8a(cell8a_out,cell8a_out_vld,stall_vld,cell7a_out,8'b0,cell7a_out_vld,cell79_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                                          
arrange_cell u_cell90(cell90_out,cell90_out_vld,stall_vld,cell80_out,cell81_out,cell80_out_vld,1'b1,cell81_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell91(cell91_out,cell91_out_vld,stall_vld,cell81_out,cell82_out,cell81_out_vld,cell80_out_vld,cell82_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell92(cell92_out,cell92_out_vld,stall_vld,cell82_out,cell83_out,cell82_out_vld,cell81_out_vld,cell83_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell93(cell93_out,cell93_out_vld,stall_vld,cell83_out,cell84_out,cell83_out_vld,cell82_out_vld,cell84_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell94(cell94_out,cell94_out_vld,stall_vld,cell84_out,cell85_out,cell84_out_vld,cell83_out_vld,cell85_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell95(cell95_out,cell95_out_vld,stall_vld,cell85_out,cell86_out,cell85_out_vld,cell84_out_vld,cell86_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell96(cell96_out,cell96_out_vld,stall_vld,cell86_out,cell87_out,cell86_out_vld,cell85_out_vld,cell87_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell97(cell97_out,cell97_out_vld,stall_vld,cell87_out,cell88_out,cell87_out_vld,cell86_out_vld,cell88_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell98(cell98_out,cell98_out_vld,stall_vld,cell88_out,cell89_out,cell88_out_vld,cell87_out_vld,cell89_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell99(cell99_out,cell99_out_vld,stall_vld,cell89_out,cell8a_out,cell89_out_vld,cell88_out_vld,cell8a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cell9a(cell9a_out,cell9a_out_vld,stall_vld,cell8a_out,8'b0,cell8a_out_vld,cell89_out_vld,1'b0,clk_dwt,pos_clk_bpc,rst,rst_syn);
                             
arrange_cell u_cella0(cella0_out,cella0_out_vld,stall_vld,cell90_out,cell91_out,cell90_out_vld,1'b1,cell91_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella1(cella1_out,cella1_out_vld,stall_vld,cell91_out,cell92_out,cell91_out_vld,cell90_out_vld,cell92_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella2(cella2_out,cella2_out_vld,stall_vld,cell92_out,cell93_out,cell92_out_vld,cell91_out_vld,cell93_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella3(cella3_out,cella3_out_vld,stall_vld,cell93_out,cell94_out,cell93_out_vld,cell92_out_vld,cell94_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella4(cella4_out,cella4_out_vld,stall_vld,cell94_out,cell95_out,cell94_out_vld,cell93_out_vld,cell95_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella5(cella5_out,cella5_out_vld,stall_vld,cell95_out,cell96_out,cell95_out_vld,cell94_out_vld,cell96_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella6(cella6_out,cella6_out_vld,stall_vld,cell96_out,cell97_out,cell96_out_vld,cell95_out_vld,cell97_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella7(cella7_out,cella7_out_vld,stall_vld,cell97_out,cell98_out,cell97_out_vld,cell96_out_vld,cell98_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella8(cella8_out,cella8_out_vld,stall_vld,cell98_out,cell99_out,cell98_out_vld,cell97_out_vld,cell99_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
arrange_cell u_cella9(cella9_out,cella9_out_vld,stall_vld,cell99_out,cell9a_out,cell99_out_vld,cell98_out_vld,cell9a_out_vld,clk_dwt,pos_clk_bpc,rst,rst_syn);
		   
//********************************  for error ******************************************//
reg bpc_start_flag_delay_1;
reg bpc_start_flag_delay_2;
reg bpc_start_flag_delay_3;
reg pass_error_start;

always @(posedge clk_dwt or negedge rst) begin
	if(!rst) begin
		bpc_start_flag_delay_1 <=1'b0;
		bpc_start_flag_delay_2 <=1'b0;
		bpc_start_flag_delay_3 <=1'b0;
		pass_error_start <=1'b0;
	end
	else if(rst_syn)begin
		bpc_start_flag_delay_1 <=1'b0;
		bpc_start_flag_delay_2 <=1'b0;
		bpc_start_flag_delay_3 <=1'b0;
		pass_error_start <=1'b0;
	end
	else if(pos_clk_bpc==1'b1)begin
		if(stall_vld==1'b0) begin
			bpc_start_flag_delay_1 <=bpc_start_flag;
			bpc_start_flag_delay_2 <=bpc_start_flag_delay_1;
			bpc_start_flag_delay_3 <=bpc_start_flag_delay_2;
			pass_error_start <=bpc_start_flag_delay_3;
		end
	end
end

endmodule


