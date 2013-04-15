`timescale 1ns/10ps
module write_fifo(//output
                  fifo_in0,
				  fifo_in1,
				  fifo_in2,
				  fifo_in3,
				  fifo_in4,
				  fifo_in5,
				  fifo_in6,
				  fifo_in7,
				  fifo_in8,
				  fifo_in9,
				  wr_vld,
				  stall_vld,
				  //stall_vld_single,
				 
				  
				  //input
				  wrfull,
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
				  clk_wr,
				  clk_dwt,
				  rst,
				  rst_syn);
				  
	output [7:0] fifo_in0;
	output [7:0] fifo_in1;
	output [7:0] fifo_in2;
	output [7:0] fifo_in3;
	output [7:0] fifo_in4;
	output [7:0] fifo_in5;
	output [7:0] fifo_in6;
	output [7:0] fifo_in7;
	output [7:0] fifo_in8;
	output [7:0] fifo_in9;
	
	output [9:0] wr_vld;
	output  stall_vld;
	
	
	
	input [7:0] arrange_out0;
	input [7:0] arrange_out1;
	input [7:0] arrange_out2;
	input [7:0] arrange_out3;
	input [7:0] arrange_out4;
	input [7:0] arrange_out5;
	input [7:0] arrange_out6;
	input [7:0] arrange_out7;
	input [7:0] arrange_out8;
	input [7:0] arrange_out9;
	//input stall_vld;
	input [9:0] wrfull;
	input [3:0] vld_num;
	input  flush;
	input  clk_wr;
	input  clk_dwt;
	input  rst;
	input  rst_syn;

wire clk_sg=clk_wr;
reg clk_sg_reg;
always@(posedge clk_dwt or negedge rst)
	begin
		if(!rst)
			clk_sg_reg<=0;
		else if(rst_syn)
			clk_sg_reg<=0;	
		else 	
			clk_sg_reg<=clk_sg;
	end
wire pos_clk_sg=((clk_sg_reg==1'b0)&&(clk_sg==1'b1))?1'b1:1'b0;
	
	
	
	reg flush1,flush2;
	always@(posedge clk_dwt or negedge rst) begin
	    if(!rst) begin
	        flush1 <= 1'b0;
	        flush2 <= 1'b0;
	    end
		else if(rst_syn)begin
			flush1 <= 1'b0;
			flush2 <= 1'b0;
		end
	    else if(pos_clk_sg==1'b1)begin
	        flush1 <= flush;
	        flush2 <= flush1;
	    end
	end
	
reg [1:0]count_clk_dwt;
	
	wire stall_vld_n_before;
	wire stall_vld_n;
	assign stall_vld_n_before = ~(wrfull == 10'b0);
	//assign stall_vld_n=(count_clk_dwt==2'd3)?stall_vld_n_before:0;
	assign stall_vld_n=((count_clk_dwt==2'd1)&&(clk_sg==1'b1))?stall_vld_n_before:0;

always@(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			count_clk_dwt <= 2'b0;
		else  if(rst_syn)
			count_clk_dwt <= 2'b0;
		else if(clk_sg==1'b0)
			count_clk_dwt <= 2'b0;
		else if(clk_sg==1'b1)
		//else
			count_clk_dwt <= count_clk_dwt + 1 ;
	end 
	
	
reg	stall_vld_reg1;
reg stall_vld_reg2;
reg stall_vld_reg3;
reg stall_vld_reg4;

always@(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			stall_vld_reg1 <= 1'b0;
		else if(rst_syn)
			stall_vld_reg1 <= 1'b0;
		else 
			stall_vld_reg1 <= stall_vld_n;			
	end
always@(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			stall_vld_reg2 <= 1'b0;
		else if(rst_syn)
			stall_vld_reg2 <= 1'b0;
		else if((stall_vld_reg1==1'b1)&&(stall_vld_reg2==1'b1)&&(stall_vld_n==1'b0))
			stall_vld_reg2 <= 1'b0;
		else 
			stall_vld_reg2 <= stall_vld_reg1;	
	end
always@(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			stall_vld_reg3 <= 1'b0;
		else if(rst_syn)
			stall_vld_reg3 <= 1'b0;
		else if((stall_vld_reg3==1'b1)&&(stall_vld_reg2==1'b1))
			stall_vld_reg3 <= 1'b0;
		else 
			stall_vld_reg3 <= stall_vld_reg2;	
	end

always@(posedge clk_dwt or negedge rst) 
	begin
		if(!rst) 
			stall_vld_reg4 <= 1'b0;
		else if(rst_syn)
			stall_vld_reg4 <= 1'b0;
		else
			stall_vld_reg4 <= stall_vld_reg3;
	end
	
	
	
	
wire stall_vld;
assign stall_vld=stall_vld_n||stall_vld_reg1||stall_vld_reg2||stall_vld_reg3;

//wire stall_vld_temp=stall_vld_n||stall_vld_reg1||stall_vld_reg2	;
	
	reg [3:0] start_point;
	wire [3:0] start_point_n;
	
	assign start_point_n = ((start_point+vld_num)<10)? (start_point+vld_num):(start_point+vld_num-10); 
	
	always@(posedge clk_dwt or negedge rst) begin
	    if(!rst) begin
		    start_point <= 0;
		end
		else if(rst_syn)begin
			start_point <= 0;
		end
		//else if(flush2==1'b1) begin
		//    start_point <= 4'b0;
		//end
		else if(pos_clk_sg==1'b1)begin
			if(stall_vld == 1'b0)begin
				start_point <= start_point_n;
			end
		end
	end
	
	reg [9:0] wr_temp;
	always@(*) begin
	    case(vld_num)
	        1: begin
		        wr_temp = 10'b0000000001;
		    end
			2: begin
			    wr_temp = 10'b0000000011;
			end
			3: begin
		        wr_temp = 10'b0000000111;
		    end
			4: begin
		        wr_temp = 10'b0000001111;
		    end
			5: begin
		        wr_temp = 10'b0000011111;
		    end
			6: begin
		        wr_temp = 10'b0000111111;
		    end
			7: begin
		        wr_temp = 10'b0001111111;
		    end
			8: begin
		        wr_temp = 10'b0011111111;
		    end
			9: begin
		        wr_temp = 10'b0111111111;
		    end
			10: begin
		        wr_temp = 10'b1111111111;
		    end
			default: begin
			    wr_temp = 10'b0000000000;
			end
			endcase
	end
	
	reg [9:0] wr_vldn;
	always@(posedge clk_dwt or negedge rst) begin
	    if(!rst) begin
		    wr_vldn <= 10'b0;
		end
		else if(rst_syn)begin
			wr_vldn <= 10'b0;
		end
//		else if(stall_vld == 1'b1) begin
//		   wr_vld <= 10'b0;
//		end
		else if(pos_clk_sg==1'b1)begin
			if(stall_vld==1'b0)begin
				case(start_point)
					0: begin
						wr_vldn <= wr_temp;
					end
					1: begin
						wr_vldn <= {wr_temp[8:0],wr_temp[9]};
					end
					2: begin
						wr_vldn <= {wr_temp[7:0],wr_temp[9:8]};
					end
					3: begin
						wr_vldn <= {wr_temp[6:0],wr_temp[9:7]};
					end
					4: begin
						wr_vldn <= {wr_temp[5:0],wr_temp[9:6]};
					end
					5: begin
						wr_vldn <= {wr_temp[4:0],wr_temp[9:5]};
					end
					6: begin
						wr_vldn <= {wr_temp[3:0],wr_temp[9:4]};
					end
					7: begin
						wr_vldn <= {wr_temp[2:0],wr_temp[9:3]};
					end
					8: begin
						wr_vldn <= {wr_temp[1:0],wr_temp[9:2]};
					end
					9: begin
						wr_vldn <= {wr_temp[0],wr_temp[9:1]};
					end
				endcase
			end
		end
		else 
			wr_vldn <=10'b0;
	end
	
reg [9:0]wr_vldn_reg1;
reg [9:0]wr_vldn_reg2;
reg [9:0]wr_vldn_reg3;
 //reg [9:0]wr_vldn_reg4;
always@(posedge clk_dwt or negedge rst)	
	begin
		if(!rst) 
			begin
				wr_vldn_reg1 <= 10'b0;
				wr_vldn_reg2 <= 10'b0;
				wr_vldn_reg3 <= 10'b0;
				//wr_vldn_reg4 <= 10'b0;
			end
		else if(rst_syn)
			begin
				wr_vldn_reg1 <= 10'b0;
				wr_vldn_reg2 <= 10'b0;
				wr_vldn_reg3 <= 10'b0;
				//wr_vldn_reg4 <= 10'b0;
			end
		else 
			begin
				wr_vldn_reg1 <= wr_vldn;
				wr_vldn_reg2 <= wr_vldn_reg1;
				wr_vldn_reg3 <= wr_vldn_reg2;
				//wr_vldn_reg4 <= wr_vldn_reg3;				
			end			
	end 
	
	
	reg [9:0] wr_vld;
	//assign wr_vld=(stall_vld==1'b1)? 10'b0:wr_vldn_reg3;
	reg [9:0]wr_vld_temp;
	always@(posedge clk_dwt or negedge rst)
		begin
			if(!rst)
				wr_vld_temp<=0;
			else if(rst_syn)
				wr_vld_temp<=0;				
			else if((stall_vld==1'b1)&&(stall_vld_n==1'b1)&&(stall_vld_reg1==1'b0))
				wr_vld_temp<=wr_vldn;
			else if(stall_vld_reg4==1'b1)
				wr_vld_temp<=0;
		end
	always@(*)
		begin
			//if((stall_vld==1'b0)&&(stall_vld_reg4==1'b1))
			if(((stall_vld==1'b0)||((count_clk_dwt==2'd1)&&(clk_sg==1'b1)))&&(stall_vld_reg4==1'b1))
				wr_vld<=wr_vld_temp;
			else if(stall_vld==1'b0)	
				wr_vld<=wr_vldn_reg3;
			else 
				wr_vld<=0;
		end 
		
    reg [7:0] fifo_in0;
	reg [7:0] fifo_in1;
	reg [7:0] fifo_in2;
	reg [7:0] fifo_in3;
	reg [7:0] fifo_in4;
	reg [7:0] fifo_in5;
	reg [7:0] fifo_in6;
	reg [7:0] fifo_in7;
	reg [7:0] fifo_in8;
	reg [7:0] fifo_in9;
	
	always@(posedge clk_dwt or negedge rst) begin
	    if(!rst) begin
		    fifo_in0 <= 8'b0;
			fifo_in1 <= 8'b0;
			fifo_in2 <= 8'b0;
			fifo_in3 <= 8'b0;
			fifo_in4 <= 8'b0;
			fifo_in5 <= 8'b0;
			fifo_in6 <= 8'b0;
			fifo_in7 <= 8'b0;
			fifo_in8 <= 8'b0;
			fifo_in9 <= 8'b0;
		end
		else if(rst_syn)begin
			fifo_in0 <= 8'b0;
			fifo_in1 <= 8'b0;
			fifo_in2 <= 8'b0;
			fifo_in3 <= 8'b0;
			fifo_in4 <= 8'b0;
			fifo_in5 <= 8'b0;
			fifo_in6 <= 8'b0;
			fifo_in7 <= 8'b0;
			fifo_in8 <= 8'b0;
			fifo_in9 <= 8'b0;	
		end
		else if(pos_clk_sg==1'b1)begin
			if(stall_vld == 1'b0)begin
				case(start_point)
					0: begin
						fifo_in0 <= arrange_out0;
						fifo_in1 <= arrange_out1;
						fifo_in2 <= arrange_out2;
						fifo_in3 <= arrange_out3;
						fifo_in4 <= arrange_out4;
						fifo_in5 <= arrange_out5;
						fifo_in6 <= arrange_out6;
						fifo_in7 <= arrange_out7;
						fifo_in8 <= arrange_out8;
						fifo_in9 <= arrange_out9;
					end	
					1: begin
						fifo_in0 <= arrange_out9;
						fifo_in1 <= arrange_out0;
						fifo_in2 <= arrange_out1;
						fifo_in3 <= arrange_out2;
						fifo_in4 <= arrange_out3;
						fifo_in5 <= arrange_out4;
						fifo_in6 <= arrange_out5;
						fifo_in7 <= arrange_out6;
						fifo_in8 <= arrange_out7;
						fifo_in9 <= arrange_out8;
					end
					2: begin
						fifo_in0 <= arrange_out8;
						fifo_in1 <= arrange_out9;
						fifo_in2 <= arrange_out0;
						fifo_in3 <= arrange_out1;
						fifo_in4 <= arrange_out2;
						fifo_in5 <= arrange_out3;
						fifo_in6 <= arrange_out4;
						fifo_in7 <= arrange_out5;
						fifo_in8 <= arrange_out6;
						fifo_in9 <= arrange_out7;
					end	
					3: begin
						fifo_in0 <= arrange_out7;
						fifo_in1 <= arrange_out8;
						fifo_in2 <= arrange_out9;
						fifo_in3 <= arrange_out0;
						fifo_in4 <= arrange_out1;
						fifo_in5 <= arrange_out2;
						fifo_in6 <= arrange_out3;
						fifo_in7 <= arrange_out4;
						fifo_in8 <= arrange_out5;
						fifo_in9 <= arrange_out6;
					end	
					4: begin
						fifo_in0 <= arrange_out6;
						fifo_in1 <= arrange_out7;
						fifo_in2 <= arrange_out8;
						fifo_in3 <= arrange_out9;
						fifo_in4 <= arrange_out0;
						fifo_in5 <= arrange_out1;
						fifo_in6 <= arrange_out2;
						fifo_in7 <= arrange_out3;
						fifo_in8 <= arrange_out4;
						fifo_in9 <= arrange_out5;
					end	
					5: begin
						fifo_in0 <= arrange_out5;
						fifo_in1 <= arrange_out6;
						fifo_in2 <= arrange_out7;
						fifo_in3 <= arrange_out8;
						fifo_in4 <= arrange_out9;
						fifo_in5 <= arrange_out0;
						fifo_in6 <= arrange_out1;
						fifo_in7 <= arrange_out2;
						fifo_in8 <= arrange_out3;
						fifo_in9 <= arrange_out4;
					end	
					6: begin
						fifo_in0 <= arrange_out4;
						fifo_in1 <= arrange_out5;
						fifo_in2 <= arrange_out6;
						fifo_in3 <= arrange_out7;
						fifo_in4 <= arrange_out8;
						fifo_in5 <= arrange_out9;
						fifo_in6 <= arrange_out0;
						fifo_in7 <= arrange_out1;
						fifo_in8 <= arrange_out2;
						fifo_in9 <= arrange_out3;
					end	
					7: begin
						fifo_in0 <= arrange_out3;
						fifo_in1 <= arrange_out4;
						fifo_in2 <= arrange_out5;
						fifo_in3 <= arrange_out6;
						fifo_in4 <= arrange_out7;
						fifo_in5 <= arrange_out8;
						fifo_in6 <= arrange_out9;
						fifo_in7 <= arrange_out0;
						fifo_in8 <= arrange_out1;
						fifo_in9 <= arrange_out2;
					end	
					8: begin
						fifo_in0 <= arrange_out2;
						fifo_in1 <= arrange_out3;
						fifo_in2 <= arrange_out4;
						fifo_in3 <= arrange_out5;
						fifo_in4 <= arrange_out6;
						fifo_in5 <= arrange_out7;
						fifo_in6 <= arrange_out8;
						fifo_in7 <= arrange_out9;
						fifo_in8 <= arrange_out0;
						fifo_in9 <= arrange_out1;
					end	
					9: begin
						fifo_in0 <= arrange_out1;
						fifo_in1 <= arrange_out2;
						fifo_in2 <= arrange_out3;
						fifo_in3 <= arrange_out4;
						fifo_in4 <= arrange_out5;
						fifo_in5 <= arrange_out6;
						fifo_in6 <= arrange_out7;
						fifo_in7 <= arrange_out8;
						fifo_in8 <= arrange_out9;
						fifo_in9 <= arrange_out0;
					end	
				endcase
			end
		end
	end	
	wire[4:0] cx0;
	wire[4:0] cx1;
	wire[4:0] cx2;
	wire[4:0] cx3;
	wire[4:0] cx4;
	wire[4:0] cx5;
	wire[4:0] cx6;
	wire[4:0] cx7;
	wire[4:0] cx8;
	wire[4:0] cx9;
    assign cx0 = fifo_in0[5:1];
	assign cx1 = fifo_in1[5:1];
	assign cx2 = fifo_in2[5:1];
	assign cx3 = fifo_in3[5:1];
	assign cx4 = fifo_in4[5:1];
	assign cx5 = fifo_in5[5:1];
	assign cx6 = fifo_in6[5:1];
	assign cx7 = fifo_in7[5:1];
	assign cx8 = fifo_in8[5:1];
	assign cx9 = fifo_in9[5:1];
	

	
	
endmodule
