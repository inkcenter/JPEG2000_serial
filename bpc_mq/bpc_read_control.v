`timescale 1ns/10ps
module bpc_read_control( //output
							data_out1,
							data_out2,
							data_out3,
							data_out4,
							addra_2,
							addra_3,
							addra_4,
							addra_1,
							wea_1,
							ena_2,
							ena_3,
							ena_4,
							ena_1,
							count_YUV,
							band,
							stripe_over_delay,
							level_delay,
							level_reg,
							last_stripe_vld_delay,
							stop_delay4,
							code_over_delay,
							bpc_start_delay,
							bpc_start_reg,
							count_bp,
							halt,
							halt_to_fifo,
							zero_bp_count,
							count_bp_to_genere,
						 ///input
							top_plane,
							bpc_halt_T2,
							start_aga_song,
							flush_over,
							block_all_bp_over,
							douta_1,						
							douta_2,
							douta_3,
							douta_4,						
							bpc_start,			
							clk_rc,
						 	clk_sg,			
							rst,
							rst_syn,
							stall_vld);
							
	
input [3:0]top_plane;	
input bpc_halt_T2;
input start_aga_song;					
input flush_over;						
input [16:0] douta_2;
input [16:0] douta_3;
input [16:0] douta_4;
input [16:0] douta_1;
input bpc_start;
input clk_sg;
input clk_rc;
input rst;
input rst_syn;
input stall_vld;

output [3:0]count_bp_to_genere;
output halt;
output bpc_start_reg;
output [3:0]count_bp;
output halt_to_fifo;
output block_all_bp_over;
output ena_2;
output ena_3; 
output ena_4;
output ena_1;
output wea_1;
output [16:0] data_out1;
output [16:0] data_out2;
output [16:0] data_out3;
output [16:0] data_out4;
output [13:0] addra_2;
output [13:0] addra_3;
output [13:0] addra_4;
output [13:0] addra_1;
output [1:0]count_YUV;
output [1:0] band;
output stripe_over_delay;
output last_stripe_vld_delay;
output [2:0]level_delay;
output code_over_delay;
output stop_delay4;
output bpc_start_delay;
output [2:0] level_reg;
output [3:0] zero_bp_count;

wire wea_1;
wire ena_2;
wire ena_3;
wire ena_4;
wire ena_1;

reg [13:0] addra_2;
reg [13:0] addra_2_n;
reg [13:0] addra_3;
reg [13:0] addra_3_n;
reg [13:0] addra_4;
reg [13:0] addra_4_n;
reg [13:0] addra_1;
reg [13:0] addra_1_n;
reg jump_to_ram3;
reg jump_to_ram4;
reg jump_to_ram2;

wire srst;		
wire srset;
wire stop;
wire read_nen;

reg [16:0] datamv_out1;
reg [16:0] datamv_out2;
reg [16:0] datamv_out3;
reg [16:0] datamv_out4;
reg [16:0] data_out1;
reg [16:0] data_out2;
reg [16:0] data_out3;
reg [16:0] data_out4;
reg [5:0] count_column;
reg [5:0] count_column_n;
reg [2:0] count_sample;
reg [2:0] count_sample_n;
reg [3:0] count_stripe;
reg [3:0] count_stripe_n;
reg [2:0] level;
reg [2:0] level_reg;
reg [2:0] level_reg1;
reg [2:0] level_delay;
reg data_vld;
reg stripe_over;
reg stripe_over_reg;
reg last_stripe_vld;
reg last_stripe_vld_reg;
reg last_stripe_vld_delay;
reg [3:0] count_block_2;
reg [3:0] count_block_n_2;
reg [3:0] count_block_3;
reg [3:0] count_block_n_3;
reg [3:0] count_block_4;
reg [3:0] count_block_n_4;
reg [1:0] count_block_1;
reg [1:0] count_block_n_1;
reg block_over;
reg code_over;
reg stop_delay1;
reg code_over_n;
reg bpc_start_reg;
reg code_over_fsm;
reg code_over_fsm_n;
reg [2:0] count_code_over;
reg [8:0] count_relate_block;
reg relate_block_fsm;
reg relate_block_fsm_n;

wire column_over;
wire column_over_reg;
wire start_ram2;
wire start_ram3;
wire start_ram4;
wire start_ram1;
wire read_nen_delayx;
wire stripe_over_delay;

reg jump_to_ram2_reg;
reg jump_to_ram3_reg;
reg jump_to_ram4_reg;

reg [2:0]genaddr_fsm;
reg [2:0]genaddr_fsm_n;		

reg[2:0] fsm_read_ram ;
reg[2:0] fsm_read_ram_n;

reg [2:0]fsm_addr_stay;
reg [2:0]fsm_addr_stay_n;

parameter idle = 3'b000;
parameter add_sample = 3'b001;
parameter add_column = 3'b010;
parameter add_stripe = 3'b011;
parameter add_bp = 3'b110;
parameter add_block = 3'b100;
parameter idle_for_srset = 3'b101;	

parameter ram_idle =  3'b000;
parameter ram2_read = 3'b001;
parameter ram3_read = 3'b010;
parameter ram4_read = 3'b011;
parameter ram1_read = 3'b100;

parameter normal=3'b000;
parameter addr2_stay=3'b001;
parameter addr3_stay=3'b010;
parameter addr4_stay=3'b011;
parameter addr1_stay=3'b100;

reg[1:0] count_YUV;
reg[1:0] count_YUV_n;
reg[1:0] band;
reg[1:0] band_n;

reg [3:0] count_block_2_reg;
reg [3:0] count_block_3_reg;
reg [3:0] count_block_4_reg;

reg halt_reg;
reg halt_reg_2;
reg halt_reg_3;
reg start_aga_reg_reg;
reg start_aga_reg_reg1;
reg start_aga_reg_reg2;
reg [3:0]count_bp;
reg [3:0]count_bp_n;
wire halt_ram2;
wire halt_ram3;
wire halt_ram4;
wire halt;
wire bp_end_jump;
wire block_all_bp_over;
reg delay_count_bp;
reg [1:0]count_clk_rc;
wire start_aga;
wire nen;
wire bpc_halt_before;
wire bpc_halt;
reg bpc_halt_reg;
wire halt_to_fifo;
//*************************************************//
reg bpc_start_for_bpcount;
reg stall_delay1;
reg bpc_halt_n;
reg bpc_halt_n_n;
//***********************************************//
reg  stop_delay2;
reg  stop_delay3;
reg  stop_delay3_1;
reg  stop_delay3_2;
reg  stop_delay4_normal;
reg  stop_delay4_fd0;
reg  stop_delay4_fd1;
reg  stop_delay4_fd2;
reg  stop_delay4_fd3;
reg stop_delay4;

wire stop_select;
wire judge_stop_delay4;
reg fsm_for_stop;
reg fsm_for_stop_n;


assign stop_select=(fsm_for_stop==1'b1);
assign judge_stop_delay4=((count_relate_block==2)&&(stall_vld==1'b1));
//*********************************************************//
always @(posedge clk_rc or negedge rst) begin
	if(!rst) begin  
		stall_delay1 <=1'b0;
	end
	else if(rst_syn)begin
		stall_delay1 <=1'b0;
	end
	else begin
		stall_delay1<= stall_vld;
	end
end

always @(*) begin
	if(stop_select) begin
		stop_delay4 = stop_delay4_fd3;
	end
	else begin
		stop_delay4 = stop_delay4_fd0;
	end
end

always @(posedge clk_rc or negedge rst) begin
	if(!rst) begin  
		fsm_for_stop <=1'b0;
	end
	else if(rst_syn)begin
		fsm_for_stop <=1'b0;
	end
	else begin
		fsm_for_stop<= fsm_for_stop_n;
	end
end

always @(*) begin
    fsm_for_stop_n = fsm_for_stop;
 case(fsm_for_stop) 
    1'b0:       begin 
                  if(judge_stop_delay4==1'b1) begin
                    fsm_for_stop_n=1'b1;
                  end
				else begin
				  fsm_for_stop_n=1'b0;
				end
			  end
  1'b1:       begin
                if(count_relate_block==10) begin
				  fsm_for_stop_n=1'b0;
                  end
                  else begin
                    fsm_for_stop_n=1'b1;
                  end
                end
 endcase
end 

wire code_over_delay = ((count_code_over > 2)&&(count_code_over < 5));

reg bpc_start_fsm;
reg bpc_start_fsm_n;
reg [2:0] count_bpc_start;
always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    count_bpc_start <= 3'b0;
  end
  else if(rst_syn)begin
	count_bpc_start <= 3'b0;
  end
  else if(srst == 1'b1) begin
    count_bpc_start <= 3'b0;
  end
  else if(bpc_start_fsm == 1'b1) begin
      count_bpc_start <= count_bpc_start + 1;
  end
end
always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    bpc_start_fsm <= 1'b0;
  end
  else if(rst_syn)begin
	bpc_start_fsm <= 1'b0;
  end
  else begin
    bpc_start_fsm <= bpc_start_fsm_n;
  end
end
always@(*) begin
  bpc_start_fsm_n = bpc_start_fsm;
  case(bpc_start_fsm)
    1'b0:if(bpc_start == 1'b1) begin
      bpc_start_fsm_n = 1'b1;
    end
    1'b1:if(count_bpc_start == 6) begin
      bpc_start_fsm_n = 1'b0;
    end 
  endcase
end

wire bpc_start_delay = ((count_bpc_start>2)&&(count_bpc_start < 7));
//*****************************************//
assign read_nen_delayx = ((stop_delay1==1'b1)||(stall_delay1==1'b1));

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	  bpc_start_reg <= 1'b0;
    end
	else if(rst_syn)begin
		bpc_start_reg <= 1'b0;
	end
    else if(bpc_start)begin
	  bpc_start_reg <= 1'b1 ;
    end
end
reg bpc_start_for_bpcount3;
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	  bpc_start_for_bpcount <= 1'b0;
	  bpc_start_for_bpcount3<= 1'b0;
    end
	else if(rst_syn)begin
		bpc_start_for_bpcount <= 1'b0;
	    bpc_start_for_bpcount3<= 1'b0;
	end
    else begin
	  bpc_start_for_bpcount <= bpc_start ;
	  bpc_start_for_bpcount3<=bpc_start_for_bpcount;
    end
end
 
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		stop_delay1<=0;
		stop_delay2 <= 1'b0;
		stop_delay3 <= 1'b0;
		stop_delay3_1 <= 1'b0;
		stop_delay3_2 <= 1'b0;
		stop_delay4_normal <= 1'b0;
		stop_delay4_fd0 <= 1'b0;
		stop_delay4_fd1 <= 1'b0;
		stop_delay4_fd2 <= 1'b0;
		stop_delay4_fd3 <= 1'b0;
	end
	else if(rst_syn)begin
		stop_delay1<=0;
	    stop_delay2 <= 1'b0;
	    stop_delay3 <= 1'b0;
	    stop_delay3_1 <= 1'b0;
	    stop_delay3_2 <= 1'b0;
	    stop_delay4_normal <= 1'b0;
	    stop_delay4_fd0 <= 1'b0;
	    stop_delay4_fd1 <= 1'b0;
	    stop_delay4_fd2 <= 1'b0;
	    stop_delay4_fd3 <= 1'b0;
	end
	else begin
		stop_delay1 <= stop;
		stop_delay2 <= stop_delay1;
		stop_delay3 <= stop_delay2;
		stop_delay3_1 <= stop_delay3;
		stop_delay3_2 <= stop_delay3_1;
		stop_delay4_normal <= stop_delay3_2;
		stop_delay4_fd0 <= stop_delay4_normal;
		stop_delay4_fd1 <= stop_delay4_fd0;
		stop_delay4_fd2 <= stop_delay4_fd1;
		stop_delay4_fd3 <= stop_delay4_fd2;
	end
end

//*****************************************  wea   ena  ***********************************//
assign wea_1=(level != 3'b111)?1'b0:1'b1;

assign ena_1=(level != 3'b111)?1'b1:1'b0;
assign ena_2=(level != 3'b111)?1'b1:1'b0;
assign ena_3=(level != 3'b111)?1'b1:1'b0;
assign ena_4=(level != 3'b111)?1'b1:1'b0;
//******************************************************************//
always @(*)begin
  case(level)
     3'b100:   jump_to_ram3 = ((((addra_2==16335)||(addra_2==16351)||(addra_2==16367))&&bp_end_jump)||(start_aga&&start_ram2));
     3'b011:   jump_to_ram3 = ((((addra_2==16191)||(addra_2==16255)||(addra_2==16319))&&bp_end_jump)||(start_aga&&start_ram2));
	 3'b010:   jump_to_ram3 = ((((addra_2==15615)||(addra_2==15871)||(addra_2==16127))&&bp_end_jump)||(start_aga&&start_ram2));
	 3'b001:   jump_to_ram3 = ((((addra_2==13311)||(addra_2==14335)||(addra_2==15359))&&bp_end_jump)||(start_aga&&start_ram2));
	 3'b000:   jump_to_ram3 = ((((addra_2==4095)||(addra_2==8191)||(addra_2==12287))&&bp_end_jump)||(start_aga&&start_ram2));
	default:   jump_to_ram3 = 0;
  endcase
end

always @(*)begin
  case(level)
     3'b100:   jump_to_ram4 = ((((addra_3==16335)||(addra_3==16351)||(addra_3==16367))&&bp_end_jump)||(start_aga&&start_ram3));
     3'b011:   jump_to_ram4 = ((((addra_3==16191)||(addra_3==16255)||(addra_3==16319))&&bp_end_jump)||(start_aga&&start_ram3));
	 3'b010:   jump_to_ram4 = ((((addra_3==15615)||(addra_3==15871)||(addra_3==16127))&&bp_end_jump)||(start_aga&&start_ram3));
	 3'b001:   jump_to_ram4 = ((((addra_3==13311)||(addra_3==14335)||(addra_3==15359))&&bp_end_jump)||(start_aga&&start_ram3));
	 3'b000:   jump_to_ram4 = ((((addra_3==4095)||(addra_3==8191)||(addra_3==12287))&&bp_end_jump)||(start_aga&&start_ram3));
	default:   jump_to_ram4 = 0;
  endcase
end

always @(*)begin
  case(level)
     3'b100:   jump_to_ram2 = ((((addra_4==16335)||(addra_4==16351)||(addra_4==16367)||(addra_1==47))&&bp_end_jump)||(start_aga&&start_ram4)||(start_aga&&start_ram1&&(count_block_n_1==2'd3)));
     3'b011:   jump_to_ram2 = ((((addra_4==16191)||(addra_4==16255)||(addra_4==16319))&&bp_end_jump)||(start_aga&&start_ram4));
	 3'b010:   jump_to_ram2 = ((((addra_4==15615)||(addra_4==15871)||(addra_4==16127))&&bp_end_jump)||(start_aga&&start_ram4));
	 3'b001:   jump_to_ram2 = ((((addra_4==13311)||(addra_4==14335)||(addra_4==15359))&&bp_end_jump)||(start_aga&&start_ram4));
	 3'b000:   jump_to_ram2 = ((((addra_4==4095)||(addra_4==8191)||(addra_4==12287))&&bp_end_jump)||(start_aga&&start_ram4));
	default:   jump_to_ram2 = 0;
  endcase
end
assign start_ram2 = (fsm_read_ram == ram2_read);
assign start_ram3 = (fsm_read_ram == ram3_read);
assign start_ram4 = (fsm_read_ram == ram4_read);
assign start_ram1 = (fsm_read_ram == ram1_read);
///********************************************************************///
reg data_vld_last;
reg data_vld_last_reg;
assign column_over = (count_sample == 3'b010);
assign column_over_reg = (count_sample == 3'b100); 

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    datamv_out1 <= 17'b0;
		datamv_out2 <= 17'b0;
		datamv_out3 <= 17'b0;
		datamv_out4 <= 17'b0;
	end
	else if(rst_syn)begin
		datamv_out1 <= 17'b0;
	    datamv_out2 <= 17'b0;
	    datamv_out3 <= 17'b0;
	    datamv_out4 <= 17'b0;
	end
	else if(srset==1'b1) begin
	    datamv_out1 <= 17'b0;
		datamv_out2 <= 17'b0;
		datamv_out3 <= 17'b0;
		datamv_out4 <= 17'b0;
	end
	else if(((ena_2 == 1'b1)&&(read_nen_delayx == 1'b0))||(count_relate_block==1))begin
	            case({start_ram1,start_ram4,start_ram3,start_ram2})
				          4'b0001:   datamv_out1 <= douta_2[16:0];
						  4'b0010:   datamv_out1 <= douta_3[16:0];
						  4'b0100:   datamv_out1 <= douta_4[16:0];
						  4'b1000:   datamv_out1 <= douta_1[16:0];
						 default:   datamv_out1 <= datamv_out1;
				endcase
		        datamv_out2 <= datamv_out1;
		        datamv_out3 <= datamv_out2;
		        datamv_out4 <= datamv_out3;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
        data_out1 <= 17'b0;
        data_out2 <= 17'b0;
        data_out3 <= 17'b0;
        data_out4 <= 17'b0;
    end
	else if(rst_syn)begin
		data_out1 <= 17'b0;
	    data_out2 <= 17'b0;
	    data_out3 <= 17'b0;
	    data_out4 <= 17'b0;
	end
	else if(srset==1'b1) begin
        data_out1 <= 17'b0;	
	    data_out2 <= 17'b0;
	    data_out3 <= 17'b0;
	    data_out4 <= 17'b0;
	end
	else if(halt==1'b1)begin
		data_out1 <= 17'b0;
		data_out2 <= 17'b0;
		data_out3 <= 17'b0;
		data_out4 <= 17'b0;
	end
	else if(data_vld_last_reg==1'b1) begin
        data_out1 <= datamv_out4;
        data_out2 <= datamv_out3;
        data_out3 <= datamv_out2;
        data_out4 <= datamv_out1;
    end
	else if((data_vld == 1'b1)&&(stall_delay1==1'b0))begin
        data_out1 <= datamv_out4;
        data_out2 <= datamv_out3;
        data_out3 <= datamv_out2;
        data_out4 <= datamv_out1;
    end
end


always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    data_vld <= 1'b0;
	end
	else if(rst_syn)begin	
		data_vld <= 1'b0;
	end
    else if(srst==1'b1) begin
	    data_vld <= 1'b0;
	end
	else if	((column_over_reg == 1'b1))begin
		if((count_column_n==0)&&(count_stripe_n==0))begin
			data_vld <= 1'b0;
		end
		else begin
			data_vld <= 1'b1;
		end
	end
	else begin
	    data_vld <= 1'b0;
	end
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		data_vld_last<=0;
		data_vld_last_reg<=0;
	end
	else if(rst_syn)begin
		data_vld_last<=0;
	    data_vld_last_reg<=0;
	end
	else if((count_sample==3'd3)&&(stop==1'b1))begin
		data_vld_last<=1'b1;
		data_vld_last_reg<=data_vld_last;
	end
	else begin
		data_vld_last<=0;
		data_vld_last_reg<=0;
	end	
end
///**************************   ******************************///
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		level <= 3'b111;
	end
	else if(rst_syn)begin
		level <= 3'b111;
	end
	else if(bpc_start)begin
		level <= 3'b100;
	end
	else  begin
		case(level)
			3'b100: begin
						if((stop==0)&&(count_block_4==4'd3))begin
							level <= 3'b011;
						end
					end
			3'b011: begin
						if((stop==0)&&(count_block_4==6))begin
							level <= 3'b010;
						end
					end
			3'b010: begin
						if((stop==0)&&(count_block_4==9))begin
							level <= 3'b001;
						end
					end
			3'b001: begin
						if((stop==0)&&(count_block_4==12))begin
							level <= 3'b000;
						end
					end
			3'b000: begin
						if((stop==0)&&(count_block_4==15))begin
							level <= 3'b111;
						end
					end			
		endcase			
	end
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		level_reg <= 3'b111;	
	end
	else if(rst_syn)begin
		level_reg <= 3'b111;
	end
	else if(stall_vld==1'b0)begin
		level_reg <= level;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
        level_reg1 <= 3'b111;
    end
	else if(rst_syn)begin
		level_reg1 <= 3'b111;
	end
    else if(stall_vld==1'b0)begin
        level_reg1 <= level_reg;
    end
end

always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    level_delay <= 3'b111;
  end
  else if(rst_syn)begin
	level_delay <= 3'b111;
  end
  else if(stall_vld==1'b0)begin
    level_delay <= level_reg1;
  end
end

///****************************************************************///
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_sample<=3'b111;
	end
	else if(rst_syn)begin
		count_sample<=3'b111;
	end
	else if(srset==1'b1) begin
	    count_sample<=0;
	end
	else if(start_aga_reg_reg)begin
		count_sample<=0;
	end
	else if(read_nen == 1'b0)begin
	    count_sample<=count_sample_n;
	end
end

always@(*) begin
    count_sample_n = count_sample;
    if(srst == 1'b1) begin
      if(bpc_start_reg == 1'b1) begin
	        count_sample_n = 3'b001;
	    end
	    else begin
	        count_sample_n = 3'b0;
	    end
	end
	else if(count_sample == 3'b100) begin
	    count_sample_n = 3'b001;
	end
	else begin
	    count_sample_n = count_sample + 1;
	end
end
///***********************************************************///
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_column <= 6'b0;
	end
	else if(rst_syn)begin
		 count_column <= 6'b0;
	end
	else if(srset==1'b1) begin
	    count_column <= 6'b0;
	end
	else if(start_aga_reg_reg)begin
		count_column<=0;
	end
   else if(read_nen == 1'b0)begin
	    count_column <= count_column_n;
	end
end

always@(*) begin
    count_column_n = count_column;
    if(srst == 1'b1) begin
	    count_column_n = 6'b0;
	end
	else begin
	    case(level)
            3'b100: begin
			  if(column_over_reg == 1'b1)begin
			    if(count_column == 6'd3) begin
				    count_column_n = 0;
				end
				else begin
				    count_column_n = count_column + 1;
				end
			end
            end
            3'b011: begin
			  if(level_reg==3'b100) begin
			  count_column_n = 0;
			end
			else if(column_over_reg == 1'b1) begin
			      if(count_column == 6'd7) begin
				    count_column_n = 0;
				  end
				  else begin
				    count_column_n = count_column + 1;
				  end
			end
             end			
			3'b010: begin
			    if(level_reg==3'b011) begin
				  count_column_n = 0;
				end
				else if(column_over_reg == 1'b1) begin
				    if(count_column == 6'd15) begin
					    count_column_n = 0;
					end
					else begin
					    count_column_n = count_column + 1;
					end
				end
			end
			3'b001: begin
			    if(level_reg==3'b010) begin
				  count_column_n = 0;
				end
				else if(column_over_reg == 1'b1) begin
				    if(count_column == 6'd31) begin
					    count_column_n = 0;
					end
					else begin
					    count_column_n = count_column + 1;
					end
				end
			end
			3'b000: begin
			    if(level_reg==3'b001) begin
				  count_column_n = 0;
				end
			    else if(column_over_reg == 1'b1) begin
				    if(count_column == 6'd63) begin
					    count_column_n = 0;
					end
					else begin
					    count_column_n = count_column + 1;
					end
				end
			end
			default: begin
			    count_column_n = count_column;
			end
	    endcase
	end
end

///**************************************************///
always@(*)begin
	case(level)
		3'b100: begin
		    if((count_column == 6'd3)&&(count_sample == 3'b010)) begin
			    stripe_over = 1'b1;
			end
			else begin
			    stripe_over = 1'b0;
			end
		end
		3'b011: begin
		    if((count_column == 6'd7)&&(count_sample == 3'b010)) begin
			    stripe_over = 1'b1;
			end
			else begin
			    stripe_over = 1'b0;
			end
		end
		3'b010: begin
		    if((count_column == 6'd15)&&(count_sample == 3'b010)) begin
			    stripe_over = 1'b1;
			end
			else begin
			    stripe_over = 1'b0;
			end
		end
		3'b001: begin
		    if((count_column == 6'd31)&&(count_sample == 3'b010)) begin
			    stripe_over = 1'b1;
			end
			else begin
			    stripe_over = 1'b0;
			end
		end
		3'b000: begin
	       if((count_column == 6'd63)&&(count_sample == 3'b010)) begin
			    stripe_over = 1'b1;
			end
			else begin
			    stripe_over = 1'b0;
			end
	    end
		default: begin
		    stripe_over = 1'b0;
		end
	endcase
end

always@(*)begin
	if((halt_reg_2==1'b0)&&(bpc_halt_reg==1'b0))begin
		case(level)
			3'b100: begin
				if((count_column == 6'd3)&&(count_sample == 3'b100)) begin
					stripe_over_reg = 1'b1;
				end
				else begin
					stripe_over_reg = 1'b0;
				end
			end	
			3'b011: begin
				if((count_column == 6'd7)&&(count_sample == 3'b100)) begin
					stripe_over_reg = 1'b1;
				end
				else begin
					stripe_over_reg = 1'b0;
				end
			end
			3'b010: begin
				if((count_column == 6'd15)&&(count_sample == 3'b100)) begin
					stripe_over_reg = 1'b1;
				end
				else begin
					stripe_over_reg = 1'b0;
				end
			end
			3'b001: begin
				if((count_column == 6'd31)&&(count_sample == 3'b100)) begin
					stripe_over_reg = 1'b1;
				end
				else begin
					stripe_over_reg = 1'b0;
				end
			end
			3'b000: begin
			if((count_column == 6'd63)&&(count_sample == 3'b100)) begin
					stripe_over_reg = 1'b1;
				end
				else begin
					stripe_over_reg = 1'b0;
				end
			end
			default: begin
				stripe_over_reg = 1'b0;
			end
		endcase	
	end	
	else if(halt_reg_2==1'b1)begin
		case(level)
			3'b100,3'b011,3'b010,3'b001,3'b000:
			begin
				if(halt_reg==1'b0) begin
						stripe_over_reg = 1'b1;
					end
						else begin
							stripe_over_reg = 1'b0;
						end
			end
		default:stripe_over_reg = 1'b0;
		endcase
	end
	else begin
		stripe_over_reg = 1'b0;
	end
end

reg stripe_over_reg1;
reg stripe_over_reg2;
reg stripe_over_reg3;
reg stripe_over_reg_x;
reg stripe_over_reg_x_1;
reg stripe_over_reg_x_2;
reg stripe_over_reg_x_3;

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
        stripe_over_reg1 <= 1'b0;
        stripe_over_reg2 <= 1'b0;
        stripe_over_reg3 <= 1'b0;
    end
	else if(rst_syn)begin
		stripe_over_reg1 <= 1'b0;
	    stripe_over_reg2 <= 1'b0;
	    stripe_over_reg3 <= 1'b0;
	end
	else if(srset==1'b1) begin
	    stripe_over_reg1 <= 1'b0;
        stripe_over_reg2 <= 1'b0;
        stripe_over_reg3 <= 1'b0;
	end
    else if(read_nen == 1'b0)begin
		if((level_reg!=level)&&(level!=3'b111)) begin
		  stripe_over_reg1 <=1'b1;
		end
		else begin			
		 stripe_over_reg1 <= stripe_over_reg;
         stripe_over_reg2 <= stripe_over_reg1;
         stripe_over_reg3 <= stripe_over_reg2;
		end	
    end
end

always@(posedge clk_rc or negedge rst) begin
	if(!rst) begin
		stripe_over_reg_x <= 1'b0;
	end
	else if(rst_syn)begin
		stripe_over_reg_x <= 1'b0;
	end
	else if((relate_block_fsm==1'b1)&&(count_relate_block==0)&&(stall_vld==1'b0)) begin
		  stripe_over_reg_x <= 1'b1;
	end
	else if(count_relate_block==4) begin
	  stripe_over_reg_x <= 1'b1;
	end
	else begin
	  stripe_over_reg_x <= 1'b0;
	end
end

always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    stripe_over_reg_x_1 <=1'b0;       
    stripe_over_reg_x_2 <=1'b0;
    stripe_over_reg_x_3 <=1'b0;
  end
  else if(rst_syn)begin
	stripe_over_reg_x_1 <=1'b0; 
    stripe_over_reg_x_2 <=1'b0;
    stripe_over_reg_x_3 <=1'b0;
  end
  else begin
    stripe_over_reg_x_1 <= stripe_over_reg_x;
    stripe_over_reg_x_2 <= stripe_over_reg_x_1;
	stripe_over_reg_x_3 <= stripe_over_reg_x_2;
  end
end

assign stripe_over_delay =(count_relate_block!=0)?((stripe_over_reg_x==1'b1)||(stripe_over_reg_x_1==1'b1)||(stripe_over_reg_x_2==1'b1)||(stripe_over_reg_x_3==1'b1)):((stripe_over_reg==1'b1)||(stripe_over_reg1==1'b1)||(stripe_over_reg2==1'b1)||(stripe_over_reg3==1'b1));

//**************************************************************//
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_stripe <= 4'b0;
	end
	else if(rst_syn)begin
		count_stripe <= 4'b0;
	end
	else if(srset==1'b1) begin
	    count_stripe <= 4'b0;
	end
	else if(read_nen == 1'b0)begin
	    count_stripe <= count_stripe_n;
	end
end

always@(*)begin
		count_stripe_n = count_stripe;
	if(srst == 1'b1)begin
		count_stripe_n = 4'b0;
	end
	else begin
		case(level)
			3'b100: 
			begin
                 if(stripe_over_reg == 1'b1) 
				 begin
            	    if(count_stripe == 4'b0000) 
					begin
            		    count_stripe_n = 4'b0;
            		end
            		else 
					begin
            		    count_stripe_n = count_stripe + 1;
            		end
            	end
			end
           3'b011: begin
                if(level_reg==3'b100) begin
            	   count_stripe_n = 4'b0;
            	end
                else if(stripe_over_reg == 1'b1) begin
            	    if(count_stripe == 4'b0001) begin
            		    count_stripe_n = 4'b0;
            		end
            		else if(halt_reg_2==1'b0)begin
            		    count_stripe_n = count_stripe + 1;
            		end
            	end
            end
			3'b010: begin
                if(level_reg==3'b011)begin
            		  count_stripe_n = 4'b0;
            	end
                else if(stripe_over_reg == 1'b1) begin
            	    if(count_stripe == 4'b0011) begin
            		    count_stripe_n = 4'b0;
            		end
            		else if(halt_reg_2==1'b0)begin
            		    count_stripe_n = count_stripe + 1;
            		end
            	end
            end
			3'b001: begin
            	if(level_reg==3'b010)begin
            	    count_stripe_n = 4'b0;
            	end
            	else if(stripe_over_reg == 1'b1) begin
					if(count_stripe == 4'b0111) begin
						count_stripe_n = 4'b0;
					end
					else if(halt_reg_2==1'b0)begin
						count_stripe_n = count_stripe + 1;
					end
            	end
            end
			3'b000: begin
				if(level_reg==3'b001)begin
					count_stripe_n = 4'b0;
				end
				else if(stripe_over_reg == 1'b1)begin
					if(count_stripe == 4'b1111)begin
						count_stripe_n = 4'b0;
					end
					else if(halt_reg_2==1'b0)begin
						count_stripe_n = count_stripe + 1;
					end
				end
			end
			default: begin
                count_stripe_n = count_stripe;
			end
		endcase	
	end
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst) begin
	    last_stripe_vld <= 1'b0;
    end
	else if(rst_syn)begin
		last_stripe_vld <= 1'b0;
	end
	else begin
		case(level)
			3'b100: begin
                if(count_stripe == 4'b0000) begin
            	    last_stripe_vld <= 1'b1;
            	end
            	else begin
            	    last_stripe_vld <= 1'b0;
            	end
            end
			3'b011: begin
                if(count_stripe == 4'b0001) begin
            	    last_stripe_vld <= 1'b1;
            	end
            	else begin
            	    last_stripe_vld <= 1'b0;
            	end
            end
			3'b010: begin
                if(count_stripe == 4'b0011) begin
            	    last_stripe_vld <= 1'b1;
            	end
            	else begin
            	    last_stripe_vld <= 1'b0;
            	end
            end
			3'b001: begin
                if(count_stripe == 4'b0111) begin
            	    last_stripe_vld <= 1'b1;
            	end
            	else begin
            	    last_stripe_vld <= 1'b0;
            	end
            end
			3'b000: begin
			    if(count_stripe == 4'b1111) begin
				    last_stripe_vld <= 1'b1;
			    end
			    else begin
				    last_stripe_vld <= 1'b0;
			    end					
			end				
			default: begin
			    last_stripe_vld <= 1'b0;
			end
		endcase		
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
        last_stripe_vld_reg <= 1'b0;
    end
	else if(rst_syn)begin
		last_stripe_vld_reg <= 1'b0;
	end
	else if(srset==1'b1) begin
	    last_stripe_vld_reg <= 1'b0;
	end
    else if(read_nen == 1'b0)begin
        last_stripe_vld_reg <= last_stripe_vld;
    end
end

always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    last_stripe_vld_delay <= 1'b0;
  end
  else if(rst_syn)begin
	last_stripe_vld_delay <= 1'b0;
  end
  else if(read_nen == 1'b0) begin
    last_stripe_vld_delay <= last_stripe_vld_reg;
  end
end

// reg block_over_reg;
// always@(posedge clk_rc or negedge rst) begin
  // if(!rst) begin
    // block_over_reg <= 1'b0;
  // end
   // else if(rst_syn)begin
	  // block_over_reg <= 1'b0;
   // end
  // else begin
    // block_over_reg <= block_over;
  // end
// end

always@(*)begin
	case(level)
		3'b100: begin
            if((count_column == 6'd3)&&(count_sample == 3'b010)&&(count_stripe == 4'b0000)) begin
        	    block_over = 1'b1;
        	end
        	else begin
        	    block_over = 1'b0;
        	end
        end
		3'b011: begin
            if((count_column == 6'd7)&&(count_sample == 3'b010)&&(count_stripe == 4'b0001)) begin
        	    block_over = 1'b1;
        	end
        	else begin
        	    block_over = 1'b0;
        	end
        end
        3'b010: begin
            if((count_column == 6'd15)&&(count_sample == 3'b010)&&(count_stripe == 4'b0011)) begin
        	    block_over = 1'b1;
        	end
        	else begin
        	    block_over = 1'b0;
        	end
        end
		3'b001: begin
            if((count_column == 6'd31)&&(count_sample == 3'b010)&&(count_stripe == 4'b0111)) begin
        	    block_over = 1'b1;
        	end
        	else begin
        	    block_over = 1'b0;
        	end
        end
		3'b000: begin
            if((count_column == 6'd63)&&(count_sample == 3'b010)&&(count_stripe == 4'b1111)) begin
        	    block_over = 1'b1;
        	end
        	else begin
        	    block_over = 1'b0;
        	end
        end
		default: begin
            block_over = 1'b0;
        end
	endcase
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_2 <= 4'b0;
	end
	  else if(rst_syn)begin
		count_block_2 <= 4'b0;
	  end
	else if(srset==1'b1) begin
	    count_block_2 <= 4'b0;
	end
	else if(read_nen == 1'b0)begin
	    count_block_2 <= count_block_n_2;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_3 <= 4'b0;
	end
	else if(rst_syn)begin
		 count_block_3 <= 4'b0;
	end
	else if(srset==1'b1) begin
	    count_block_3 <= 4'b0;
	end
	else if(read_nen == 1'b0)begin
	    count_block_3 <= count_block_n_3;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_4 <= 4'b0;
	end
	else if(rst_syn)begin
		count_block_4 <= 4'b0;
	end
	else if(srset==1'b1) begin
	    count_block_4 <= 4'b0;
	end
	else if(read_nen == 1'b0)begin
	    count_block_4 <= count_block_n_4;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_1 <= 0;
	end
	else if(rst_syn)begin
		 count_block_1 <= 0;
	end
	else if(srset==1'b1) begin
	    count_block_1 <= 0;
	end
	else if(read_nen == 1'b0)begin
	    count_block_1 <= count_block_n_1;
	end
end

always@(*)
begin
	count_block_n_2 = count_block_2;
	count_block_n_3 = count_block_3;
	count_block_n_4 = count_block_4;
	count_block_n_1 = count_block_1;
	
	if(srst == 1'b1)begin
		count_block_n_2=4'b0;
		count_block_n_3=4'b0;
		count_block_n_4=4'b0;
		count_block_n_1=2'b0;
	end
	else begin
		if(((block_over == 1'b1)&&(bp_end_jump)&&(halt==1'b0))||start_aga)begin				///???????????????????????
				case({start_ram1,start_ram4,start_ram3,start_ram2})
					4'b0001:    begin
					
					                    count_block_n_2=count_block_2 + 1;
					
							   end
					4'b0010:    begin
					
					                    count_block_n_3=count_block_3 + 1;
					
							   end
							   
					4'b0100:    begin
					
					                    count_block_n_4=count_block_4 + 1;
					
							   end
					4'b1000:    begin
					
					                    count_block_n_1=count_block_1 + 1;
					
							   end
					default:   begin
					              count_block_n_2 = count_block_2;
								  count_block_n_3 = count_block_3;
								  count_block_n_4 = count_block_4;
								  count_block_n_1 = count_block_1;
							   end
				endcase			
		end
		else begin
			count_block_n_2=count_block_2;
			count_block_n_3=count_block_3;
			count_block_n_4=count_block_4;
			count_block_n_1=count_block_1;
		end
	end
end
	
always@(posedge clk_rc or negedge rst)
begin
	if(!rst)
	begin
		code_over <= 1'b0;
	end
	else if(rst_syn)
	begin
		code_over <= 1'b0;
	end
	else 
	begin
		code_over <= code_over_n;
	end
end

always@(*)begin
	code_over_n = code_over;
	
	if((level == 3'b111)&&(level_reg==3'b000))begin
		code_over_n = 1'b1;
	end
	else begin
		code_over_n = 1'b0;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
      code_over_fsm <= 1'b0;
    end
	else if(rst_syn)begin
		code_over_fsm <= 1'b0;
	end
  else begin
    code_over_fsm <= code_over_fsm_n;
  end
end

always@(*) begin
  code_over_fsm_n = code_over_fsm;
  case(code_over_fsm)
    1'b0: begin
		if(code_over == 1'b1) begin
			code_over_fsm_n = 1'b1;
		end
    end
    1'b1: begin
		if(count_code_over == 5) begin
			code_over_fsm_n = 1'b0;
		end 
    end
  endcase
end

always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    count_code_over <= 3'b0;
  end
  else if(rst_syn)begin
	 count_code_over <= 3'b0;
  end
  else if(code_over_fsm == 1'b1) begin
  count_code_over <= count_code_over + 1;
  end
end
	
///*************************************   ***************************************///			
 always@(posedge clk_rc or negedge rst) begin
  if(!rst) begin
    relate_block_fsm <= 1'b0;
  end
    else if(rst_syn)begin
		relate_block_fsm <= 1'b0;
	end
  else if(stall_vld == 1'b0)begin
    relate_block_fsm <= relate_block_fsm_n;
  end  
end

always@(*)begin
	relate_block_fsm_n = relate_block_fsm;
	case(relate_block_fsm)
		1'b0: 	begin
					if(block_over == 1'b1&&halt==1'b0)begin
						relate_block_fsm_n = 1'b1;
					end
				end
		1'b1:	begin
					if(count_relate_block == 295)begin
						relate_block_fsm_n = 1'b0;
					end
				end
		default: begin
				relate_block_fsm_n = 1'b0;
		end
	endcase	
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		count_relate_block <= 9'b0;
	end
	else if(rst_syn)begin
		count_relate_block <= 9'b0;
	end
	else if(relate_block_fsm == 1'b0)begin
		count_relate_block <= 9'b0;
	end
	else if(halt==1'b1)begin
		count_relate_block<=count_relate_block;
	end
	else if(relate_block_fsm == 1'b1)begin
		count_relate_block <= count_relate_block + 1;
	end
end

assign stop = (relate_block_fsm == 1'b1);
assign read_nen = ((stop == 1'b1)||(stall_vld==1'b1));
reg read_nen_delay;
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    read_nen_delay <= 0;
	end
	else if(rst_syn)begin
		read_nen_delay <= 0;
	end
	else begin
		read_nen_delay<=read_nen;
	end
end	
///**************************************      ******************************************////		
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    addra_2 <= 14'd16320;
	end
	else if(rst_syn)begin
		addra_2 <= 14'd16320;
	end
	else if(srset==1'b1) begin
	    addra_2 <= 14'd16320;
	end	
	else if(halt==1'b1)begin
		addra_2 <= addra_2;
	end
	else if(start_aga_reg_reg&&start_ram2)begin			
		case(count_block_2_reg)
			4'd0:begin
				addra_2<=14'd16336;	
			end
			4'd1:begin
				addra_2<=14'd16352;
			end
			4'd2:begin
				addra_2<=14'd16128;
			end
			4'd3:begin
				addra_2<=14'd16192;
			end
			4'd4:begin
				addra_2<=14'd16256;
			end
			4'd5:begin
				addra_2<=14'd15360;
			end
			4'd6:begin
				addra_2<=14'd15616;
			end
			4'd7:begin
				addra_2<=14'd15872;
			end
			4'd8:begin
				addra_2<=14'd12288;
			end
			4'd9:begin
				addra_2<=14'd13312;
			end
			4'd10:begin
				addra_2<=14'd14336;
			end
			4'd11:begin
				addra_2<=14'd0;
			end
			4'd12:begin
				addra_2<=14'd4096;
			end
			4'd13:begin
				addra_2<=14'd8192;
			end
			default:
			   addra_2 <= 0;
		endcase	
	end	
	else if((count_block_2==4'd3)&&(jump_to_ram3_reg == 1'b1)&&(level==3'd4)&&(read_nen == 1'b0))begin
		addra_2 <= 14'd16128;
	end
	else if((count_block_2==4'd6)&&(read_nen == 1'b0)&&(jump_to_ram3_reg == 1'b1)&&(level==3'd3))begin
		addra_2 <= 14'd15360;
	end
	else if((count_block_2==4'd9)&&(read_nen == 1'b0)&&(jump_to_ram3_reg == 1'b1)&&(level==3'd2))begin
		addra_2 <= 14'd12288;
	end
	else if((count_block_2==4'd12)&&(read_nen == 1'b0)&&(jump_to_ram3_reg == 1'b1)&&(level==3'd1))begin
		addra_2 <= 14'd0;
	end
	else if(read_nen == 1'b0)begin
	    addra_2 <= addra_2_n;
	end
end
 
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    addra_3 <= 14'd16320;
	end
	else if(rst_syn)begin
		addra_3 <= 14'd16320;
	end
	else if(srset==1'b1) begin
	    addra_3 <= 14'd16320;
    end
	else if(halt==1'b1)begin
		addra_3 <= addra_3;
	end
    else if(start_aga_reg_reg&&start_ram3)begin
		case(count_block_3_reg)
				4'd0:begin
					addra_3 <= 14'd16336;
				end
				4'd1:begin
					addra_3 <= 14'd16352;
				end
				4'd2:begin
					addra_3 <= 14'd16128;
				end
				4'd3:begin
					addra_3 <= 14'd16192;
				end
				4'd4:begin
					addra_3 <= 14'd16256;
				end
				4'd5:begin
					addra_3 <= 14'd15360;
				end
				4'd6:begin
					addra_3 <= 14'd15616;
				end
				4'd7:begin
					addra_3 <= 14'd15872;
				end
				4'd8:begin
					addra_3 <= 14'd12288;
				end
				4'd9:begin
					addra_3 <= 14'd13312;
				end
				4'd10:begin
					addra_3 <= 14'd14336;
				end
				4'd11:begin
					addra_3 <= 14'd0;
				end
				4'd12:begin
					addra_3 <= 14'd4096;
				end
				4'd13:begin
					addra_3 <= 14'd8192;
				end
			default:addra_3 <= 0;
		endcase	
	end
	else if((count_block_3==4'd3)&&(read_nen == 1'b0)&&(jump_to_ram4_reg == 1'b1)&&(level==3'd4))begin
		addra_3 <= 14'd16128;
	end
	else if((count_block_3==4'd6)&&(read_nen == 1'b0)&&(jump_to_ram4_reg == 1'b1)&&(level==3'd3))begin
		addra_3 <= 14'd15360;
	end
	else if((count_block_3==4'd9)&&(read_nen == 1'b0)&&(jump_to_ram4_reg == 1'b1)&&(level==3'd2))begin
		addra_3 <= 14'd12288;
	end
	else if((count_block_3==4'd12)&&(read_nen == 1'b0)&&(jump_to_ram4_reg == 1'b1)&&(level==3'd1))begin
		addra_3 <= 14'd0;
	end
	else if(read_nen == 1'b0)begin
	    addra_3 <= addra_3_n;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    addra_4 <= 14'd16320;
	end
	else if(rst_syn)begin
		addra_4 <= 14'd16320;
	end
	else if(srset==1'b1) begin
	    addra_4 <= 14'd16320;
	end
	else if(halt==1'b1)begin
		addra_4 <= addra_4;
	end
	else if(start_aga_reg_reg&&start_ram4)begin
		case(count_block_4_reg)
			4'd0:begin
				addra_4 <=14'd16336;
			end
			4'd1:begin
				addra_4 <=14'd16352;
			end
			4'd2:begin
				addra_4 <=14'd16128;
			end
			4'd3:begin
				addra_4 <=14'd16192;
			end
			4'd4:begin
				addra_4 <=14'd16256;
			end
			4'd5:begin
				addra_4 <=14'd15360;
			end
			4'd6:begin
				addra_4 <=14'd15616;
			end
			4'd7:begin
				addra_4 <=14'd15872;
			end
			4'd8:begin
				addra_4 <=14'd12288;
			end
			4'd9:begin
				addra_4 <=14'd13312;
			end
			4'd10:begin
				addra_4 <=14'd14336;
			end
			4'd11:begin
				addra_4 <=0;
			end
			4'd12:begin
				addra_4 <=14'd4096;
			end
			4'd13:begin
				addra_4 <=14'd8192;
			end
			default:addra_4 <=0;
		endcase	
	end
	
	else if((count_block_4==4'd3)&&(read_nen == 1'b0)&&(jump_to_ram2_reg == 1'b1)&&(level==3'd4))begin
		addra_4 <= 14'd16128;
	end
	else if((count_block_4==4'd6)&&(read_nen == 1'b0)&&(jump_to_ram2_reg == 1'b1)&&(level==3'd3))begin
		addra_4 <= 14'd15360;
	end
	else if((count_block_4==4'd9)&&(read_nen == 1'b0)&&(jump_to_ram2_reg == 1'b1)&&(level==3'd2))begin
		addra_4 <= 14'd12288;
	end
	else if((count_block_4==4'd12)&&(read_nen == 1'b0)&&(jump_to_ram2_reg == 1'b1)&&(level==3'd1))begin
		addra_4 <= 14'd0;
	end
	else if(read_nen == 1'b0)begin
	    addra_4 <= addra_4_n;
	end
end

always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    addra_1 <= 14'b0;
	end
	else if(rst_syn)begin
		addra_1 <= 14'b0;
	end
	else if(srset==1'b1) begin
	    addra_1 <= 14'b0;
	end
	else if(halt==1'b1)begin
		addra_1 <= addra_1;
	end
	//else if(start_aga&&start_ram1)begin
	else if(start_aga_reg_reg&&start_ram1)begin
		case(count_block_1)
			4'd1:begin
				addra_1<=14'd16;
			end
			4'd2:begin
					addra_1<=14'd32;
			end
			default:addra_1 <= 14'b0;
		endcase	
	end	
	else if(read_nen == 1'b0)begin
	    addra_1 <= addra_1_n;
	end
end


always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_2_reg <= 0;
	end
	else if(rst_syn)begin
	   count_block_2_reg <= 0;
	end
	else begin
	    count_block_2_reg <= count_block_2;
	end
end
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_3_reg <= 0;
	end
	else if(rst_syn)begin
	    count_block_3_reg <= 0;	
	end
	else begin
	    count_block_3_reg <= count_block_3;
	end
end
always@(posedge clk_rc or negedge rst) begin
    if(!rst) begin
	    count_block_4_reg <= 0;
	end
	else if(rst_syn)begin
	    count_block_4_reg <= 0;
	end
	else begin
	    count_block_4_reg <= count_block_4;
	end
end


always@(*)begin
		addra_2_n = addra_2;
		addra_3_n = addra_3;
		addra_4_n = addra_4;
		addra_1_n = addra_1;
	if(halt==0)begin	
	case(genaddr_fsm)
		add_sample:begin
			case(level)
				3'b100: begin
				    case({start_ram1,start_ram4,start_ram3,start_ram2})
				                   4'b0001: begin
												addra_2_n = addra_2 + 4;
											end
				                   4'b0010: begin
												addra_3_n = addra_3 + 4;
											end
								   4'b0100: begin
												addra_4_n = addra_4 + 4;
											end
								   4'b1000: begin
												if(count_block_1==4'd3)begin
													addra_1_n = addra_1;			/// addra_1 ²»±ä
												end
												 else begin
													addra_1_n = addra_1 + 4;
												 end
											end		  
								 default:  begin
								                 addra_2_n = addra_2;
												 addra_3_n = addra_3;
												 addra_4_n = addra_4;
												 addra_1_n = addra_1;
				               				end
				    endcase
				end
				3'b011: begin
				    case({start_ram4,start_ram3,start_ram2})
				                   3'b001:    begin
								                 addra_2_n = addra_2 + 8;
											  end
				                   3'b010:    begin
								                 addra_3_n = addra_3 + 8;
											  end
								   3'b100:    begin
								                 addra_4_n = addra_4 + 8;
											  end
								 default:     begin
								                 addra_2_n = addra_2;
												 addra_3_n = addra_3;
												 addra_4_n = addra_4;
				               				  end
				    endcase
				end
				3'b010: begin
				    case({start_ram4,start_ram3,start_ram2})
				                   3'b001:    begin
								                 addra_2_n = addra_2 + 16;
											  end
				                   3'b010:    begin
								                 addra_3_n = addra_3 + 16;
											  end
								   3'b100:    begin
								                 addra_4_n = addra_4 + 16;
											  end
								 default:     begin
								                 addra_2_n = addra_2;
												 addra_3_n = addra_3;
												 addra_4_n = addra_4;
				               				  end
				    endcase
				end
				3'b001: begin
				    case({start_ram4,start_ram3,start_ram2})
				                   3'b001:    begin
								                 addra_2_n = addra_2 + 32;
											  end
				                   3'b010:    begin
								                 addra_3_n = addra_3 + 32;
											  end
								   3'b100:    begin
								                 addra_4_n = addra_4 + 32;
											  end
								 default:     begin
								                 addra_2_n = addra_2;
												 addra_3_n = addra_3;
												 addra_4_n = addra_4;
				          				      end
				     endcase
				end
				3'b000: begin
				   case({start_ram4,start_ram3,start_ram2})
				                   3'b001:    begin
								                 addra_2_n = addra_2 + 64;
											  end
				                   3'b010:    begin
								                 addra_3_n = addra_3 + 64;
											  end
								   3'b100:    begin
								                 addra_4_n = addra_4 + 64;
											  end
								 default:     begin
								                 addra_2_n = addra_2;
												 addra_3_n = addra_3;
												 addra_4_n = addra_4;
				      					      end
				   endcase 						  
				end
				default: begin
				    addra_2_n = addra_2;
					addra_3_n = addra_3;
					addra_4_n = addra_4;
					addra_1_n = addra_1;
				end
			endcase
			
		end
		add_column: begin
			case(level)
				3'b100: begin
					 case({start_ram1,start_ram4,start_ram3,start_ram2})
						  4'b0001:  begin
						             addra_2_n = addra_2 - 12 + 1;
								   end
						  4'b0010:  begin
						             addra_3_n = addra_3 - 12 + 1;
								   end
						  4'b0100:  begin
						             addra_4_n = addra_4 - 12 + 1;
						           end
						  4'b1000:  begin
						             addra_1_n = addra_1 - 12 + 1;
						           end
								   
						 default:	begin
							          addra_2_n = addra_2;
									  addra_3_n = addra_3;
									  addra_4_n = addra_4;
									  addra_1_n = addra_1;
						   			end
					  endcase				
				end
				3'b011: begin
					case({start_ram4,start_ram3,start_ram2})
					     3'b001:  begin
					                addra_2_n = addra_2 - 24 + 1;	
								   end
						  3'b010:  begin
					                addra_3_n = addra_3 - 24 + 1;
								   end
						  3'b100:  begin
						             addra_4_n = addra_4 - 24 + 1;
					              end
					    default:	begin
							          addra_2_n = addra_2;
									  addra_3_n = addra_3;
									  addra_4_n = addra_4;
					      			end
					endcase
				end
				3'b010: begin
					 case({start_ram4,start_ram3,start_ram2})
					      3'b001:  begin
					                 addra_2_n = addra_2 - 48 + 1;	
								   end	
						  3'b010:  begin	
					                 addra_3_n = addra_3 - 48 + 1;	
								   end	
						  3'b100:  begin	
						             addra_4_n = addra_4 - 48 + 1;	
					               end	
					     default:	begin	
							          addra_2_n = addra_2;	
									  addra_3_n = addra_3;	
									  addra_4_n = addra_4;	
					       			end	
					 endcase											
				end
				3'b001: begin
					 case({start_ram4,start_ram3,start_ram2})
					      3'b001:  begin
					                 addra_2_n = addra_2 - 96 + 1;	
								   end
						  3'b010:  begin
					                 addra_3_n = addra_3 - 96 + 1;
								   end
						  3'b100:  begin
						             addra_4_n = addra_4 - 96 + 1;
					               end
					     default:	begin
							          addra_2_n = addra_2;
									  addra_3_n = addra_3;
									  addra_4_n = addra_4;
					       			end
					 endcase										
				end
				3'b000: begin
					 case({start_ram4,start_ram3,start_ram2})
					      3'b001:  begin
					                 addra_2_n = addra_2 - 192 + 1;	
								   end
						  3'b010:  begin
					                 addra_3_n = addra_3 - 192 + 1;
								   end
						  3'b100:  begin
						             addra_4_n = addra_4 - 192 + 1;
					               end
					     default:	begin
							          addra_2_n = addra_2;
									  addra_3_n = addra_3;
									  addra_4_n = addra_4;
					       			end
					 endcase										
				end
				default: begin
					addra_2_n = addra_2;
					addra_3_n = addra_3;
					addra_4_n = addra_4;
					addra_1_n = addra_1;
				end
			endcase	
		end
		add_stripe:begin
			case(level)
					3'b100: begin
						case({start_ram1,start_ram4,start_ram3,start_ram2})
							4'b0001: begin
										addra_2_n = addra_2 + 1;
									end
							4'b0010: begin
										addra_3_n = addra_3 + 1;
									end
							4'b0100: begin
										addra_4_n = addra_4 + 1;
									end
							4'b1000: begin
										addra_1_n = addra_1 + 1;
									end
							default: begin
									addra_2_n = addra_2;
									addra_3_n = addra_3;
									addra_4_n = addra_4;
									addra_1_n = addra_1;
							end
						endcase
		            end
					3'b000,3'b001,3'b010,3'b011: begin
					      case({start_ram4,start_ram3,start_ram2})
						      3'b001:begin
										addra_2_n = addra_2 + 1;
									end
							  3'b010:begin
										addra_3_n = addra_3 + 1;
									end	
                              3'b100:begin
										addra_4_n = addra_4 + 1;
									end
                              default: begin
								  addra_2_n = addra_2;
								  addra_3_n = addra_3;
								  addra_4_n = addra_4;
                              end
						  endcase 
                    end
					default: begin
					    addra_2_n = addra_2;
					    addra_3_n = addra_3;
						addra_4_n = addra_4;
	                	addra_1_n = addra_1;
					end
			endcase		
		end
		add_bp: begin
			case(level)
				3'b100:begin
							case({start_ram4,start_ram3,start_ram2,start_ram1})	
								4'b0001:begin
										addra_1_n = addra_1 - 15;
									end
								4'b0010:begin
										addra_2_n = addra_2 - 15;
									end
								4'b0100:begin
										addra_3_n = addra_3 - 15;
									end	
								4'b1000:begin
										addra_4_n = addra_4 - 15;
									end
								default: begin
									addra_2_n = addra_2;
									addra_3_n = addra_3;
									addra_4_n = addra_4;
								end
							endcase	
						end
				3'b011:begin
							case({start_ram4,start_ram3,start_ram2})	
								3'b001:begin
										addra_2_n = addra_2 - 63;
									end
								3'b010:begin
										addra_3_n = addra_3 - 63;
									end	
								3'b100:begin
										addra_4_n = addra_4 - 63;
									end
								default: begin
									addra_2_n = addra_2;
									addra_3_n = addra_3;
									addra_4_n = addra_4;
								end
							endcase
						end	
				3'b010:begin
							case({start_ram4,start_ram3,start_ram2})	
								3'b001:begin
										addra_2_n = addra_2 - 255;
									end
								3'b010:begin
										addra_3_n = addra_3 - 255;
									end	
								3'b100:begin
										addra_4_n = addra_4 - 255;
									end
								default: begin
									addra_2_n = addra_2;
									addra_3_n = addra_3;
									addra_4_n = addra_4;
								end
							endcase
						end	
				3'b001:begin
							case({start_ram4,start_ram3,start_ram2})	
								3'b001:begin
										addra_2_n = addra_2 - 1023;
									end
								3'b010:begin
										addra_3_n = addra_3 - 1023;
									end	
								3'b100:begin
										addra_4_n = addra_4 - 1023;
									end
								default: begin
											addra_2_n = addra_2;
											addra_3_n = addra_3;
											addra_4_n = addra_4;
								   		  end
							endcase
					   end
				3'b000:begin
							case({start_ram4,start_ram3,start_ram2})	
								3'b001:begin
										addra_2_n = addra_2 - 4095;
									end
								3'b010:begin
										addra_3_n = addra_3 - 4095;
									end	
								3'b100:begin
										addra_4_n = addra_4 - 4095;
									end
								default: begin
											addra_2_n = addra_2;
											addra_3_n = addra_3;
											addra_4_n = addra_4;
										  end
							endcase
					   end	
				default: begin
							addra_2_n = addra_2;
							addra_3_n = addra_3;
							addra_4_n = addra_4;
							addra_1_n = addra_1;
						  end
			endcase
		end
	
		add_block: begin
			case(level)
				3'b000,3'b001,3'b010,3'b011,3'b100: begin
					case({start_ram4,start_ram3,start_ram2,start_ram1}) 
						4'b0001: begin
									addra_1_n = addra_1 + 1;
								 end
						4'b0010: begin
									addra_2_n = addra_2 + 1;
								 end
						4'b0100: begin
									 addra_3_n = addra_3 + 1;
								 end
						4'b1000: begin
									addra_4_n = addra_4 + 1;
								 end
						default: begin
							addra_2_n = addra_2;
							addra_3_n = addra_3;
							addra_4_n = addra_4;
							addra_1_n = addra_1;
						end
					endcase
				end
				default: begin
							addra_2_n = addra_2;
							addra_3_n = addra_3;
							addra_4_n = addra_4;
							addra_1_n = addra_1;
						end
			endcase
		end			
	endcase
	end
	else begin
		addra_2_n = addra_2_n;
		addra_3_n = addra_3_n;
		addra_4_n = addra_4_n;
		addra_1_n = addra_1_n;
	end	
end		

///****************************************    ************************************///			
	
always@(posedge clk_rc or negedge rst) 
begin
    if(!rst) 
	begin	
	    genaddr_fsm <= idle;	
	end	
    else if(rst_syn)
	begin
		genaddr_fsm <= idle;
	end
	else if(read_nen == 1'b0)
	begin	
	    genaddr_fsm <= genaddr_fsm_n;	
	end
end

assign srst = (genaddr_fsm == idle);
assign srset = (genaddr_fsm == idle_for_srset);


always@(*)begin
	genaddr_fsm_n = genaddr_fsm;
	case(genaddr_fsm)
				  idle: begin
							if(bpc_start == 1'b1)begin
								genaddr_fsm_n = add_sample;
							end
						end
			add_sample: begin
							if(code_over == 1'b1)begin
								genaddr_fsm_n = idle_for_srset;
							end
							else begin
								case({column_over,stripe_over,(block_over&&(!bp_end_jump)),(block_over&&bp_end_jump)})
									4'b1000: genaddr_fsm_n = add_column;
									4'b1100: genaddr_fsm_n = add_stripe;
									4'b1110: genaddr_fsm_n = add_bp;
									4'b1101: genaddr_fsm_n = add_block;
									default: genaddr_fsm_n = genaddr_fsm;
								endcase
							end
						end
			add_column:	begin
							genaddr_fsm_n = add_sample;
						end
			add_stripe:	begin
							genaddr_fsm_n = add_sample;
						end
			add_bp:		begin
							genaddr_fsm_n = add_sample;
						end
			add_block:	begin
							genaddr_fsm_n = add_sample;
						end
		idle_for_srset: begin
							if(count_code_over == 5) begin
								genaddr_fsm_n = idle;
							end
							else begin
								genaddr_fsm_n = idle_for_srset;
							end
						end
		default:begin
			genaddr_fsm_n = genaddr_fsm;
		end
	endcase
end			
		
///*********************************    ***********************************///					
always @(posedge clk_rc or negedge rst) begin
  if(!rst)
    fsm_read_ram <= ram_idle;
  else if(rst_syn)
	fsm_read_ram <= ram_idle;
  else 
    fsm_read_ram <= fsm_read_ram_n;
end			
				
always@(*) begin
    fsm_read_ram_n = fsm_read_ram;
	case(fsm_read_ram)
	  ram_idle:  begin
	               if(bpc_start==1'b1) begin
                     fsm_read_ram_n = ram1_read;
				   end
				   else fsm_read_ram_n = ram_idle;
			     end
	  ram1_read: begin
	               if((jump_to_ram2_reg==1'b1)&&(relate_block_fsm ==1'b0)) begin
                     fsm_read_ram_n = ram2_read;
				   end
				   else fsm_read_ram_n = ram1_read;
			     end
	  ram2_read: begin
	               if((jump_to_ram3_reg==1'b1)&&(relate_block_fsm ==1'b0)) begin
                     fsm_read_ram_n = ram3_read;
				   end
				   else fsm_read_ram_n = ram2_read;
			     end
	  ram3_read: begin
                   if((jump_to_ram4_reg==1'b1)&&(relate_block_fsm ==1'b0)) begin
				     fsm_read_ram_n = ram4_read;
				   end
                   else fsm_read_ram_n = ram3_read;				 
				 end
	  ram4_read: begin
	                if((jump_to_ram2_reg==1'b1)&&(relate_block_fsm ==1'b0)) begin
						fsm_read_ram_n = ram2_read;
				    end
					else if(code_over == 1'b1)begin
						fsm_read_ram_n = ram_idle;
					end
				    else begin
						fsm_read_ram_n = ram4_read;
					end
				 end 
	  default:   begin
	               fsm_read_ram_n = 3'b111;
				  end
	endcase
end			

always @(posedge clk_rc or negedge rst) begin
  if(!rst)
    fsm_addr_stay <= normal;
  else if(rst_syn)
	 fsm_addr_stay <= normal;
  else 
    fsm_addr_stay <= fsm_addr_stay_n;
end	
always@(*)begin
	fsm_addr_stay_n=fsm_addr_stay;
	case(fsm_addr_stay)
		normal:begin
					if(start_ram2&&bpc_halt)
						fsm_addr_stay_n=addr2_stay;
					else if(start_ram3&&bpc_halt)
						fsm_addr_stay_n=addr3_stay;
					else if(start_ram4&&bpc_halt)
						fsm_addr_stay_n=addr4_stay;
					else if(start_ram1&&bpc_halt&&(count_block_1!=2'b10))
						fsm_addr_stay_n=addr1_stay;
					else if(start_ram1&&bpc_halt&&(count_block_1==2'b10))	
						fsm_addr_stay_n=addr2_stay;
					else 
						fsm_addr_stay_n=normal;
				end	
		addr1_stay:	begin
						if(start_aga)
							fsm_addr_stay_n=normal;
						else 
							fsm_addr_stay_n=addr1_stay;
					end
		addr2_stay:	begin
						if(start_aga)
							fsm_addr_stay_n=normal;
						else 
							fsm_addr_stay_n=addr2_stay;
					end
		addr3_stay:	begin
						if(start_aga)
							fsm_addr_stay_n=normal;
						else 
							fsm_addr_stay_n=addr3_stay;
					end
		addr4_stay:	begin
						if(start_aga)
							fsm_addr_stay_n=normal;
						else 
							fsm_addr_stay_n=addr4_stay;
					end
		default:fsm_addr_stay_n=normal;
	endcase	
end

assign halt_ram1=(fsm_addr_stay==addr1_stay)?1'b1:1'b0;
assign halt_ram2=(fsm_addr_stay==addr2_stay)?1'b1:1'b0;
assign halt_ram3=(fsm_addr_stay==addr3_stay)?1'b1:1'b0;
assign halt_ram4=(fsm_addr_stay==addr4_stay)?1'b1:1'b0;
assign halt=(level_delay!=3'b111)?(halt_ram1|halt_ram2|halt_ram3|halt_ram4):1'b0;

always@(posedge clk_rc or negedge rst) begin
	  if(!rst) begin
	    halt_reg <= 2'b0;
		halt_reg_2 <= 2'b0;
		halt_reg_3 <= 2'b0;
	  end
	  else if(rst_syn)begin
		halt_reg <= 2'b0;
	    halt_reg_2 <= 2'b0;
	    halt_reg_3 <= 2'b0;
	  end
	  else begin
		halt_reg<=halt;
		halt_reg_2<=halt_reg;
		halt_reg_3<=halt_reg_2;
	  end
end
assign halt_to_fifo= ((halt_reg_2==1'b1)&&(halt_reg_3==1'b0))?1'b1:1'b0;
 
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		count_YUV<=2'b0;
	end
	else if(rst_syn)begin
		count_YUV<=2'b0;
	end
	else if(read_nen == 1'b0)begin
		count_YUV<=count_YUV_n;
	end
end

always@(*)begin
	case({start_ram1,start_ram4,start_ram3,start_ram2})
	     4'b0001:  begin
               		if((count_block_2==0)||(count_block_2==3)||(count_block_2==6)||(count_block_2==9)||(count_block_2==12))begin
	                  count_YUV_n=2'b00;
	                end
	                else if((count_block_2==1)||(count_block_2==4)||(count_block_2==7)||(count_block_2==10)||(count_block_2==13))begin
	                  count_YUV_n=2'b01;
	                end
	                else if((count_block_2==2)||(count_block_2==5)||(count_block_2==8)||(count_block_2==11)||(count_block_2==14))begin
	                  count_YUV_n=2'b10;
                    end
					else begin
						count_YUV_n=2'b11;
					end
				  end
	     4'b0010:  begin
               		if((count_block_3==0)||(count_block_3==3)||(count_block_3==6)||(count_block_3==9)||(count_block_3==12))begin
	                  count_YUV_n=2'b00;
	                end
	                else if((count_block_3==1)||(count_block_3==4)||(count_block_3==7)||(count_block_3==10)||(count_block_3==13))begin
	                  count_YUV_n=2'b01;
	                end
	                else if((count_block_3==2)||(count_block_3==5)||(count_block_3==8)||(count_block_3==11)||(count_block_3==14))begin
	                  count_YUV_n=2'b10;
                    end
					else begin
						count_YUV_n=2'b11;
					end
				  end
	     4'b0100:  begin
               		if((count_block_4==0)||(count_block_4==3)||(count_block_4==6)||(count_block_4==9)||(count_block_4==12))begin
	                  count_YUV_n=2'b00;
	                end
	                else if((count_block_4==1)||(count_block_4==4)||(count_block_4==7)||(count_block_4==10)||(count_block_4==13))begin
	                  count_YUV_n=2'b01;
	                end
	                else if((count_block_4==2)||(count_block_4==5)||(count_block_4==8)||(count_block_4==11)||(count_block_4==14))begin
	                  count_YUV_n=2'b10;
                    end
					else begin
						count_YUV_n=2'b11;
					end
				  end
		4'b1000:  begin
               		if(count_block_1==0)begin
	                  count_YUV_n=2'b00;
	                end
	                else if(count_block_1==1)begin
	                  count_YUV_n=2'b01;
	                end
	                else if(count_block_1==2)begin
	                  count_YUV_n=2'b10;
                    end
					else begin
						count_YUV_n=2'b11;
					end
				  end		  
	  
	     default:  begin
						count_YUV_n=2'b11;
					end
	endcase	
end	
always@(posedge clk_rc or negedge rst) begin
	  if(!rst) begin
	    band <= 2'b0;
	  end
	  else if(rst_syn)begin
		band <= 2'b0;
	  end
	  else if(read_nen == 1'b0) begin
	    band <= band_n;
	  end
end 

always@(*)begin
	 band_n = band;
    case({start_ram1,start_ram4,start_ram3,start_ram2})
	    4'b0001:    begin
                    // band_n = 2'b10;		/// ram2 LH
					band_n = 2'b01;
                   end
        4'b0010:    begin
                     //band_n = 2'b01;		/// ram3 HL
					 band_n = 2'b10;
                   end	
        4'b0100:    begin
                     band_n = 2'b11;		/// ram4 HH
                   end	
		4'b1000:    begin
                     band_n = 2'b00;		/// ram1 LL
                   end	   
		default:   begin
                     band_n = 2'b00;
                   end
    endcase
end

wire jump_to_ram_234=((jump_to_ram2)||(jump_to_ram3)||(jump_to_ram4));

always @(posedge clk_rc or negedge rst) begin
	if(!rst)
		jump_to_ram2_reg <= 0;
	else if(rst_syn)
		jump_to_ram2_reg <= 0;
	else if(jump_to_ram2)begin
			jump_to_ram2_reg <= 1'b1;
		end
	else if((relate_block_fsm==1'b0)&&(count_relate_block==296))begin
		jump_to_ram2_reg <= 1'b0;
	end
	else if(jump_to_ram_234)begin
		jump_to_ram2_reg <= 1'b0;
	end
end	
always @(posedge clk_rc or negedge rst) begin
	if(!rst)
		jump_to_ram3_reg <= 0;
	else if(rst_syn)
		jump_to_ram3_reg <= 0;
	else if(jump_to_ram3)begin
			jump_to_ram3_reg <= 1'b1;
		end
	else if((relate_block_fsm==1'b0)&&(count_relate_block==296))begin
		jump_to_ram3_reg <= 1'b0;
	end
	else if(jump_to_ram_234)begin
		jump_to_ram3_reg <= 1'b0;
	end
end	
always @(posedge clk_rc or negedge rst) begin
	if(!rst)
		jump_to_ram4_reg <= 0;
	else if(rst_syn)
		jump_to_ram4_reg <= 0;	
	else if(jump_to_ram4)begin
			jump_to_ram4_reg <= 1'b1;
		end
	else if((relate_block_fsm==1'b0)&&(count_relate_block==296))begin
		jump_to_ram4_reg <= 1'b0;
	end
	else if(jump_to_ram_234)begin
		jump_to_ram4_reg <= 1'b0;
	end
end	


always @(posedge clk_rc or negedge rst) begin
	if(!rst) begin  
		start_aga_reg_reg<=0;
		start_aga_reg_reg1<=0;
		start_aga_reg_reg2<=0;
	end
	else if(rst_syn)begin
		start_aga_reg_reg<=0;
	    start_aga_reg_reg1<=0;
	    start_aga_reg_reg2<=0;
	end
	else begin
		start_aga_reg_reg<=start_aga;
		start_aga_reg_reg1<=start_aga_reg_reg;
		start_aga_reg_reg2<=start_aga_reg_reg1;
	end
end

reg [1:0]fsm_jump;
reg [1:0]fsm_jump_n;

parameter S_0=2'b00;
parameter delete_bp=2'b01;
parameter next_block=2'b10;


always @(posedge clk_rc or negedge rst) begin
  if(!rst)
    fsm_jump <= delete_bp;
  else if(rst_syn)
	fsm_jump <= delete_bp;	
  else 
    fsm_jump <= fsm_jump_n;
end	
always@(*)begin
	fsm_jump_n=fsm_jump;
	case(fsm_jump)
		delete_bp:	if(block_all_bp_over)
						fsm_jump_n=next_block;
					else 
						fsm_jump_n=delete_bp;
		next_block:	if(flush_over)
						fsm_jump_n=delete_bp;
					else 
						fsm_jump_n=next_block;
		default:fsm_jump_n=delete_bp;
	endcase
end

assign bp_end_jump=((block_all_bp_over==1'b1)&&(count_relate_block==0))?1'b1:1'b0;
assign block_all_bp_over=(count_bp==5)?1'b1:1'b0;	
wire bp_renom_delay=((delay_count_bp==1'b1)&&(count_relate_block==0))?1'b1:1'b0;
reg bp_renom_delay_reg;



always @(posedge clk_rc or negedge rst) begin
  if(!rst)
    count_bp <= 0;
  else if(rst_syn)
	count_bp <= 0;	
  else 
    count_bp <= count_bp_n;
end	


reg [3:0]count_bp_to_genere;
reg [3:0]count_bp_register;
always@(posedge clk_rc or negedge rst)
	begin
		if(!rst)
			count_bp_register<=0;
		else
			count_bp_register<=count_bp;
	end

wire cb_eq_cbreg=(count_bp_register==count_bp)?1'b1:1'b0;

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		count_bp_to_genere<=0;
	end
	else if((count_clk_rc==0)&&(cb_eq_cbreg==1'b0))begin
		count_bp_to_genere<=count_bp;
	end
	else if((count_clk_rc==0)&&(cb_eq_cbreg==1'b1))begin
		count_bp_to_genere<=count_bp_n;
	end
end


always@(*)begin
	count_bp_n=count_bp;
	if(start_aga_reg_reg2)begin
		count_bp_n=top_plane;
	end
	else if(bpc_start_for_bpcount3==1'b1)begin
		count_bp_n=top_plane;
	end
	else if(fsm_jump==delete_bp)begin
		if(bp_renom_delay_reg==1'b1)begin
			count_bp_n=count_bp_n-1'b1;
		end
		else begin
			count_bp_n=count_bp_n;
		end
	end	
	else if(fsm_jump==next_block)begin
		if(bp_renom_delay_reg==1'b1)begin
			count_bp_n=top_plane;
		end
		else begin
			count_bp_n=count_bp_n;
		end
	end	
	else begin
		count_bp_n=count_bp_n;
	end
end
 	

always @(posedge clk_rc or negedge rst) begin
	if(!rst)
		bp_renom_delay_reg <= 0;
	else if(rst_syn)
		bp_renom_delay_reg <= 0;
	else 
		bp_renom_delay_reg <= bp_renom_delay;
end	

always @(posedge clk_rc or negedge rst) begin
	if(!rst)
		delay_count_bp <= 0;
	else if(rst_syn)
		delay_count_bp <= 0;		
	else if(flush_over)begin
		delay_count_bp <= 1'b1;
	end	
	else if(count_relate_block==0)begin
		delay_count_bp <= 1'b0;
	end	
	else 
		delay_count_bp<=delay_count_bp;
end	


always@(posedge clk_rc or negedge rst) begin
	if(!rst)begin
		count_clk_rc<=0;
	end
	else if(rst_syn)begin
		count_clk_rc<=0;
	end
	else if(clk_sg==1'b0)begin
		count_clk_rc<=0;
	end
	else if(clk_sg==1'b1) begin
		count_clk_rc<=count_clk_rc+1'b1;
	end
end


reg start_aga_song_reg;
reg [2:0]plus_halt;
reg [2:0]plus_start;
wire bpc_halt_n_1;

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		start_aga_song_reg=1'b0;
	end
	else if(rst_syn)begin
		start_aga_song_reg=1'b0;
	end	
	else if(start_aga_song==1'b1)begin
			start_aga_song_reg=1'b1;
	end
	else if(plus_start==4)begin
		start_aga_song_reg=1'b0;
	end
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		plus_start<=0;
	end
	else if(rst_syn)begin
		plus_start<=0;
	end
	else if(start_aga_song==1'b1)begin
		if(count_clk_rc==2'd1)begin
			plus_start<=5;
		end
		else begin
			plus_start<=1;
		end
	end
	else begin
		plus_start<=plus_start+1;
	end
end
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		plus_halt<=0;
	end
	else if(rst_syn)begin
		plus_halt<=0;
	end
	 else if(bpc_halt_n_1)begin
		if(count_clk_rc==2'd2)begin
			plus_halt<=5;
		end
		else begin
			plus_halt<=1;
		end
	end 
	else begin
		plus_halt<=plus_halt+1;
	end
end
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		bpc_halt_n_n<=1'b0;
	end
	else if(rst_syn)begin
		bpc_halt_n_n<=0;
	end
	else if(bpc_halt_n_1==1'b1)begin
			bpc_halt_n_n<=1'b1;
	end
	else if(plus_halt==4)begin
		bpc_halt_n_n<=1'b0;
	end
end

//assign bpc_halt=(count_clk_rc==2'd2)?bpc_halt_n_n:0;
//assign start_aga=(count_clk_rc==2'd0)?start_aga_song_reg:0;

assign bpc_halt=((count_clk_rc==2'd0)&&(clk_sg==1))?bpc_halt_n_n:0;
assign start_aga=((count_clk_rc==2'd2)&&(clk_sg==0))?start_aga_song_reg:0;


assign nen=((read_nen)||(read_nen_delay));
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		bpc_halt_reg<=0;
	end
	else if(rst_syn)begin
		bpc_halt_reg<=0;
	end
	else if(count_bp!=5)begin
		if(nen==1'b1)begin
			if(bpc_halt_T2==1'b1)begin
				bpc_halt_reg<=1;
			end
		end
		else if(nen==1'b0)begin
			bpc_halt_reg<=0;
		end
	end	
	else begin
		bpc_halt_reg<=0;
	end
end
assign bpc_halt_before=((nen==1'b0)&&(bpc_halt_reg==1'b1))?1'b1:1'b0;
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		bpc_halt_n<=0;
	end
	else if(rst_syn)begin
		bpc_halt_n<=0;	
	end	
	else if(nen==1'b0)begin
		bpc_halt_n<=(bpc_halt_T2||bpc_halt_before);
	end
end

//*******************************************//
wire band_unequ_band_n=(band!=band_n)?1'b1:1'b0;
reg band_unequ_band;

always@(posedge clk_rc or negedge rst) begin
	  if(!rst) begin
	    band_unequ_band <= 0;
	  end
	  else if(rst_syn)begin
		band_unequ_band <= 0;
	  end
	  else begin
	    band_unequ_band <= band_unequ_band_n;
	  end
end
reg count_bp_below_4;
reg count_bp_below_4_reg;
always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		count_bp_below_4_reg<=0;
	end
	else if(rst_syn)begin
		count_bp_below_4_reg<=0;
	end
	else begin
		count_bp_below_4_reg<=count_bp_below_4;
	end
end

always@(posedge clk_rc or negedge rst)begin
	if(!rst)begin
		count_bp_below_4<=1'b0;
	end
	else if(rst_syn)begin
		count_bp_below_4<=1'b0;
	end
	else if((band_unequ_band==1'b1)&&(top_plane<=4))begin
		count_bp_below_4<=1'b1;
	end
	else begin
		count_bp_below_4<=1'b0;
	end
end

wire count_bp_below_4_reg_n=((count_bp_below_4==1'b1)&&(count_bp_below_4_reg==1'b0));
assign bpc_halt_n_1=(bpc_halt_n||count_bp_below_4_reg_n);
//********************************************************************************************************//

reg [3:0]top_bp_band;
reg [3:0] zero_bp_count;

always @(*) begin
  case(level)
   3'b000,3'b001:  begin
                    top_bp_band=10;
				   end
   3'b010:         begin
                    top_bp_band=12;
				   end
   3'b011:         begin
                    top_bp_band=13;
				   end
   3'b100,3'b101:  begin
                    top_bp_band=14;
				   end	
   default:        begin
                    top_bp_band=0;
				   end
		
  endcase
end  
 always @(*)
	begin
		zero_bp_count=top_bp_band - top_plane+3;
	end

endmodule 
