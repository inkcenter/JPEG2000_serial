module putdata(	//output
				dina_o1,
				dina_o2,
				addra_o1_w,
				addra_o2_w,
				ena_o1_w,
				ena_o2_w,
				wea_o1_w,
				wea_o2_w,
				start,
				//input
				clk_dwt,
				clk_sg,
				rst,
				start_cpu,
				rst_syn);

output [16:0] dina_o1;
output [16:0] dina_o2;
output [13:0] addra_o1_w;
output [13:0] addra_o2_w;
output ena_o1_w;
output ena_o2_w;
output wea_o1_w;
output wea_o2_w;
output start;

input clk_dwt;
input clk_sg;
input rst;
input start_cpu;
input rst_syn;

parameter 	idle = 0 ,
		 	work = 1 ;

parameter add_sample 	=	2'b01,
		  add_coulme 	=	2'b10,
		  wait_add_tile	=	2'b00;

wire over;
wire start;
wire pre_vld;
wire over_start;
wire wea_o1_w;
wire wea_o2_w;
reg ena_o1_w;
wire ena_o2_w;
wire [31:0]data_mem2_temp;
wire pre_vld_and;
wire over_start_or;
wire [31:0]data_mem1_out;
wire start_pre;

reg [1:0]fsm_address;
reg [1:0]fsm_address_n;
reg [5:0]count_sample;
reg [6:0]count_colume;
reg [4:0]count_tiles;
reg [1:0]count_clk_dwt;
reg [31:0]mem2[204799:0];
// reg [12:0]addr_mem2_in;	//8192	
reg [17:0]addr_mem2_in;	//204800
reg [19:0]addr_mem1_out;
reg mem2_in_valid;
reg start_pre_delay;
reg [1:0] start_count;	
reg start_cpu_syn;
reg	start_cpu_reg1;
reg start_cpu_reg2;
reg	start_cpu_reg3;
reg	start_cpu_reg4;
reg start_pre_reg1;
reg	start_pre_reg2;
reg	start_pre_reg3;
reg	start_pre_reg4;
reg fsm_n;
reg fsm;
reg pre_vld_delay;
reg pre_vld_delay_1;
reg pre_vld_delay_2;
reg pre_vld_delay_3;
reg pre_vld_delay_4;	
reg [8:0]count;
reg ce0_ctrl;	
reg odd_even_judge_r;
reg odd_even_judge;
reg odd_even_judge_delay;
reg [31:0]data_mem2_temp_reg1;
reg [31:0]data_mem2_temp_reg2;
reg [31:0]data_mem2_temp_reg3;
reg over_start_delay;
reg over_start_delay_1;
reg over_start_delay_2;
reg start_reg;
reg start_reg1;
reg start_reg2;
reg [17:0]addra_all_1;
reg [1:0]count_3;
reg [7:0]dina_high_1;
reg [7:0]dina_low_1;
reg [16:0]dina_o1;
reg [16:0]dina_o2;
reg [13:0]addra_o1_w;
reg [13:0]addra_o2_w;
reg [19:0]address;
reg [7:0]mem[819199:0];		// 640*640*2
assign data_mem2_temp = mem2[addra_all_1];
assign pre_vld_and = pre_vld_delay_2 & pre_vld_delay;
assign start=((start_reg)||(start_reg1));
assign pre_vld=(fsm==work);
assign over=(addra_o2_w==4095);
assign over_start = (addra_o2_w==12287);
assign over_start_or=over_start||over_start_delay||over_start_delay_1||over_start_delay_2;
assign data_mem1_out = (addr_mem1_out < 819197)?{mem[addr_mem1_out],mem[addr_mem1_out+1],mem[addr_mem1_out+2],mem[addr_mem1_out+3]}:32'bz;
//****************************************//
//integer k;
integer i;
integer cnt;
integer fp_r;
//reg [14:0]address;
//reg[7:0]mem[32767:0];    	// 32768 = 128 * 128 * 2



initial  
begin
    //k=0;
    fp_r = $fopen("uyvy.txt", "r");
    address=0;
    while(!$feof(fp_r))  begin 
        //k=k+1;
        //$monitor("k=%d",k);              
        //for(i=0;i<32768;i=i+1)  begin
        for(i=0;i<819200;i=i+1)  begin
            cnt = $fscanf (fp_r, "%d",mem[address]); 
            address=address+1;
        end
    end
    $fclose(fp_r);
end

always@(posedge clk_dwt or negedge rst) 
begin
	if(!rst)
		count_clk_dwt<=0;
	else if(rst_syn)
		count_clk_dwt<=0;
	else if(clk_sg==1'b0)
		count_clk_dwt<=0;
	else if(clk_sg==1'b1) 
		count_clk_dwt<=count_clk_dwt+1'b1;
end	

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		mem2_in_valid<=0;		
	//else if(rst_syn)
		//mem2_in_valid<=0;		
	else if((addr_mem2_in==18'd204799)&&(clk_sg==1'b1))
		mem2_in_valid<=1;
end

always@(posedge clk_dwt or negedge rst) 
begin
    if(!rst) 
	   	addr_mem1_out <= 20'b0;
	else if(rst_syn)
		addr_mem1_out <= 20'b0;
	else if(mem2_in_valid==1'b1)
			addr_mem1_out <= 20'b0;	
	else if((clk_sg == 1'b1)&&(count_clk_dwt == 2'b01)&&(count_tiles==0)) 
	    addr_mem1_out <= addr_mem1_out + 4;
	else 
		addr_mem1_out <= addr_mem1_out;
end	

always@(posedge clk_dwt or negedge rst) 
begin
    if(!rst) 
    	addr_mem2_in <= 18'b0;
	else if(rst_syn)
		addr_mem2_in <= 18'b0;
	else if(mem2_in_valid==1'b1)
		addr_mem2_in <= 18'b0;					
	else if((clk_sg == 1'b1)&&(count_clk_dwt == 2'b01)) 
	    addr_mem2_in <= addr_mem2_in + 1;
end	

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		mem2[addr_mem2_in]<=32'b0;
	else if((count_tiles==0)&&(mem2_in_valid==1'b0))
		mem2[addr_mem2_in]<=data_mem1_out;		
end

always@(posedge clk_dwt or negedge rst)
begin
    if(!rst)
		start_count<=0;
	else if(!clk_sg)
		start_count<=0;
	else if(clk_sg)
		start_count<=start_count+1;
end
always@(posedge clk_dwt or negedge rst)
begin
	if(!rst)
	begin
		start_cpu_syn<=0;
		start_cpu_reg1<=0;
		start_cpu_reg2<=0;
		start_cpu_reg3<=0;
		start_cpu_reg4<=0;
		start_pre_reg2<=0;
		start_pre_reg3<=0;
		start_pre_reg4<=0;
	end 
	else if(rst_syn)
	begin
		start_cpu_reg1<=0;
		start_cpu_reg2<=0;
		start_cpu_reg3<=0;
		start_cpu_reg4<=0;
		start_pre_reg2<=0;
		start_pre_reg3<=0;
		start_pre_reg4<=0;
	end 
	else
	begin
		start_cpu_syn<=start_cpu;
		start_cpu_reg1<=!start_cpu_syn&&start_cpu;
		start_cpu_reg2<=start_cpu_reg1;
		start_cpu_reg3<=start_cpu_reg2;
		start_cpu_reg4<=start_cpu_reg3;
		start_pre_reg2<=start_pre_reg1;
		start_pre_reg3<=start_pre_reg2;
		start_pre_reg4<=start_pre_reg3;
	end 
end
always@(posedge clk_dwt or negedge rst)
begin
    if(!rst)
		start_pre_reg1<=0;
	else if(rst_syn)
		start_pre_reg1<=0;
	else if(start_count==2&&(start_cpu_reg1||start_cpu_reg2||start_cpu_reg3||start_cpu_reg4))
		start_pre_reg1<=1;
	else start_pre_reg1<=0;
end
assign start_pre=start_pre_reg1||start_pre_reg2||start_pre_reg3||start_pre_reg4;
always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst)
		start_pre_delay <= 1'b0;
	else if(rst_syn)
		start_pre_delay <= 1'b0;
	else 
		start_pre_delay <= start_pre;
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		fsm <= 1'b0;
	else if(rst_syn)
		fsm <= 1'b0;
	else 
		fsm <= fsm_n;
end

always @(*) begin
 fsm_n = fsm;
 case(fsm)
   idle :   begin
             if((start_pre==1'b1)&&(start_pre_delay==1'b0)) begin
			   fsm_n = work;
			 end
			 else begin
			   fsm_n = idle;
			 end
			end
   work:    begin
             if(over==1'b1) begin
			  fsm_n = idle;
			 end
			 else begin
			  fsm_n = work;
			 end
			end
 endcase
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			pre_vld_delay <=1'b0;
			pre_vld_delay_1 <=1'b0;
			pre_vld_delay_2 <=1'b0;
			pre_vld_delay_3 <=1'b0;
			pre_vld_delay_4 <=1'b0;
		end
    else if(rst_syn)
		begin
			pre_vld_delay <=1'b0;
			pre_vld_delay_1 <=1'b0;
			pre_vld_delay_2 <=1'b0;
			pre_vld_delay_3 <=1'b0;
			pre_vld_delay_4 <=1'b0;
		end
	else 
		begin
			pre_vld_delay <=pre_vld;
			pre_vld_delay_1 <=pre_vld_delay;
			pre_vld_delay_2 <=pre_vld_delay_1;
		    pre_vld_delay_3 <=pre_vld_delay_2;
		    pre_vld_delay_4 <=pre_vld_delay_3;
		end
end 

always @(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			ce0_ctrl <=1'b0;
		else if(rst_syn)
			ce0_ctrl <=1'b0;
		else if(pre_vld_delay_2==1'b1) 
			ce0_ctrl <=ce0_ctrl + 1;
	end

always@(posedge clk_dwt or negedge rst) 
	begin
	    if(!rst) 
		    count <= 9'b0;
		else if(rst_syn)
		    count <= 9'b0;
		else if(count == 191)
		    count <= 9'b0;
		else if(pre_vld_delay_2==1'b1)
			count = count + 1;
	end

always @(posedge clk_dwt or negedge rst) begin
  if(!rst) begin
    odd_even_judge_r <=1'b0;
  end
  else if(rst_syn)begin
    odd_even_judge_r <=1'b0;
  end
  else if((count==191)&&(ce0_ctrl==1'b1)) begin
    odd_even_judge_r <= odd_even_judge_r +1;
  end
end

always @(posedge clk_dwt or negedge rst) begin
  if(!rst) begin
    odd_even_judge <=1'b0;
	odd_even_judge_delay <=1'b0;
  end
  else if(rst_syn)begin
    odd_even_judge <=1'b0;
	odd_even_judge_delay <=1'b0;
  end
  else begin
	odd_even_judge <= odd_even_judge_r;
	odd_even_judge_delay <= odd_even_judge;
  end
end

always @(posedge clk_dwt or negedge rst) 
	begin
		if(!rst)
			count_3<=0;
		else if(rst_syn)
			count_3<=0;	
		else if((pre_vld==1'b1)||(pre_vld_delay_2==1'b1))
			begin
				if(count_3==2)
					count_3<=0;
				else 	
					count_3<=count_3+1;
			end	
	end
// always @(posedge clk_dwt or negedge rst) 
// begin
// 	if(!rst) 
// 		addra_all_1 <=18'b0;
// 	else if(rst_syn)
// 		addra_all_1 <=18'b0;
// 	else if((pre_vld_delay_1==1'b1)&&(pre_vld_delay_2==1'b0))
// 		addra_all_1 <= addra_all_1 + 1;
// 	else if((pre_vld==1'b1)&&(count_3==2'd2))
// 		addra_all_1 <= addra_all_1 + 1;
// end
/****************************************************/
always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst)
		fsm_address <= 2'b00;
	else if(rst_syn)
		fsm_address <= 2'b00;
	else
		fsm_address <= fsm_address_n;
end
always @(*) begin
 fsm_address_n = fsm_address;
 	case(fsm_address)
		wait_add_tile :  //0
 	  				begin
 	            		//if((fsm_n==work)&&(count_3==2'd1)) 
 	            		if((fsm_n==work)&&(fsm==idle)) 
 	            			begin
				  				fsm_address_n = add_sample;
							end
				 		else 
				 			begin
				   				fsm_address_n = wait_add_tile;
				 			end
					end
		add_sample:  // 1
 	  				begin
 	           	 	if((count_sample==6'd63)&&(count_colume==7'd127)) 
 	           	 		begin
					 		fsm_address_n = wait_add_tile;
					 	end
					 else if(count_sample==6'd63)
					 	begin
					 	 	fsm_address_n = add_coulme;
					 	end
					 else 
					 	begin
					 		fsm_address_n = add_sample;
					 	end	
					end
		add_coulme:	// 2
					begin
						if(count_3==0)
							fsm_address_n = add_sample;
					end			
 	endcase
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			count_sample<=0;
		end
	else if(rst_syn) 
		begin
			count_sample<=0;
		end
	else if((fsm_address==add_coulme)&&(count_3==2'd2))
		begin
			count_sample<=0;				
		end		
	else if((pre_vld==1'b1)&&(count_3==2'd2))
		begin
			count_sample<=count_sample+1;
		end
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			count_colume<=0;
		end
	else if(rst_syn) 
		begin
			count_colume<=0;
		end
	else if((count_sample==6'd63)&&(count_3==2'd2))
		begin 
			count_colume<=count_colume+1;
		end		
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			count_tiles<=0;
		end
	else if((fsm_address==2'd1)&&(fsm_address_n==0))
		begin 
			count_tiles<=count_tiles+1;
		end		
end

always @(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			addra_all_1 <=18'b0;
		else 
			begin
				case(fsm_address)
					add_sample:
						if((pre_vld_delay_1==1'b1)&&(count_3==2'd2))
							begin
								addra_all_1 <= addra_all_1 + 1;
							end
					add_coulme:
						if((pre_vld==1'b1)&&(count_3==2'd2))
							begin
								case(count_tiles)
									0,5,10,15,20:
										begin
											addra_all_1 <= addra_all_1 + 257;
										end
									1,6,11,16,21:
										begin
											addra_all_1 <= addra_all_1 + 257;
										end
									2,7,12,17,22:
										begin
											addra_all_1 <= addra_all_1 + 257;
										end
									3,8,13,18,23:
										begin
											addra_all_1 <= addra_all_1 + 257;
										end
									4,9,14,19,24:	
										begin
											addra_all_1 <= addra_all_1 + 257;			
										end
									default:addra_all_1 <= addra_all_1;
								endcase		
							end	
					wait_add_tile:
						if((fsm_address==0)&&(fsm_address_n==2'd1))
							begin
								case(count_tiles)
									0:
										begin
											addra_all_1 <= 0;
										end	
									5,10,15,20:
										begin
											addra_all_1 <= addra_all_1 + 1;			
										end	
									//5,10,15,20,1,6,11,16,21,2,7,12,17,22,3,8,13,18,23:
									1,6,11,16,21,2,7,12,17,22,3,8,13,18,23,4,9,14,19,24:
										begin
											addra_all_1 <= addra_all_1 - 40639;		//(-320*127)+1
										end
									default:addra_all_1 <= addra_all_1;
								endcase		
							end
					default:addra_all_1 <= addra_all_1;
				endcase						
			end
	end

/***************************************************/
always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			 data_mem2_temp_reg1 <= 0;
			 data_mem2_temp_reg2 <= 0;
			 data_mem2_temp_reg3 <= 0;
		end
	else if(rst_syn) 
		begin
			 data_mem2_temp_reg1 <= 0;
			 data_mem2_temp_reg2 <= 0;
			 data_mem2_temp_reg3 <= 0;
		end
	else 
		begin
			data_mem2_temp_reg1 <= data_mem2_temp;
			data_mem2_temp_reg2 <= data_mem2_temp_reg1;
			data_mem2_temp_reg3 <= data_mem2_temp_reg2;
		end
end

always@(*)
begin
	if(pre_vld_and==1'b1)
		begin	
			case(count_3)
				0:	begin
						dina_high_1<= {data_mem2_temp_reg3[23:16]};
						dina_low_1 <= {data_mem2_temp_reg3[7:0]};
						// dina_high_1<= douta_all_1[23:16];		//Y0	
						// dina_low_1 <= douta_all_1[7:0];			//Y1
					end
				1:	begin
						dina_high_1<= {data_mem2_temp_reg3[31:24]};
						dina_low_1 <= {data_mem2_temp_reg3[31:24]};
						// dina_high_1<= douta_all_1[31:24];		//U0
						// dina_low_1 <= douta_all_1[31:24];		//U1	
					end
				2:	begin
						dina_high_1<= data_mem2_temp_reg3[15:8];
						dina_low_1 <= data_mem2_temp_reg3[15:8];
						// dina_high_1<= douta_all_1[15:8];		//V0
						// dina_low_1 <= douta_all_1[15:8];		//V1
					end 
			default:begin
						dina_high_1<=8'b0;
						dina_low_1 <=8'b0;
					end
			endcase		
		end
	else 
		begin
			dina_high_1<=8'b0;
			dina_low_1 <=8'b0;
		end
end


always@(posedge clk_dwt or negedge rst) 
begin
	if(!rst)
		dina_o1<=17'b0;
	else if(rst_syn)
		dina_o1<=17'b0;
	else if((addra_o1_w < 12288)&&(odd_even_judge_r==1'b0))	
		dina_o1<={1'bz,dina_low_1[7:0],dina_high_1[7:0]};
		//dina_o1<={1'bz,dina_high_1[7:0],dina_low_1[7:0]};
	else	
		dina_o1<=17'bz;
end
	
always@(posedge clk_dwt or negedge rst) 
begin
	if(!rst)
		dina_o2<=17'b0;
	else if(rst_syn)
		dina_o2<=17'b0;
	else if((addra_o2_w < 12288)&&(odd_even_judge_r==1'b1))	
		//dina_o2<={1'bz,dina_high_1[7:0],dina_low_1[7:0]};
		dina_o2<={1'bz,dina_low_1[7:0],dina_high_1[7:0]};
	else	
		dina_o2<=17'bz;
end	

always@(posedge clk_dwt or negedge rst) 
begin
    if(!rst) 
		addra_o1_w <= 14'b0;
	else if(rst_syn) 
		addra_o1_w <= 14'b0;
	else if((pre_vld_delay_3==1'b1)&&(!odd_even_judge))
	//else if((pre_vld_delay_2==1'b1)&&(!odd_even_judge_r))
		begin
			if(count_3==2'd0)
				addra_o1_w <= addra_o1_w-8191;
			else 
				addra_o1_w <= addra_o1_w+4096;
		end
end

always@(posedge clk_dwt or negedge rst) 
begin
    if(!rst) 
		addra_o2_w <= 14'b0;
	else if(rst_syn) 
		addra_o2_w <= 14'b0;
	else if((pre_vld_delay_3==1'b1)&&odd_even_judge)
		begin
			if(addra_o2_w==0)
				begin
					if(odd_even_judge)
						addra_o2_w <= addra_o2_w + 4096;
				end		
			else if(count_3==2'd0)
				addra_o2_w <= addra_o2_w - 8191;
			else 
				addra_o2_w <= addra_o2_w + 4096;	
		end
end	

assign wea_o1_w = 1;
assign wea_o2_w = 1;
//assign ena_o1_w = (odd_even_judge_delay==1'b0)?  1'b1:1'b0;
assign ena_o2_w = (odd_even_judge==1'b1)?  1'b1:1'b0;	
always @(*) 
begin
	if(fsm_address==0) 
		begin
			ena_o1_w<=0;
		end
	else if(odd_even_judge==1'b0) 
		begin
			ena_o1_w<=1;
		end
	else 
		begin
			ena_o1_w<=0;
		end	
end
/************************** start *******************************/
always @(posedge clk_dwt or negedge rst) 
begin
  if(!rst) 
 	begin
		over_start_delay <= 1'b0;
		over_start_delay_1 <= 1'b0;
		over_start_delay_2 <= 1'b0;
 	end
  else if(rst_syn)
  	begin
		over_start_delay <= 1'b0;
		over_start_delay_1 <= 1'b0;
		over_start_delay_2 <= 1'b0;
  	end
  else 
 	begin
 		over_start_delay <= over_start;
		over_start_delay_1 <= over_start_delay;
		over_start_delay_2 <= over_start_delay_1;		
 	end
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		start_reg <= 1'b0;
	else if(rst_syn)
		start_reg <= 1'b0;
	else if(start_count==2&&over_start_or)
		start_reg <= 1;
	else 	start_reg<=0;
end

always @(posedge clk_dwt or negedge rst) 
begin
	if(!rst) 
		begin
			start_reg1 <= 1'b0;
			start_reg2 <= 1'b0;
		end
	else 
		begin
			start_reg1 <= start_reg;
			start_reg2 <= start_reg1;
		end
end

endmodule
