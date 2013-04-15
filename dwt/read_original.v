`timescale 1ns/10ps
module read_raw_control ( //output
                          addra_o1_r,
                          addra_o2_r,
			              ena_o1_r,
			              ena_o2_r,
			              wea_o1_r,
			              wea_o2_r,
						  odd_data_raw,
						  even_data_raw,
						  //input
						  dout_o1,
                          dout_o2,
						  level,
						  wr_over,
						  start,
						  dwt_work,
						  rf_over,
						  clk_mmu,
						  rst,
						  rst_syn);
						  
output [13:0] addra_o1_r;
output [13:0] addra_o2_r;
output ena_o1_r;
output ena_o2_r;
output wea_o1_r;
output wea_o2_r;
output [15:0] odd_data_raw;
output [15:0] even_data_raw;


input[16:0] dout_o1;
input[16:0] dout_o2;
input [2:0] level;
input [1:0] wr_over;
input start;
input clk_mmu;
input rst;
input rst_syn;
input dwt_work;
input rf_over;

reg[1:0] fsm_raw;
reg[1:0] fsm_raw_n;

parameter idle = 2'b10;
parameter read = 3'b01;

wire srst;

assign srst = (fsm_raw == idle);


reg [13:0] addra_o1_n;
reg [13:0] addra_o2_n;
reg [13:0] addra_o1_r;
reg [13:0] addra_o2_r;

reg [2:0] level_reg;
reg [2:0] level_reg_1;

reg ena_o1_r;
reg ena_o2_r;

wire wea_o1_r;
wire wea_o2_r;

always @(posedge clk_mmu or negedge rst)
  if(!rst) begin
    level_reg <= 3'b0;
	level_reg_1<=3'b0;
  end
  else if(rst_syn)begin
	level_reg <= 3'b0;
	level_reg_1<=3'b0;
  end
  else if(dwt_work == 1'b1) begin
    level_reg <= level;
	level_reg_1 <= level_reg;
  end
  
reg [3:0] expand_col;
reg [3:0] expand_col_n;
reg hold;


always@(posedge clk_mmu or negedge rst)begin
	if(!rst)begin
		hold<=0;
	end
	else if(rst_syn)begin
		hold<=0;
	end
	else if((rf_over==1'b1)&&(expand_col==9))begin
		hold<=1'b1;
	end
end

always@(posedge clk_mmu or negedge rst) begin
    if(!rst) begin
	    addra_o1_r <= 14'b0;
	end
	else if(rst_syn)begin
		addra_o1_r <= 14'b0;
	end
	else if(dwt_work == 1'b1) begin
		if(hold)begin
			addra_o1_r<=addra_o1_r;
		end
		else begin
			addra_o1_r <= addra_o1_n;
		end
	end
end
  
always@(posedge clk_mmu or negedge rst) begin
	    if(!rst) begin
		    addra_o2_r <= 14'b0;
		end
		else if(rst_syn)begin
			addra_o2_r <= 14'b0;
		end
		else if(dwt_work == 1'b1) begin
			if(hold)begin
				addra_o2_r<=addra_o2_r;
			end
			else begin
				addra_o2_r <= addra_o2_n;
			end
		end
end



always@(posedge clk_mmu or negedge rst) begin
    if(!rst) begin
        expand_col <= 4'b0;
    end
	else if(rst_syn)begin
		expand_col <= 4'b0;
	end
    else if(srst == 1'b1) begin
        expand_col <= 4'b0;
    end
    else if(dwt_work == 1'b1) begin
        expand_col <= expand_col_n;
    end
	   
end


reg level0_cnt;

always@(posedge clk_mmu or negedge rst) begin
    if(!rst) begin
	    level0_cnt <= 1'b1;
	end
	else if(rst_syn)begin
		level0_cnt <= 1'b1;
	end
	else if(srst == 1'b1) begin
	    level0_cnt <= 1'b1;
	end
	else if(dwt_work == 1'b1) begin
	        if(level_reg == 3'b000) begin
	           level0_cnt <= level0_cnt + 1'b1;
	        end
			else begin
			   level0_cnt <= level0_cnt;
			end
    end
end


always@(*) begin
	    addra_o1_n = addra_o1_r;
	    expand_col_n = expand_col;
	    if(level_reg == 3'b000)begin
	        if(level0_cnt == 1'b0) begin
	        if((addra_o1_r == 4095)&&(expand_col < 3)) begin
	            if(expand_col == 2) begin 
	                addra_o1_n = 4096 - 4;
	            end
	            else begin
	                addra_o1_n = addra_o1_r - 63;
	            end
	            expand_col_n = expand_col + 1;
	        end
	        else if((addra_o1_r == 8191)&&(expand_col < 6)) begin
	            if(expand_col == 5) begin 
	                addra_o1_n = 8192 - 4;
	            end
	            else begin
	                addra_o1_n = addra_o1_r - 63;
	            end
	            expand_col_n = expand_col + 1;
	        end
	        else if((addra_o1_r == 12287)&&(expand_col < 9)) begin
	            if(expand_col == 8) begin 
	                addra_o1_n = 0;
	            end
	            else begin
	                addra_o1_n = addra_o1_r - 63;
	            end
	            expand_col_n = expand_col + 1;
	        end
	        else begin
	            addra_o1_n = addra_o1_r + 1;
	        end
	        end
	        else begin
	            addra_o1_n = addra_o1_r;
	        end
	    end
	    else begin
	        addra_o1_n = 0;
	    end    
	end
	
	always@(*) begin
	    addra_o2_n = addra_o2_r;
	    if(level_reg == 3'b000)begin
	        if(level0_cnt == 1'b0) begin
	        if((addra_o2_r == 4095)&&(expand_col < 3)) begin
	            if(expand_col == 2) begin 
	                addra_o2_n = 4096 - 4;
	            end
	            else begin
	                addra_o2_n = addra_o2_r - 63;
	            end
	        end
	        else if((addra_o2_r == 8191)&&(expand_col < 6)) begin
	            if(expand_col == 5) begin 
	                addra_o2_n = 8192 - 4;
	            end
	            else begin
	                addra_o2_n = addra_o2_r - 63;
	            end
	        end
	        else if((addra_o2_r == 12287)&&(expand_col < 9)) begin
	            if(expand_col == 8) begin 
	                addra_o2_n = 0;
	            end
	            else begin
	                addra_o2_n = addra_o2_r - 63;
	            end
	        end
	        else begin
	            addra_o2_n = addra_o2_r + 1;
	        end
	        end
	        else begin
	            addra_o2_n = addra_o2_r;
	        end
	    end
	    else begin
	        addra_o2_n = 0;
	    end    
	end
	
	
always@(posedge clk_mmu or negedge rst) begin
	if(!rst) begin
	    ena_o1_r <= 1'b0;
	end
	else if(rst_syn)begin
		ena_o1_r <= 1'b0;
	end
	else if(level == 3'b000) begin
	    ena_o1_r <= 1'b1;
	end
	else begin
	    ena_o1_r <= 1'b0;
	end
end
	
always@(posedge clk_mmu or negedge rst) begin
	if(!rst) begin
		ena_o2_r <= 1'b0;
    end
	else if(rst_syn)begin
		ena_o2_r <= 1'b0;
	end
	else if(level == 3'b000) begin
	  ena_o2_r <= 1'b1;
	end
	else begin
	  ena_o2_r <= 1'b0;
	end
end


	
assign wea_o1_r = 1'b0;
assign wea_o2_r = 1'b0;


reg [15:0] odd_data_raw;
reg [15:0] even_data_raw;


always@(posedge clk_mmu or negedge rst) begin
   if(!rst) begin
		even_data_raw <= 16'b0;
   end
   else if(rst_syn)begin
		even_data_raw <= 16'b0;
   end
   else if(level_reg_1 == 3'b000) begin
	 if(level0_cnt == 1'b0) begin
	     even_data_raw <= {{4{dout_o1[7]}},dout_o1[7:0],4'b0000};
	 end
	 else begin
	     even_data_raw <= {{4{dout_o1[15]}},dout_o1[15:8],4'b0000};
	 end
   end
end


always@(posedge clk_mmu or negedge rst) begin
   if(!rst) begin
		odd_data_raw <= 16'b0;
   end
   else if(rst_syn)begin
		odd_data_raw <= 16'b0;
   end
   else if(level_reg_1 == 3'b000) begin
	 if(level0_cnt == 1'b0) begin
	     odd_data_raw <= {{4{dout_o2[7]}},dout_o2[7:0],4'b0000};
	 end
	 else begin
		 odd_data_raw <= {{4{dout_o2[15]}},dout_o2[15:8],4'b0000};
	 end
   end
end


always@(posedge clk_mmu or negedge rst) begin
	if(!rst)
		fsm_raw <= 2'b0;
	else if(rst_syn)
		fsm_raw <= 2'b0;
	else 
		fsm_raw <= fsm_raw_n;
end

always @(*) begin
  fsm_raw_n = fsm_raw;
   case(fsm_raw)
     idle:  begin 
	         if(start)
	          fsm_raw_n = read;
			 else
			  fsm_raw_n = idle;
            end
     read:  begin
	         if(wr_over == 2'b11)
			   fsm_raw_n = idle;
			 else
			   fsm_raw_n = read;
			end
	default:   fsm_raw_n = 2'b11;
  endcase
end
endmodule

             	 
