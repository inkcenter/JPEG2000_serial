`timescale 1ns/10ps
module mmu(//out
			dina_64,
			dina_1,
			dina_2,	
			dina_3,
			dina_4,
			addra_64,
			addrb_64,
			addra_1,
			addrb_1,
			addra_2,
			addra_3,
			addra_4,
			wea_64,
			web_64,
			wea_1,
			web_1,
			wea_2,
			wea_3,
			wea_4,
			ena_64,
		    enb_64,
		    ena_1,
		    enb_1,
			ena_2,
			ena_3,
			ena_4,
			odd_data,
			even_data,
			start_cf,
			level,	
			ce0_ctrl,
			unvalid_cnt,
			dwt_work,
			wr_over,
			Y_U_V_over,
	//input		
			bpc_start,
			douta_64,
			doutb_64,
			douta_1,
			doutb_1,
			quant_out_l,
			quant_out_h,
			quant_out_vld,
			start,
			clk_mmu,
			rst,
			rst_syn);
			
			
output dwt_work;
output start_cf;			
output [2:0]level;
output [15:0] odd_data;
output [15:0] even_data;
output [1:0]unvalid_cnt;
output ce0_ctrl;
output [1:0]wr_over;
output [1:0]Y_U_V_over;
output 	[16:0]dina_1;			
output 	[16:0]dina_64;				
output 	[16:0]dina_2;			
output 	[16:0]dina_3;
output [16:0]dina_4;					
output [11:0]addra_64;
output [11:0]addrb_64;
output [13:0]addra_1;
output [13:0]addrb_1; 
output [13:0]addra_2;			
output [13:0]addra_3;
output [13:0]addra_4;
output wea_64;
output web_64;
output wea_1;
output web_1;				
output wea_2;				
output wea_3;
output wea_4;										
output ena_64;
output enb_64;
output ena_1;
output enb_1;
output ena_2; 
output ena_3;
output ena_4;

input [16:0]quant_out_l;
input [16:0]quant_out_h;
input quant_out_vld;
input start;
input bpc_start;
input clk_mmu;
input rst;	
input rst_syn;		
input [16:0]douta_64;
input [16:0]doutb_64;					
input [16:0]douta_1;
input [16:0]doutb_1;

parameter idle=3'b000; 
parameter cal0=3'b001; 
parameter cal1=3'b010; 
parameter cal2=3'b011;
parameter cal3=3'b100;
parameter cal4=3'b101;

reg [11:0]addra_64;
reg [11:0]addrb_64;
reg [13:0]addra_1;
reg [13:0]addrb_1;
reg [13:0]addra_2;
reg [13:0]addra_3;
reg	[13:0]addra_4;
reg [13:0]addra_2_n;
reg [13:0]addra_3_n;
reg [13:0]addra_4_n;

wire web_64;
wire web_1; 
reg  wea_64;
reg  wea_1;
reg  wea_2;
reg  wea_3;
reg  wea_4;
reg ena_64;
reg enb_64;
reg ena_1;
reg enb_1;
reg ena_2;
reg ena_3;
reg ena_4;

wire dwt_over;
wire srst;
wire [1:0]Y_U_V_over;

reg dwt_work;
reg [1:0]wr_over;
reg [2:0]level;
reg [2:0]level_reg;
reg [2:0]level_delay;
reg [2:0]level_delay_1;
reg ce0_ctrl;
reg start_cf;
reg start_cf_pre;
reg inc_addr_cnt;
reg quant_out_vld_reg;
reg [1:0]unvalid_cnt;
reg [1:0]unvalid_cnt_n;
reg [15:0] odd_data;
reg [15:0] even_data;
reg [2:0]fsm_mmu;
reg [2:0]fsm_mmu_n;
reg [1:0]Y_U_V_over_1;
reg [1:0]Y_U_V_over_2;

assign srst = (fsm_mmu == idle);
assign	dwt_over=(addra_4==16367)?1'b1:1'b0;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dwt_work<=0;
	end
	else if(rst_syn)begin
		dwt_work<=0;
	end
	else if(level!=3'b111)begin
		dwt_work<=1'b1;
	end
	else if(dwt_over==1'b1)begin
		dwt_work<=0;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)
		fsm_mmu<= idle;
	else if(rst_syn)
		fsm_mmu<= idle;
	else 
		fsm_mmu<= fsm_mmu_n; 
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wr_over<=2'b0;
	end
	else if(rst_syn)begin
		wr_over<=2'b0;
	end
	else begin
		case(level)
			3'b000:	begin  
				if((addra_2 == 4095)&&(addra_2_n == 4095))begin
					wr_over<=2'b01;
				end
				else if((addra_2 == 8191)&&(addra_2_n == 8191))begin
					wr_over<=2'b10;
				end
				else if((addra_2 == 12287)&&(addra_2_n == 12287))begin
					wr_over<=2'b11;
				end
				else begin
					wr_over<=2'b00;
				end
			end
			3'b001:	begin
					if((addra_2_n == 13311)&&(addra_2 == 13311 ))begin  //1023
					wr_over<=2'b01;
				end
				else if((addra_2_n == 14335)&&(addra_2 == 14335 ))begin  //2047
					wr_over<=2'b10;
				end
				else if((addra_2_n == 15359)&&(addra_2 == 15359 ))begin  //3071
					wr_over<=2'b11;
				end
				else begin
					wr_over<=2'b00;
				end
			end
			3'b010:	begin
					if((addra_2_n == 15615)&&(addra_2 == 15615))begin  //255
					wr_over<=2'b01;
				end
				else if((addra_2_n == 15871)&&(addra_2 == 15871))begin  //511
					wr_over<=2'b10;
				end
				else if((addra_2_n == 16127)&&(addra_2 == 16127))begin  //767
					wr_over<=2'b11;
				end
				else begin
					wr_over<=2'b00;
				end
			end
			3'b011:	begin
					if((addra_2_n == 16191)&&(addra_2 == 16191))begin  //63
					wr_over<=2'b01;
				end
				else if((addra_2_n == 16255)&&(addra_2 == 16255))begin  //127
					wr_over<=2'b10;
				end
				else if((addra_2_n == 16319)&&(addra_2 == 16319))begin  //191
					wr_over<=2'b11;
				end
				else begin
					wr_over<=2'b00;
				end	
			end
			3'b100:	begin
				if((addra_2_n == 16335)&&(addra_2 == 16335))begin  //15
					wr_over<=2'b01;
				end
				else if((addra_2_n == 16351)&&(addra_2 == 16351))begin  //31
					wr_over<=2'b10;
				end
				else if((addra_2_n == 16367)&&(addra_2 == 16367))begin  //47
					wr_over<=2'b11;
				end
				else begin
					wr_over<=2'b00;
				end
			end
		endcase
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		level<=3'b111;
	end
	else if(rst_syn)begin
		level<=3'b111;
	end
	else if(start == 1'b1)begin
		level<=3'b000;
	end
	else if(srst == 1'b1)begin
		level<=3'b111;
	end
	
	else if((level == 0)&&(wr_over == 2'b11))begin
		level<=3'b001;
	end
	else if((level == 1)&&(wr_over == 2'b11))begin
		level<=3'b010;
	end
	else if((level == 2)&&(wr_over == 2'b11))begin
		level<=3'b011;
	end
	else if((level == 3)&&(wr_over == 2'b11))begin
		level<=3'b100;
	end	
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		level_reg<=3'b111;
	end
	else if(rst_syn)begin
		level_reg<=3'b111;
	end
	else begin
		level_reg<=level;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		level_delay<=3'b111;
		level_delay_1<=3'b111;
	end
	else if(rst_syn)begin
		level_delay<=3'b111;
	    level_delay_1<=3'b111;
	end
	else begin
		level_delay<=level;
		level_delay_1<=level_delay;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		start_cf<=0;
	end
	else if(rst_syn)begin
		start_cf<=0;
	end
	else begin
		case(level)
			3'b000: begin
				if((level_delay == 3'b000)&&(level_delay_1==3'b111))begin
					start_cf<=1'b1;
				end
				else if((addra_1 == 4089)&&(ce0_ctrl == 1'b0))begin
					start_cf<=1'b1;
				end
				else if((addra_1 == 8185)&&(ce0_ctrl == 1'b0))begin
					start_cf<=1'b1;
				end
				else begin
					start_cf<=1'b0;
				end		
			end
			3'b001: begin
				if((level_delay == 3'b001)&&(level_delay_1==3'b000))begin
					start_cf<=1'b1;
				end
				else if((addra_64 == 1017)&&(ce0_ctrl == 1'b1))begin
					start_cf<=1'b1;
				end
				else if((addra_64 == 2041)&&(ce0_ctrl == 1'b1))begin
					start_cf<=1'b1;
				end
				else begin
					start_cf<=1'b0;
				end	
			end
			3'b010: begin
				if((level_delay == 3'b010)&&(level_delay_1==3'b001))begin
						start_cf<=1'b1;
					end
					else if((addra_1 == 249)&&(ce0_ctrl == 1'b0))begin
						start_cf<=1'b1;
					end
					else if((addra_1 == 505)&&(ce0_ctrl == 1'b0))begin
						start_cf<=1'b1;
					end
					else begin
						start_cf<=1'b0;
					end	
			end
			3'b011: begin
				if((level_delay == 3'b011)&&(level_delay_1==3'b010))begin
					start_cf<=1'b1;
				end
				else if((addra_64 == 57)&&(ce0_ctrl == 1'b1))begin
					start_cf<=1'b1;
				end
				else if((addra_64 == 121)&&(ce0_ctrl ==1'b1))begin
					start_cf<=1'b1;
				end
				else begin
					start_cf<=1'b0;
				end		
			end
			3'b100: begin
				if((level_delay == 3'b100)&&(level_delay_1==3'b011))begin
					start_cf<=1'b1;
				end
				else if((addra_1 == 9)&&(ce0_ctrl == 1'b0))begin
					start_cf<=1'b1;
				end
				else if((addra_1 == 25)&&(ce0_ctrl== 1'b0))begin
					start_cf<=1'b1;
				end
				else begin
					start_cf<=1'b0;
				end	
			end
			default: begin
				start_cf<=1'b0;
			end
		endcase
	end
end

always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		    start_cf_pre <= 1'b0;
		end
		else if(rst_syn)begin
			 start_cf_pre <= 1'b0;
		end	
		else begin
		      case(level)
	             3'b001: begin
				    if((addra_64 == 1016)&&(ce0_ctrl == 1'b1)) begin
					    start_cf_pre <= 1'b1;
					end
					else if((addra_64 == 2040)&&(ce0_ctrl == 1'b1)) begin
					    start_cf_pre <= 1'b1;
					end
					else begin
					    start_cf_pre <= 1'b0;
					end
                end
				
				3'b010: begin
					if((addra_1 == 248)&&(ce0_ctrl == 1'b0)) begin
					   start_cf_pre <= 1'b1;
					end
					else if((addra_1 == 504)&&(ce0_ctrl == 1'b0)) begin
					   start_cf_pre <= 1'b1;
					end
					else begin
					    start_cf_pre <= 1'b0;
					end
                end
				
				3'b011: begin
					if((addra_64 == 56)&&(ce0_ctrl == 1'b1)) begin
					    start_cf_pre <= 1'b1;
					end
					else if((addra_64 == 120)&&(ce0_ctrl == 1'b1)) begin
					    start_cf_pre <= 1'b1;
					end
					else begin
					    start_cf_pre <= 1'b0;
					end
                end
				3'b100: begin
					if((addra_1 == 8)&&(ce0_ctrl == 1'b0)) begin
					    start_cf_pre <= 1'b1;
					end
					else if((addra_1 == 24)&&(ce0_ctrl == 1'b0)) begin
					    start_cf_pre <= 1'b1;
					end
					else begin
					    start_cf_pre <= 1'b0;
					end
                end
				
			    default: begin
				    start_cf_pre <= 1'b0;
                end
			  endcase
		end
	end
	
///***************** en ******** we *******************///

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ena_1 <= 1'b0;
	end
	else if(rst_syn)begin
		ena_1 <= 1'b0;
	end	
	else if(srst == 1'b1)begin
		ena_1 <= 1'b0;
	end
	else if((level != 3'b111))begin
		ena_1 <= 1'b1;
	end
end

always @(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		enb_1<=1'b0;
	end
	else if(rst_syn)begin
		enb_1<=1'b0;
	end
	else if(srst == 1'b1)begin
		enb_1<=1'b0;
	end
	else if((level == 3'b001)||(level == 3'b011))begin
		enb_1<=1'b1;
	end
	else if((level == 3'b010)||(level == 3'b100))begin
		enb_1<=1'b0;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ena_64 <= 1'b0;
	end
	else if(rst_syn)begin
		ena_64 <= 1'b0;
	end
	else if(srst == 1'b1)begin
		ena_64<=1'b0;
	end
	else if(level == 3'b000)begin
		ena_64<=1'b0;
	end
	else if(level != 3'b111)begin
		ena_64<=1'b1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		enb_64<=1'b0;
	end
	else if(rst_syn)begin
		enb_64<=1'b0;
	end
	else if(srst == 1'b1)begin
		enb_64<=1'b0;
	end
	else if((level == 3'b010)||(level == 3'b100))begin
		enb_64<=1'b1;
	end
	else if((level == 3'b001)||(level == 3'b011))begin
		enb_64<=1'b0;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ena_2<=1'b0;
	end
	else if(rst_syn)begin
		ena_2<=1'b0;
	end
	else if(srst ==1'b1)begin
		ena_2<=1'b0;
	end
	else if((level != 3'b111))begin
		ena_2<=1'b1;
	end	
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ena_3<=1'b0;
	end
	else if(rst_syn)begin
		ena_3<=1'b0;
	end
	else if(srst ==1'b1)begin
		ena_3<=1'b0;
	end
	else if((level != 3'b111))begin
		ena_3<=1'b1;
	end	
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ena_4<=1'b0;
	end
	else if(rst_syn)begin
		ena_4<=1'b0;
	end
	else if(srst ==1'b1)begin
		ena_4<=1'b0;
	end
	else if((level != 3'b111))begin
		ena_4<=1'b1;
	end	
end
////////  write signal 写控制
always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wea_1<=1'b0;
	end
	else if(rst_syn)begin
		wea_1<=1'b0;
	end
	else if(srst ==1'b1)begin
		wea_1<=1'b0;
	end
	else if((level == 3'b000)||(level == 3'b010)||(level == 3'b100))begin
		wea_1<=1'b1;
	end
	else begin
		wea_1<=1'b0;
	end
end

assign web_1 =1'b0;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wea_64<=1'b0;
	end	
	else if(rst_syn)begin
		wea_64<=1'b0;
	end
	else if((level == 3'b001)||(level == 3'b011))begin
		wea_64<=1'b1;
	end
	else begin
		wea_64<=1'b0;
	end
end

assign web_64 =1'b0;

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wea_2<=1'b0;
	end
	else if(rst_syn)begin
		wea_2<=1'b0;
	end
	else if(srst ==1'b1)begin
		wea_2<=1'b0;
	end
	else if(level != 3'b111)begin
		wea_2<=1'b1;
	end
	else begin
		wea_2<=1'b0;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wea_3<=1'b0;
	end
	else if(rst_syn)begin
		wea_3<=1'b0;
	end
	else if(srst ==1'b1)begin
		wea_3<=1'b0;
	end
	else if(level != 3'b111)begin
		wea_3<=1'b1;
	end
	else begin
		wea_3<=1'b0;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		wea_4<=1'b0;
	end
	else if(rst_syn)begin
		wea_4<=1'b0;
	end
	else if(srst ==1'b1)begin
		wea_4<=1'b0;
	end
	else if(level != 3'b111)begin
		wea_4<=1'b1;
	end
	else begin
		wea_4<=1'b0;
	end
end
////********************** data port *********************////

wire [16:0] dina_1;
wire [16:0] dina_64;
wire [16:0] dina_2;
wire [16:0] dina_3;
wire [16:0] dina_4;

reg [16:0] dina_1_reg;
reg [16:0] dina_64_reg;	
reg [16:0] dina_2_reg;
reg [16:0] dina_3_reg;
reg [16:0] dina_4_reg;

wire [16:0]dian_p_1;
wire [16:0]dian_p_2;	
wire [16:0]dian_p_3;	
wire [16:0]dian_p_4;	
// 注意：此处以取绝对值，state_generate 不用再取反

assign dian_p_1=(dina_1_reg[16]==1'b1)?{dina_1_reg[16],(~dina_1_reg[15:0]+1'b1)}:{dina_1_reg[16],dina_1_reg[15:0]};
assign dian_p_2=(dina_2_reg[16]==1'b1)?{dina_2_reg[16],(~dina_2_reg[15:0]+1'b1)}:{dina_2_reg[16],dina_2_reg[15:0]};
assign dian_p_3=(dina_3_reg[16]==1'b1)?{dina_3_reg[16],(~dina_3_reg[15:0]+1'b1)}:{dina_3_reg[16],dina_3_reg[15:0]};
assign dian_p_4=(dina_4_reg[16]==1'b1)?{dina_4_reg[16],(~dina_4_reg[15:0]+1'b1)}:{dina_4_reg[16],dina_4_reg[15:0]};

assign dina_64=(wea_64==1'b1)?dina_64_reg:17'bz;
assign dina_1=(level_reg!=3'd4)?dina_1_reg:(wea_1==1'b1)?dian_p_1:17'bz;
assign dina_2=(wea_2==1'b1)?dian_p_2:17'bz;
assign dina_3=(wea_3==1'b1)?dian_p_3:17'bz;
assign dina_4=(wea_4==1'b1)?dian_p_4:17'bz; 


// assign dina_1=(wea_1==1'b1)?dina_1_reg:17'bz;
// assign dina_64=(wea_64==1'b1)?dina_64_reg:17'bz;
// assign dina_2=(wea_2==1'b1)?dina_2_reg:17'bz;
// assign dina_3=(wea_3==1'b1)?dina_3_reg:17'bz;
// assign dina_4=(wea_4==1'b1)?dina_4_reg:17'bz; 
 

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dina_1_reg<=17'b0;
	end
	else if(rst_syn)begin
		dina_1_reg<=17'b0;	
	end	
	else if(wr_over==2'b11)begin
		dina_1_reg<=dina_1_reg;
	end
	else if(((level == 3'b000)&&(ce0_ctrl == 1'b1))||((level == 3'b010)&&(ce0_ctrl == 1'b1))||((level == 3'b100)&&(ce0_ctrl == 1'b1)))begin
		dina_1_reg<=quant_out_l;
	end
end

always @(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dina_64_reg<=17'b0;
	end
	else if(rst_syn)begin
		dina_64_reg<=17'b0;
	end
	else if(wr_over==2'b11)begin
		dina_64_reg<=dina_64_reg;
	end
	else if(((level == 3'b001)&&(ce0_ctrl ==1'b0 ))||((level == 3'b011)&&(ce0_ctrl ==1'b0 )))begin
		dina_64_reg<=quant_out_l;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dina_2_reg<=17'b0;
	end
	else if(rst_syn)begin
		dina_2_reg<=17'b0;
	end
	else if(wr_over==2'b11)begin
		dina_2_reg<=dina_2_reg;
	end
	else if (((ce0_ctrl == 1'b0)&&((level==3'b000)||(level==3'b010)||(level==3'b100)))||((ce0_ctrl ==1'b1 )&&((level==3'b001)||(level==3'b011))))begin
		dina_2_reg<=quant_out_l;
	end	
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dina_3_reg<=17'b0;
	end
	else if(rst_syn)begin
		dina_3_reg<=17'b0;
	end
	else if(wr_over==2'b11)begin
		dina_3_reg<=dina_3_reg;
	end
	else if(((ce0_ctrl == 1'b1)&&((level==3'b000)||(level==3'b010)||(level==3'b100)))||((ce0_ctrl == 1'b0)&&((level==3'b001)||(level==3'b011))))begin  
		dina_3_reg<=quant_out_h;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		dina_4_reg<=17'b0;
	end	
	else if(rst_syn)begin
		dina_4_reg<=17'b0;
	end
	else if(wr_over==2'b11)begin
		dina_4_reg<=dina_4_reg;
	end
	else if(((ce0_ctrl == 1'b0)&&((level==3'b000)||(level==3'b010)||(level==3'b100)))||((ce0_ctrl == 1'b1)&&((level==3'b001)||(level==3'b011))))begin
		dina_4_reg<=quant_out_h;
	end
end
///*********************************  output of （ram 1  and  ram 64） *********************************///
always@(posedge clk_mmu or negedge rst) begin
	if(!rst) begin
	    even_data <= 16'b0;
	end
	else if(rst_syn)begin
		even_data <= 16'b0;
	end
	else begin
		case(level_reg)
			
			3'b001: begin
				even_data<=douta_1[15:0];
			end
			3'b010: begin
				even_data<=douta_64[15:0];
			end
			3'b011: begin
				even_data<=douta_1[15:0];
			end
			3'b100: begin
				even_data<=douta_64[15:0];
			end
			default: begin
				even_data<=16'b0;
			end
		endcase
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		odd_data<=16'b0;
	end
	else if(rst_syn)begin
		odd_data<=16'b0;
	end
	else begin
		case(level_reg)
			
			3'b001: begin
				odd_data <= doutb_1[15:0];
			end
			3'b010: begin
				odd_data <= doutb_64[15:0];
			end
			3'b011: begin
				odd_data <= doutb_1[15:0];
			end
			3'b100: begin
				odd_data <= doutb_64[15:0];
			end
			default:begin
				odd_data <= 16'b0;
			end
		endcase
	end
end


///*************************addra_1 and addrb_1 *************************////
reg [1:0] ex_1;
reg [1:0] ex_1_n;
reg [5:0] rover_cnt;
reg [5:0] rover_cnt_n;
reg [13:0] addra_1_n;
reg [13:0] addrb_1_n;

always@(posedge clk_mmu or negedge rst) begin
       if(!rst) begin
           ex_1 <= 2'b0;
       end
	   else if(rst_syn)begin
			ex_1 <= 2'b0;
	   end
       else if(srst == 1'b1) begin
           ex_1 <= 2'b0;
       end
       else begin
           ex_1 <= ex_1_n;
       end
   end

always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		    rover_cnt <= 0;
		end
		else if(rst_syn)begin
			 rover_cnt <= 0;
		end
		else if(start_cf_pre == 1'b1) begin
		    rover_cnt <= 0;
		end
		else begin
		    rover_cnt <= rover_cnt_n;
		end
	end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		addra_1 <= 14'b0;
	end
	else if(rst_syn)begin
		addra_1 <= 14'b0;
	end
	else if((level==3'b001)||(level==3'b011))begin
		if(dwt_work==1'b1)begin
			addra_1 <= addra_1_n;
		end
	end
	else if(dwt_work==1'b1)begin
		addra_1 <= addra_1_n;
	end
 end


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		addrb_1 <= 14'b0;
	end
	else if(rst_syn)begin
		addrb_1 <= 14'b0;
	end
	else if((level==3'b001)||(level==3'b011))begin
		if(dwt_work==1'b1)begin
			addrb_1 <= addrb_1_n;
		end
	end
	else if(dwt_work==1'b1)begin
		addrb_1 <= addrb_1_n;
	end
 end

always@(*)begin
	addra_1_n = addra_1;
	rover_cnt_n = rover_cnt;
	ex_1_n = ex_1;
	if(level == 3'b001)begin
		if(level_delay == 3'b000)begin
			addra_1_n =0;
		end
		else if(level_reg != 3'b001)begin
			addra_1_n =0;
		end
		else begin
			if(addra_1 == 4031)begin
				if(ex_1 == 2)begin
					addra_1_n = addra_1 + 65 - 8;
		             ex_1_n = 0;
				end
				else begin
					 addra_1_n = addra_1 - 63;
		             ex_1_n = ex_1 + 1;
				end
				rover_cnt_n = 0;
			end
			else if(addra_1 == 8127) begin
				if(ex_1 == 2) begin
		             addra_1_n = addra_1 + 65 - 8;
		             ex_1_n = 0;
		         end
		         else begin
		             addra_1_n = addra_1 - 63;
		             ex_1_n = ex_1 + 1;
		         end
		         rover_cnt_n = 0;
			end
			else if(addra_1 == 12223)begin
				if(ex_1 == 2) begin
		             addra_1_n = 0;
		             ex_1_n = 0;
		         end
		         else begin
		             addra_1_n = addra_1 - 63;
		             ex_1_n = ex_1 + 1;
		         end
		         rover_cnt_n = 0;
			end
			else begin 
				if(rover_cnt == 63) begin
			          addra_1_n = addra_1 + 65;
				      rover_cnt_n = 0;
				 end
				 else begin
					addra_1_n = addra_1 + 1;
				    rover_cnt_n = rover_cnt + 1;
				 end
			end
		end
	end
	else if(level == 3'b011)begin
		if(level_delay == 3'b010)begin
			addra_1_n = 0;
		end
		else if(level_reg != 3'b011) begin
		           addra_1_n = 0;
		end
		else begin
			if(addra_1 == 239)begin
				if(ex_1 == 2) begin
		                addra_1_n = addra_1 + 17 - 8;
		                ex_1_n = 0;
		            end
		            else begin
		                addra_1_n = addra_1 - 15;
		                ex_1_n = ex_1 + 1;
		            end
		            rover_cnt_n = 0;
			end
			else if(addra_1 == 495)begin
				if(ex_1 == 2) begin
		                addra_1_n = addra_1 + 17 - 8;
		                ex_1_n = 0;
		            end
		            else begin
		                addra_1_n = addra_1 - 15;
		                ex_1_n = ex_1 + 1;
		            end
		            rover_cnt_n = 0;
			end
			else if(addra_1 == 751)begin
				if(ex_1 == 2) begin
		            addra_1_n = 0;
		            ex_1_n = 0;
		            end
		        else begin
		            addra_1_n = addra_1 - 15;
		            ex_1_n = ex_1 + 1;
		        end
		            rover_cnt_n = 0;
			end
			else begin
				if(rover_cnt == 15) begin
			        addra_1_n = addra_1 + 17;
			    	rover_cnt_n = 0;
			    end
			    else if((dwt_work==1'b1))begin
			        addra_1_n = addra_1 + 1;
			    	rover_cnt_n = rover_cnt + 1;
			    end
			    else begin
			    	addra_1_n = addra_1;
			    	rover_cnt_n = rover_cnt;
			    end
			end
		end
	end
	else if((level_reg == 3'b000)||(level_reg == 3'b010)||(level_reg == 3'b100))begin
		if((level_delay_1==3'b001)||(level_delay_1==3'b011))begin
			addra_1_n = 0;
		end
		else if(quant_out_vld_reg == 1'b1)begin
			if(inc_addr_cnt == 1'b0) begin
				addra_1_n = addra_1 + 1'b1;
			end
			else begin
				addra_1_n = addra_1;
			end
		end
		else begin
			addra_1_n = addra_1;
		end
	end
	else begin
		addra_1_n = 0;
		rover_cnt_n = 0;
		ex_1_n = 0;
	end
end


always@(*)begin
	addrb_1_n = addrb_1;
	if(level == 3'b001)begin
		if(level_delay == 3'b000) begin
			addrb_1_n = 64;
		end
		else if(level_reg != 3'b001)begin
			addrb_1_n = 64;
		end
		else begin
			if(addrb_1 == 4095)begin
				if(ex_1 == 2) begin
		               addrb_1_n = addrb_1 + 65 - 8;
		           end
		        else begin
		            addrb_1_n = addrb_1 - 63;
		        end
			end	
			else if(addrb_1 == 8191)begin
				if(ex_1 == 2) begin
		            addrb_1_n = addrb_1 + 65 - 8;
		        end
		        else begin
					addrb_1_n = addrb_1 - 63;
		        end
			end
			else if(addrb_1 == 12287)begin
				if(ex_1 == 2) begin
		            addrb_1_n = 0;
		        end
		        else begin
		            addrb_1_n = addrb_1 - 63;
		        end
			end
			else begin
				if(rover_cnt == 63) begin
			        addrb_1_n = addrb_1 + 65;
				end
				else begin
			        addrb_1_n = addrb_1 + 1;
			    end
			end
		end		
	end
	else if(level == 3'b011)begin
		if(level_delay == 3'b010)begin
			addrb_1_n = 16;
		end
		else if(level_reg != 3'b011)begin
			addrb_1_n = 16;
		end
		else begin
			if(addrb_1 == 255)begin
				if(ex_1 == 2)	begin
					 addrb_1_n = addrb_1 + 17 - 8;
				end
				else begin
					addrb_1_n = addrb_1 - 15;
				end
			end
			else if(addrb_1 == 511)begin
				if(ex_1 == 2)begin
					 addrb_1_n = addrb_1 + 17 - 8;
				end
				else begin
					addrb_1_n = addrb_1 - 15;
				end
			end
			else if(addrb_1 == 767)begin
				if(ex_1 == 2)begin
					addrb_1_n = 0;
				end
				else begin
					addrb_1_n = addrb_1 - 15;
				end
			end
			else begin
				if(rover_cnt == 15) begin
			        addrb_1_n = addrb_1 + 17;
				end
				else begin
					addrb_1_n = addrb_1 + 1;
				end
			end
		end
	end	
	else begin
		addrb_1_n = 14'b0;
	end
end


/////**********     addra_64  and  aderb_64   ********************///

reg [1:0] ex_2;
reg [1:0] ex_2_n;
reg [4:0] rover_cnt1;
reg [4:0] rover_cnt1_n;
reg [11:0] addrb_64_n;
reg [11:0] addra_64_n;

always@(posedge clk_mmu or negedge rst) begin
   if(!rst) begin
		ex_2 <= 2'b0;
   end
   else if(rst_syn)begin
		ex_2 <= 2'b0;
   end
   else if(srst == 1'b1) begin
     ex_2 <= 2'b0;
   end
   else begin
     ex_2 <= ex_2_n;
   end
end

always@(posedge clk_mmu or negedge rst) begin
  if(!rst) begin
	rover_cnt1 <= 0;
  end
  else if(rst_syn)begin
	rover_cnt1 <= 0;
  end
  else if(start_cf_pre == 1'b1) begin
	rover_cnt1 <= 0;
  end
  else begin
	rover_cnt1 <= rover_cnt1_n;
  end
end


always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		     addra_64 <= 12'b0;
		 end
		 else if(rst_syn)begin
			addra_64 <= 12'b0;
		 end
		else if((level==3'b010)||(level==3'b100)) begin
			if(dwt_work==1'b1)begin
					addra_64 <= addra_64_n;
				end
		end
		else if(dwt_work==1'b1)begin
			addra_64 <= addra_64_n;
		end
end
	
always@(*)begin
		addra_64_n = addra_64;
		rover_cnt1_n = rover_cnt1;
		ex_2_n = ex_2;	
		if(level == 3'b010)begin
			if(level_delay == 3'b001)begin
				addra_64_n = 0; 
			end
			else if(level_reg != 3'b010)begin
				addra_64_n = 0; 
			end
			else begin
				if(addra_64 == 991)begin
					if(ex_2 == 2)begin
						addra_64_n = addra_64 + 33 - 8;
						ex_2_n = 0;
					end
					else begin
						addra_64_n = addra_64 - 31;
						ex_2_n = ex_2 + 1;	
					end
					rover_cnt1_n = 0;
				end
				else if(addra_64 == 2015)begin
					if(ex_2==2)begin
						addra_64_n = addra_64 + 33 - 8;
						ex_2_n = 0;
					end
					else begin
						addra_64_n = addra_64 - 31;
						ex_2_n = ex_2 + 1;	
					end	
					rover_cnt1_n = 0;
				end
				else if(addra_64 == 3039)begin
					if(ex_2 == 2)begin
						addra_64_n = 0;
						ex_2_n = 0;	
					end
					else begin
						addra_64_n = addra_64 - 31;
						ex_2_n = ex_2 + 1;
					end
						rover_cnt1_n = 0;
				end
				else begin
					if(rover_cnt1 == 31)begin
						addra_64_n = addra_64 + 33;
						rover_cnt1_n = 0;	
					end
					else begin
						addra_64_n = addra_64 + 1;
			  	        rover_cnt1_n = rover_cnt1 + 1;
					end	
				end
			end
		end
		else if(level == 3'b100)begin
			if(level_delay == 3'b011)begin
				addra_64_n = 0;
			end
			else if(level_reg != 3'b100) begin
		        addra_64_n = 0;
		    end
			else begin
				if(addra_64 == 55)begin
					if(ex_2 == 2)begin
						addra_64_n = addra_64 + 9 - 8;
						ex_2_n = 0;	
					end
					else begin
						addra_64_n = addra_64 - 7;
						ex_2_n = ex_2 + 1;
					end
						rover_cnt1_n = 0;
				end
				else if(addra_64 == 119)begin
					if(ex_2 == 2)begin
						addra_64_n = addra_64 + 9 - 8;
						ex_2_n = 0;	
					end
					else begin
						addra_64_n = addra_64 - 7;
						ex_2_n = ex_2 + 1;
					end
						rover_cnt1_n = 0;
				end
				else if(addra_64 == 183)begin
					if(ex_2 == 2)begin
						addra_64_n = 0;
						ex_2_n = 0;	
					end
					else begin
						addra_64_n = addra_64 - 7;
						ex_2_n = ex_2 + 1;
					end
					rover_cnt1_n = 0;
				end
				else begin
					if(	(rover_cnt1 == 7)&&(start_cf_pre==1'b0))begin
						addra_64_n = addra_64 + 9;
						rover_cnt1_n = 0;
					end
					else begin
						addra_64_n = addra_64 + 1;
						rover_cnt1_n = rover_cnt1 + 1;	
					end
				end
			end
		end
		else if((level_reg == 3'b001)||(level_reg == 3'b011))begin
			if(quant_out_vld_reg == 1'b1)begin
				if((level_delay_1 == 3'b000)||(level_delay_1 == 3'b010)) begin
				     addra_64_n = 0;
				 end
				 else if(inc_addr_cnt == 1'b0) begin
		             addra_64_n = addra_64 + 1'b1;
		         end
		         else begin
		             addra_64_n = addra_64;
		         end
			end
			else begin
				 addra_64_n = addra_64;
			end
		end
		else  begin
			addra_64_n = 0;
		    rover_cnt1_n = 0;
		    ex_2_n = 0;	
		end
end


always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		     addrb_64 <= 12'b0;
		 end
		 else if(rst_syn)begin
			addrb_64 <= 12'b0;
		 end
		else if((level==3'b010)||(level==3'b100)) begin
            if(dwt_work==1'b1)begin
					addrb_64 <= addrb_64_n;
				end
		end
		else if(dwt_work==1'b1)begin
			addrb_64 <= addrb_64_n;
		end	
end

always@(*)begin
	addrb_64_n = addrb_64;
	if(level == 3'b010)begin
		if(level_delay == 3'b001) begin
		   addrb_64_n = 32;
		end
		else if(level_reg != 3'b010) begin
		    addrb_64_n = 32;
		end
		else begin
		  if(addrb_64 == 1023) begin
		     if(ex_2 == 2) begin
		         addrb_64_n = addrb_64 + 33 - 8;
		     end
		     else begin
		         addrb_64_n = addrb_64 - 31;
		     end
		 end
		 else if(addrb_64 == 2047) begin
		     if(ex_2 == 2) begin
		         addrb_64_n = addrb_64 + 33 - 8;
		     end
		     else begin
		         addrb_64_n = addrb_64 - 31;
		     end
		 end
		 else if(addrb_64 == 3071) begin
		     if(ex_2 == 2) begin
		         addrb_64_n = 0;
		     end
		     else begin
		         addrb_64_n = addrb_64 - 31;
		     end
		 end
		 else begin
		     if(rover_cnt1 == 31) begin
		          addrb_64_n = addrb_64 + 33;
			 end
			 else begin
			      addrb_64_n = addrb_64 + 1;
			 end
		 end  
		end	
	end
	else if(level == 3'b100) begin
		if(level_delay == 3'b011) begin
			    addrb_64_n = 8;
		end
		else if(level_reg != 3'b100) begin
			addrb_64_n = 8;
		end
		else begin
		if(addrb_64 == 63) begin
				if(ex_2 == 2) begin
					addrb_64_n = addrb_64 + 9 - 8;
				end
				else begin
					addrb_64_n = addrb_64 - 7;
				end
			end
			else if(addrb_64 == 127) begin
				if(ex_2 == 2) begin
					addrb_64_n = addrb_64 + 9 - 8;
				end
				else begin
					addrb_64_n = addrb_64 - 7;
				end
			end
			else if(addrb_64 == 191) begin
				if(ex_2 == 2) begin
					addrb_64_n = 0;
				end
				else begin
					addrb_64_n = addrb_64 - 7;
				end
			end
			else begin
				if((rover_cnt1 == 7)&&(start_cf_pre==1'b0))begin
					addrb_64_n = addrb_64 + 9;
				end
				else begin
					addrb_64_n = addrb_64 + 1;
				end				  
			end 
		end
	end
	else begin
		addrb_64_n = 12'b0;
	end
end

///***************************  addra_2  and  addra_3   and  addra_4  **************************///

always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		     addra_2<= 14'b0;
		 end
		  else if(rst_syn)begin
			addra_2<= 14'b0;
		  end
		else begin
            addra_2<= addra_2_n;
		end
end

always@(*)begin
	addra_2_n=addra_2;
	if(quant_out_vld_reg == 1'b1)begin
		if(inc_addr_cnt == 1'b0)begin
			addra_2_n = addra_2 + 1;
		end
		else begin
			addra_2_n = addra_2;
		end
	end	
	else begin
		addra_2_n = addra_2;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		addra_3<= 14'b0;
	end
	else if(rst_syn)begin
		addra_3<= 14'b0;
	end
	else begin
		addra_3<=addra_3_n;
	end
end

always@(*)begin
	addra_3_n=addra_3;
	if(quant_out_vld_reg == 1'b1)begin
		if(	inc_addr_cnt == 1'b0)begin
			addra_3_n=addra_3+1;
		end
		else begin
			addra_3_n=addra_3;
		end
	end
	else begin
		addra_3_n=addra_3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		addra_4<= 14'b0;
	end
	else if(rst_syn)begin
		addra_4<= 14'b0;
	end
	else begin
		addra_4<=addra_4_n;
	end
end

always@(*)begin
	addra_4_n=addra_4;
	if(quant_out_vld_reg == 1'b1)begin
		if(	inc_addr_cnt == 1'b0)begin
			addra_4_n=addra_4+1;
		end
		else begin
			addra_4_n=addra_4;
		end
	end
	else if(bpc_start==1'b1)begin
		addra_4_n=0;
	end
	else begin
		addra_4_n=addra_4;
	end
end
///*******************************************************************************///
always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		ce0_ctrl<=0;
	end
	else if(rst_syn)begin
		ce0_ctrl<=0;
	end
	else if((level==3'b001)&&(quant_out_vld==1'b0)&&(quant_out_vld_reg==1'b1)&&(unvalid_cnt_n==2'b01))begin
		ce0_ctrl<=1;
	end
	else if((level==3'b001)&&(quant_out_vld==1'b0)&&(quant_out_vld_reg==1'b1)&&(unvalid_cnt_n==2'b10))begin
		ce0_ctrl<=1;
	end
	else if(level!=3'b111)begin
		ce0_ctrl<=ce0_ctrl+1;
	end
	else begin
		ce0_ctrl<=1'b1;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		inc_addr_cnt<=1'b0;
	end
	else if(rst_syn)begin
		inc_addr_cnt<=1'b0;
	end
	else if(quant_out_vld == 1'b0)begin
		inc_addr_cnt<=1'b0;
	end
	else if(quant_out_vld == 1'b1)begin
		 inc_addr_cnt <= inc_addr_cnt + 1'b1;
	end
	else begin
		 inc_addr_cnt <= inc_addr_cnt;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		quant_out_vld_reg<=1'b0;
	end
	else if(rst_syn)begin
		quant_out_vld_reg<=1'b0;
	end
	else begin
		quant_out_vld_reg <= quant_out_vld;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		unvalid_cnt<=2'b0;
	end
	else if(rst_syn)begin
		unvalid_cnt<=2'b0;
	end
	else begin
		unvalid_cnt<=unvalid_cnt_n;
	end
end

always@(*)begin
	unvalid_cnt_n=unvalid_cnt;
	if(quant_out_vld_reg == 1'b1)begin
		if(quant_out_vld == 1'b0)begin
			if(unvalid_cnt==2)begin
				unvalid_cnt_n=0;
			end
			else begin
				unvalid_cnt_n=unvalid_cnt+1;
			end
		end
		else begin
				unvalid_cnt_n=unvalid_cnt;
		end
	end
	else begin
		unvalid_cnt_n=unvalid_cnt;
	end
end
////////////////////////////// state machine ////////////////////

always@(*) begin
	fsm_mmu_n=fsm_mmu;
	case(fsm_mmu)
		idle: begin
			if(start == 1'b1)begin
				fsm_mmu_n=cal0;
			end
			else begin
				fsm_mmu_n=idle;
			end
		end
		cal0: begin
			if(wr_over==2'b11)begin
				fsm_mmu_n=cal1;
			end
			else begin
				fsm_mmu_n=cal0;
			end
		end
		cal1: begin
			if(wr_over == 2'b11)begin
				fsm_mmu_n=cal2;
			end
			else begin
				fsm_mmu_n = cal1;
			end
		end
		cal2: begin
			if(wr_over == 2'b11)begin
				fsm_mmu_n=cal3;
			end	
			else begin
				fsm_mmu_n=cal2;
			end
		end
		cal3: begin
			if(wr_over == 2'b11)begin
				fsm_mmu_n=cal4;
			end
			else begin
				fsm_mmu_n=cal3;
			end
		end
		cal4: begin
			if(wr_over == 2'b11)begin
				fsm_mmu_n=idle;
			end
			else begin
				fsm_mmu_n=cal4;
			end
		end
		default: begin
			 fsm_mmu_n=idle;
		end
		endcase
	end


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		Y_U_V_over_1<=0;
	end
	else if(rst_syn)begin
		Y_U_V_over_1<=0;
	end
	else if((unvalid_cnt==2'd0)&&(unvalid_cnt_n==2'd1))begin
		Y_U_V_over_1<=2'd1;
	end
	else if((unvalid_cnt==2'd1)&&(unvalid_cnt_n==2'd2))begin
		Y_U_V_over_1<=2'd2;
	end
	else if((unvalid_cnt==2'd2)&&(unvalid_cnt_n==2'd0))begin
		Y_U_V_over_1<=2'd3;
	end
end

always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		Y_U_V_over_2<=0;
	end
	else if(rst_syn)begin
		Y_U_V_over_2<=0;
	end
	else begin
		Y_U_V_over_2<=Y_U_V_over_1;
	end
end
	
assign Y_U_V_over=(Y_U_V_over_1!=Y_U_V_over_2)?Y_U_V_over_1:0;


endmodule
